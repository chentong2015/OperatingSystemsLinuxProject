# 统计文件的行数
wc -l filename.txt
grep -c . filename.txt

# 从文件中查询字符串并输出
grep 'xml' file.txt
grep -o 'xml' file.txt # --only-matching show only line matching PATTERN

# 从文件中查询字符串并计算数量
grep -o 'xml' file.txt | wc -l
grep --count '<record ' file.xml

# 从目录中文件(递归遍历)查找特定字符串
grep -r 'string_to_find' .

# 从指定文件格式中查找
grep -r --include="*.log" "cleaning up"  log
grep -rl --include="*.pom" "log4j-core" /data/workspace