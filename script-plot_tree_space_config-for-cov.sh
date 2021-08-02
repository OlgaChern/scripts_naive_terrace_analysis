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
i=$f_path/terrace_analysis/data/datasets_${taxa}_taxa/part_${part}/cov_${taxa}_${id}
#-------------------------------------------------------------------------------------------
# Scripts
script="$f_scripts/script-plot_tree_space_graph.r"
script_2="$f_scripts/script-plot_info_terrace_space_config.r"
#-------------------------------------------------------------------------------------------
file_TSC="$i/tree_space_config/TSG_map_tree_terrace"
file_rfdist="$i/tree_space_config/trees_in_terrace_order.rfdist"
file_out="$i/tree_space_config/plot-TSG"
file_connect_info="$i/tree_space_config/connectivity_info"
#-------------------------------------------------------------------------------------------
echo ""
echo "----------------------------------------------------------------------------------"
echo "INFO: script-plot_tree_space_config-for-cov.sh ${taxa} ${part} ${id} ${f_path}"
echo "----------------------------------------------------------------------------------"
echo "  Perform plot tree space configuration and additional summaries for coverage matrix ${id} for taxon number ${taxa} and partition number ${part}..."
echo "----------------------------------------------------------------------------------"
echo ""
#-------------------------------------------------------------------------------------------






if [ -e $file_connect_info ]
then
	echo "Connectivity info file exists"
else
	file_res="$i/results-cov_${taxa}_${id}.txt"
	awk -F "|" '{print $1, $2, $3,$4}' $file_res | sed "s/.terrace_ON.rfdist//g" | awk -F "/rfdist/terrace_" '{print $2}' | sort -n -k 1 | sed "s/FALSE/0/g" | sed "s/TRUE/1/g"> $file_connect_info
fi


if [ -e $file_TSC ]
then
	trivial_terrace_NUM=0
	file_trivial_terraces="$i/trivial_terraces_*"
	if [ -e $file_trivial_terraces ]
	then
		trivial_terrace_NUM="`wc -l $file_trivial_terraces |awk -F " " '{print $1}'`"
	fi

	# the script below plot complete tree space graph with tree space configuration. Do not do this for larger than 7 taxa!
	#if [ ${taxa} -lt 8 ]
	#then
#		RScript $script $file_rfdist $file_TSC $file_out $file_connect_info $trivial_terrace_NUM $f_scripts
	#fi
	# the script below outputs the statistics about the tree space configuration: number of terraces, how many connected/disconnected etc.
	RScript $script_2 $file_rfdist $file_TSC $file_out $file_connect_info $trivial_terrace_NUM $f_scripts
fi
	
