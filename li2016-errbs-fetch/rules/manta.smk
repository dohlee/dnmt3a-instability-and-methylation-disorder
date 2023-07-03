def manta_tumor_normal_input(wildcards):
    tumor_ll = 'se' if sample2layout[wildcards.tumor] == 'single' else 'pe'
    normal_ll = 'se' if sample2layout[wildcards.normal] == 'single' else 'pe'

    ret = {}
    ret['tumor'] = str(RESULT_DIR / config['bwa_result_dir'] / tumor_ll / wildcards.tumor / (wildcards.tumor + '.duplicates_marked.sorted.bam'))
    ret['tumor_index'] = str(RESULT_DIR / config['bwa_result_dir'] / tumor_ll / wildcards.tumor / (wildcards.tumor + '.duplicates_marked.sorted.bam.bai'))
    ret['normal'] = str(RESULT_DIR / config['bwa_result_dir'] / normal_ll / wildcards.normal / (wildcards.normal + '.duplicates_marked.sorted.bam'))
    ret['normal_index'] = str(RESULT_DIR / config['bwa_result_dir'] / normal_ll / wildcards.normal / (wildcards.normal + '.duplicates_marked.sorted.bam.bai'))
    ret['reference'] = config['reference']['fasta']
    ret['reference_index'] = config['reference']['index']

    return ret

MTN = config['manta_tumor_normal']
rule manta_tumor_normal:
    input:
        # Required input.
        unpack(manta_tumor_normal_input)
    output:
        # Required output.
        candidate_small_indels = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.candidateSmallIndels.vcf.gz'),
        candidate_sv = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.candidateSV.vcf.gz'),
        diploid_sv = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.diploidSV.vcf.gz'),
        somatic_sv = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.somaticSV.vcf.gz'),
        candidate_small_indels_idx = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.candidateSmallIndels.vcf.gz.tbi'),
        candidate_sv_idx = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.candidateSV.vcf.gz.tbi'),
        diploid_sv_idx = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.diploidSV.vcf.gz.tbi'),
        somatic_sv_idx = str(RESULT_DIR / config['manta_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.somaticSV.vcf.gz.tbi'),
    params:
        extra = MTN['extra'],
        # Set options for WES input: turn off depth filters.
        # Default: False
        exome = MTN['exome'],
        # Set options for RNA-Seq input. Must specify exactly one bam input file.
        # Default: False
        rna = MTN['rna'],
        # Set if RNA-Seq input is unstranded: Allows splice-junctions on either strand.
        # Default: False
        unstrandedRNA = MTN['unstrandedRNA'],
        # Optionally provide a bgzip-compressed/tabix-indexed BED file containing the set of regions to
        # call. No VCF output will be provided outside of these regions. The full genome will be provided
        # outside of these regions. The full genome will still be used to estimate statistics from the input
        # (such as expected fragment size distribution). Only one BED file may be specified.
        # Default: call the entire genome.
        callRegions = MTN['callRegions'],
        # Pre-calculated alignment statistics file. Skips alignment stats calculation.
        # Default: None
        existingAlignStatsFile = MTN['existingAlignStatsFile'],
        # Use pre-calculated chromosome depths.
        # Default: None
        useExistingChromDepths = MTN['useExistingChromDepths'],
        # Keep all temporary files (for workflow debugging).
        # Default: False
        retainTempFiles = MTN['retainTempFiles'],
        # Generate a bam of supporting reads for all SVs.
        # Default: False
        generateEvidenceBam = MTN['generateEvidenceBam'],
        # Output assembled contig sequences in VCF file.
        # Default: False
        outputContig = MTN['outputContig'],
        # Maximum sequence region size (in megabases) scanned by each task during SV Locus graph generation.
        # Default: 12
        scanSizeMb = MTN['scanSizeMb'],
    threads: config['threads']['manta_tumor_normal']
    log: 'logs/manta/tumor-normal/{tumor}_vs_{normal}.log'
    benchmark: 'benchmarks/manta/tumor-normal/{tumor}_vs_{normal}.benchmark'
    conda: 'manta_env.yaml'
    wrapper:
        'http://dohlee-bio.info:9193/manta/tumor-normal'

