# trap: Shell内建命令
# 用来捕获和处理信号(signal)或Shell退出事件

trap 'echo "Do not press Ctrl+C"' SIGINT

trap 'echo "Receive Signal, exit"' SIGINT SIGTERM

# 在推出时实现清理操作
touch /tmp/test.tmp
echo "Script is running ..."
trap 'rm -f /tmp/test.tmp' EXIT

# 在推出时执行特定方法
function cleanOnExit() {
}
trap 'cleanOnExit' EXIT


while true; do
    sleep 1
done