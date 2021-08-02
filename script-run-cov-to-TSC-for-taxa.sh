#!/bin/bash
#----------------------------------------------------------------------------------
f_path=/Users/Olga/Google_Drive/PhD/Projects/terraces/	# path to the working directory terrace_analysis
f_scripts=$f_path/terrace_analysis/scripts
#----------------------------------------------------------------------------------
taxa="$1"
if [ "$taxa" == "" ]
then
        echo "you did not specify the taxon number!"
        echo "exiting..."
        exit
fi
#----------------------------------------------------------------------------------
f_work=$f_path/terrace_analysis/data/datasets_${taxa}_taxa
#----------------------------------------------------------------------------------
# the template for folder names
# terrace_analysis/data/datasets_TAXON_NUM_taxa/part_PARTITION_NUM/cov_TAXON_NUM_PARTITION_NUM_id/
#----------------------------------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-run-cov-to-TSC-for-taxa.sh ${taxa}"
echo "----------------------------------------------------------------------------------"
echo "	Perform analysis for all partitions and all coverage matrices for ${taxa}..."
echo "----------------------------------------------------------------------------------"
echo ""

ls $f_work | grep "part_" | awk -F "_" '{print $2}' | while read -r line
do
	part=$line
	echo "$part"
	script=$f_scripts/script-run-cov-to-TSC-for-taxa_part.sh
	$script $taxa $part "$f_path"
done
#----------------------------------------------------------------------------------
#script=$f_scripts/script-summary-for-taxa.sh
#$script $taxa "$f_path"

