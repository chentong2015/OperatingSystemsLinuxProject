#!/usr/bin/env bash

set -euo pipefail
which psql > /dev/null || (echoerr "The PostgreSQL client is not in your PATH" && exit 1)

export PGPASSWORD=secret_password

# 连接DB并直接执行SQL脚本，准备数据库基础数据
psql -U user1 -d secret_database -h localhost -f creation.sql
psql -U user1 -d secret_database -h localhost -f data.sql