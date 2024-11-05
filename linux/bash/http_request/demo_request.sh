#! /bin/bash

EXPECTED_CODE="response ok"

# 获取并判断Http请求的返回数据，测试Web接受请求的正确性
RESULT=$(curl --request POST --header 'Content-Type: application/json' --data '{"id": 10,"question":"this is a test question"}' http://localhost:8080/chat)
echo "$RESULT"

if [[ $RESULT == $EXPECTED_CODE ]];then
   echo "Success \n"
else
   echo "Request Failed"
fi