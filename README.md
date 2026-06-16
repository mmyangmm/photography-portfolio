# 攝影作品集 Photography Portfolio

簡約 editorial 風格的個人攝影作品集，單一 HTML 檔，部署於 GitHub Pages。
照片以**原圖**存在 `images/` 資料夾，**不壓縮、數量不限**。

**線上網址：** https://mmyangmm.github.io/photography-portfolio/

## 新增照片（核心流程）

1. 把照片（可一次多張）丟進 `images/` 資料夾。
2. 在這個資料夾的終端機執行：
   ```bash
   ./publish.sh
   ```
   腳本會掃描 `images/`、把作品清單寫進 `index.html`、commit 並 push。約 1–2 分鐘後線上網址更新。

## 設定標題、分類、首頁文案

1. 雙擊 `index.html` 用瀏覽器打開（本機開檔右上角才會出現「編輯」）。
2. 滑到照片上 → ✎ 編輯標題/分類/年份/說明；↑↓ 調整順序；✕ 從網站移除。
   「網站設定」可改名字、首頁標語、自我介紹、封面圖、Email、社群連結。
3. 改完按「**匯出資料**」（下載 `portfolio-data.json`），再執行 `./publish.sh` 套用上線。

## 運作方式

- **照片**：真實檔案放 `images/`，原圖不壓縮。GitHub Pages 單站約 1GB、流量寬鬆。
- **作品清單與設定**：一小段 JSON 內嵌在 `index.html`（由 `publish.sh` 寫入），訪客與你都讀這份。
- 編輯時的暫存放在瀏覽器（localStorage）當作覆蓋層；真正上線以 `publish.sh` 寫入檔案為準。
- 「從網站移除」只是隱藏；要徹底刪除並釋放空間，把該檔案從 `images/` 刪掉再 `./publish.sh`。
- 原圖很大時訪客載入較慢；若要加速可日後加入縮圖產生（grid 用縮圖、燈箱用原圖）。

## 技術

- 純前端單檔（HTML + 內嵌 CSS/JS），無框架、無後端。
- 字體：Playfair Display（標題）/ Inter（內文）。設計用 ui-ux-pro-max skill 規劃。
