rule samtools_faidx:
    input:
        config['reference']['fasta']
    output:
        config['reference']['index']
    wrapper:
        'http://dohlee-bio.info:9193/samtools/faidx'

