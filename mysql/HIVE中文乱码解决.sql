/*
为什么建表时会有中文乱码？
    Hive 的元数据（如表名、列名、注释等）是存储在关系型数据库（如 MySQL）中的
    默认字符集不匹配：Hive本身使用UTF-8编码，但为其存储元数据的 MySQL 数据库，
其character_set_server和character_set_database参数默认是 latin1 字符集,而latin1不支持中文。
    存储过程出错：当在Hive中创建包含中文注释的表时，Hive 会尝试将UTF-8编码的中文注释存入MySQL。
但MySQL误以为收到的是latin1编码的数据，并按此处理。这个“误解”导致数据在存储时发生错误转换，最终变成乱码

为什么要在MySQL上执行？
    因为Hive的架构，Hive本身不存储元数据，它只是一个“解释器”，将SQL语句翻译成MapReduce作业，
所有元数据都存放在MySQL这样的外部关系型数据库中
*/

-- 在MySQL中执行以下操作: 修改MySQL中存储Hive元数据的那些表的字段字符集
use hive;
alter table COLUMNS_V2 modify column COMMENT varchar(256) character set utf8;
alter table TABLE_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;
alter table PARTITION_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;
alter table PARTITION_KEYS modify column PKEY_COMMENT varchar(4000) character set utf8;
alter table INDEX_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;

-- 修改后, 通过CM重启一下HIVE,然后删除表重新建表即可