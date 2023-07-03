rule parallel_fastq_dump_single:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        'sra/{sample}.sra'
    output:
        # Required output.
        temp(DATA_DIR / '{sample}.fastq.gz')
    params:
        extra = '--tmpdir . '
    threads: config['threads']['parallel_fastq_dump']
    resources: dump = 1
    wrapper:
        'http://dohlee-bio.info:9193/parallel-fastq-dump'

rule parallel_fastq_dump_paired:
    input:
        # Required input. Recommend using wildcards for sample names,
        # e.g. {sample,SRR[0-9]+}
        'sra/{sample}.sra'
    output:
        # Required output.
        temp(DATA_DIR / '{sample}.read1.fastq.gz'),
        temp(DATA_DIR / '{sample}.read2.fastq.gz'),
    params:
        # Optional parameters. Omit if unused.
        extra = '--tmpdir . '
    resources: dump = 1
    threads: config['threads']['parallel_fastq_dump']
    wrapper:
        'http://dohlee-bio.info:9193/parallel-fastq-dump'

