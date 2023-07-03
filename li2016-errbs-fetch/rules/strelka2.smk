def strelka2_tumor_normal_input(wildcards):
    tumor_ll = 'se' if sample2layout[wildcards.tumor] == 'single' else 'pe'
    normal_ll = 'se' if sample2layout[wildcards.normal] == 'single' else 'pe'

    ret = {}
    ret['tumor'] = str(RESULT_DIR / config['bwa_result_dir'] / tumor_ll / wildcards.tumor / (wildcards.tumor + '.duplicates_marked.sorted.bam'))
    ret['tumor_index'] = str(RESULT_DIR / config['bwa_result_dir'] / tumor_ll / wildcards.tumor / (wildcards.tumor + '.duplicates_marked.sorted.bam.bai'))
    ret['normal'] = str(RESULT_DIR / config['bwa_result_dir'] / normal_ll / wildcards.normal / (wildcards.normal + '.duplicates_marked.sorted.bam'))
    ret['normal_index'] = str(RESULT_DIR / config['bwa_result_dir'] / normal_ll / wildcards.normal / (wildcards.normal + '.duplicates_marked.sorted.bam.bai'))
    ret['reference'] = config['reference']['fasta']
    ret['reference_index'] = config['reference']['index']

    if tumor_ll == 'pe' and normal_ll == 'pe':
        ret['candidate_small_indels'] = str(RESULT_DIR / config['manta_result_dir'] / wildcards.tumor / (wildcards.tumor + '_vs_' + wildcards.normal + '.candidateSmallIndels.vcf.gz'))
        ret['candidate_small_indels_idx'] = str(RESULT_DIR / config['manta_result_dir'] / wildcards.tumor / (wildcards.tumor + '_vs_' + wildcards.normal + '.candidateSmallIndels.vcf.gz.tbi'))
    
    return ret

def strelka2_indel_candidates(wildcards, input):
    """Use small indel candidates from manta only if input is paired-end,
    since manta requires paired-end reads.
    """
    tumor_ll = 'se' if sample2layout[wildcards.tumor] == 'single' else 'pe'
    normal_ll = 'se' if sample2layout[wildcards.normal] == 'single' else 'pe'
    
    if tumor_ll == 'pe' and normal_ll == 'pe':
        return input.candidate_small_indels
    else:
        return False

SS = config['strelka2_tumor_normal']
rule strelka2_tumor_normal:
    input:
        # Required input.
        unpack(strelka2_tumor_normal_input),
    output:
        # Required output.
        snv = str(RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.vcf.gz'),
        indel = str(RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.vcf.gz'),
    params:
        extra = SS['extra'],
        # Output a bed file describing somatic callable regions of the genome.
        # Default: False
        outputCallableRegions = SS['outputCallableRegions'],
        # Specify a VCF of candidate indel alleles. These alleles are always evaluated but only reported
        # in the output when they are inferred to exist in the sample. The VCF must be tabix indexed. All
        # indel alleles must be left-shifted/normalized, any unnormalized alleles will be ignored. This
        # option may be specified more than once, multiple input VCFs will be merged.
        # Default: False
        # indelCandidates = SS['indelCandidates'],
        indelCandidates = strelka2_indel_candidates,
        # Specify a VCF of candidate alleles. These alleles are always evaluated and reported even if they
        # are unlikely to exist in the sample. The VCF must be tabix indexed. All indel alleles must be
        # left-shifted/normalzed, any unnormalized allele will trigger runtime error. This option may be 
        # specified more than once, multiple input VCFs will be merged. Note that for any SNVs provided in
        # the VCF, the SNV site will be reported (and for gVCF, excluded from block compression), but the
        # specific SNV alleles are ignored.
        # Default: None
        forcedGT = SS['forcedGT'],
        # Set options for exome or other targeted input: note in particular that this flag turns off
        # high-depth filters.
        # Default: False
        exome = SS['exome'],
        # Optionally provide a bgzip-compressed/tabix-indexed BED file containing the set of regions to call.
        # No VCF output will be provided outside of these regions. The full genome will still be used to 
        # estimabe statistics from the input (such as expected depth per chromosome). Only one BED file
        # may be specified.
        # Default: False (call the entire genome)
        callRegions = SS['callRegions'],
        # Extended options:
        # These options are either unlikely to be reset after initial site configuration or only of interest
        # for workflow development/debugging. They will not be printed here if a default exists unless
        # --allHelp is specified.
        # Noise vcf file (submit argument multiple times for more than one file)
        # Default: False
        noiseVcf = SS['noiseVcf'],
        # Maximum sequence region size (in megabases) scanned by each task during genome variant calling. 
        # Default: 12
        scanSizeMb = SS['scanSizeMb'],
        # Limit the analysis to one or more genome region(s) for debugging purposes. If this arugment is 
        # provided multiple times the union of all specified regions will be analyzed. All regions must be
        # non-overlapping to get meaningful result.
        # Examples: '--region chr20' (whole chromosome), '--region chr2:100-2000 --region chr3:2500-3000'
        # (two regions).
        # If this option is specified (one or more times) together with the --callRegions BED file,
        # then all region arguments will be intersected with the callRegions BED track.
        # Default: False
        region = SS['region'],
        # Set variant calling task memory limit (in megabytes). It is not recommended to change the default
        # in most cases, but this might be required for a sample of unusual depth.
        # Default: False
        callMemMb = SS['callMemMb'],
        # Keep all temporary files (for workflow debugging).
        # Default: False
        retainTempFiles = SS['retainTempFiles'],
        # Disable empirical variant scoring (EVS).
        # Default: False
        disableEVS = SS['disableEVS'],
        # Report all empirical variant scoring features in VCF output.
        # Default: False
        reportEVSFeatures = SS['reportEVSFeatures'],
        # Provide a custom empirical scoring model file for SNVs.
        # Default: False,
        snvScoringModelFile = SS['snvScoringModelFile'],
        # Provide a custome empirical scoring model file for indels.
        # Default: False
        indelScoringModelFile = SS['indelScoringModelFile'],
    threads: config['threads']['strelka2_tumor_normal']
    log: 'logs/strelka2/tumor-normal/{tumor}_vs_{normal}.log'
    benchmark: 'benchmarks/strelka2/tumor-normal/{tumor}_vs_{normal}.benchmark'
    conda: 'strelka_env.yaml'
    wrapper:
        'http://dohlee-bio.info:9193/strelka2/tumor-normal'
