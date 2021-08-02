#!/bin/bash
#-------------------------------------------------------------------------------------------
# Software
#iq_terr=/Users/Olga/Google_Drive/PhD/Projects/terraces/terrace_analysis/scripts/iqtree_terrace # INSTAL IQTREE TERRACE BRANCH
#iq_terr=/Users/Olga/Projects/Science/Projects/terraces/terrace_analysis/scripts/iqtree2
#iqtree=/Users/Olga/Projects/Science/Projects/terraces/terrace_analysis/scripts/iqtree2

iq_terr=/Users/Olga/Projects/Science/Projects/terraces/terrace_analysis/scripts/iqtree_terrace

if [ "$iq_terr" == "" ]
then
	echo "Sorry I don't know where to find iqtree binary:( Instal it and specify here the binary with the path to it."
	echo "exiting..."
	echo
fi

#iqtree=/Users/Olga/Google_Drive/PhD/Projects/terraces/terrace_analysis/scripts/iqtree_terrace # specify the usual iqtree or maybe use the same binary as in iq_terr?
iqtree=/Users/Olga/Projects/Science/Projects/terraces/terrace_analysis/scripts/iqtree_terrace

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
f_input=$f_path/terrace_analysis/data/input
f_scripts=$f_path/terrace_analysis/scripts
f=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_${id}
#-------------------------------------------------------------------------------------------
#Files that should be prepared ahead!
trees=$f_input/trees/all_trees_${taxa}

# for tests with generating terrace trees
tree_id=1
#trees=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_${id}/terrace_generate_trees/results_tree_${taxa}_${tree_id}/terrace_trees

#-------------------------------------------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-split-space-into-terraces.sh ${taxa} ${part} ${id} ${f_path}"
echo "----------------------------------------------------------------------------------"
echo "  Perform split of tree into terraces for coverage matrix ${id} for taxon number ${taxa} and partition number ${part}..."
echo "----------------------------------------------------------------------------------"
echo ""


#echo "specs for this run: taxa|part|cov -> $taxa|$part|$id"
cov=$f/cov_${taxa}_${id}
#----------------------------------------------------------
# Check if corresponding tree file exists
# Note: this file should be prepared in advance!
#trees=$f_path/terrace_analysis/data/input/trees/all_trees_${taxa}_taxa
if [ ! -e $trees ]
then
        echo "---> script-split-space-into-terraces.sh"
        echo "File with trees does not exit! Check if the file name is correct: $trees"
        echo "exiting..."
        exit
fi
#----------------------------------------------------------
echo "Starting the analysis: split the trees into terraces..."
cp $trees $f/terrace_OUT_0
file="$f/terrace_OUT_0"

query="`wc -l $trees | awk -F " " '{print $1}'`"
n=0
while [ $query -gt 0 ]
do
	echo "-------------------------------------------------------------------------"
	n=$[$n+1]
	echo "Preparing to analyse terrace_$n..."

	head -n 1 $file > $f/terrace_rep_$n
	echo "terrace representative"
	cat $f/terrace_rep_$n

	tail -n +2 $file > $f/terrace_query_$n
	q_trees="`wc -l $f/terrace_query_$n | awk -F " " '{print $1}'`"
	echo "$q_trees of query trees in the file terrace_query_$n ..."

	# clean a bit
	rm $file

	echo "Starting analysis.."
	file_out="$f/terrace_$n"
	#$iq_terr -sp $part_info -s $aln -terrace_rep $f/terrace_rep_$n -terrace_query $f/terrace_query_$n -pre $file_out


	$iq_terr -terrace_analysis -pr_ab_matrix $cov $f/terrace_rep_$n -terrace_query $f/terrace_query_$n -pre $file_out 

	# clean a bit
	#rm $file_out.log
	#rm $f/terrace_rep_$n
	#rm $f/terrace_query_$n

	query="`wc -l $file_out.off_terrace | awk -F " " '{print $1}'`"
	echo "$query trees are not on the cosidered terrace"
	file=$file_out.off_terrace
done

mkdir $f/rfdist
cp $f/*.on_terrace $f/rfdist
rm $f/*terrace*

if [ -e $f/trivial_terraces ]
then
	rm $f/trivial_terraces
fi

for i in $f/rfdist/*.on_terrace
do
	check="`wc -l $i | awk -F " " '{print $1}'`"
	if [ $check -eq 1 ]
	then
		echo "terrace is trivial with just one tree"
		echo "$i|trivial|contains_ONE_TREE_only" >> $f/trivial_terraces
	else
		echo "terrace contains $check trees"
		$iqtree -rf_all $i
		# clean a bit
		rm $i.log
	fi
done


if [ -e $f/trivial_terraces ]
then
	v="`wc -l $f/trivial_terraces | awk -F " " '{print $1}'`"
	mv $f/trivial_terraces $f/trivial_terraces_${v}_stk
fi
