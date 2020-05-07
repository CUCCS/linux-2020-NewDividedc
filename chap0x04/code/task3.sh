#!/usr/bin/env bas

#统计访问来源主机TOP 100和分别对应出现的总次数
function host {
	echo "The total number of occurrences of the TOP 100 visits to the source host and their respective occurrences"
	printf "\n"
	echo "   Times  Host"
	cat web_log.tsv | awk -F "\t" '{if (NR > 1) {print $1} }' | sort | uniq -c | sort -nr | head -100
	printf "\n"
}

#统计访问来源主机TOP 100 IP和分别对应出现的总次数
function id {
	echo "TOP 100 IP of the source host visited and the corresponding total number of occurrences"
	printf "\n"
	echo "   Times  ID"
	cat web_log.tsv | awk -F "\t" '{if (NR > 1) {print $1} }' | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq -c | sort -nr | head -100
	printf "\n"
}

#统计最频繁被访问的URL TOP 100
function url {
	echo "The most frequently visited URL TOP 100"
	printf "\n"
	echo "   Times  URL"
	cat web_log.tsv | awk -F "\t" '{if (NR > 1) {print $5} }' | sort | uniq -c | sort -nr | head -100
	printf "\n"
}

#分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
function four {
	echo "Count the TOP 10 URLs corresponding to different 4XX status codes and the total number of occurrences"
	printf "\n"
	echo "Response 403"
	echo "   Times	URL"
	cat web_log.tsv | awk -F "\t" '{ if ($6=="403") {print $5} }' | sort | uniq -c | sort -nr | head -10
	printf "\n"
	echo "Response 404"
	echo "   Times	URL"
	cat web_log.tsv | awk -F "\t" '{ if ($6=="404") {print $5} }' | sort | uniq -c | sort -nr | head -10
	printf "\n"
}

#给定URL输出TOP 100访问来源主机
function SpeURL {
	URL="$1"
	echo "$URL top 100 most frequently visitors"
	echo "   Times  Host"
	cat web_log.tsv | awk -F "\t" '{ if ($5=="'$URL'") {print $1} }' | sort | uniq -c | sort -nr | head -100
}

#统计不同响应状态码的出现次数和对应百分比
function StaticticalRes {
       
	echo "The number of occurrences and corresponding percentages of different response"
	printf "\n"
       	code=$(awk -F "\t" '{if (NR > 1) {print $6} }' web_log.tsv ) #获得响应码数组
        declare -A c #初始化关联数组来统计不同响应码的出现次数

        totle=0

	#统计不同响应状态码的出现次数
        for co in ${code[@]};do
                if [[ ${c[$co]} ]];then
                        c[$co]=$((c[$co]+1))
                else
                        c[$co]=1
                fi
                totle=$((totle+1))
        done

	#输出不同响应状态码的出现次数和百分比
        echo "Response  Sum     Pro"
        for key in ${!c[@]};do
                echo "$key      ${c[$key]}      $(echo "${c[$key]} $totle" | awk '{printf("%0.5f\n",$1/$2*100)}')%"
        done
 	printf "\n"

}

#命令行不同参数含义帮助信息
function help {
	echo "the options:"
        echo "-a:The total number of occurrences of the TOP 100 visits to the source host and their respective occurrences"
        echo "-b:TOP 100 IP of the source host visited and the corresponding total number of occurrences"
        echo "-c:The most frequently visited URL TOP 100"
        echo "-d:The number of occurrences and corresponding percentages of different response"
        echo "-e:the TOP 10 URLs corresponding to different 4XX status codes and the total number of occurrences"
        echo "-s:enter the URL you want to query"
}

if [[ $# -lt 1 ]];then
        echo "Please enter your command."
else
        while [[ $# -ne 0 ]];do
                case $1 in
                        "-a")
                                host #统计访问来源主机TOP 100和分别对应出现的总次数
                                shift
                                ;;
                        "-h")
                                help #获得命令行不同参数帮助信息
                                shift
                                ;;
                        "-b")
                                id #统计访问来源主机TOP 100 IP和分别对应出现的总次数
                                shift
                                ;;
                        "-c")
                                url #统计最频繁被访问的URL TOP 100
                                shift
                                ;;
                        "-d")
                                StaticticalRes #统计不同响应状态码的出现次数和对应百分比
                                shift
                                ;;
                        "-e")
                                four #分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数
                                shift
				;;
			"-s")
				SpeURL $2 #给定URL输出TOP 100访问来源主机
				shift 2
				;;
                esac
        done
fi

