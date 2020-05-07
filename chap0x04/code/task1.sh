#!/usr/bin/env bash

function Para_Func {
	echo "the options:"
	echo "-a:enter specified watermark to add in pictures"
	echo "-c:enter the quality for compression for jpeg format pictures"
	echo "-d:Batch process all the image files in the specified directory"
	echo "-h:get the help of the opetions"
	echo "-p:enter the prefix added to the picture name"
	echo "-r:enter the size to resize jpeg/png/svg pictures"
	echo "-s:enter the suffix added to the picture name"
	echo "-t:turn all png/svg pictures into jpeg pictures"
}

function compress {
	qua=$2
	for file in `ls $1`;do
		extension=${file##*.}
		if [[ $extension == "jpg" ]];then
			echo "Compressing $file"
			NewFile=$1/cop_$file
			convert -quality $qua $1/$file $NewFile
		fi
	done
	echo "Compressing succeed"
}

function resize {
	newSize=$2
	for file in `ls $1`;do
		extension=${file##*.}
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Resizing $file"
			NewFile=$1/res_$file
			convert -resize ${newSize} $1/$file $NewFile
		fi
	done
	echo "Resizing succeed"
}

function addWatermark {
	color=$2
	size=$3
	mark=$4
	for file in `ls $1`;do
		extension=${file##*.}
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
                        echo "Adding watermark"
			NewFile=$1/fill_$file
			convert -fill $color -pointsize $size -draw "text 10,50 '$mark'" $1/$file $NewFile
		fi
	done
        echo "Adding watermark succeed"	
}

function prefix {
	pre=$2
	for file in `ls $1`;do
		extension=${file##*.}
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Adding prefix name"
			NewFile=$1/${pre}_$file
			convert $1/$file $NewFile
		fi
	done
	echo "Adding prefix succeed"
}

function suffix {
	suf=$2
	for file in `ls $1`;do
		extension=${file##*.}
		fileName=${file%.*}
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Adding suffix name"
			NewFile=$1/${fileName}_${suf}.${extension}
			convert $1/$file $NewFile
		fi
	done
	echo "Adding suffix succeed"
}

function transform {
	for file in `ls $1`;do
		extension=${file##*.}
		if [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Transforming $file"
			FileName=${file%.*}
			NewFile=$1/${FileName}.jpeg
			convert $1/$file $NewFile
		fi
	done
	echo "Transforming succeed"
}

dir=""

if [[ $# -lt 1 ]];then
	echo "Please enter your command."
else
	while [[ $# -ne 0 ]];do
		case $1 in
			"-d")
				dir="$2"
				shift 2
				;;
			"-h")
				Para_Func
				shift
				;;
			"-c")
				compress $dir $2
				shift 2
				;;
			"-r")
				resize $dir $2
				shift 2
				;;
			"-a")
				addWatermark $dir $2 $3 $4
				shift 4
				;;
			"-p")
				prefix $dir $2
				shift 2
				;;
			"-s")
				suffix $dir $2
				shift 2
				;;
			"-t")
				transform $dir
				shift
				;;
		esac
	done
fi

