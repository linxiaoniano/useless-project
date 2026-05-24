#!/bin/bash
# 自动提交脚本 - 每分钟修改文件并提交

set -e

REPO_DIR="/root/useless-project"
COUNTER_FILE="$REPO_DIR/counter.txt"
LOG_FILE="$REPO_DIR/commit.log"
COMMIT_COUNT=0

echo "=== 自动提交脚本启动于 $(date) ===" | tee -a "$LOG_FILE"
echo "按 Ctrl+C 停止" | tee -a "$LOG_FILE"

while true; do
    COMMIT_COUNT=$((COMMIT_COUNT + 1))
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] 提交 #$COMMIT_COUNT" >> "$COUNTER_FILE"
    
    cd "$REPO_DIR"
    git add -A
    git commit -m "chore: 无用的提交 #$COMMIT_COUNT - $TIMESTAMP"
    
    echo "[$TIMESTAMP] 提交 #$COMMIT_COUNT 完成" | tee -a "$LOG_FILE"
    
    # 推送到 GitHub（每隔 5 次推送一次，减少推送频率）
    if (( COMMIT_COUNT % 5 == 0 )); then
        echo "[$TIMESTAMP] 推送到 GitHub..." | tee -a "$LOG_FILE"
        git push origin main 2>&1 | tee -a "$LOG_FILE"
    fi
    
    if [ $? -eq 0 ]; then
        echo "等待 60 秒..." | tee -a "$LOG_FILE"
        sleep 60
    else
        echo "提交失败，退出" | tee -a "$LOG_FILE"
        exit 1
    fi
done
