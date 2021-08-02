#!/bin/bash

#--------------------------------------------------------------------------------
#Arguments
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

#tree_type="$3"
#if [ "$tree_type" == "" ]
#then
#        echo "you did not specify the tree type!"
#        echo "exiting..."
#        exit
#fi

#------------------------------------------------------------------------------------
f=/Users/Olga/Google_Drive/PhD/Projects/terraces/2019.11.Nov/datasets_${taxa}_taxa/part_${part}

ls $f | grep "cov_" |  awk -F "cov_${taxa}_" '{print $2}' | while read -r line
do

        id=$line
        echo "currently copying datasets_${taxa}_taxa/part_$part/cov_${taxa}_${id}..."
        file=cov_${taxa}_${id}
        f_origin=$f/cov_${taxa}_${id}
        f_dest=/Users/Olga/Google_Drive/PhD/Projects/terraces/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_$id

        mkdir -p $f_dest
        cp $f_origin/$file $f_dest/

#exit
done
