#!/usr/bin/env bash

for file in code/*.sh;do
	if [[ $file =~ $0 ]];then
		continue
	fi
	printf "============== %s ====================\n" "$file"
	bash "$file"
done
