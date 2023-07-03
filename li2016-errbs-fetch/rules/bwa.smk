rule bwa_index:
    input:
        # Required input. Reference genome fasta file.
        config['reference']['fasta'],
    output:
        # Required output. BWA-indexed reference genome files.
        config['index']['prefix'] + '.amb',
        config['index']['prefix'] + '.ann',
        config['index']['prefix'] + '.bwt',
        config['index']['prefix'] + '.pac',
        config['index']['prefix'] + '.sa',
    params:
        extra = config['bwa_index']['extra'],
        # Note that the default algorithm for this wrapper is 'bwtsw'.
        # The other option is 'is', but please be warned that this algorithm doesn't work
        # with genomes longer than 2GB.
        # Default: 'bwtsw',
        a = config['bwa_index']['a'],
        # Block size for the bwtsw algorithm (effective with -a bwtsw).
        # Default: False [10000000]
        b = config['bwa_index']['b'],
        # Index files named as <in.fasta>.64.* instead of <in.fasta>.*
        _6 = config['bwa_index']['_6'],
    threads: config['threads']['bwa_index']
    log: 'logs/bwa_index/%s.log' % config['reference']['name']
    benchmark: 'benchmarks/bwa_index/%s.log' % config['reference']['name']
    wrapper:
        'http://dohlee-bio.info:9193/bwa/index'

BMS = config['bwa_mem_se']
rule bwa_mem_se:
    input:
        # Required input. Input read file.
        reads = [
            str(DATA_DIR / '{sample}.fastq.gz'),
        ],
        # You may use any of {genome}.amb, {genome}.ann, {genome}.bwt,
        # {genome}.pac, {genome}.sa just to obligate snakemake to run `bwa index` first.
        reference = config['index']['prefix'] + '.amb',
    output:
        # BAM output or SAM output is both allowed.
        # Note that BAM output will be automatically detected by its file extension,
        # and SAM output (which is bwa mem default) will be piped through `samtools view`
        # to convert SAM to BAM.
        temp(str(RESULT_DIR / config['bwa_result_dir'] / 'se' / '{sample}' / '{sample}.bam'))
    params:
        extra = BMS['extra'],
        # Minimum seed length.
        # Default: 19
        k = BMS['k'],
        # Band width for banded alignment.
        # Default: 100
        w = BMS['w'],
        # Off-diagonal X-dropoff.
        # Default: 100
        d = BMS['d'],
        # Look for internal seeds inside a seed longer than {-k} * FLOAT
        # Default: 1.5
        r = BMS['r'],
        # Seed occurrence for the 3rd round seeding.
        # Default: 20
        y = BMS['y'],
        # Skip seeds with more than INT occurrences.
        # Default: 500
        c = BMS['c'],
        # Drop chains shorter than FLOAT fraction of the logest overlapping chain.
        # Default: 0.5
        D = BMS['D'],
        # Discard a chain if seeded bases shorter than INT.
        # Default: 0
        W = BMS['W'],
        # Perform at most INT rounds of mate rescues for each read.
        # Default: 50
        m = BMS['m'],
        # Skip mate rescue.
        # Default: False
        S = BMS['S'],
        # Skip pairing; mate rescue performed unless -S also in use
        # Default: False
        P = BMS['P'],
        # Score for a sequence match, which scales options -TdBOELU unless overridden.
        # Default: 1
        A = BMS['A'],
        # Penalty for a mismatch.
        # Default: 4
        B = BMS['B'],
        # Gap open penalties for deletions and insertions.
        # Default: 6,6
        O = BMS['O'],
        # Gap extension penalty; a gap of size k cost '{-O} + {-E}*k'.
        # Default: 1,1
        E = BMS['E'],
        # Penalty for 5'- and 3'-end clipping.
        # Default: 5,5
        L = BMS['L'],
        # Penalty for an unpaired read pair.
        # Default: 17
        U = BMS['U'],
        # Read type. Setting -x changes multiple parameters unless overridden [null]
        # pacbio: -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0 (PacBio reads to ref)
        # ont2d: -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0 (Oxford Nanopore 2D-reads to ref)
        # intractg: -B9 -O16 -L5 (intra-species contigs to ref)
        # Default: False
        x = BMS['x'],
        # Read group header line such as '@RG\tID:foo\tSM:bar'
        # Default: False
        # NOTE: You should check the platform information of the read data!
        R = r"'@RG\tID:{sample}\tSM:{sample}\tPL:ILLUMINA'",
        # Insert STR to header if it starts with @; or insert lines in FILE.
        # Default: False
        H = BMS['H'],
        # Treat ALT contigs as part of the primary assembly. (i.e. ignore <idxbase>.alt file)
        # Default: False
        j = BMS['j'],
        # For split alignment, take the alignment with the smallest coordinate as primary.
        # Default: False
        _5 = BMS['_5'],
        # Dont't modify mapQ of supplementary alignments.
        # Default: False
        q = BMS['q'],
        # Process INT input bases in each batch regardless of nThreads (for reproducibility).
        # Default: False.
        K = BMS['K'],
        # Verbosity level: 1=error, 2=warning, 3=message, 4+=debugging
        # Default: 3
        v = BMS['v'],
        # Minimum score to output.
        # Default: 30
        T = BMS['T'],
        # If there are <INT hits with score > 80% of the max score, output all in XA.
        # Default: 5,200
        h = BMS['h'],
        # Output all alignments for SE or unpaired PE.
        # Default: False
        a = BMS['a'],
        # Append FASTA/FASTQ comment to SAM output.
        # Default: False
        C = BMS['C'],
        # Output the reference FASTA header in the XR tag.
        # Default: False
        V = BMS['V'],
        # Use soft clipping for supplementary alignments.
        # Default: False
        Y = BMS['Y'],
        # Mark shorter split hits as secondary.
        # NOTE: You may need this if you use GATK downstream.
        # Default: False
        M = BMS['M'],
        # Specify the mean, standard deviation (10% of the mean if absent), max
        # (4 sigma from the mean if absent) and min of the insert size distribution.
        # FR orientation only.
        # Default: False (inferred)
        I = BMS['I'],
    threads: config['threads']['bwa_mem']
    log: 'logs/bwa_mem/{sample}.log'
    benchmark: 'benchmarks/bwa_mem/{sample}.benchmark'
    wrapper:
        'http://dohlee-bio.info:9193/bwa/mem'

BMP = config['bwa_mem_pe']
rule bwa_mem_pe:
    input:
        # Required input. Input read file.
        reads = [
            str(DATA_DIR / '{sample}.read1.fastq.gz'),
            str(DATA_DIR / '{sample}.read2.fastq.gz'),
        ],
        # You may use any of {genome}.amb, {genome}.ann, {genome}.bwt,
        # {genome}.pac, {genome}.sa just to obligate snakemake to run `bwa index` first.
        reference = config['index']['prefix'] + '.amb',
    output:
        # BAM output or SAM output is both allowed.
        # Note that BAM output will be automatically detected by its file extension,
        # and SAM output (which is bwa mem default) will be piped through `samtools view`
        # to convert SAM to BAM.
        temp(str(RESULT_DIR / config['bwa_result_dir'] / 'pe' / '{sample}' / '{sample}.bam'))
    params:
        extra = BMP['extra'],
        # Minimum seed length.
        # Default: 19
        k = BMP['k'],
        # Band width for banded alignment.
        # Default: 100
        w = BMP['w'],
        # Off-diagonal X-dropoff.
        # Default: 100
        d = BMP['d'],
        # Look for internal seeds inside a seed longer than {-k} * FLOAT
        # Default: 1.5
        r = BMP['r'],
        # Seed occurrence for the 3rd round seeding.
        # Default: 20
        y = BMP['y'],
        # Skip seeds with more than INT occurrences.
        # Default: 500
        c = BMP['c'],
        # Drop chains shorter than FLOAT fraction of the logest overlapping chain.
        # Default: 0.5
        D = BMP['D'],
        # Discard a chain if seeded bases shorter than INT.
        # Default: 0
        W = BMP['W'],
        # Perform at most INT rounds of mate rescues for each read.
        # Default: 50
        m = BMP['m'],
        # Skip mate rescue.
        # Default: False
        S = BMP['S'],
        # Skip pairing; mate rescue performed unless -S also in use
        # Default: False
        P = BMP['P'],
        # Score for a sequence match, which scales options -TdBOELU unless overridden.
        # Default: 1
        A = BMP['A'],
        # Penalty for a mismatch.
        # Default: 4
        B = BMP['B'],
        # Gap open penalties for deletions and insertions.
        # Default: 6,6
        O = BMP['O'],
        # Gap extension penalty; a gap of size k cost '{-O} + {-E}*k'.
        # Default: 1,1
        E = BMP['E'],
        # Penalty for 5'- and 3'-end clipping.
        # Default: 5,5
        L = BMP['L'],
        # Penalty for an unpaired read pair.
        # Default: 17
        U = BMP['U'],
        # Read type. Setting -x changes multiple parameters unless overridden [null]
        # pacbio: -k17 -W40 -r10 -A1 -B1 -O1 -E1 -L0 (PacBio reads to ref)
        # ont2d: -k14 -W20 -r10 -A1 -B1 -O1 -E1 -L0 (Oxford Nanopore 2D-reads to ref)
        # intractg: -B9 -O16 -L5 (intra-species contigs to ref)
        # Default: False
        x = BMP['x'],
        # Read group header line such as '@RG\tID:foo\tSM:bar'
        # Default: False
        # NOTE: You should check the platform information of the read data!
        R = r"'@RG\tID:{sample}\tSM:{sample}\tPL:ILLUMINA'",
        # Insert STR to header if it starts with @; or insert lines in FILE.
        # Default: False
        H = BMP['H'],
        # Treat ALT contigs as part of the primary assembly. (i.e. ignore <idxbase>.alt file)
        # Default: False
        j = BMP['j'],
        # For split alignment, take the alignment with the smallest coordinate as primary.
        # Default: False
        _5 = BMP['_5'],
        # Dont't modify mapQ of supplementary alignments.
        # Default: False
        q = BMP['q'],
        # Process INT input bases in each batch regardless of nThreads (for reproducibility).
        # Default: False.
        K = BMP['K'],
        # Verbosity level: 1=error, 2=warning, 3=message, 4+=debugging
        # Default: 3
        v = BMP['v'],
        # Minimum score to output.
        # Default: 30
        T = BMP['T'],
        # If there are <INT hits with score > 80% of the max score, output all in XA.
        # Default: 5,200
        h = BMP['h'],
        # Output all alignments for SE or unpaired PE.
        # Default: False
        a = BMP['a'],
        # Append FASTA/FASTQ comment to SAM output.
        # Default: False
        C = BMP['C'],
        # Output the reference FASTA header in the XR tag.
        # Default: False
        V = BMP['V'],
        # Use soft clipping for supplementary alignments.
        # Default: False
        Y = BMP['Y'],
        # Mark shorter split hits as secondary.
        # NOTE: You may need this if you use GATK downstream.
        # Default: False
        M = BMP['M'],
        # Specify the mean, standard deviation (10% of the mean if absent), max
        # (4 sigma from the mean if absent) and min of the insert size distribution.
        # FR orientation only.
        # Default: False (inferred)
        I = BMP['I'],
    threads: config['threads']['bwa_mem']
    log: 'logs/bwa_mem/{sample}.log'
    benchmark: 'benchmarks/bwa_mem/{sample}.benchmark'
    wrapper:
        'http://dohlee-bio.info:9193/bwa/mem'

