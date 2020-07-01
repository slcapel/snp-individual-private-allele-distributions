# Individual Private Allele Genotypes for Population of Interest

This script was designed to identify the distribution of private alleles among individuals of a population of interest following identification of private alleles among populatios of origin (see https://github.com/slcapel/snp-population-level-private-allele-tracker). While it is informative to identify the population-level distribution of private alleles present via maintenance and introgression, it can be equally important to understand how those private alleles are distributed among individuals of said population.

![schmatic](https://github.com/slcapel/snp-individual-private-allele-genotypes/blob/master/Individual%20Private%20Allele%20Graphic.png?raw=true)

This script cannot be executed properly without first identifying population-level private allele using https://github.com/slcapel/snp-population-level-private-allele-tracker. The final product of this script is a modified vcf file containing all individuals from the population of interest and their genotypes for each private allele locus.

## Requirements:
* Linux-based environment with bash-5.0 or later
* VCFtools v0.1.16 or later
* Private Allele Tracker v1.0.0 (https://github.com/slcapel/snp-population-level-private-allele-tracker) output files

## Output file format
| Column | Name | Description |
| ------ | ---- | ----------- |
| 1 | Locus ID_Col | Private allele locus and SNP ID as assigned by populations.sumstats.tsv (i.e. Locus_SNP) |
| 2 | Pop ID | Population from which the private allele originated |
| 3 | Q Nuc | Private allele nucleotide identity |
| 4 | CHROM | Locus ID as assigned by the VCF file (off by 1 when compared to other Stacks files) |
| 5 | POS | SNP ID as assigned by the VCF file (off by 1 when compared to other Stacks files) |
| 6+ | _varies_ | Remaining columns are the genotypes of each individual from the population of interest for each locus |
