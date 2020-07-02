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
cat=$src1/populations.snps.vcf # if your vcf output file from the populations run for all populations is locate elsewhere, edit this path accordingly

# Generate a list of individuals to analyze (population of interest)
cat $popmap | grep $popint | cut -f 1 > $src1/$popint.indiv.txt

# Generate a list of the private allele loci names to analyze (vcf SNPs are coded 1+ from other output files)
cat $snps | tr "_" "\t" | awk '{ print $1 "\t" $2+1}' > $src1/loci_PA_$popint+1.csv

# Filter vcf file to just private allele SNP positions, individuals of interest, and genotype information
vcftools --vcf $cat --extract-FORMAT-info GT --keep $src1/$popint.indiv.txt --positions $src1/loci_PA_$popint+1.csv --out $src1/populations.snps.filtered

# Create a list of which population private alleles originate from for each SNP locus
cat $src2/populations.sumstats_all.PA_$popint.sampled.tsv | awk '{ if ( $18 == 1 ) {print $1 "\t" $2 } }' > $src1/PA_pops.tsv
top1=$(head -n 1 $src2/populations.sumstats_all.PA_$popint.sampled.tsv | cut -f 1,2)
sed -i "1 i $top1" $src1/PA_pops.tsv

# Combine PA population origin list and filtered vcf file
paste $src1/PA_pops.tsv $src1/populations.snps.filtered.GT.FORMAT > $src1/population.snps.PA_$popint.Indiv.tsv

### Remove loci with no private alleles sampeld in IL2003 and create individual genotypes file ###
cat $src1/population.snps.PA_$popint.Indiv.tsv| grep "0/1\|1/1\|CHROM" > $src1/populations.PA_GT_Present_$popint.Indiv.snp.tsv

# Calculate the number of individuals within population of interest
numind=$(wc -l < $src1/$popint.indiv.txt)
fc=$(expr $numind + 5)

# Create an array containing string names of all populations of origin
origpops=()
cat $popmap | cut -f 2 | sort -g | uniq | grep -v $popint > $src1/op.txt
readarray -t origpops < $src1/op.txt

# Calculate the distribution of private alleles among individuals from population of interest
for i in $(seq 6 $fc)
do
    for j in "${origpops[@]}"
    do
        if [[ "$j" == "${origpops[0]}" ]]
        then
            cat $src1/populations.PA_GT_Present_$popint.Indiv.snp.tsv | cut -f $i | head -n 1
        fi
        cat $src1/populations.PA_GT_Present_$popint.Indiv.snp.tsv | cut -f 2,$i | grep -v "0/0\|\." | sed -E 's/0\/1/1/; s/1\/1/2/' | grep $j | awk -v j=$j '{s+=$2} END {if (s != 0) print s; else print 0}'
    done > $src1/temp$i
done

### Create final output file of individual private allele distributions ###
for i in "${origpops[@]}"
do
    echo $i
done > $src1/$popint.Indiv.PA.dist.tsv
sed -i '1 i\P.A. Origin ' $src1/$popint.Indiv.PA.dist.tsv
paste $src1/$popint.Indiv.PA.dist.tsv $(seq -f "$src1/temp%.0f" 6 $fc) > $src1/out.tsv
cat $src1/out.tsv

# Delete temporary files
for i in $(seq 6 $fc)
do
    rm $src1/temp$i
done
rm $src1/op.txt
rm $src1/population.snps.PA_$popint.Indiv.tsv
rm $src1/populations.snps.filtered.GT.FORMAT
