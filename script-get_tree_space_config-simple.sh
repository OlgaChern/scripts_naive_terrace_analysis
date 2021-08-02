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
f_work=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_${id}
#-------------------------------------------------------------------------------------------
# Scripts
script="$f_scripts/script-get_tree_space_config-simple.sh"
iqtree="iqtree"
#-------------------------------------------------------------------------------------------
f_rfdist=$f_work/rfdist
f_tsc=$f_work/tree_space_config
file_tsc=$f_tsc/TSG_map_tree_terrace
file_trees=$f_tsc/trees_in_terrace_order

mkdir $f_tsc

if [ -e $file_tsc ]
then
        rm $file_tsc
fi

if [ -e $file_trees ]
then
        rm $file_tsc
fi


totalNUM="`ls $f_rfdist/terrace_*.terrace_ON | wc -l | awk -F " " '{print $1}'`"
NUM=0
while [ $NUM -ne $totalNUM ]
do
	NUM=$[$NUM+1]
	i=$f_rfdist/terrace_${NUM}.terrace_ON
	echo "$i"
        cat $i >> $file_trees
        size="`wc -l $i | awk -F " " '{print $1}'`"
        while [ $size -ne 0 ]
        do
                size=$[$size - 1]
                echo "$NUM" >> $file_tsc
        done
done

$iqtree -rf_all $file_trees 

