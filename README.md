# dnmt3a-instability-and-methylation-disorder

This repository provides analysis codes and bioinformatic pipelines for article entitled "Increased local DNA methylation disorder in AMLs with DNMT3A-destabilizing variants and its clinical implication".

## Analysis codes and bioinformatics pipelines

This repository is organized into several directories:

**li2016-errbs-fetch** *(~3 days, depending on the network status)*

*Related to Fig. 1, 2, 3, 4 Supplementary Fig. 2, 4, 5, 6, 7*

This directory contains the pipeline for downloading Li2016 enhanced reduced representation bisulfite sequencing (eRRBS) data.
To run this pipeline, you should have access for dbGaP accession phs001027.v2.p1 and appropriately configure the download directory using `sra-toolkit`.

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -s download_aml_errbs.smk -pr -j[CORES] --network 1
$ snakemake -s download_nbm_errbs.smk -pr -j[CORES] --network 1
```

**li2016-errbs-processing** *(~1 week)*

*Related to Fig. 1, 2, 3, 4 Supplementary Fig. 2, 4, 5, 6, 7*

*Requires a symlink to FASTQ files (from `li2016-errbs-fetch`) in a sub-directory named `data`*

This directory contains the processing pipeline for eRRBS data processing pipeline.
Given eRRBS data, sequencing reads were trimmed using `trim-galore`, aligned to reference genome by `bismark`.
Aligned reads were sorted and indexed using `sambamba` and CpG-wise methylation levels were quantified by `MethylDackel`.

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -pr -j[CORES]
```

**li2016-methylation-heterogeneity-calculation** *(<6 hours)*

*Related to Fig. 1, 3, 4 and Supplementary Fig. 2*

*Requires a symlink to BAMs and BAM indices (from `li2016-errbs-processing`) in a sub-directory named `bams`*

Given aligned eRRBS reads from `li2016-errbs-processing` pipeline, methylation heterogeneity levels (including local pairwise methylation disorder (LPMD) levels, epipolymorphism (PM) and methylation entropy levels (ME)) were computed using `metheor`.
This pipeline also computes the context-specific methylation heterogeneity across (1) CpG islands, (2) CpG shores, (3) CpG shelves, (4) promoters, (5) methylation canyons, (6) exons, (7) gene bodies, (8) SINEs, (9) LINESs, (10) LTRs, (11) bivalent chromatin domains, (12) bivalent promoters, (13) non-bivalent promoters.

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -pr -j[CORES]
```

**li2016-dmr-calling** *(<2 hours)*

*Related to Fig. 2, 3 and Supplementary Fig. 5, 6*

*Requires a symlink to methylation level bedGraph files (from `li2016-errbs-processing`) in a sub-directory named `data`*

This directory contains the differentially methylated region (DMR)-calling pipeline using `metilene`.
This pipeline identifies the DMRs between (1) DNMT3A-instability (INS) vs normal bone marrow (NBM), (2) WT vs NBM, (3) DNMT3A-R882 (R882) vs NBM, (4) INS vs WT, (5) R882 vs WT and (6) DNMT3A-Other (Other) vs NBM.

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -pr -j[CORES]
```

**li2016-pileup-methlevel-around-dmr** *(<2 hours)*

*Related to Fig. 2, 3 and Supplementary Fig. 5*

*Requires a symlink to methylation level bedGraph files (from `li2016-errbs-processing`) in a sub-directory named `data`*

This directory contains the analysis pipeline for aggregating methylation levels around DMRs. 

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -pr -j[CORES]
```

**li2016-rnaseq-fetch**

*Related to Fig. 4*

This directory contains the pipeline for downloading Li2016 RNA-seq data.
To run this pipeline, you should have access for dbGaP accession phs001027.v2.p1 and appropriately configure the download directory using `sra-toolkit`.

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -s download.smk -pr -j[CORES] --network 1
```

**li2016-rnaseq-processing**

*Related to Fig. 4*

*Requires a symlink to FASTQ files (from `li2016-rnaseq-fetch`) in a sub-directory named `data`*

This directory contains the RNA-seq data processing pipeline for Li2016 cohort.
Given RNA-seq data, sequencing reads were trimmed using `trim-galore`, aligned to hg38 reference genome with GENCODE v32 gene annotation using `STAR`.

After moving into the directory, the pipeline can be run as below:
```bash
$ snakemake -pr -j[CORES]
```

**source-data-and-analysis-codes**

This diectory contains the source data and Jupyter Notebooks with analysis codes to reproduce the figures in the manuscript.

- `source_data`: Processed (mostly) tabular data that are used to generate figures in the manuscript.
- `source_data_figures`: Manuscript figures in both `png` and `pdf` formats.
- `*.ipynb`: Jupyter Notebook containing analysis codes.

*Please note that some analyses require the access for participant phenotype data under dbGaP accession phs001027.v2.p1, so these phenotype data is not included in the `data` sub-directory.*

## System Requirements

### Hardward requirements

Analyses throughout this study were done using a server with 128 Intel(R) Xeon(R) Gold 6130 CPU @ 2.10GHz CPUs and 504GB RAM.

According to the statistics above, we provide the optimal hardware requirements as follows:

- CPU requirement: 64+ cores, 2.10+ GHz per core
- RAM requirement: 256+ GB

### Software requirements

**Operating system**

All the analyses were done on *Linux* operating system.

**Software package versions**

The versions of the software packages used in this study are as below:

- `sra-toolkit`=2.10.1
- `fasterq-dump`=2.9.2
- `parallel-fastq-dump`=0.6.6
- `trim-galore`=0.6.7
- `bismark`=0.22.3
- `MethylDackel`=0.4.0
- `bwa`=0.7.17-r1188
- `Strelka2`=v2.9.10
- `Varscan`=2.4.4
- `SnpEff`=5.0
- `SnpSift`=4.3t
- `STAR`=2.7.8a
- `RSEM`=1.3.1
- `Metheor`=0.1.2
- `bedtools`=2.26.0
- `metilene`=0.2-8