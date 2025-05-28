# 程式架構
## 分類
```=
├── interface
    ├── contacable.dart
        └── 給employees、供應商、經銷商使用
    ├── serializable.dart
        └── 給所有需要傳到後端的資料格式做序列化使用
        
├── models
    ├── transfer_data
        ├── auth_data.dart
            └── 登入時使用的資料格式 (account, password)
        ├── forgot_password_data.dart
            └── 忘記密碼使用的資料格式 (email)
        ├── issue_report_data.dart 
            └── 回報問題使用的資料格式 (issue, logs[])
    ├── association.dart
        └── 聯繫方式的格式 interface contacable
    ├── employee.dart
        └── 登入後須載入的員工資訊格式 (name, id, association, jwtToken)
        
├── pages
    ├── home_page
        ├── home_page.dart
            └── 主頁面的承載容器，控制換頁與app bar, bottom nav bar的切換與顯示
    ├── login_page
        ├── login_page.dart
            └── 登入頁面ui顯示
        ├── forgot_password_bottom_sheet.dart
            └── 登入頁面中，忘記密碼的底部彈跳視窗ui
    ├── issue_report.dart
        └── 問題回報使用的dialog ui顯示
    ├── routes.dart
        └── 切換頁面的route總表

├── providers
    ├── api_provider.dart
        └── 存放api_client的provider單例，所有需要傳送後端的資料皆須通過這個provider (Provider)
        └── 相關檔案: api_route, api_client
    ├── api_route.dart
        └── 存放傳送後端的各個指令進行分類時，需要的url
    ├── auth_provider.dart
        └── 登入驗證使用的provider (StateNotifierProvider)
        └── 相關檔案: api_provider
    ├── forgot_password_provider.dart
        └── 忘記密碼使用的provider (StateNotifierProvider.autoDispose)
        └── 相關檔案: api_provider
    ├── issue_report_provider.dart
        └── 回報問題使用的provider (StateNotifierProvider.autoDispose)
        └── 相關檔案: log_provider, api_provider
    ├── log_provider.dart
        └── 提供紀錄log使用的provider單例 (Provider)
        └── 相關檔案: log_service
        
├── services
    ├── api_client.dart
        └── 連接後端的方法實作，內含post等方法
        └── 相關檔案: api_provider
    ├── log_service.dart
        └── 提供紀錄log使用的實作方法
        └── 相關檔案: log_provider
        
├── theme
    ├── theme.dart
        └── 訂定公用的顏色方案
        
├── widgets
    ├── dialog_utils.dart
        └── 存放一些共用的dialog widgets，像是loading中的alert dialog，可以用裡面的dismiss刪除
        
├── main.dart
    └── 主程式    
```
* interface
    存放容器模型使用的interface
    * contactable
        給employees、供應商、經銷商
    * serializable
        給所有需要傳到後端子資料型態
* models
    存放容器模型
* pages
    放置page的設計
  * routes
    放置各個頁面的route以供切換
  * login_page
    登入頁面，初始頁面，不能用"返回"回到此頁面，只能通過logout回到此頁面，setting沒有logout可以使用
  * home_page
    使用top bar或bottom bar切換Dashboard, ProcurementPage, InventoryPage, OrderPage, CalanderPage
* providers
    存放provider的地方
  * auth_provider
    處理login邏輯，將account與password傳至後方確認
    如果帳號密碼正確，會建立Employee並將用戶個人資料存入此provider，方便後續操作
* services
    放service，後端連結之類的
* theme
    定義app的設計顏色與主題
* widgets
    存放一些共用的widgets
* main.dart
    程式的起點，連結頁面的route表，並定義最初的route位置

## 傳輸相關協定
### auth_data
需包含String account, String password
使用serialization將資料轉為json格式

### ==POST== /api/auth/login
#### request
```json
{
    "account" : "user_account", 
    "password" : "user_password"
}
```
#### response (200)
```json
{
    "name" : "user_name", 
    "id" : "user_id", 
    "email" : "user_email", 
    "phone" : "user_phone",
    "jwt" : "jwtToken"
}
```
#### response (401)
```json
{
  "error": "reason"
}
```

### ==POST== /api/auth/forgot-password
#### request
```json
{
    "email" : "user_email"
}
```

#### response (200/401)
```json
{
    "error" : "error message"
}
```

### /api/issue-report
#### request
```json
{
    "issue" : "user_issue", 
    "logs" : [
        {
            "level" : "log_level", 
            "timestamp" : "log_timestamp", 
            "message" : "log_message"
        },
        {
            "level" : "log_level", 
            "timestamp" : "log_timestamp", 
            "message" : "log_message"
        }
        
    ]
}
```

#### response (200/400)
```json
{
    "error" : "error message"
}
```

### ==GET== /api/procurement/get-data
```json

```

### response (200)
```json
{
  "data" : [
    {
      "id" : 1, 
      "commodity" : {
        "name" : "commodityName",
        "type" : "commodityType",
        "transactionValue" : {
          "unitPrice" : 1.5, 
          "quantity" : 100.0, 
          "totalCost" : 150.0
        }
      },
      "supplier" : {
        "name" : "supplierName",
        "id" : "supplierId",
        "association" : {
          "email" : "supplier email",
          "phone" : "supplier phone"
        }
      },
      "orderTimeStamp" :  "DateTime", 
      "deadlineTimeStamp" : "DateTime", 
      "responsible" : {
        "name" : "Employee name", 
        "id" : "Employee id", 
        "association" : {
          "email" : "Employee email",
          "phone" : "Employee phone"
        }
      }
    }
    
  ]
}
```
#### response (404)
```json
{
  "error" : "error message"
}
```

### ==GET== /api/inventory/get-data
#### request
```json
{
    
}
```
#### response (200)
futureStockQuantity = stockQuantity + expectedImportQuantity - expectedExportQuantity
```json
{
  "data" : [
    {
      "commodity" : {
        "name" : "commodity name",
        "type" : "commodity type"
      },
      "stockQuantity" : "stockQuantity (double)",
      "expectedImportQuantity" : "expectedImportQuantity (double)", 
      "expectedExportQuantity" : "expectedExportQuantity (double)", 
      "futureStockQuantity" : "futureStockQuantity (double)"
    }
  ]
}
```

#### response (404) 
```json
{
  "error" : "error message"
}
```