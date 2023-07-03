import pandas as pd
from pathlib import Path

DATA_DIR = Path('data')
RESULT_DIR = Path('result')

meta = pd.read_csv('DBGAP_AML_SAMPLE_MAPPING.csv')
runs = meta.run_rrbs.values

FASTQ = expand(str(DATA_DIR / '{sample}.fastq.gz'), sample=runs)

ALL = []
ALL.append(FASTQ)

include: 'rules/fetch-dbgap-data.smk'
include: 'rules/fasterq-dump.smk'

onsuccess: 'AML ERRBS DOWNLOAD COMPLETED.'

rule all:
    input: ALL
