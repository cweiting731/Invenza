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
        ├── filter_options.dart
            └── 給 ProcurementPage, SalesPage, InventoryPage 的 http.get 使用的 filter 參數格式
        ├── forgot_password_data.dart
            └── 忘記密碼使用的資料格式 (email)
        ├── inventory_request
            └── 給倉管發需求，採買與銷售領取需求的格式
        ├── issue_report_data.dart 
            └── 回報問題使用的資料格式 (issue, logs[])
    ├── association.dart
        └── 聯繫方式的格式 interface contacable
    ├── business_partner.dart
        └── 給 ImportOrder 與 ExportOrder 中的 supplier 與 distributor 使用的統一格式
    ├── employee.dart
        └── 登入後須載入的員工資訊格式 (name, id, association, jwtToken)

    ├── commodity.dart
        └── 商品的統一格式 (name、type、TransactionValue)
    ├── transaction_value.dart
        └── 放在 commodity 中儲存

    ├── export_order.dart
        └── 在 SalesPage 顯示的出貨單格式
    ├── import_order.dart
        └── 在 ProcurementPage 顯示的進貨單格式
    ├── inventory_item.dart
        └── 在 InventoryPage 中顯示庫存商品格式
        
├── pages
    ├── home_page
        ├── home_page.dart
            └── 主頁面的承載容器，控制換頁與 NavigationBottomBar 的切換與顯示

        ├── dashboard.dart
            └── 首頁，顯示從倉管發來的 InventoryRequest 讓採買與銷售可以接取請求
            └── 有採買或是銷售權限的可以看到自己接取的 InventoryRequest
            └── 顯示存貨不足或是即將爆倉的庫存給倉管查看

        ├── procurement_page.dart
            └── 採買頁面，顯示進貨單列表
            └── 點擊 card 可以往下延伸顯示進貨單詳細資訊
            └── 可以通過按鈕前往 edit_procurement_filter 頁面編輯這個頁面的 filter
            └── 有 procurement 權限的可以通過按鈕編輯 自己負責的 進貨單
            └── 有 procurement 權限的可以通過按鈕新增自己進貨單
        ├── edit_procurement_filter.dart
            └── 編輯 ProcurementPage 的 filter 屬性
        ├── edit_procurement_page.dart
            └── 編輯 ImportOrder 的頁面，有較嚴格的格式要求
            └── 使用 add 按鈕會傳進一個空的 ImportOrder (沒id，id由後端給予)，以進行新增 ImportOrder 的動作
            └── 使用 edit 按鈕會傳進該 ImportOrder (帶id)，以進行編輯
        
        ├── inventory_page.dart
            └── 倉管頁面，顯示當前倉庫物品與數量，以及根據進貨單與出貨單顯示未來的進貨數量與出貨數量
            └── 有 inventory 權限的可以點擊 floating action button 來新增 InventoryRequest
            └── 有 inventory 權限的可以長按倉庫物品的 card 來新增 InventoryRequest
        ├── edit_inventory_filter.dart
            └── 編輯 InventoryPage 的 filter 屬性
        ├── edit_inventory_request.dart
            └── 編輯 InventoryRequest 的頁面，有較嚴格的格式要求
            └── 使用 floating action button 的方法新增的 InventoryRequest 不能發給 Saler，避免沒商品還叫銷售
            └── 使用 長按 新增的的 InventoryRequest 可以選擇要發給 Procurement 或是 Saler
            └── InventoryRequest 的 id 編號都由後端給予
        
        ├── sales_page.dart
            └── 銷售頁面，顯示出貨單列表
            └── 點擊 card 可以往下延伸顯示出貨單詳細資訊
            └── 可以通過按鈕前往 edit_sales_filter 頁面編輯這個頁面的 filter
            └── 有 saler 權限的可以通過按鈕編輯 自己負責的 出貨單
            └── 有 saler 權限的可以通過按鈕新增自己的出貨單
        ├── edit_sales_filter.dart
            └── 編輯 SalesPage 的 filter 屬性
        ├── edit_sales_page.dart
            └── 編輯 ExportOrder 的頁面，有較嚴格的格式要求
            └── 使用 add 按鈕會傳進一個空的 ExportOrder (沒id，id由後端給予)，以進行新增
            └── 使用 edit 按鈕會傳進該 ExportOrder (帶id)，以進行編輯

        ├── profile_page.dart
            └── 個人檔案頁面，顯示自己的名字、職位、員工ID、email、phone
            └── 可以從這裡登出

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
    ├── api_route.dart
        └── 存放傳送後端的各個指令進行分類時，需要的url

    ├── api_provider.dart
        └── 存放api_client的provider單例，所有需要傳送後端的資料皆須通過這個provider (Provider)
        └── 相關檔案: api_route, api_client
    ├── log_provider.dart
        └── 提供紀錄log使用的provider單例 (Provider)
        └── 相關檔案: log_service

    ├── auth_provider.dart
        └── 登入驗證使用的provider (StateNotifierProvider)
        └── 相關檔案: api_provider, login_page
    ├── forgot_password_provider.dart
        └── 忘記密碼使用的provider (StateNotifierProvider.autoDispose)
        └── 相關檔案: api_provider, login_page
    ├── issue_report_provider.dart
        └── 回報問題使用的provider (StateNotifierProvider.autoDispose)
        └── 相關檔案: log_provider, api_provider
    
    ├── dashboard_provider.dart
        └── 首頁使用的 provider，可以操作不同的 function 來執行載入不同資料與承接請求、放棄請求、完成請求的動作
        └── 相關檔案: api_provider, dashboard
    ├── procurement_provider.dart
        └── 採買頁面使用的 provider，內含不同的 provider 來儲存狀態
        └── 儲存Filter importOrderFilterProvider
        └── 獲取資料 importOrderProvider
        └── 新增資料 addImportOrderProvider
        └── 編輯資料 editImportOrderProvider
        └── 刪除資料 deleteImportOrderProvider
        └── 聯繫 api_client 的 procurementRepositoryProvider
    ├── inventory_provider.dart
        └── 倉管頁面使用的 provider，內含不同的 provider 來儲存狀態
        └── 儲存Filter inventoryFilterProvider
        └── 獲取資料 inventoryItemsProvider
        └── 新增資料 addInventoryRequestProvider
        └── 聯繫 api_client 的 inventoryRepositoryProvider
    ├── sales_provider.dart
        └── 銷售頁面使用的 provider，內含不同的 provider 來儲存狀態
        └── 儲存Filter exportOrderFilterProvider
        └── 獲取資料 exportOrdersProvider
        └── 新增資料 addExportOrderProvider
        └── 編輯資料 editExportOrderProvider
        └── 刪除資料 deleteExportOrderProvider
        └── 聯繫 api_client 的 salesRepositoryProvider
        
├── services
    ├── api_client.dart
        └── 連接後端的方法實作，內含post, get, put, delete, 以及formatErrorMessage等方法
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
    ├── text_form.dart
        └── 存放一些共用的textForm widgets，像是顯示負責人的textButton
        
├── main.dart
    └── 主程式進入點
```