# 找到指定目录下的文件
find . -name file_name
find . -type f -name file_name

# 统计指定目录下特定文件的数量
find . -type -f -name *.java | wc -l

# 找到指定目录的目录(指定文件类型)
find . -type d -name folder_name

# TODO. 先查找文件，再逐个搜索
find log -name "*.gz" -exec zgrep -H "cleaning up" {} +

# 传递脚本执行的参数
DIR="$1"
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