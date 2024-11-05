#!/bin/bash

# $1为方法的第一个参数，在调用时直接传递
get_greeting() {
  echo "Hello, $1!"
}

# Factorial using recursion
factorial(){
    if test $1 -eq 1; then
        echo 1;
    else
        x=$(echo "$1 - 1" | bc)
        echo "${1} * $(factorial $x)" | bc
    fi
}

# 定义方法判断Num是否为质数
isPrime() {
  number=$1
  count=2
  while test $count -lt $number;
  do
      y=$(echo "${number} % ${count} " | bc)
      if test $y -eq 0; then
          echo "The number ${number} is not prime"
          break;
      fi
      count=$(echo "${count} + 1" | bc) #i++
  done

  if test $count -ge $number; then
      echo "The number ${number} is Prime."
  fi
}

# TODO: 将方法的返回值设置到变量
STRING_VAR=$(get_greeting "chen")
echo $STRING_VAR

factorial 10
isPrime 14