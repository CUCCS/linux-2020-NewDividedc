#!/usr/bin/env bash

function StatisticalAge {
	age=$(awk -F "\t" '{if (NR > 1) {print $6} }' worldcupplayerinfo.tsv )
	
	underTwen=0
        BtwTtoT=0
        upThr=0
        totle=0
	
	for a in ${age[@]};do
		if [[ $a -lt 20 ]];then
			underTwen=$((underTwen+1))
		elif [[ $a -gt 30 ]];then
			upThr=$((upThr+1))
		else
			BtwTtoT=$((BtwTtoT+1))
		fi
		totle=$((totle+1))
	done

	echo "Age	Sum	Pro"
	echo "<20	$underTwen	$(echo "$underTwen $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	echo "20~30	$BtwTtoT	$(echo "$BtwTtoT $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	echo ">30	$upThr	$(echo "$upThr $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	printf "\n"
}

function StaticticalPos {
	pos=$(awk -F "\t" '{if (NR > 1) {print $5} }' worldcupplayerinfo.tsv )
	declare -A p

	totle=0
	
	for po in ${pos[@]};do
		if [[ ${p[$po]} ]];then
			p[$po]=$((p[$po]+1))
		else
			p[$po]=1
		fi
		totle=$((totle+1))
	done

	echo "Position 	Sum	Pro"
	for key in "${!p[@]}";do
		echo "$key	${p[$key]}	$(echo "${p[$key]} $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	done
	printf "\n"
}

function Name {
	OLD_IFS="$IFS"
	string=$(awk -F "\t" '{if (NR > 1) {print $9","} }' worldcupplayerinfo.tsv )
        IFS=","

	player=($string)
	IFS="$OLD_IFS"

	longest=0
	shortest=100

	for p in "${player[@]}";do
		if [[ ${#p} -gt $longest ]];then
			longest=${#p}
		fi
	
		if [[ ${#p} -lt $shortest ]];then
			shortest=${#p}
		fi
	done

	echo "The players with the longest name:"
	for p in "${player[@]}";do
		if [[ ${#p} -eq $longest ]];then
			echo $p
		fi
	done

	printf "\n"

	echo "The players with the shortest name:"
	for p in "${player[@]}";do
		if [[ ${#p} -eq $shortest ]];then
			echo $p
		fi
	done
	printf "\n"
}

function Age {
	age=$(awk -F "\t" '{if (NR > 1) {print $6} }' worldcupplayerinfo.tsv )
	max=0
	min=100

	for a in ${age[@]};do
		if [[ $a -gt $max ]];then
			max=$a
		fi

		if [[ $a -lt $min ]];then
			min=$a
		fi
	done

	echo "The oldest age:$max"
	printf "\n"
	echo "The oldest players:"
	awk -F "\t" '$6=='$max' {print $9}' worldcupplayerinfo.tsv
	printf "\n"
	echo "The youngest age:$min"
	printf "\n"
	echo "The yougest players:"
	awk -F "\t" '$6=='$min' {print $9}' worldcupplayerinfo.tsv


}

function Help {
	echo "the options:"
        echo "-a:Count the number and percentage of players in different age ranges (under 20, [20-30], over 30)"
        echo "-b:Count the number and percentage of players in different positions on the field"
        echo "-c:Count the players with the longest name and shortest age"
	echo "-d:Count the oldest and youngest players"
        echo "-h:get the help of the opetions"
}
if [[ $# -lt 1 ]];then
        echo "Please enter your command."
else
        while [[ $# -ne 0 ]];do
                case $1 in
                        "-d")
                                Age
                                shift
                                ;;
                        "-h")
                                Help
                                shift
                                ;;
                        "-c")
                                Name
                                shift
                                ;;
                        "-b")
                                StaticticalPos
                                shift
                                ;;
                        "-a")
                                StatisticalAge
                                shift
                                ;;
                esac
        done
fi

