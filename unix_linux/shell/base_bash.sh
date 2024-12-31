#!/usr/bin/env bash

# 使用$符号表示对变量的引用
# 变量不能使用-连接
# 变量=赋值时不能有空格

value="test value"
result=$value
echo "The result is $result"

# 按指定字符分割并提取最后段的字符串
class_name=`echo $result | awk -F"/" '{print $NF}' | awk -F "." '{print $1}'`

# 判断文件是否是目录
if [[ -d output ]]
then
    rm -r outputdxq
fi
mkdir -p output/primary
mkdir -p output/secondary
cp -r ./packaging/resources/target/resources*/* ./output/primary