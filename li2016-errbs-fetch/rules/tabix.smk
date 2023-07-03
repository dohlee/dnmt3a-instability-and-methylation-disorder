rule tabix_index_snvs:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.vcf.gz'
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_snvs/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'

rule tabix_index_indels:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.vcf.gz'
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_indels/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'

rule bgzip_varscan_vcfs:
    input:
        snv = str(RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.vcf'),
        indel = str(RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.vcf'),
    output:
        snv = str(RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.vcf.gz'),
        indel = str(RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.vcf.gz'),
    threads: 1
    shell: 'bgzip {input.snv} -c -@ {threads} > {output.snv} && bgzip {input.indel} -c -@ {threads} > {output.indel}'

rule tabix_index_varscan_snvs:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.vcf.gz'
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_varscan_snvs/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'

rule tabix_index_varscan_indels:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.vcf.gz'
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_varscan_indels/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'
    
rule tabix_index_strelka2_snvs_snpsift:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.snpsift_annotated.vcf.gz'
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.snpsift_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_strelka2_snvs_snpsift/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'

rule tabix_index_strelka2_indels_snpsift:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.snpsift_annotated.vcf.gz'
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.snpsift_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_strelka2_indels_snpsift/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'

rule tabix_index_varscan_snvs_snpsift:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.snpsift_annotated.vcf.gz'
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.snpsift_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_varscan_snvs_snpsift/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'

rule tabix_index_varscan_indels_snpsift:
    # NOTE: When executed, this rule will overwrite existing index without asking.
    # input should end with either of '.vcf.gz', '.bed.gz', or '.gff.gz'.
    input:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.snpsift_annotated.vcf.gz'
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.snpsift_annotated.vcf.gz.tbi'
    params:
        extra = ''
    threads: config['threads']['tabix_index']
    log: 'logs/tabix_index_varscan_indels_snpsift/{tumor}_vs_{normal}.log'
    wrapper: 'http://dohlee-bio.info:9193/tabix'
