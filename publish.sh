#!/usr/bin/env bash
# 把你的最新作品發佈到 GitHub Pages
#
# 用法：
#   1. 在本機開啟 index.html，按「編輯 → 新增作品」加好照片
#   2. 按「編輯 → 匯出資料」下載 portfolio-data.json（會在「下載」資料夾）
#   3. 在這個資料夾執行：   ./publish.sh
#      （或指定檔案：       ./publish.sh ~/Downloads/portfolio-data.json ）
set -e
cd "$(dirname "$0")"

SRC="${1:-$(ls -t "$HOME/Downloads"/portfolio-data*.json 2>/dev/null | head -1)}"
if [ -z "$SRC" ] || [ ! -f "$SRC" ]; then
  echo "✗ 找不到資料檔。請先在網站按「編輯 → 匯出資料」，或用：./publish.sh 路徑/portfolio-data.json"
  exit 1
fi
echo "→ 使用資料檔：$SRC"

python3 - "$SRC" <<'PY'
import sys, re, json
raw = open(sys.argv[1], encoding='utf-8').read()
json.loads(raw)                       # 驗證 JSON 格式
safe = raw.replace('<', '\\u003c')    # 避免提早關閉 <script>
html = open('index.html', encoding='utf-8').read()
html = re.sub(r'(<script id="portfolio-data"[^>]*>).*?(</script>)',
              lambda m: m.group(1) + safe + m.group(2),
              html, count=1, flags=re.S)
open('index.html', 'w', encoding='utf-8').write(html)
print("→ 已把照片資料寫入 index.html")
PY

git add index.html
if git diff --cached --quiet; then
  echo "（沒有變更，不需發佈）"
  exit 0
fi
git commit -m "Update portfolio $(date '+%Y-%m-%d %H:%M')"
git push
echo "✅ 已發佈！1–2 分鐘後到這裡看：https://mmyangmm.github.io/photography-portfolio/"
