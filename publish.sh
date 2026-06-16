#!/usr/bin/env bash
# 掃描 images/ 資料夾、更新作品清單，並發佈到 GitHub Pages。
#
# 用法：
#   1. 把照片（可一次多張）放進 images/ 資料夾
#   2. 在這個資料夾執行：   ./publish.sh
#   （若剛在網站「匯出資料」改了標題/分類，腳本會自動套用 ~/Downloads 最新的 portfolio-data.json，
#    也可手動指定：        ./publish.sh ~/Downloads/portfolio-data.json ）
set -e
cd "$(dirname "$0")"
mkdir -p images

ARG="${1:-}"

python3 - "$ARG" <<'PY'
import sys, os, re, json, glob

arg = sys.argv[1] if len(sys.argv) > 1 else ""
EXTS = {".jpg", ".jpeg", ".png", ".webp", ".gif", ".avif"}
WARN = {".heic", ".heif", ".tif", ".tiff", ".bmp", ".cr2", ".cr3", ".nef", ".arw", ".dng", ".raf"}

DEFAULT = {
  "settings": {
    "brand": "Studio", "eyebrow": "Photographer · Taipei",
    "title": "捕捉光影裡\n的靜謐瞬間",
    "intro": "以自然光與細膩構圖記錄人、地方與時間的痕跡。每一幀都是一段安靜而誠實的敘事。",
    "heroImage": "", "aboutEyebrow": "About",
    "about": "我相信最好的照片是等待而非製造出來的，於是我學會了凝視與等待。",
    "email": "hello@example.com", "ig": "", "be": "", "other": ""
  },
  "categories": ["人像", "風景", "街拍", "靜物", "建築", "旅行"],
  "photos": []
}

html = open("index.html", encoding="utf-8").read()
m = re.search(r'(<script id="portfolio-data"[^>]*>)(.*?)(</script>)', html, re.S)
if not m:
    print("✗ index.html 找不到 portfolio-data 區塊"); sys.exit(1)

def load_meta():
    # 1) 明確指定的檔案  2) ~/Downloads 最新匯出  3) index.html 內嵌  4) 預設
    cand = arg
    if not cand:
        dl = sorted(glob.glob(os.path.expanduser("~/Downloads/portfolio-data*.json")),
                    key=os.path.getmtime, reverse=True)
        cand = dl[0] if dl else ""
    if cand and os.path.isfile(cand):
        print(f"→ 套用匯出資料：{cand}")
        return json.load(open(cand, encoding="utf-8"))
    try:
        d = json.loads(m.group(2))
        if isinstance(d, dict) and "photos" in d:
            print("→ 沿用 index.html 既有資料")
            return d
    except Exception:
        pass
    print("→ 使用預設設定（第一次發佈）")
    return json.loads(json.dumps(DEFAULT))

base = load_meta()
base.setdefault("settings", DEFAULT["settings"])
base.setdefault("categories", DEFAULT["categories"])
base.setdefault("photos", [])

# 掃描 images/
files, warned = [], []
for fn in os.listdir("images"):
    if fn.startswith("."):
        continue
    ext = os.path.splitext(fn)[1].lower()
    if ext in EXTS:
        files.append(fn)
    elif ext in WARN:
        warned.append(fn)
files_set = set(files)

# 對照：保留既有順序/標題/隱藏，移除已刪檔，附加新檔
out, seen = [], set()
for p in base["photos"]:
    fn = (p.get("file") or "").split("/")[-1]
    if fn in files_set and fn not in seen:
        p["file"] = "images/" + fn
        out.append(p); seen.add(fn)
for fn in sorted(files):
    if fn not in seen:
        out.append({"id": fn, "file": "images/" + fn,
                    "name": os.path.splitext(fn)[0].replace("_", " ").replace("-", " "),
                    "category": "", "year": "", "desc": ""})
        seen.add(fn)
base["photos"] = out

payload = json.dumps(base, ensure_ascii=False).replace("<", "\\u003c")
new_html = html[:m.start(2)] + payload + html[m.end(2):]
open("index.html", "w", encoding="utf-8").write(new_html)

shown = len([p for p in out if not p.get("hidden")])
print(f"→ images/ 共 {len(files)} 張圖；作品清單 {len(out)} 筆（顯示 {shown}）")
if warned:
    print("⚠ 以下格式瀏覽器多半無法顯示，建議先轉成 JPG/PNG：")
    for w in warned: print("   -", w)
PY

git add images index.html
if git diff --cached --quiet; then
  echo "（沒有變更，不需發佈）"; exit 0
fi
git commit -m "Update gallery $(date '+%Y-%m-%d %H:%M')"
git push
echo "✅ 已發佈！1–2 分鐘後到這裡看：https://mmyangmm.github.io/photography-portfolio/"
