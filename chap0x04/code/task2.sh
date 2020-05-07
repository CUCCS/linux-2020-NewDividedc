#!/usr/bin/env bash

#统计不同年龄区间范围（20岁以下、[20-30]、30岁以上）的球员数量、百分比
function StatisticalAge {
	age=$(awk -F "\t" '{if (NR > 1) {print $6} }' worldcupplayerinfo.tsv )#获得所有球员的年龄
	
	underTwen=0
        BtwTtoT=0
        upThr=0
        totle=0
	
	#遍历年龄数组，找到<20、20~30、>30的球员数目，以及总球员数目
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

	#输出球员年龄区间范围信息
	echo "Age	Sum	Pro"
	echo "<20	$underTwen	$(echo "$underTwen $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	echo "20~30	$BtwTtoT	$(echo "$BtwTtoT $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	echo ">30	$upThr	$(echo "$upThr $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	printf "\n"
}

#200~统计不同场上位置的球员数量、百分比
function StaticticalPos {
	pos=$(awk -F "\t" '{if (NR > 1) {print $5} }' worldcupplayerinfo.tsv )#获得所有球员的位置
	declare -A p #初始化关联数组来计算各个位置的数目

	totle=0
	
	#统计各个位置的球员数目以及总的球员数
	for po in ${pos[@]};do
		if [[ ${p[$po]} ]];then
			p[$po]=$((p[$po]+1))
		else
			p[$po]=1
		fi
		totle=$((totle+1))
	done

	#输出不同位置的球员数量和百分比
	echo "Position 	Sum	Pro"
	for key in "${!p[@]}";do
		echo "$key	${p[$key]}	$(echo "${p[$key]} $totle" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
	done
	printf "\n"
}

#统计名字最长的球员和名字最短的球员
function Name {
	OLD_IFS="$IFS"
	string=$(awk -F "\t" '{if (NR > 1) {print $9","} }' worldcupplayerinfo.tsv )#获得所有球员的名字数组
        IFS=","

	player=($string)
	IFS="$OLD_IFS"

	longest=0
	shortest=100

	#找到最长的名字长度和最短的名字长度
	for p in "${player[@]}";do
		if [[ ${#p} -gt $longest ]];then
			longest=${#p}
		fi
	
		if [[ ${#p} -lt $shortest ]];then
			shortest=${#p}
		fi
	done

	#遍历球员名字数组，和最长长度、最短长度比较，输出名字最长球员的名字和名字最短球员的名字
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

#统计年龄最大和最小的球员
function Age {
	age=$(awk -F "\t" '{if (NR > 1) {print $6} }' worldcupplayerinfo.tsv )#获得所有球员的年龄数组
	max=0
	min=100

	#找到最小的年龄和最大的年龄
	for a in ${age[@]};do
		if [[ $a -gt $max ]];then
			max=$a
		fi

		if [[ $a -lt $min ]];then
			min=$a
		fi
	done

	#将球员年龄与最小最大的年龄比较，输出年龄最大的球员和年龄最小的球员
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

#命令行参数含义帮助
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
                                Age #统计年龄最大和最小的球员
                                shift
                                ;;
                        "-h")
                                Help #获得命令行参数帮助信息
                                shift
                                ;;
                        "-c")
                                Name #统计名字最长和最短的球员
                                shift
                                ;;
                        "-b")
                                StaticticalPos #统计球场不同位置的球员人数、占比
                                shift
                                ;;
                        "-a")
                                StatisticalAge #统计不同年龄范围的球员认识、占比
                                shift
                                ;;
                esac
        done
fi

