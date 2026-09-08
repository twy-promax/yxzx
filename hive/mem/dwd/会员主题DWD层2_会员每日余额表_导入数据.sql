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



-- DWD 线上会员每日余额表
-- 说明: 此表是用于记录每个会员每天(某一天)会员余额是多少
-- 先找到最大id
-- 基于最大的ID, 找到对应的余额数据
-- 目前写的这条SQL 其实已经拿到了每天每个用户的余额,但是这个数据是来源于用户余额变动表, 如果用户在某一天没有变化, 在这一天就不会有这个用户余额
with t1 as (
    select
        dt as trade_date,
        zt_id,
        max(id) as last_id
    from ods.ods_mem_store_amount_record_i
    group by dt,zt_id
),
t2 as(
    select
        t1.trade_date as start_date,
        t1.zt_id,
        t3.member_id,
        t3.store_no,
        t3.city_id,
        t3.left_store_amount,
        lead(t1.trade_date,1,'9999-99-99') over(partition by t1.zt_id order by t1.trade_date) as end_date
    from t1 inner join ods.ods_mem_store_amount_record_i t3 on t1.last_id = t3.id
)
insert overwrite table dwd.dwd_mem_balance_online_i partition (dt)
select
    start_date as trade_date,
    zt_id,
    member_id,
    2 as member_type,
    '线上会员' as member_type_name,
    store_no,
    city_id,
    left_store_amount as balance_amount,
    '2026-08-16' as dt
--   date_sub(current_date(),1) as dt
from t2
where start_date <= '2026-08-16'    and end_date > '2026-08-16'  and left_store_amount <> 0;
-- where start_date <= date_sub(current_date(),1)    and end_date > date_sub(current_date(),1)  and left_store_amount <> 0;



