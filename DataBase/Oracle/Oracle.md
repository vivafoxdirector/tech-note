# Oracle

## ATER TABLE 
### ADD column
```
ALTER TABLE my_table ADD (
    char_col VARCHAR2(200) DEFAULT 'xxx' NOT NULL,
    number_col NUMBER(10)
);
```

### MODIFY column
```

```

### SYSDATE
```SQL
select sysdate from dual;

-- 1일 후
select sysdate + 1 from dual;

-- 10분 후
select sysdate + 10/(24*60) from dual;

-- 10초 후
select sysdate + 10/(24*60*60) from dual;

-- 12시간 후
select sysdate + 12/24 from dual;
```

# 참조사이트
- [ALTER TABLE （列の追加、変更、削除）](https://www.shift-the-oracle.com/sql/alter-table-column.html)
- [Oracleでテーブルの途中にカラム列を追加したい場合の対処方法](http://replication.hatenablog.com/entry/20140225/1393293976)