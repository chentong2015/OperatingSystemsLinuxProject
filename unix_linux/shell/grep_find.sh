wc -l filename.txt    # 统计文件的行数

find . -name /folder  # 找到指定目录下包含指定名称的文件
find ./test01/ -type f -name *.java | wc -l # 找到指定的目录下java文件的数量

grep -c . filename.txt # 统计文件的行数
grep --count '<record ' file.xml # 统计包含指定字符串的行数

grep 'xml' file.txt    # 输出找到字符串的所有行

grep -o 'xml' file.txt # 只输出找到的字符串，逐行输出
     --only-matching   # show only the part of a line matching PATTERN

# TODO. 统计某个文件中特殊字符的数量
grep -o 'xml' file.txt | wc -l

# 查找指定目录下包含指定字符串的文件(递归遍历文件的内容)
grep -r 'string_to_find' .


# 截取首位，并找到首次匹配条件并截取100行数据到结果文件
head -2 file.xml > result.xml
grep -m 1 -A 100 'uid="11235"' file.xml >> result.xml
     --match 查找第几次匹配位置
     -A num  从找到的匹配位置起取多少行的数据
     > >     选择覆盖输出或追加输出
tail -1 file.xml >> result.xml