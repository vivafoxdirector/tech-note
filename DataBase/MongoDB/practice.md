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

# 참고사이트
* 기초
- [MongoDB コマンドメモとか書き](https://qiita.com/svjunic/items/285e9cf20169d70aa1fa)

- [](https://stackoverflow.com/questions/18896470/converting-isodate-to-numerical-value)
- [](https://docs.mongodb.com/manual/reference/operator/aggregation/dateFromString/)
