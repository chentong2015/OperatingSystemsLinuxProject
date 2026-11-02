#!/bin/bash

# 使用方法: ./search_logs.sh /path/to/directory
DIR="$1"sra
if [ -z "$DIR" ]; then
  echo "Please input the folder to search"
  exit 1
fi

find "$DIR" -type f \( -name "*.log" -o -name "*.gz" \) | while read -r file
do
  if [[ "$file" == *.gz ]]; then
    zgrep -H "cleaning up" "$file"
  else
    grep -H "cleaning up" "$file"
  fi
done

# 刷选特定文件格式, 匹配文件后缀
file="c42f5bcbc95fe771.xml"
file_lower="${file,,}"
echo $file
echo "Filename: $file_lower"

if [[ "$file_lower" =~ ^#?.*\.(xlsx|kz|xml)$ ]]; then
    echo "Matched"
else
    echo "Not matched"
fi