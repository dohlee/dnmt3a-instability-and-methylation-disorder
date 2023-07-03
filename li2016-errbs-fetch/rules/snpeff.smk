rule snpeff_strelka2_snv:
    input:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.vcf.gz'
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.strelka.snpeff_annotated.vcf.gz'
    params:
        # Required parameters.
        genome_version = 'hg38',
        # Optional parameters. Omit if unused.
        java_options = '-Xmx4g',
        # It true, there will be a significant speedup if there are a lot of samples.
        no_statistics = False,
        extra = ''
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpeff = 1
    log: 'logs/snpeff/strelka2_snv/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpeff/ann'

rule snpeff_strelka2_indel:
    input:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.vcf.gz'
    output:
        RESULT_DIR / config['strelka2_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.strelka.snpeff_annotated.vcf.gz'
    params:
        # Required parameters.
        genome_version = 'hg38',
        # Optional parameters. Omit if unused.
        java_options = '-Xmx4g',
        # It true, there will be a significant speedup if there are a lot of samples.
        no_statistics = False,
        extra = ''
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpeff = 1
    log: 'logs/snpeff/strelka2_indel/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpeff/ann'

rule snpeff_varscan_snv:
    input:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.vcf.gz'
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.snvs.varscan.snpeff_annotated.vcf.gz'
    params:
        # Required parameters.
        genome_version = 'hg38',
        # Optional parameters. Omit if unused.
        java_options = '-Xmx4g',
        # It true, there will be a significant speedup if there are a lot of samples.
        no_statistics = False,
        extra = ''
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpeff = 1
    log: 'logs/snpeff/varscan_snv/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpeff/ann'

rule snpeff_varscan_indel:
    input:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.vcf.gz'
    output:
        RESULT_DIR / config['varscan_result_dir'] / '{tumor}' / '{tumor}_vs_{normal}.indels.varscan.snpeff_annotated.vcf.gz'
    params:
        # Required parameters.
        genome_version = 'hg38',
        # Optional parameters. Omit if unused.
        java_options = '-Xmx4g',
        # It true, there will be a significant speedup if there are a lot of samples.
        no_statistics = False,
        extra = ''
    threads: 1  # For now the wrapper only supports single-threaded execution.
    resources: snpeff = 1
    log: 'logs/snpeff/varscan_indel/{tumor}_vs_{normal}.log'
    wrapper:
        'http://dohlee-bio.info:9193/snpeff/ann'

