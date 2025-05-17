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

## 
