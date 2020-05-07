#!/usr/bin/env bash

#支持命令行参数方式使用不同功能
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

#对jpeg格式图片进行图片质量压缩
function compress {
	qua=$2
	for file in `ls $1`;do
		extension=${file##*.}#获得图片后缀名即图片格式
		if [[ $extension == "jpg" ]];then
			echo "Compressing $file"
			NewFile=$1/cop_$file
			convert -quality $qua $1/$file $NewFile#使用convert指令进行图片质量压缩
		fi
	done
	echo "Compressing succeed"
}

#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function resize {
	newSize=$2 
	for file in `ls $1`;do
		extension=${file##*.}#获得图片后缀名即图片格式
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Resizing $file"
			NewFile=$1/res_$file
			convert -resize ${newSize} $1/$file $NewFile#使用convert指令进行图片分辨率压缩
		fi
	done
	echo "Resizing succeed"
}

#为图片添加水印
function addWatermark {
	color=$2
	size=$3
	mark=$4#指定水印的颜色大小内容
	for file in `ls $1`;do
		extension=${file##*.}#获得图片后缀名即图片格式
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
                        echo "Adding watermark"
			NewFile=$1/fill_$file
			convert -fill $color -pointsize $size -draw "text 10,50 '$mark'" $1/$file $NewFile#使用convert命令进行水印添加
		fi
	done
        echo "Adding watermark succeed"	
}

#为图片名添加前缀
function prefix {
	pre=$2#指定所要添加的前缀
	for file in `ls $1`;do
		extension=${file##*.}#获得图片后缀即图片格式
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Adding prefix name"
			NewFile=$1/${pre}_$file#定义图片新名字
			convert $1/$file $NewFile#使用convert命令将图片以加有指定前缀的名字保存
		fi
	done
	echo "Adding prefix succeed"
}

#为图片添加后缀名
function suffix {
	suf=$2#指定所要添加的后缀名
	for file in `ls $1`;do
		extension=${file##*.}#获得图片后缀即格式
		fileName=${file%.*}#获得图片不加格式名的名字
		if [[ $extension == "jpg" ]] || [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Adding suffix name"
			NewFile=$1/${fileName}_${suf}.${extension}#定义图片新名字
			convert $1/$file $NewFile#使用convert命令将图片以加有指定后缀的名字保存
		fi
	done
	echo "Adding suffix succeed"
}

#将png/svg图片统一转换为jpg格式图片
function transform {
	for file in `ls $1`;do
		extension=${file##*.}#获得图片后缀即格式
		if [[ $extension == "png" ]] || [[ $extension == "svg" ]];then
			echo "Transforming $file"
			FileName=${file%.*}
			NewFile=$1/${FileName}.jpeg
			convert $1/$file $NewFile#判断图片格式是否为png或svg，将图片以jpg为后缀名的名字保存，即改变了图片格式为jpeg
		fi
	done
	echo "Transforming succeed"
}

dir="" #初始化目录名

if [[ $# -lt 1 ]];then
	echo "Please enter your command."
else
	while [[ $# -ne 0 ]];do
		case $1 in
			"-d")
				dir="$2" #修改目录名为指定目录
				shift 2
				;;
			"-h")
				Para_Func #获得不同命令行参数含义
				shift
				;;
			"-c")
				compress $dir $2 #压缩图片质量
				shift 2
				;;
			"-r")
				resize $dir $2 #压缩图片分辨率
				shift 2
				;;
			"-a")
				addWatermark $dir $2 $3 $4 #为图片添加水印
				shift 4
				;;
			"-p")
				prefix $dir $2 #为图片名添加前缀名
				shift 2
				;;
			"-s")
				suffix $dir $2 #为图片名添加后缀名
				shift 2
				;;
			"-t")
				transform $dir #将png和svg格式图片转化为JPEG格式
				shift
				;;
		esac
	done
fi

