SS = config['sambamba_sort']
rule sambamba_sort:
    input:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.bam')
    output:
        temp(str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.sorted.bam'))
    params:
        extra = SS['extra'],
        # Sets an upper bound for used memory. However, this is very approximate.
        # Default memory limit is 512 MiB. Increasing it will allow to make chunk
        # sizes larger and also reduce amount of I/O seeks thus improving the
        # overall performance. LIMIT must be a number with an optional suffix
        # specifying unit of measurement.
        # The following endings are recongnized: K, KiB, KB, M, MiB, MB, G, GiB, GB
        # Default: False
        memory_limit = SS['memory_limit'],
        # Use TMPDIR to output sorted chunks. Default behavior is to use system 
        # temporary directory.
        # Default: False
        tmpdir = SS['tmpdir'],
        # Sort by read name instead of doing coordinate sort.
        # Default: False
        sort_by_name = SS['sort_by_name'],
        # Compression level to use for sorted BAM, from 0 (known as uncompressed
        # BAM in samtools) to 9.
        # Default: False
        compression_level = SS['compression_level'],
        # Write sorted chuks as uncompressed BAM. Default dehaviour is to write them
        # with compression level 1, because that reduces time spent on I/O, but in
        # some cases using this option can give you a better speed. Note, however,
        # that the disk space needed for sorgin will typically be 3-4 times more
        # than without enabling this option.
        # Default: False
        uncompressed_chunks = SS['uncompressed_chunks'],
        # Show wget-like progressbar in STDERR (in fact, two of them one after another,
        # first one for sorting, and then another one for merging.)
        # Default: False
        show_progress = SS['show_progress'],
    threads: config['threads']['sambamba_sort']
    log: 'logs/sambamba_sort/{sample}_{library}.log'
    benchmark: 'benchmarks/sambamba_sort/{sample}_{library}.benchmark'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/sort'

rule sambamba_index:
    input:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.sorted.bam')
    output:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.sorted.bam.bai')
    threads: config['threads']['sambamba_index']
    log: 'logs/sambamba_index/{sample}_{library}.log'
    benchmark: 'benchmarks/sambamba_index/{sample}_{library}.benchmark'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/index'

rule sambamba_duplicates_marked_index:
    input:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.duplicates_marked.sorted.bam')
    output:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.duplicates_marked.sorted.bam.bai')
    threads: config['threads']['sambamba_index']
    log: 'logs/sambamba_duplicates_marked_index/{sample}_{library}.log'
    benchmark: 'benchmarks/sambamba_duplicates_marked_index/{sample}_{library}.benchmark'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/index'

SM = config['sambamba_markdup']
rule sambamba_markdup:
    input:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.sorted.bam'),
    output:
        str(RESULT_DIR / config['bwa_result_dir'] / '{library}' / '{sample}' / '{sample}.duplicates_marked.sorted.bam'),
    threads: config['threads']['sambamba_markdup']
    params:
        extra = SM['extra'],
        # Remove duplicates instead of just marking them.
        # Default: False
        remove_duplicates = SM['remove_duplicates'],
        # Specify compression level of the resulting file (from 0 to 9).
        # Default: False
        compression_level = SM['compression_level'],
        # Show progressbar in STDERR.
        # Default: False
        show_progress = SM['show_progress'],
        # Specify directory for temporary files.
        # Default: False
        tmpdir = SM['tmpdir'],
        #
        # Performance tweaking parameters.
        #
        # Size of hash table for finding read pairs (default is 262144 reads);
        # will be rounded down to the nearest power of two;
        # should be (average coverage) * (insert size) for good performance.
        # Default: 262144
        hash_table_size = SM['hash_table_size'],
        # Size of the overflow list where reads, thrown from the hash table,
        # get a second chance to meet their pairs (default is 200000 reads),
        # increasing the size reduces the number of temporary files created.
        # Default: 200000
        overflow_list_size = SM['overflow_list_size'],
        # Total amount of memory (in *megabytes*) used for sorting purposes;
        # the default is 2048, increasing it will reduce the number of created
        # temporary files and the time spent in the main thread.
        # Default: 2048
        sort_buffer_size = SM['sort_buffer_size'],
        # Two buffers of BUFFER_SIZE *megabytes* each are used for reading and
        # writing BAM during the second pass.
        # Default: 128
        io_buffer_size = SM['io_buffer_size'],
    log: 'logs/sambamba_markdup/{sample}_{library}.log'
    benchmark: 'benchmarks/sambamba_markdup/{sample}_{library}.benchmark'
    wrapper:
        'http://dohlee-bio.info:9193/sambamba/markdup'

