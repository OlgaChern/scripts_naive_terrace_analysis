#!/bin/bash
#-------------------------------------------------------------------------------------------
# Arguments

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
if [ "$f_path" == "" ]
then
        echo "you did not specify the path to terrace_analysis folder!"
        echo "exiting..."
        exit
fi
#-------------------------------------------------------------------------------------------
# Folders
f_scripts=$f_path/terrace_analysis/scripts
f=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_${id}
#-------------------------------------------------------------------------------------------
# Scripts
script="$f_scripts/script-get_tree_space_config-simple.sh"
#-------------------------------------------------------------------------------------------
file="$f/tree_space_config/TSG_map_tree_terrace"
#-------------------------------------------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-get_tree_space_config-for-cov.sh ${taxa} ${part} ${id} ${f_path}"
echo "----------------------------------------------------------------------------------"
echo "  Perform tree space configuration analysis for coverage matrix ${id} for taxon number ${taxa} and partition number ${part}..."
echo "----------------------------------------------------------------------------------"
echo ""
#-------------------------------------------------------------------------------------------




if [ -e $file ]
then
	echo "Tree space coonfiguration file already EXISTS!"
	echo "$file"
	echo ""
else
	echo "running TSC analysis"
	$script $taxa $part $id $f_path
	echo ""
fi
