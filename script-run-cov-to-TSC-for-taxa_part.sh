#!/bin/bash
#----------------------------------------------------------------------------------
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

f_path="$3"
if [ "$f_path" == "" ]
then
	echo "you did not specify the path to terrace_analysis folder!"
	echo "exiting..."
	exit
fi
#----------------------------------------------------------------------------------
f_work=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}
f_scripts=$f_path/terrace_analysis/scripts
#----------------------------------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-run-cov-to-TSC-for-taxa_part.sh ${taxa} ${part} ${f_path}"
echo "----------------------------------------------------------------------------------"
echo "  Perform analysis for all coverage matrices for taxon number ${taxa} and partition number ${part}..."
echo "----------------------------------------------------------------------------------"
echo ""


ls $f_work | grep "cov_" | awk -F "_" '{print $3}' | while read -r line
do
	id=$line
	script=$f_scripts/script-run-cov-to-TSC-for-taxa_part_cov.sh
	$script $taxa $part $id $f_path
done
#----------------------------------------------------------------------------------
#script=$f_scripts/script-summary-for-taxa_part.sh
#$script $taxa $part "$f_path"
