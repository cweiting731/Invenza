# 程式架構
## 分類
* interface
    存放容器模型使用的interface
* models
    存放容器模型
* pages
    放置page的設計
    * login_page
        登入頁面，初始頁面，不能用"返回"回到此頁面，只能通過logout回到此頁面，setting沒有logout可以使用
    * home_page
        使用top bar或bottom bar切換Dashboard, ProcurementPage, InventoryPage, OrderPage, CalanderPage
* providers
    存放provider的地方
* services
    放service，後端連結之類的
* theme
    定義app的設計顏色與主題
* widgets
    存放一些共用的widgets
* main.dart
    程式的起點，連結頁面的route表，並定義最初的route位置
