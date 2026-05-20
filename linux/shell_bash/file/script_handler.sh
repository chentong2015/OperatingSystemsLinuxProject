#!/bin/bash

# 递归遍历$root_path/*中的文件
for f in $root_path
do
    if [ -d "$f" ]; then
        for ff in $f/*
        do
            echo "Processing $ff"
        done
    else
        echo "Processing $f"
    fi
done

# if 条件判断regular expression正则条件
while read result
do
    while IFS= read -r line; do
        if [[ $line =~ entity-name=.*entity-name= ]]; then
           echo "Find entity-name twice"
		       echo $line
        fi
        if [[ $line =~ entity-name=\".*\"\" ]]; then
           echo "Find entity-name error"
        fi
    done < $result
done

# Counts lines in the file passed.
noOfLines=0;
if test -f $1; then
    while read line
    do
        noOfLines=$( echo " ${noOfLines} + 1" | bc )
    done < $1
    echo "The total no of lines are: ${noOfLines}"
fi


# 创建Method处理文件的Line
line="<class name=\"mx.test.MyClass\" >"
echo "input line: $line"

class_name=""
get_class_name() {
   class_name=`echo $1 | awk -F"name=\"" '{print $2}' | awk -F "\"" '{print $1}'`
   if [[ "$class_name" == "" ]]; then
      echo "Error: can not find class name for the line $1"
   fi
}

get_class_name "${line}"
echo $class_name