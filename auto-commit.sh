#!/bin/bash
# 自动提交脚本 - 提交12次后停止

set -e

REPO_DIR="/root/useless-project"
COUNTER_FILE="$REPO_DIR/counter.txt"
LOG_FILE="$REPO_DIR/commit.log"
MAX_COMMITS=12

echo "=== 自动提交脚本启动于 $(date) ===" | tee "$LOG_FILE"
echo "目标: 提交 $MAX_COMMITS 次" | tee -a "$LOG_FILE"

# 清空计数器
> "$COUNTER_FILE"

for (( i=1; i<=MAX_COMMITS; i++ )); do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] 提交 #$i" >> "$COUNTER_FILE"
    
    cd "$REPO_DIR"
    git add -A
    git commit -m "chore: 无用的提交 #$i - $TIMESTAMP"
    
    echo "[$TIMESTAMP] 提交 #$i 完成" | tee -a "$LOG_FILE"
    
    if (( i < MAX_COMMITS )); then
        echo "等待 60 秒..." | tee -a "$LOG_FILE"
        sleep 60
    fi
done

echo "=== 12次提交完成，推送到 GitHub ===" | tee -a "$LOG_FILE"
git push origin main 2>&1 | tee -a "$LOG_FILE"
echo "=== 全部完成！===" | tee -a "$LOG_FILE"
