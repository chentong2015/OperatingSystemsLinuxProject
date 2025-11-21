# TODO. 找到指定目录下的文件
find . -name file_name
find . -type f -name file_name

# TODO. 统计指定目录下特定文件的数量
find . -type -f -name *.java | wc -l

# TODO. 找到指定目录的目录(指定文件类型)
find . -type d -name folder_name