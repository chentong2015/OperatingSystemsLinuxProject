# 使用方法: ./search_logs.sh /path/to/directory

DIR="$1"sra
if [ -z "$DIR" ]; then
  echo "Please input the folder to search"
  exit 1
fi
find "$DIR" -type f \( -name "*.log" -o -name "*.gz" \) | while read -r file
do
  if [[ "$file" == *.gz ]]; then
    zgrep -H "cleaning up" "$file"
  else
    grep -H "cleaning up" "$file"
  fi
done

# ------------------------------------------------------
# 直接从特定文件中查找
grep -R "cleaning up" --include="*.log" log
find log -name "*.gz" -exec zgrep -H "cleaning up" {} +