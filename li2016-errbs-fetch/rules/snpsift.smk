rule snpsift_strelka2_snv:
    input:
        vcf = RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.vcf.gz',
        vcf_index = RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.vcf.gz.tbi',
        db = config['exac'],
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.snpsift_annotated.vcf.gz'
    params:
        extra = '',
        java_options = '',
        id = False,
        info = False,
        tabix = True,
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpsift = 1
    log: 'logs/snpsift/strelka2_snv/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpsift/annotate'

rule snpsift_strelka2_indel:
    input:
        vcf = RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.vcf.gz',
        vcf_index = RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.vcf.gz.tbi',
        db = config['exac'],
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.snpsift_annotated.vcf.gz'
    params:
        extra = '',
        java_options = '',
        id = False,
        info = False,
        tabix = True,
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpsift = 1
    log: 'logs/snpsift/strelka2_indel/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpsift/annotate'

rule snpsift_varscan_snv:
    input:
        vcf = RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.vcf.gz',
        vcf_index = RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.vcf.gz.tbi',
        db = config['exac'],
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.snpsift_annotated.vcf.gz'
    params:
        extra = '',
        java_options = '',
        id = False,
        info = False,
        tabix = True,
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpsift = 1
    log: 'logs/snpsift/varscan_snv/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpsift/annotate'

rule snpsift_varscan_indel:
    input:
        vcf = RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.vcf.gz',
        vcf_index = RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.vcf.gz.tbi',
        db = config['exac'],
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.snpsift_annotated.vcf.gz'
    params:
        extra = '',
        java_options = '',
        id = False,
        info = False,
        tabix = True,
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpsift = 1
    log: 'logs/snpsift/varscan_indel/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpsift/annotate'
