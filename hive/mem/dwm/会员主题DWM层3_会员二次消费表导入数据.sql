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


-- DWM层:  会员二次消费表

-- 1.统计日期: 2026-08-10
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-10' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-10'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-10') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-10') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-10') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;





-- 2.统计日期: 2026-08-11
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-11' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-11'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-11') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-11') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-11') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;





-- 3.统计日期: 2026-08-12
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-12' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-12'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-12') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-12') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-12') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;


-- 4.统计日期: 2026-08-13
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-13' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-13'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-13') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-13') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-13') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;




-- 5.统计日期: 2026-08-14
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-14' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-14'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-14') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-14') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-14') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;




-- 6.统计日期: 2026-08-15
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-15' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-15'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-15') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-15') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-15') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;




-- 7.统计日期: 2026-08-16
-- 会员二次消费表
/*情况一:
首次消费表中之前的数据 left join 二次消费表中之前的数据
如果二次消费表中zt_id是null,说明没有过二次消费
也就意味着今天的首次就是历史的二次消费!!!
拿着今天的首次inner join首次消费过没有过二次消费的会员
*/
/*情况二:
今天的二次消费的数据 inner join 首次消费表今天的数据
如果关联上,说明今天的二次就是历史的二次消费
*/
with t1 as(
        select
            zt_id,
            create_time as trade_date_time,
            trade_date,
            week_trade_date,
            month_trade_date,
            store_no,
            real_paid_amount as sale_amount,
            order_no,
            source_type,
            '2026-08-16' as dt,
            row_number() over (partition by zt_id order by create_time) as rn
        from dwm.dwm_mem_sell_order_i where dt = '2026-08-16'
    ),

t2 as (
   select
      a.zt_id
   from (select * from dwm.dwm_mem_first_buy_i where trade_date < '2026-08-16') a
       left join  (select * from dwm.dwm_mem_second_buy_i where trade_date < '2026-08-16') b
           on a.zt_id = b.zt_id
   where b.zt_id is null
),
t3 as (
    select *
    from t1 where rn = 1
),
-- t4就是第一种情况的结果
t4 as (
    select t3.*
    from t2 inner join t3 on t2.zt_id = t3.zt_id
),

t5 as(
    select *
    from t1 where rn = 2
),
-- t6就是情况二的结果
t6 as(
    select t5.*
    from t5
        inner join (select * from dwm.dwm_mem_first_buy_i where dt='2026-08-16') c
             on t5.zt_id = c.zt_id
)
insert overwrite table dwm.dwm_mem_second_buy_i partition (dt)
select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t4 where zt_id is not null

union all

select
    zt_id,
    trade_date_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    store_no,
    sale_amount,
    order_no,
    source_type,
    dt
from t6 where zt_id is not null
;