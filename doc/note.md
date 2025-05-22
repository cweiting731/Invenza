# 開發筆記
## Riverpod 加入
1. 在pubspec.yaml裡面新增"flutter_riverpod: ^2.5.1"
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
```
2. 使用ProviderScope將myApp包起來

## ref.watch / ref.read / ref.listen 差別整理
| 用法                | 觸發 rebuild        | 用途                     | 類似什麼                                  |
| ----------------- | ----------------- | ---------------------- | ------------------------------------- |
| `ref.watch(...)`  | ✅ 是               | UI 顯示資料時使用             | Flutter 的 `setState()` 自動更新畫面         |
| `ref.read(...)`   | ❌ 否               | 只讀一次資料（例如呼叫函式）         | `Provider.of(context, listen: false)` |
| `ref.listen(...)` | ❌ 否，但會觸發 callback | 監聽狀態變化做事，但不 rebuild UI | `addListener` / side effect only      |

## http status code
| 狀態碼              | 名稱                    | 說明                         |
| ---------------- | --------------------- | -------------------------- |
| **✅ 1xx：資訊性**    |                       |                            |
| 100              | Continue              | 表示可以繼續傳送請求的其餘部分            |
| **✅ 2xx：成功**     |                       |                            |
| 200              | OK                    | 一般成功回應                     |
| 201              | Created               | 成功建立新的資源（如 POST 成功新增）      |
| 204              | No Content            | 請求成功，但無回傳內容（常用於 DELETE）    |
| **⚠️ 3xx：重導向**   |                       |                            |
| 301              | Moved Permanently     | 永久轉址（資源已搬移）                |
| 302              | Found                 | 臨時轉址（舊稱 Moved Temporarily） |
| 304              | Not Modified          | 客戶端快取內容未改變，無需傳送內容          |
| **❗️ 4xx：用戶端錯誤** |                       |                            |
| 400              | Bad Request           | 請求格式錯誤，伺服器無法解析             |
| 401              | Unauthorized          | 未授權，需要登入或提供 token          |
| 403              | Forbidden             | 已認證但無權限（例如限制訪問）            |
| 404              | Not Found             | 找不到資源                      |
| 409              | Conflict              | 資源衝突（如新增重複帳號）              |
| 422              | Unprocessable Entity  | 格式正確，但語意錯誤（常見於表單驗證錯）       |
| **🔥 5xx：伺服器錯誤** |                       |                            |
| 500              | Internal Server Error | 伺服器內部錯誤                    |
| 502              | Bad Gateway           | 上游伺服器錯誤                    |
| 503              | Service Unavailable   | 伺服器暫時無法處理請求（過載、維修中）        |

| 場景            | 建議使用                        |
| ------------- | --------------------------- |
| 成功 GET / POST | `200 OK` / `201 Created`    |
| 表單沒填好         | `400 Bad Request` 或 `422`   |
| 沒登入           | `401 Unauthorized`          |
| 沒權限即使登入了      | `403 Forbidden`             |
| 找不到頁面或資料      | `404 Not Found`             |
| 使用者送出重複資料     | `409 Conflict`              |
| 系統出 bug       | `500 Internal Server Error` |
