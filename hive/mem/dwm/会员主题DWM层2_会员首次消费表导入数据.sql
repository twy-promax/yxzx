-- 开启动态分区方案
-- 开启非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;
-- 开启动态分区支持(默认true)
set hive.exec.dynamic.partition=true;
-- 设置各个节点生成动态分区的最大数量: 默认为100个  (一般在生产环境中, 都需要调整更大)
set hive.exec.max.dynamic.partitions.pernode=10000;
-- 设置最大生成动态分区的数量: 默认为1000 (一般在生产环境中, 都需要调整更大)
set hive.exec.max.dynamic.partitions=100000;
-- hive一次性最大能够创建多少个文件: 默认为10w
set hive.exec.max.created.files=150000;
--hive压缩
--开启中间结果压缩
set hive.exec.compress.intermediate=true;
--开启最终结果压缩
set hive.exec.compress.output=true;
--写入时压缩生效
set hive.exec.orc.compression.strategy=COMPRESSION;



-- DWM 会员首次消费表 dwm_mem_first_buy_i

-- 注意: 以后工作中都是跑脚本,把日期改为inputdate,然后ds海豚调度器执行脚本,直接传递日期即可!

-- 1.统计日期: 2026-08-10
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-10' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-10' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-10') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;





-- 2.统计日期: 2026-08-11
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-11' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-11' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-11') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;






-- 3.统计日期: 2026-08-12
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-12' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-12' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-12') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;






-- 4.统计日期: 2026-08-13
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-13' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-13' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-13') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;




-- 5.统计日期: 2026-08-14
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-14' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-14' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-14') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;





-- 6.统计日期: 2026-08-15
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-15' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-15' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-15') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;





-- 7.统计日期: 2026-08-16
--  第一步: 计算出当天首次消费的用户   (此用户并不代表历史首次消费)
with  t1 as (
        select zt_id,
               create_time   as    trade_date_time,
               trade_date,
               week_trade_date,
               month_trade_date,
               store_no,
               real_paid_amount as   sale_amount,
               order_no,
               source_type,
               row_number() over (partition by zt_id order by create_time) rn
        from dwm.dwm_mem_sell_order_i where dt ='2026-08-16' and zt_id is not null
    ),
t2 as (
        select *
        from t1
        where rn = 1
    )
-- 最后插入数据
insert overwrite table dwm.dwm_mem_first_buy_i partition (dt)
-- 第二步: 用第一步的结果 和 截止当天之前的历史首次消费表进行关联 (left Join)
select
    t2.zt_id,
    t2.trade_date_time,
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.store_no,
    t2.sale_amount,
    t2.order_no,
    t2.source_type,
    '2026-08-16' as dt
from t2 left join
        (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-16') t3
        on t2.zt_id = t3.zt_id
-- 第三步: 判断: 如果 没有关联上, 说明在历史首次消费中并未发现有消费, 我们就认为当天的消费就是历史首次
where t3.zt_id is null;














