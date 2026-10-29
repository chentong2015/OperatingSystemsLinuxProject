#!/bin/bash

input='/export/home/input'
output='/export/home/output'

echo "Delete all files in Output" > $output/temp.txt
rm $output/*

for file_in in $input/*
do
	let is_found=0
	# 使用pipe管道依次执行
	# awk -F使用指定的分隔符分割，print提取指定位置上的值
	# sed 根据正则表达式进行文本(字符串)的替换
	nameFile=`echo $file_in | awk -F"/input" '{print $2}' | sed "s/\/HOST.._//g" | sed 's/\b[a-z]/\U&/g'`
	echo $nameFile
	
	for file_out in $output/*
	do
	    if [ -n "$(echo $file_out | grep "$nameFile")" ];then
		    # -e 多点编辑，可以执行多个子命令
			   sed -e "1d" $file_in >> $output/$nameFile
			   let is_found=1
			break
		fi
	done
	
  if [ "$is_found" -eq "0" ];then
		cat $file_in > $output/$nameFile
	fi
done 
rm $input/*