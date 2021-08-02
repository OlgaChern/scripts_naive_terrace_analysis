#/bin/bash

seq_0="----------"
seq_1="AGTGATGATG"

# Supermatrix
sm=()


file=$1
file_out=$1.aln
if [ -e $file_out ]
then
	rm $file_out
fi
echo "Input file with presence-absence pattern $file"
sp_num=0
cat $file | while read -r line
do
	sp_num=$[$sp_num+1]
	#echo "this is the line: $line"
	sp_info=($line)
	p=0
	sp=""
	for i in ${sp_info[*]}
	do
		p=$[$p+1]
		#echo "for partition $p : $i"
		if [ $i == 0 ]
		then
			sp="${sp}${seq_0}"
		elif [ $i == 1 ]
		then
			sp="${sp}${seq_1}"
		else
			echo "Species $sp_num: Something is wrong with the partition info : i = $i"
			exit
		fi

	done
	echo ">sp$sp_num" >> $file_out
	echo "$sp" >> $file_out
done
echo "Supermatrix was printed into $file_out"
