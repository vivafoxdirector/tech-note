# 날짜 변환
```

# 문자열 날짜 => Long 변환
# ref: https://stackoverflow.com/questions/18896470/converting-isodate-to-numerical-value
# ref: https://docs.mongodb.com/manual/reference/operator/aggregation/dateFromString/
db.log_hfwall.aggregate(
    [
        {
            $project: {
                date: {
                    $toLong: {
                        $dateFromString: {
                            dateString: '$datetime'
                        }
                    }
                }
            }
        }
    ]
)

# 날짜 포맷 변환 : YYYY-mm-dd HH:MM:SS ==> YYYY-mm-dd
db.log_hfwall.aggregate(
    [
        {
            $project: {
                date: {
                    $dateToString: {
                        format: '%Y-%m-%d',
                        date: {
                            $dateFromString: {
                                dateString: '$datetime'
                            }
                        }
                    }
                }
            }
        }
    ]
)

```

db.log_hfwall.aggregate(
[
   {
      "$match": {
         "$and": [
            {
               "hostSn": {
                  "$in": [
                     1,
                     2,
                     3,
                     4,
                     5,
                     14
                  ]
               }
            },
            {
               "datetime": {
                  "$gte": "2020-06-24",
                  "$lte": "2020-06-25"
               }
            },
            {
               "DenyFlag": 1
            }
         ]
      }
   },
   {
    "$project": {
         "value": "$LRepeat",
         "hour": {
            "$hour": {
               "$dateFromString": {
                  "dateString": "$datetime",
                  "format": "%Y-%m-%d %H:%M:%S"
               }
            }
         },
         "day": {
            "$dayOfMonth": {
               "$dateFromString": {
                  "dateString": "$datetime",
                  "format": "%Y-%m-%d %H:%M:%S"
               }
            }
         },
         "at": {
            "$dateToString": {
               "format": "%Y-%m-%d",
               "date": {
                  "$dateFromString": {
                     "dateString": "$datetime"
                  }
               }
            }
         }
      }
   },
   {
      "$group": {
         "_id": "$hour",
         "value": {
            "$sum": 1
         }
      }
   }
])




db.log_hfwall.aggregate(
   {
      $match: {
         $and: [
            { hostSn: {$in: [1,2,3,4,5,14]} },
            { datetime: { $gte: "2020-06-24", $lte: "2020-06-25" }},
            { DenyFlag: 1}
         ]
      }
   },
        {
            $group: {
                _id : {
                    $dateToString: {
                        format: '%Y-%m-%d %H:00',
                        date: {
                            $dateFromString: {
                                dateString: '$datetime'
                            }
                        }
                    }
                },
                datetime: { 
                    $dateFromString : {
                       "dateString" : "$datetime",
                       "format" : "%Y-%m-%d %H:%M:%S" }
                },
                LRepeat: {$sum: 1}
            }
        },
        {
            $project: { _id: 1, 
                hour: {
                    $hour: {
                       $dateFromString: {
                          dateString: "$datetime",
                          format: "%Y-%m-%d %H:%M:%S"
                       }
                    }
                },
                LRepeat: 1}
        },
        {
            $sort : {"_id" : 1}
        }
 
)
        





# 참고사이트
* 기초
- [MongoDB コマンドメモとか書き](https://qiita.com/svjunic/items/285e9cf20169d70aa1fa)
- [](https://stackoverflow.com/questions/18896470/converting-isodate-to-numerical-value)
- [](https://docs.mongodb.com/manual/reference/operator/aggregation/dateFromString/)

- [TimeZone설정1](https://github.com/spring-projects/spring-data-mongodb/blob/master/spring-data-mongodb/src/test/java/org/springframework/data/mongodb/core/aggregation/ProjectionOperationUnitTests.java)
- [TimeZone설정2](https://stackoverflow.com/questions/34914737/mongodb-aggregate-convert-date-to-another-timezone)

