# 後端資料傳遞格式
## 通用
* 所有要傳到後端的資料皆須通過 apiClientProvider ( 使用 final api = ref.read(apiClientProvider) 讀入 )

## POST /api/auth/login
### request
```json
{
    "account" : "user_account", 
    "password" : "user_password"
}
```
### response (200)
```json
{
    "name" : "user_name", 
    "id" : "user_id", 
    "email" : "user_email", 
    "phone" : "user_phone",
    "jwt" : "jwtToken"
}
```
### response (401)
```json
{
  "error": "reason"
}
```

## POST /api/auth/forgot-password
### request
```json
{
    "email" : "user_email"
}
```

### response (200/401)
```json
{
    "error" : "error message"
}
```

## POST /api/issue-report
### request
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

### response (200/400)
```json
{
    "error" : "error message"
}
```

## GET /api/procurement/get-data
### request
此處的request是放在url的QueryParams裡面，真實url長這樣
```
GET /api/procurement/get-data?commodityName=ddd&commodityType=fgg&businessPartner=yhj&businessPartnerId=fhji&orderTimeStart=2025-06-15+11%3A24&orderTimeEnd=2025-06-15+11%3A24&deadlineStart=2025-06-15+11%3A24&deadlineEnd=2025-06-15+11%3A24&responsible=fhj&responsibleId=bkjt
```
用args提取長這樣
```json
{
    "commodityName": "ddd",
    "commodityType": "fgg",
    "businessPartner": "yhj",
    "businessPartnerId": "fhji",
    "orderTimeStart": "2025-06-15 11:24",
    "orderTimeEnd": "2025-06-15 11:24",
    "deadlineStart": "2025-06-15 11:24",
    "deadlineEnd": "2025-06-15 11:24",
    "responsible": "fhj",
    "responsibleId": "bkjt"
}
```

businessPartner 需根據後端需求變化成supplier或是distributor判斷

所有的query params都可以是null，null表示不以該條件搜尋

TimeStart有值，但TimeEnd沒值 = 從TimeStart之後所有符合的Order (filter time > TimeStart)
TimeStart沒值，但TimeEnd有值 = 從TimeEnd之前所有符合的Order (filter time < TimeEnd)
TimeStart有值，TimeEnd有值 = 區間[TimeStart : TimeEnd]之間所有符合的Order (TimeStart < filter time < TimeEnd)

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
      "orderTimeStamp" :  "yyyy-MM-dd HH:mm", 
      "deadlineTimeStamp" : "yyyy-MM-dd HH:mm", 
      "responsible" : {
        "name" : "Employee name", 
        "id" : "Employee id", 
        "association" : {
          "email" : "Employee email",
          "phone" : "Employee phone"
        }
      }
    },
      
    {
      "id" : 2, 
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
      "orderTimeStamp" :  "yyyy-MM-dd HH:mm", 
      "deadlineTimeStamp" : "yyyy-MM-dd HH:mm", 
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
### response (200)
如果filter沒有搜到，傳空array就好
```json
{
    "data" : []
}
```

### response (404)
```json
{
  "error" : "error message"
}
```

## POST /api/procurement/add-data
此處傳過去的id是null，需要後端根據資料庫數量給定id
### request
```json
{
    "id": null,
    "commodity": {
        "name": "b",
        "type": "a",
        "transactionValue": {
            "unitPrice": 1.0,
            "quantity": 4.0,
            "totalCost": 4.0
        }
    },
    "supplier": {
        "name": "a",
        "id": "a",
        "association": {
            "email": "a",
            "phone": "5"
        }
    },
    "orderTimeStamp": "2025-06-12 14:55",
    "deadlineTimeStamp": "2025-06-12 14:55",
    "responsible": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": null
        }
    }
}
```
### response (200)
不用回傳資料，給status code就好
```json
{ 
}
```
### response (404)
```json
{
    "error" : "error message"
}
```

## PUT /api/procurement/update-data
### request
```json
{
    "id": 5,
    "commodity": {
        "name": "jhgfdryhfghhfgjjhgszxvgj",
        "type": "hhj",
        "transactionValue": {
            "unitPrice": 999.0,
            "quantity": 300.0,
            "totalCost": 4995.0
        }
    },
    "supplier": {
        "name": "vbm",
        "id": "gj",
        "association": {
            "email": "h@gmail.com",
            "phone": "996"
        }
    },
    "orderTimeStamp": "2025-06-14 15:58",
    "deadlineTimeStamp": "2025-06-14 15:58",
    "responsible": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": null
        }
    }
}
```
### response (200)
不用回傳資料，給status code就好
```json
{
}
```
### response (404)
```json
{
    "error" : "error message"
}
```

## DELETE /api/procurement/delete-data
### request
使用 queryParameters 給 import order id
```
DELETE /api/procurement/delete-data?id=3
```
### response (200)
不用回傳資料，給status code就好
```json
{
}
```
### response (400)
```json
{
    "error" : "error message"
}
```

## GET /api/inventory/get-data
### request
inventoryFilterType 只會有 "inventoryFuture" 或是 "inventoryNow"
這個跟 /api/procurement/get-data 一樣是 url 格式顯示，選項都可以是null，但如果是null則不會顯示在url上
```json
{
    "commodityName": "g",
    "commodityType": "g",
    "minAmount": "666.0",
    "maxAmount": "999.0",
    "inventoryFilterType": "inventoryFuture"
}
```
```json
{
    "commodityName": "g",
    "commodityType": "g",
    "minAmount": "666.0",
    "maxAmount": "999.0",
    "inventoryFilterType": "inventoryNow"
}
```
### response (200)
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

### response (404) 
```json
{
  "error" : "error message"
}
```

## POST /api/inventory/add-request

> **這個後端不用判斷** \
> 用 Floating Action add 方式點擊的 target 只會是 procurement
> 通過長按點擊的 target 可以是 saler 或是 procurement
:::
target 只會是 "procurement" 或是 "saler"
id 需要後端給予
### request
```json
{
    "id": null,
    "commodityName": "aaa",
    "commodityType": "aaa",
    "requestQuantity": 66.0,
    "target": "procurement",
    "responsible": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": null
        }
    },
    "checker": null,
    "isFinished": false
}
```
```json
{
    "id": null,
    "commodityName": "Banana",
    "commodityType": "Fruit",
    "requestQuantity": 66.0,
    "target": "saler",
    "responsible": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": null
        }
    },
    "checker": null,
    "isFinished": false
}
```
### response (200)
```json
{
}
```
### response (404)
```json
{
    "error" : "error message"
}
```

## GET /api/sales/get-data
### request
url顯示，跟 /api/procurement/get-data 與 /api/inventory/get-data一樣
```json
{
    "commodityName": "dd",
    "commodityType": "gg",
    "businessPartner": "gjkj",
    "businessPartnerId": "dbnj",
    "orderTimeStart": "2025-06-18 19:33",
    "orderTimeEnd": "2025-06-18 19:33",
    "deadlineStart": "2025-06-18 19:33",
    "deadlineEnd": "2025-06-18 19:29",
    "responsible": "fjj",
    "responsibleId": "dhj"
}
```
### response (200)
```json
{
  "data": [
    {
      "commodity": {
        "name": "Orange",
        "transactionValue": {
          "quantity": 120.0,
          "totalCost": 216.0,
          "unitPrice": 1.8
        },
        "type": "Fruit"
      },
      "deadlineTimeStamp": "2025-07-15 08:30",
      "distributor": {
        "association": {
          "email": "orange@distributor.com",
          "phone": "0911222333"
        },
        "id": "DIST101",
        "name": "南區水果通路"
      },
      "id": 1,
      "orderTimeStamp": "2025-06-15 08:30",
      "responsible": {
        "association": {
          "email": "lin.sales@example.com",
          "phone": "0977000999"
        },
        "id": "100003",
        "name": "林雅文"
      }
    },
    {
      "commodity": {
        "name": "Grapes",
        "transactionValue": {
          "quantity": 60.0,
          "totalCost": 192.0,
          "unitPrice": 3.2
        },
        "type": "Fruit"
      },
      "deadlineTimeStamp": "2025-07-10 10:00",
      "distributor": {
        "association": {
          "email": "grape@distributor.com",
          "phone": "0911222444"
        },
        "id": "DIST202",
        "name": "北方農產銷售"
      },
      "id": 2,
      "orderTimeStamp": "2025-06-10 10:00",
      "responsible": {
        "association": {
          "email": "wang.sales@example.com",
          "phone": "0966888777"
        },
        "id": "100004",
        "name": "王淑惠"
      }
    }
  ]
}
```
### response (404)
```json
{
    "error" : "error message"
}
```

## POST /api/sales/add-data
### request
id 值為null，需要後端賦值
```json
{
    "id": null,
    "commodity": {
        "name": "dd",
        "type": "gh",
        "transactionValue": {
            "unitPrice": 89.0,
            "quantity": 59.0,
            "totalCost": 5251.0
        }
    },
    "distributor": {
        "name": "gj",
        "id": "ghj",
        "association": {
            "email": "fhj@gmail.com",
            "phone": "89"
        }
    },
    "orderTimeStamp": "2025-06-18 19:50",
    "deadlineTimeStamp": "2025-06-18 19:50",
    "responsible": {
        "name": "sales",
        "id": "100003",
        "association": {
            "email": "sales@gmail.com",
            "phone": "0912345678"
        }
    }
}
```
### response (200)
```json
{
}
```
### response (404)
```json
{
    "error" : "error message"
}
```
## PUT /api/sales/update-data
### request
id 值不為 null
```json
{
    "id": 1,
    "commodity": {
        "name": "Orange",
        "type": "Fruit",
        "transactionValue": {
            "unitPrice": 1.8,
            "quantity": 120.0,
            "totalCost": 216.0
        }
    },
    "distributor": {
        "name": "南區水果通路",
        "id": "DIST101",
        "association": {
            "email": "orange@distributor.com",
            "phone": "0911222333"
        }
    },
    "orderTimeStamp": "2025-06-15 08:30",
    "deadlineTimeStamp": "2025-07-15 08:30",
    "responsible": {
        "name": "林雅文",
        "id": "100003",
        "association": {
            "email": "lin.sales@example.com",
            "phone": "0977000999"
        }
    }
}
```
### response (200)
```json
{
}
```
### response (404)
```json
{
    "error" : "error message"
}
```

## DELETE /api/sales/delete-data
### request
```
DELETE /api/sales/delete-data?id=1 
```
### response (200)
```json
{
}
```
### response (400)
```json
{
    "error" : "error message"
}
```

## GET /api/dashboard/get-procurement-requests
#### InventoryRequest 完整格式
```json
{
    "id": 10,
    "commodityName": "Banana",
    "commodityType": "Fruit",
    "requestQuantity": 66.0,
    "target": "saler",
    "responsible": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": "0900000000"
        }
    },
    "checker": {
        "name": "saler",
        "id": "100001",
        "association": {
            "email": "saler@gmail.com",
            "phone": "0911111111"
        }
    },
    "isFinished": false
}
```

### request
把inventory發給procurement的request都show出來
需要 isFinished 為 false 以及 checker 為 null 的

### response (200)
target都是procurement
checker跟isFinished不需要傳過來
```json
{
    "data": [
        {
            "id" : 1,
            "commodityName": "ghi",
            "commodityType": "fji",
            "requestQuantity": 56.0,
            "target": "procurement",
            "responsible": {
                "name": "admin",
                "id": "F00001",
                "association": {
                    "email": "admin@gmail.com",
                    "phone": "212345678"
                }
            }, 
        },
        {
            "id" : 2,
            "commodityName": "abc",
            "commodityType": "def",
            "requestQuantity": 100.0,
            "target": "procurement",
            "responsible": {
                "name": "inventory",
                "id": "200002",
                "association": {
                    "email": "inventory@gmail.com",
                    "phone": "212345679"
                }
            }, 
        }
    ]
}
```
### response (404)
會吃資料，目前不特別顯示錯誤資訊
```json
{
    "error" : "error message"
}
```

## GET /api/dashboard/get-saler-requests
### request
沒有設定參數，把inventory發給saler的request都show出來
### response (200)
```json
{
    "data": [
        {
            "id" : 1,
            "commodityName": "xyz",
            "commodityType": "uvw",
            "requestQuantity": 75.0,
            "target": "saler",
            "responsible": {
                "name": "admin3",
                "id": "F00003",
                "association": {
                    "email": "admin@gmail.com",
                    "phone": "212345680"
                }
            }, 
        }, 
        {
            "id" : 2,
            "commodityName": "lmn",
            "commodityType": "opq",
            "requestQuantity": 200.0,
            "target": "saler",
            "responsible": {
                "name": "inventory",
                "id": "200001",
                "association": {
                    "email": "inventory@gmail.com",
                    "phone": "212345679"
                }
            },
        }
    ]
}
```
### reponse (404)
會吃資料，目前不特別顯示錯誤資訊
```json
{
    "error" : "error message"
}
```

## GET /api/dashboard/get-inventory-data
### request
沒有設定參數，回傳inventory item中 futureStockQuantity < 50 或是 futureStockQuantity > 9950的
### response (200)
```json
{
    "data": [
            {
                "commodity" : {
                    "name": "Apple",
                    "type": "Fruit"
                },
                "stockQuantity": 100.0,
                "expectedImportQuantity": 50.0,
                "expectedExportQuantity": 30.0,
                "futureStockQuantity": 120.0
            },
            {
                "commodity" : {
                    "name": "Banana",
                    "type": "Fruit"
                },
                "stockQuantity": 200.0,
                "expectedImportQuantity": 40.0,
                "expectedExportQuantity": 60.0,
                "futureStockQuantity": 180.0
            }
        ]
}
```
### response (400)
會吃資料，目前不特別顯示錯誤資訊
```json
{
    "error" : "error message"
}
```

## GET /api/dashboard/get-user-requests
### request
給使用者的用戶id，回傳checker是該用戶，以及isFinished為false的request
```
GET /api/dashboard/get-user-requests?id=F00001
```
### response (200)
checker應不為空並且應為該用戶，isFinished應為false
```json
{
    "data": [
        {
            "id" : 1,
            "commodityName": "xyz",
            "commodityType": "uvw",
            "requestQuantity": 75.0,
            "target": "saler",
            "responsible": {
                "name": "inventory",
                "id": "200003",
                "association": {
                    "email": "inventory@gmail.com",
                    "phone": "212345680"
                }
            }, 
            "checker": {
                "id": "F00001",
                "name": "admin",
                "association": {
                    "email": "admin@gmail.com",
                    "phone": "0900000000"
                },
            },
            "isFinished": false
        }, 
        {
            "id" : 2,
            "commodityName": "lmn",
            "commodityType": "opq",
            "requestQuantity": 200.0,
            "target": "procurement",
            "responsible": {
                "name": "admin",
                "id": "F00001",
                "association": {
                    "email": "admin@gmail.com",
                    "phone": "212345679"
                }
            },
            "checker": {
                "id": "F00001",
                "name": "admin",
                "association": {
                    "email": "admin@gmail.com",
                    "phone": "0900000000"
                },
            },
            "isFinished": false
        }
    ]
}
```
### response (404)
會吃資料，目前不特別顯示錯誤資訊
```json
{
    "error" : "error message"
}
```

## PUT /api/dashboard/accept-request
### request
需要後端根據target值為何，選擇對哪個table操作，此處isFinished應為false
```json
{
    "id": 1,
    "commodityName": "xyz",
    "commodityType": "uvw",
    "requestQuantity": 75.0,
    "target": "saler",
    "responsible": {
        "name": "inventory",
        "id": "200003",
        "association": {
            "email": "inventory@gmail.com",
            "phone": "212345680"
        }
    },
    "checker": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": "0900000000"
        }
    },
    "isFinished": false
}
```
### response (200)
```json
{
}
```
### response (404)
這裡會顯示error message
```json
{
    "error" : "error message"
}
```

## PUT /api/dashboard/abandon-request
### request
需要後端根據target值不同將這個request塞回他應在的table
此處checker應為null，isFinished應為false
```json
{
    "id": 1,
    "commodityName": "ghi",
    "commodityType": "fji",
    "requestQuantity": 56.0,
    "target": "procurement",
    "responsible": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": "212345678"
        }
    },
    "checker": null,
    "isFinished": false
}
```
### response (200)
```json
{
}
```
### response (404)
這裡會顯示error message
```json
{
    "error" : "error message"
}
```

## PUT /api/dashboard/finished-request
### request
此處checker應有值，isFinished應為true
```json
{
    "id": 1,
    "commodityName": "xyz",
    "commodityType": "uvw",
    "requestQuantity": 75.0,
    "target": "saler",
    "responsible": {
        "name": "admin",
        "id": "F00003",
        "association": {
            "email": "admin@gmail.com",
            "phone": "212345680"
        }
    },
    "checker": {
        "name": "admin",
        "id": "F00001",
        "association": {
            "email": "admin@gmail.com",
            "phone": "0900000000"
        }
    },
    "isFinished": true
}
```
### response (200)
```json
{
}
```
### response (404)
```json
{
    "error" : "error message"
}
```