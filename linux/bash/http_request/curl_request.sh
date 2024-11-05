#!/usr/bin/env bash

curl --request GET \
  --url 'http://www.ctong.com/v1/testing/example' \
  --header "Authorization: Bearer $JWT_TOKEN" \
   --user <user:password> Server user and password
  --insecure
echo

# 设置指定的请求类型并传递Response Body
curl --request POST
  --header 'Content-Type: application/json'
  --data '{"id": 10,"question":"this is a test question"}'
  http://localhost:8080/chat


# TODO. 输出请求后的Status Code, 使用特殊变量
curl -w "\n %{http_code} \n" --request POST
  --header 'Content-Type: application/json'
  --data '{"id": 10,"question":"this is a test question"}'
  http://localhost:8080/chat

# -s or --silent option act as silent or quiet mode. Don’t show progress meter or error messages.
curl -s https://www.test.com/ > /tmp/output.html
curl -silent https://www.test.com/ > /tmp/output.html