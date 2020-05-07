#!/usr/bin/env bas

function host {
	echo "The total number of occurrences of the TOP 100 visits to the source host and their respective occurrences"
	printf "\n"
	echo "   Times  Host"
	cat web_log.tsv | awk -F "\t" '{if (NR > 1) {print $1} }' | sort | uniq -c | sort -nr | head -100
	printf "\n"
}

function id {
	echo "TOP 100 IP of the source host visited and the corresponding total number of occurrences"
	printf "\n"
	echo "   Times  ID"
	cat web_log.tsv | awk -F "\t" '{if (NR > 1) {print $1} }' | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq -c | sort -nr | head -100
	printf "\n"
}

function url {
	echo "The most frequently visited URL TOP 100"
	printf "\n"
	echo "   Times  URL"
	cat web_log.tsv | awk -F "\t" '{if (NR > 1) {print $5} }' | sort | uniq -c | sort -nr | head -100
	printf "\n"
}

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

function SpeURL {
	URL="$1"
	echo "$URL top 100 most frequently visitors"
	echo "   Times  Host"
	cat web_log.tsv | awk -F "\t" '{ if ($5=="'$URL'") {print $1} }' | sort | uniq -c | sort -nr | head -100
}

function StaticticalRes {
       
	echo "The number of occurrences and corresponding percentages of different response"
	printf "\n"
       	code=$(awk -F "\t" '{if (NR > 1) {print $6} }' web_log.tsv )
        declare -A c

        totle=0

        for co in ${code[@]};do
                if [[ ${c[$co]} ]];then
                        c[$co]=$((c[$co]+1))
                else
                        c[$co]=1
                fi
                totle=$((totle+1))
        done

        echo "Response  Sum     Pro"
        for key in ${!c[@]};do
                echo "$key      ${c[$key]}      $(echo "${c[$key]} $totle" | awk '{printf("%0.5f\n",$1/$2*100)}')%"
        done
 	printf "\n"

}

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
                                host
                                shift
                                ;;
                        "-h")
                                help
                                shift
                                ;;
                        "-b")
                                id
                                shift
                                ;;
                        "-c")
                                url
                                shift
                                ;;
                        "-d")
                                StaticticalRes
                                shift
                                ;;
                        "-e")
                                four
                                shift
				;;
			"-s")
				SpeURL $2
				shift 2
				;;
                esac
        done
fi

