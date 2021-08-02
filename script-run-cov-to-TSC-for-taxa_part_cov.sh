#!/bin/bash

taxa="$1"
if [ "$taxa" == "" ]
then
        echo "you did not specify the taxon number!"
        echo "exiting..."
        exit
fi

part="$2"
if [ "$part" == "" ]
then
        echo "you did not specify the partition number!"
        echo "exiting..."
        exit
fi

id="$3"
if [ "$id" == "" ]
then
        echo "you did not specify the coverage id!"
        echo "exiting..."
        exit
fi

f_path="$4" # either pass it from the previous script or write here the hard path
f_path=/Users/Olga/Google_Drive/PhD/Projects/terraces/
f_path=/Users/Olga/Projects/Science/Projects/terraces/


if [ "$f_path" == "" ]
then
        echo "you did not specify the path to terrace_analysis folder!"
        echo "exiting..."
        exit
fi

#----------------------------------------------------------
#echo "specs for this run: taxa|part|cov -> $taxa|$part|$id"
f_work=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_${id}
f_scripts=$f_path/terrace_analysis/scripts
#----------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-run-cov-to-TSC-for-taxa_part_cov.sh ${taxa} ${part} ${id} ${f_path}"
echo "----------------------------------------------------------------------------------"
echo "  Perform analysis for coverage matrix ${id} for taxon number ${taxa} and partition number ${part}..."
echo "----------------------------------------------------------------------------------"
echo ""
#----------------------------------------------------------

file=$f_work/cov_${taxa}_${id}
if [ ! -e $file ]
then
	echo "---> script-run-cov-to-TSC-for-taxa_part_cov.sh"
	echo "Ooops! File does not exist! Check if the file name is correct: $file"
	echo "exiting..."
	exit
fi
#----------------------------------------------------------
# Split the trees into terraces using iqtree
script=$f_scripts/script-split-space-into-terraces.sh
#script=$f_scripts/script-split-space-into-terraces-Gentrius.sh
#$script $taxa $part $id $f_path
#----------------------------------------------------------
# do the check here, run only if the previous was successful!
# Run terrace check
script=$f_scripts/script-run-terrace-check.sh
#$script $taxa $part $id $f_path
#----------------------------------------------------------
# do the check here, run only if the previous was successful!
# Get details about Tree Space Configuration
script=$f_scripts/script-get_tree_space_config-for-cov.sh
$script $taxa $part $id $f_path
#----------------------------------------------------------
# do the check here, run only if the previous was successful!
# Plot and summarise Tree Space Configuration
script=$f_scripts/script-plot_tree_space_config-for-cov.sh
$script $taxa $part $id $f_path
#----------------------------------------------------------
