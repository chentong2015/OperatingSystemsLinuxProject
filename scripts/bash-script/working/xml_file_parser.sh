# 截取文件的前几行
head -2 file.xml > result.xml

# 截取文件中某个位置的匹配之后的100行数据
grep -m 1 -A 100 'uid="11235"' file.xml >> result.xml
     # --match 查找第几次匹配位置
     # -A num  从找到的匹配位置起取多少行的数据
     # > >     选择覆盖输出或追加输出

# 截取文件的末尾一行
tail -1 file.xml >> result.xml