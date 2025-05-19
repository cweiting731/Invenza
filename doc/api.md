# 後端資料傳遞格式
## 通用
* 所有要傳到後端的資料皆須通過 apiClientProvider ( 使用 final api = ref.read(apiClientProvider) 讀入 )