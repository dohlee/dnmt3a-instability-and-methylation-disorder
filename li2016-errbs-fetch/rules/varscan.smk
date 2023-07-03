def varscan_somatic_input(wildcards):
    tumor_ll = 'se' if sample2layout[wildcards.tumor] == 'single' else 'pe'
    normal_ll = 'se' if sample2layout[wildcards.normal] == 'single' else 'pe'

    ret = {}
    ret['tumor_bam'] = str(RESULT_DIR / config['bwa_result_dir'] / tumor_ll / wildcards.tumor / (wildcards.tumor + '.duplicates_marked.sorted.bam'))
    ret['tumor_index'] = str(RESULT_DIR / config['bwa_result_dir'] / tumor_ll / wildcards.tumor / (wildcards.tumor + '.duplicates_marked.sorted.bam.bai'))
    ret['normal_bam'] = str(RESULT_DIR / config['bwa_result_dir'] / normal_ll / wildcards.normal / (wildcards.normal + '.duplicates_marked.sorted.bam'))
    ret['normal_index'] = str(RESULT_DIR / config['bwa_result_dir'] / normal_ll / wildcards.normal / (wildcards.normal + '.duplicates_marked.sorted.bam.bai'))
    ret['reference'] = config['reference']['fasta']
    ret['reference_index'] = config['reference']['index']
    return ret

rule varscan_somatic:
    input:
        # Required input.
        unpack(varscan_somatic_input),
    output:
        # Required output.
        # NOTE: Varscan can output variants in its own format such as output.snp, output.indel,
        # however, this wrapper forces VCF output for unity of variant calling pipelines.
        snv = temp(str(RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.vcf')),
        indel = temp(str(RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.vcf')),
    params:
        # Optional parameters. Omit if unneeded.
        extra = config['varscan_somatic']['extra'],
        # Minimum frequency to call a heterozygote. (default 0.10)
        min_var_freq = config['varscan_somatic']['min_var_freq'],
        # If set to 1, removes variants with >90% strand bias.
        strand_filter = config['varscan_somatic']['strand_filter'],
        pileup_quality_cutoff = config['varscan_somatic']['pileup_quality_cutoff'],  # Recommended. (default 20)
    threads: config['threads']['varscan_somatic']
    wrapper:
        'http://dohlee-bio.info:9193/varscan/somatic'

