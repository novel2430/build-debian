#!/usr/bin/env bash

LOG_FILE="/var/log/my-timeshift-backup.log"

# 2. 將後續所有的 標準輸出 (stdout) 與 標準錯誤 (stderr) 都導向該檔案
# >> 是累加模式，如果你想每次覆蓋，請用 >
exec >> "$LOG_FILE" 2>&1

# 3. 印出執行時間（方便以後對帳）
echo "--- Backup Start: $(date '+%Y-%m-%d %H:%M:%S') ---"

# 4. 執行 Timeshift
# 建議加上 PATH 確保 cron 執行時能找到所有相依工具
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

/usr/bin/timeshift --create --comments "Weekly backup" --tags W

echo "--- Backup End: $(date '+%Y-%m-%d %H:%M:%S') ---"
echo ""

