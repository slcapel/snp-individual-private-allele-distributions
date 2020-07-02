#!/bin/bash

# by Samantha LR Capel <scapel2@illinois.edu> <slr.capel2@gmail.com>

# DISCLAIMER: this script runs on the contingency that you have run population_private_alleles.sh (see https://github.com/slcapel/snp-population-level-private-allele-tracker)

##################################### INPUTS #####################################
popint=""  # string used to designate population of interest in population map   #
src1=  # path to directory containing populations run for all populations        #
src2=  # path to directory containing populations run for populations of origin  #
popmap= # path to population map used for all populations                        #
##################################################################################


# Setting variables for list of private allele SNP loci and VCF file to be filtered
snps=$src1/loci_PA_$popint.csv
cat=$src1/Output/populations.snps.vcf

# Generate a list of individuals to analyze (population of interest)
cat $popmap | grep $popint | cut -f 1 > $src1/$popint.indiv.txt

# Generate a list of the private allele loci names to analyze (vcf SNPs are coded 1+ from other output files)
cat $snps | tr "_" "\t" | awk '{ print $1 "\t" $2+1}' > $src1/loci_PA_$popint+1.csv

# Filter vcf file to just private allele SNP positions, individuals of interest, and genotype information
vcftools --vcf $cat --extract-FORMAT-info GT --keep $src1/$popint.indiv.txt --positions $src1/loci_PA_$popint+1.csv --out $src1/Output/populations.snps.filtered

# Create a list of which population private alleles originate from for each SNP locus
cat $src2/populations.sumstats_all.PA_$popint.sampled.tsv | awk '{ if ( $18 == 1 ) {print $1 "\t" $2 } }' > $src1/PA_pops.tsv
top1=$(head -n 1 $src2/populations.sumstats_all.PA_$popint.sampled.tsv | cut -f 1,2)
sed -i "1 i $top1" $src1/PA_pops.tsv

# Combine PA population origin list and filtered vcf file
paste $src1/PA_pops.tsv $src1/Output/populations.snps.filtered.GT.FORMAT > $src1/Output/population.snps.PA_$popint.Indiv.tsv

# Remove loci with no private alleles sampeld in IL2003
cat $src1/Output/population.snps.PA_$popint.Indiv.tsv| grep "0/1\|1/1\|CHROM" > $src1/Output/populations.PA_GT_Present_$popint.Indiv.snp.tsv

# Remove temporary files
rm $src1/Output/population.snps.PA_$popint.Indiv.tsv
rm $src1/Output/populations.snps.filtered.GT.FORMAT
