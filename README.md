# 攝影作品集 Photography Portfolio

簡約 editorial 風格的個人攝影作品集，單一 HTML 檔，部署於 GitHub Pages。

**線上網址：** https://mmyangmm.github.io/photography-portfolio/

## 日常使用流程

1. **編輯（在本機）**
   雙擊本資料夾的 `index.html` 用瀏覽器開啟 → 右上角會出現「編輯」按鈕（只有本機開檔才會出現，訪客看不到）。
   - 「＋ 新增作品」：上傳／拖曳照片、填標題、分類、年份、說明
   - 「網站設定」：改名字、首頁標語、自我介紹、Email、社群連結、首頁封面
   - 點任一張照片可全螢幕檢視（左右鍵切換、ESC 關閉）

2. **發佈到網路上**
   編輯模式 →「**匯出資料**」會下載 `portfolio-data.json`，然後在這個資料夾執行：
   ```bash
   ./publish.sh
   ```
   腳本會把照片資料寫進 `index.html` 並推上 GitHub，約 1–2 分鐘後線上網址即更新。

3. **分享單一檔案（不想用 GitHub 時）**
   編輯模式 →「匯出可分享網頁」會下載一個內含所有照片的 `portfolio.html`，可直接寄給別人或丟到任何空間。

## 說明

- 照片存在「你這台電腦、這個瀏覽器」的本機儲存（localStorage，約 5–10MB），所以請固定在同一台電腦編輯。
- 換電腦：用「匯出資料」存 JSON，到新電腦的網站「匯入資料」。
- 大圖會在上傳時自動壓縮（長邊 1600px）以節省空間。
- 訪客看到的是乾淨的唯讀作品集，沒有任何編輯按鈕。

## 技術

- 純前端單檔（HTML + 內嵌 CSS/JS），無框架、無後端。
- 字體：Playfair Display（標題）/ Inter（內文）。
- 設計用 ui-ux-pro-max skill 規劃。
