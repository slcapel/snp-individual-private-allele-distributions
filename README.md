# Individual Private Allele Genotypes for Population of Interest

This script was designed to identify the distribution of private alleles among individuals of a population of interest following identification of private alleles among populatios of origin (see https://github.com/slcapel/snp-population-level-private-allele-tracker). While it is informative to identify the population-level distribution of private alleles present via maintenance and introgression, it can be equally important to understand how those private alleles are distributed among individuals of said population.

![schmatic](https://github.com/slcapel/snp-individual-private-allele-genotypes/blob/master/Individual%20Private%20Allele%20Graphic.png?raw=true)

This script cannot be executed properly without first identifying population-level private allele using https://github.com/slcapel/snp-population-level-private-allele-tracker. The final product of this script is a modified VCF file containing all individuals from the population of interest and their genotypes for each private allele locus.

## Requirements:
* Linux-based environment with bash-5.0 or later
* VCFtools v0.1.16 or later
* Private Allele Tracker v1.0.0 (https://github.com/slcapel/snp-population-level-private-allele-tracker) output files

## Instructions
After running `population_private_alleles.sh` simply fill out the following variables within the "INPUTS" box near the top of the script:
* Within the quotations following `popint` input the string used to designate your population of interest in your population map used by the _populations_ program of Stacks (Rochette et al. 2019)
* Following `src1` input the path to directory containing populations run for all populations
* Following `src2` input the path to directory containing populations run for populations of origin
* Following `popmap` input the path to the population map file used to run _populations_ for all populations

Once you have filled out the required inputs simply run the script on the command line `./individual_private_allele_gt.sh`.  It will return a final output file named `populations.PA_GT_Present_$popint.Indiv.snp.tsv` where `$popint` will be the string designation for your populaiton of interest. As is normal VCF format, the genotypes for individuals will be coded with 0 for the primary (most common) allele and 1 for the alternate allele.  In this case, all 1s indicate private alleles.

## Output file format
| Column | Name | Description |
| ------ | ---- | ----------- |
| 1 | Locus ID_Col | Private allele locus and SNP ID as assigned by populations.sumstats.tsv (i.e. Locus_SNP) |
| 2 | Pop ID | Population from which the private allele originated |
| 3 | Q Nuc | Private allele nucleotide identity |
| 4 | CHROM | Locus ID as assigned by the VCF file (off by 1 when compared to other Stacks files) |
| 5 | POS | SNP ID as assigned by the VCF file (off by 1 when compared to other Stacks files) |
| 6+ | _varies_ | Remaining columns are the genotypes of each individual from the population of interest for each locus |
