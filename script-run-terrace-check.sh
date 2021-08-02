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
script_r=$f_scripts/script-check_terrace_connectivity.r
script_r_tree_plots=$f_scripts/script-plot_terrace_trees.r
#-------------------------------------------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-run-terrace-check.sh ${taxa} ${part} ${id} ${f_path}"
echo "----------------------------------------------------------------------------------"
echo "  Perform check (connected/disconnected) for terraces for coverage matrix ${id} for taxon number ${taxa} and partition number ${part}..."
echo "----------------------------------------------------------------------------------"
echo ""
#-------------------------------------------------------------------------------------------

cov=$f/cov_${taxa}_${id}
res=$f/results-cov_${taxa}_${id}.txt

if [ -e $res ]
then
	rm $res
fi
#-------------------------------------------------------------------------------------------
# Plot terrace trees

plot_terrace_trees="TRUE"
if [ $plot_terrace_trees == "TRUE" ]
then

	for i in $f/rfdist/*.terrace_ON
	do
		f_tree="${i}_TREES"
		mkdir $f_tree
		c=0
		cat $i | while read -r line
		do
			c=$[$c+1]
			file_tree="$f_tree/terrace_tree_$c"
			echo $line > $file_tree
		done

		## ONLY for small n !! for 9 taxa it will be too much!!
		size="`wc -l $i | awk -F " " '{print $1}'`"
		if [ $taxa -lt 9 ] && [ $size -gt 1 ]
		then
			#echo "taxaNUM=$space is smaller than 9. Plotting terrace trees for $i....."
			Rscript $script_r_tree_plots $f_tree/terrace_tree_ $i $size
		fi
		# clean a bit
		rm -r $f_tree
		#rm $i
	done

	mkdir $f/tree_plots
	mv $f/rfdist/*plot_trees.pdf $f/tree_plots/
fi
#-------------------------------------------------------------------------------------------
# Analyse all terraces for the considered cov matrix
for i in $f/rfdist/*.rfdist
do
        c=`Rscript $script_r $i | awk -F "] " '{print $2}'`
        #size="`head -n 1 $i | awk -F " " '{print $1}'`"
        echo "$i|$c" >> $res
done

sed 's/"//g' $res > $res-2
mv $res-2 $res
