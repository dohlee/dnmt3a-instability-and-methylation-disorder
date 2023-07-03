import pandas as pd
from pathlib import Path

DATA_DIR = Path('data')
RESULT_DIR = Path('result')

meta = pd.read_csv('NBM_ERRBS_run_table.txt')
single = meta[meta.LibraryLayout == 'SINGLE'].Run.values

FASTQ = expand(str(DATA_DIR / '{sample}.fastq.gz'), sample=single)
ALL = []
ALL.append(FASTQ)

include: 'rules/fetch-dbgap-data.smk'
include: 'rules/fasterq-dump.smk'

onsuccess: 'NBM ERRBS DOWNLOAD COMPLETED.'

rule all:
    input: ALL
