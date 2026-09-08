# TODO. 统计文件的行数
wc -l filename.txt
grep -c . filename.txt

# TODO. 从文件中查询字符串并输出
grep 'xml' file.txt
grep -o 'xml' file.txt # --only-matching show only line matching PATTERN

# TODO. 从文件中查询字符串并计算数量
grep -o 'xml' file.txt | wc -l
grep --count '<record ' file.xml # 统计包含指定字符串的行数

# TODO. 从目录中文件(递归遍历)查找特定字符串
grep -r 'string_to_find' .