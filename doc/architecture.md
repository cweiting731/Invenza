# 程式架構
## 分類
* interface
    存放容器模型使用的interface
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
### condition
傳輸基本。
需包含String type, Map<String, dynamic> data
使用serialization將資料轉為String，用來傳輸給後端

### auth_data
condition.data裝載用
需包含String account, String password
使用serialization_json將資料轉為Map<String, dynamic>，以便進行condition.serialization()

### login 格式
#### client -> server
```json
{
  "type" : "Login", 
  "data" : {
    "account" : "account", 
    "password" : "password"
  }
}
```
#### server -> client (success)
employee_email 與 employee_phone可以為空，整行不填
```json
{
  "success" : true, 
  "name" : "employee_name", 
  "id" : "employee_id", 
  "email" : "employee_email?",
  "phone" : "employee_phone?"
}
```
### server -> client (fail)
```json
{
  "success" : false,
  "message" : "error_message"
}
```
