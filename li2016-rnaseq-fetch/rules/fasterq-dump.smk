rule fasterq_dump_single:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        'sra/{sample}.sra'
    output:
        # Required output.
        'files/{sample}.fastq.gz'
    params:
        extra = ''
    threads: config['threads']['fasterq-dump']
    resources: io = 1
    wrapper:
        'http://dohlee-bio.info:9193/fasterq-dump'

rule fasterq_dump_paired:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        'sra/{sample}.sra'
    output:
        # Required output.
        'files/{sample}.read1.fastq.gz',
        'files/{sample}.read2.fastq.gz',
    params:
        # Optional parameters. Omit if unused.
        extra = ''
    threads: config['threads']['fasterq-dump']
    resources: io = 1
    # wrapper:
        # 'http://dohlee-bio.info:9193/fasterq-dump'
    script:
        '/data/project/dohoon/workbench/snakemake-wrappers/fasterq-dump/wrapper.py'

