rule prefetch:
    output:
        temp('sra/{sample,SRR[0-9]+}.sra')
    resources:
        network = 1
    shell:
        "prefetch --ascp-path "
        "'/data/home/dohoon/.aspera/connect/bin/ascp|/data/home/dohoon/.aspera/connect/etc/asperaweb_id_dsa.openssh' "
        "--ascp-options -l100M {wildcards.sample}"

