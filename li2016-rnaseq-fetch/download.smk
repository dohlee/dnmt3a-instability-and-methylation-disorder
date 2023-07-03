import pandas as pd
from pathlib import Path

configfile: 'config.yaml'
manifest = pd.read_csv(config['manifest'])

DATA_DIR = Path(config['data_dir'])
RESULT_DIR = Path(config['result_dir'])

runs = manifest.Run.values

FASTQ_READ1 = expand(str(DATA_DIR / '{sample}.read1.fastq.gz'), sample=runs)
FASTQ_READ2 = expand(str(DATA_DIR / '{sample}.read2.fastq.gz'), sample=runs)

ALL = []
ALL.append(FASTQ_READ1)
ALL.append(FASTQ_READ2)

include: 'rules/fetch-dbgap-data.smk'
include: 'rules/fasterq-dump.smk'

onsuccess: shell('push AML RNA-SEQ DOWNLOAD COMPLETED.')

rule all:
    input: ALL
