#!/usr/bin/env bash

# TODO. Bash脚本本质上就不适合在Windows平台运行
# 使用$符号表示对变量的引用
# 变量不能使用-连接
# 变量=赋值时不能有空格

value="test value"
result=$value
echo "The result is $result"

# 按指定字符分割并提取最后段的字符串
class_name=`echo $result | awk -F"/" '{print $NF}' | awk -F "." '{print $1}'`
echo $class_name

# TODO. 在Windows平台执行脚本，需要注意字符串的换行符
str="c42f5bcbc95fe771.xml"
str="${str%$'\r'}"    # 移除 Windows 回车符
str_lower="${str,,}"  # 将字符串转化成小写

# 刷选特定的文件格式
if [[ "$str_lower" =~ ^#?.*\.(xlsx|kz|xml)$ ]]; then
    echo "Str Matched"
fi