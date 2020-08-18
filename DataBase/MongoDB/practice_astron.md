show collections

db.log_hfwall.count();
db.log_hfwall.find().count();
db.log_hfwall.find();
db.log_hfwall.find({datetime: { $gte: '2019-10-28' }}).count();

db.log_hfwall.find({datetime: { $gte: '2019-10-28' }}, {datetime:1});

db.log_hfwall.find({datetime: { $gte: '2019-10-28' }}, {datetime:1, _id:0});

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
                        format: '%Y-%m-%d %H:00',
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

db.log_hfwall.aggregate(
    [
        {
            $project: {
                date: {
                    $dateToString: {
                        format: '%Y-%m-%d %H:00',
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

# $in
db.log_hfwall.find(
    { hostSn: { $in: [14,1,11]} , datetime : { $gte: '2020-05-01'}}
)

75,67,85,83,81,107,86,77,71


--# 차단 건수
db.log_hfwall.find(
    { hostSn: { $in: [75,67,85,83,81,107,86,77,71]} , datetime : { $gte: '2020-07-14 17:20:35', $lt: '2020-07-15 17:20:35'}, DenyFlag : 1}
).sort( {LRepeat:-1}).limit(10)

db.log_hfwall.find();
db.log_hfwall.find(
    { hostSn: { $in: [75,67,85,83,81,107,86,77,71]} , datetime : { $gte: '2020-07-14 17:20:35', $lt: '2020-07-15 17:20:35'}, DenyFlag : 1}).sort( {LRepeat:-1}).count()

--# 차단 Top10(24시간) / 차단 이력 (3개 차트)
# $in (SQL의 IN과 같음)
# sort(1:오름차순, -1:내림차순)
# limit(SQL의 LIMIT)

db.log_hfwall.find(
    { hostSn: { $in: [14,1,2,3,4,5]} , datetime : { $gte: '2019-10-28', $lt: '2020-04-31'}, DenyFlag : 1, LRepeat : { $gte: 0}}
)

-- 날짜별 집계 (빈도건수별)
db.log_hfwall.aggregate(
    [
        {
            $group: {
                _id : {
                    $dateToString: {
                        format: '%Y-%m-%d',
                        date: {
                            $dateFromString: {
                                dateString: '$datetime'
                            }
                        }
                    }
                },
                LRepeat: {$sum: 1}
            }
        },
        {
            $project: { _id: 1, stat_data:1, LRepeat: 1
            }
        }
    ]
)



db.log_hfwall.find();
-- 날짜별 집계 (로우건수별)
db.log_hfwall.aggregate(
    [
        {
            $group: {
                _id: {
                    $dateToString: {
                        format: '%Y-%m-%d',
                        date: {
                            $dateFromString: {
                                dateString: '$datetime'
                            }
                        }
                    }
                },
                datetime: { $first: "$datetime" },
                LRepeat: {$sum: 1}
            }
        },
        {
            $project: { _id:1,  LRepeat: 1 }
        }
    ]
)

db.log_hfwall.count()
db.log_hfwall.find();
db.log_hfwall.aggregate(
    [
        {
            $project: { _id:0, datetime: 1, count: 1 }
        }
    ]
)

db.log_hfwall.aggregate(
    [
        {
            $group: {
                _id: {
                    yyyy: { $year: { $dateFromString: {
                                dateString: '$datetime'
                            }} },
                    mm: { $month: { $dateFromString: {
                                dateString: '$datetime'
                            }} },
                    dd: { $dayOfMonth: { $dateFromString: {
                                dateString: '$datetime'
                            }} }
                },
                count: {$sum : 1}
            }
        },
        {
            $project: { _id:1, datetime: 1, count: 1 }
        }
    ]
)

db.log_hfwall.aggregate(
    [
        {
            $group: {
                _id: {
                    yyyy: { $year: { $dateFromString: {
                                dateString: '$datetime'
                            }} },
                    mm: { $month: { $dateFromString: {
                                dateString: '$datetime'
                            }} },
                    dd: { $dayOfMonth: { $dateFromString: {
                                dateString: '$datetime'
                            }} }
                },
                count: {$sum : 1}
            }
        },
        {
            $project: { _id:1, datetime: 1, count: 1 }
        }
    ]
)

db.log_hfwall.aggregate(
    [
        {
            $group: {
                _id: {
                    $dateToString: {
                        format: '%Y-%m-%d',
                        date: {
                            $dateFromString: {
                                dateString: '$datetime'
                            }
                        }
                    }
                },
                datetime: { $first: "$datetime" },
                count: {$sum: 1}
            }
        },
        {
            $project: { _id:1,  count: 1 }
        }
    ]
)


db.log_hfwall.aggregate(
    [
        {
            $group: {
                _id: {
                  yyyy: { $year: "$datetime" },
                  mm: { $month: "$datetime" },
                  dd: { $dayOfMonth: "$datetime" }
                },
                datetime: { $first: "$datetime" },
                count: {$sum: 1}
            }
        },
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
                }, count: 1
            }
        }
    ]
)

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
                }, count: 1
            }
        }
    ]
)



db.log_hfwall.count()
db.log_hfwall.find(
    { hostSn: { $in: [14,1,2,3,4,5]} , datetime : { $gte: '2019-10-28', $lt: '2020-04-31'}, DenyFlag : 1}
).sort( {LRepeat:-1}).limit(10)

-- 테스트용 데이터 입력
db.log_hfwall.insert({AddrDst:'224.0.0.251', AddrSrc:'10.12.103.100', DenyFlag:1, Direct:0, HostAddr:'192.168.218.22',LRepeat:2, LogLevel:2, MacDst:'', NetIntf:'', PortDst:'5353', PortSrc:'5353', Protocol:17, RuleName:'', RuleNum:1, amiSn:78, cldType:1, datetime:'2020-04-03 00:00:00', groupCd:2, hostSn:3, subSn:10, vpcSn:2});
db.log_hfwall.insert({AddrDst:'224.0.0.251', AddrSrc:'10.12.103.100', DenyFlag:1, Direct:0, HostAddr:'192.168.218.22',LRepeat:2, LogLevel:2, MacDst:'', NetIntf:'', PortDst:'5353', PortSrc:'5353', Protocol:17, RuleName:'', RuleNum:1, amiSn:78, cldType:1, datetime:'2020-04-03 00:05:00', groupCd:2, hostSn:3, subSn:10, vpcSn:2});
db.log_hfwall.insert({AddrDst:'224.0.0.251', AddrSrc:'10.12.103.100', DenyFlag:1, Direct:0, HostAddr:'192.168.218.22',LRepeat:2, LogLevel:2, MacDst:'', NetIntf:'', PortDst:'5353', PortSrc:'5353', Protocol:17, RuleName:'', RuleNum:1, amiSn:78, cldType:1, datetime:'2020-04-03 00:10:00', groupCd:2, hostSn:3, subSn:10, vpcSn:2});
db.log_hfwall.insert({AddrDst:'224.0.0.251', AddrSrc:'10.12.103.100', DenyFlag:1, Direct:0, HostAddr:'192.168.218.22',LRepeat:2, LogLevel:2, MacDst:'', NetIntf:'', PortDst:'5353', PortSrc:'5353', Protocol:17, RuleName:'', RuleNum:1, amiSn:78, cldType:1, datetime:'2020-04-03 00:15:00', groupCd:2, hostSn:3, subSn:10, vpcSn:2});
db.log_hfwall.insert({AddrDst:'224.0.0.251', AddrSrc:'10.12.103.100', DenyFlag:1, Direct:0, HostAddr:'192.168.218.22',LRepeat:3, LogLevel:2, MacDst:'', NetIntf:'', PortDst:'5353', PortSrc:'5353', Protocol:17, RuleName:'', RuleNum:1, amiSn:78, cldType:1, datetime:'2020-04-03 00:20:00', groupCd:2, hostSn:3, subSn:10, vpcSn:2});

--# 차단 이력(24시간, 날짜순)
db.log_hfwall.find(
    { hostSn: { $in: [14,1]} , datetime : { $gte: '2019-10-28', $lt: '2020-03-31'}, DenyFlag : 1}
).sort( {datetime:1}).limit(10)


-- 무결성 Collection
db.log_fileinteg.find();


db.log_hfwall.aggregate(
[
   {
      "$project": {
         "value": "$LRepeat",
         "at": {
            "$dateToString" : {
                "format" : "%Y-%m-%d",
                "date" : {
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
         "_id": "$at",
         "value": {
            "$sum": 1
         }
      }
   }
]
)


db.log_hfwall.aggregate(
[
   {
      "$group": {
         "_id": {
             "$dateToString" : {
                "format": "%Y-%m-%d",
                "date": {
                    "$dateFromString": {
                       "dateString": "$datetime"
                    }
                }
             }
         },
         "LRepeat": { "$sum": 1 }
      }
   }
]
)


db.log_hfwall.aggregate(
[
   {
      "$project": {
         "value": "$LRepeat",
         "at": "$datetime"
      }
   },
   {
      "$group": {
         "_id": "$at",
         "value": {
            "$sum": 1
         }
      }
   }
]
)

db.log_hfwall.find();
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
                  "$gte": "2020-02-01",
                  "$lte": "2020-04-07"
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
         "_id": "$at",
         "value": {
            "$sum": 1
         }
      }
   }
])

# CPU USAGE
db.cpu_usage.find({datetime: { $gte: '2020-06-15 14:00:00'}})
db.memory_usage.find({datetime: { $gte: '2020-06-15 01:00:00'}})
db.nic_usage.find({datetime: { $gte: '2020-06-02 01:00:00'}})
db.nicSum_usage.find({datetime: { $gte: '2020-05-25 13:00:00'}})

db.log_hfwall.find({datetime: { $gte: '2020-05-25 14:00:00'}})
db.log_hfwall
# CPU SUM
db.cpuSum_usage.find({datetime: { $gte: '2020-06-11 10:00:00'}})

# CPU USAGE
db.cpu_usage.find({datetime: { $gte: '2020-06-15 17:10:00', $lte: '2020-06-15 17:15:00'}, hostSn: { $in: [5]}})

# Mem
db.memory_usage.find({datetime: { $gte: '2020-06-15 17:10:00', $lte: '2020-06-15 17:15:00'}, hostSn: { $in: [5]}})

# SWAP
db.swap_usage.find({datetime: { $gte: '2020-06-15 17:10:00', $lte: '2020-06-15 17:15:00'}, hostSn: { $in: [5]}})

# disk
db.disk_usage.find({datetime: { $gte: '2020-06-15 17:10:00', $lte: '2020-06-15 17:15:00'}, hostSn: { $in: [5]}})

# Alarm
db.alarm_sysm.find({datetime: { $gte: '2020-06-12 20:00:00'}})

# Nic
db.nic_usage.find({datetime: { $gte: '2020-06-15 17:10:00', $lte: '2020-06-15 17:15:00'}, hostSn: { $in: [5]}}).sort( {LRepeat:-1})

.sort( {LRepeat:-1}).limit(10)

# log
db.log_sys.find({datetime: { $gte: '2020-06-13 13:00:00'}})

db.nic_usage.find(
    { hostSn: { $in: [12]} , datetime : { $gte: '2020-06-11 15:00:00', $lt: '2020-06-11 15:05:00'}}
)

db.nic_usage.aggregate(
[
   {
      "$match": {
         "$and": [
            {
               "hostSn": {
                  "$in": [5]
               }
            },
            {
               "datetime": {
                  "$gte": "2020-06-11 16:00:00",
                  "$lte": "2020-06-11 16:05:00"
               }
            }
         ]
      }
   },
   {
    "$project": {
         "value": "$LRepeat"
      }
   }
]
)



db.nic_usage.aggregate(
[
   {
      "$match": {
         "$and": [
            {
               "hostSn": {
                  "$in": [
                     5
                  ]
               }
            },
            {
               "datetime": {
                  "$gte": "2020-06-15 13:00:00",
                  "$lte": "2020-06-15 16:05:00"
               }
            }
         ]
      }
   },
   {
    "$project": {
         "rx_byte": 1,
         "tx_byte": 1
      }
   },
   {
      "$group": {
         "_id": "$at",
         "value": {
            "$sum": "$rx_byte"
         }
      }
   }
]
)


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
                  "$gte": "2020-06-18",
                  "$lte": "2020-06-19"
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
         "_id": "$at",
         "value": {
            "$sum": 1
         }
      }
   }
])






db.nic_usage.aggregate(
[
   {
      "$match": {
         "$and": [
            {
               "hostSn": {
                  "$in": [
                     5
                  ]
               }
            },
            {
               "datetime": {
                  "$gte": "2020-06-15 13:00:00",
                  "$lte": "2020-06-15 13:05:00"
               }
            }
         ]
      }
   },
   {
    "$project": {
         "rx_byte": 1,
         "tx_byte": 1
      }
   },
   {
      "$group": {
         "_id": "$at",
         "value": {
            "$sum": "$rx_byte"
         }
      }
   }
]
)

# 조회
db.log_hfwall.find(
    { datetime : { $gte: '2020-06-24 09:00:00'}}
)
db.log_hfwall.find(
    { hostSn: { $in: [1,5]} , datetime : { $gte: '2020-06-24 09:00:00'}}
)

# 추가
db.log_hfwall.insert(
    {
        AddrDst: '192.168.218.163',
        AddrSrc: '192.168.218.164',
        DenyFlag: 1,
        Direct: 0,
        LRepeat: 1,
        MacDst: '00:0c:29:c3:97:29',
        NetIntf: 'ens33',
        PortDst: 30000,
        PortSrc: 49929,
        Protocol: 6,
        RuleNum: 0,
        amiSn: 425,
        cldType: 1,
        datetime: '2020-06-25 09:22:00',
        groupCd: 2,
        hostSn: 5,
        subSn: 7,
        vpcSn:1
    }
)

db.log_fileinteg.find({datetime: { $gte: '2020-06-18 16:00:00'}})


# 조회
db.log_hfwall.find({datetime: { $gte: '2020-06-01 00:00:00'}})

# 전체 수정
db.log_hfwall.updateMany({hostSn : 5}, {$set: {DenyFlag: 1}});

# 삭제
db.log_hfwall.deleteMany({LogLevel: 5});


db.log_hfwall.aggregate({ "$match" : { "$and" : [{ "hostSn" : { "$in" : [1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17] } }, { "datetime" : { "$gte" : "2020-06-21 17:54:45", "$lte" : "2020-06-22 17:54:45" } }, { "DenyFlag" : 1 }] } },
 { "$project" : { "value" : "$LRepeat", "hour" : { "$hour" : { "$dateFromString" : { "dateString" : "$datetime", "format" : "%Y-%m-%d %H:%M:%S" } } }, "day" : { "$dayOfMonth" : { "$dateFromString" : { "dateString" : "$datetime", "format" : "%Y-%m-%d %H:%M:%S" } } }, "at" : { "$dateFromString" : { "dateString" : { "$dateToString" : { "format" : "%Y-%m-%d", "date" : { "$dateFromString" : { "dateString" : "$datetime" } } } } } } } },
 { "$group" : { "_id" : { "at" : "$at", "day" : "$day", "hour" : "$hour" }, "value" : { "$sum" : 1 } } })





db.log_hfwall.aggregate({ "$match" : { "$and" : [ { "hostSn" : { "$in" : [ 1 , 2 , 3 , 4 , 5 , 7 , 8 , 9 , 10 , 11 , 12 , 13 , 14 , 15 , 16 , 17]}} , { "datetime" : { "$gte" : "2020-06-21 18:49:05" , "$lte" : "2020-06-22 18:49:05"}} , { "DenyFlag" : 1}]}} , { "$project" : { "y" : "$count" , "hour" : { "$hour" : { "$dateFromString" : { "dateString" : "$datetime" , "format" : "%Y-%m-%d %H:%M:%S"}}} , "day" : { "$dayOfMonth" : { "$dateFromString" : { "dateString" : "$datetime" , "format" : "%Y-%m-%d %H:%M:%S"}}} , "x" : { "$dateFromString" : { "dateString" : { "$concat" : [ { "$substr" : [ "$datetime" , 0 , 13]} , ":00:00"]} , "format" : "%Y-%m-%d %H:%M:%S"}}}} , { "$group" : { "_id" : { "x" : "$x" , "day" : "$day" , "hour" : "$hour"} , "y" : { "$sum" : 1}}} , { "$sort" : { "_id.x" : 1 , "_id.day" : 1 , "_id.hour" : 1}})




