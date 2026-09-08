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



-- DWM: 会员行为数据表
--  统计时间: 2026-08-10
with
 t1 as(
    select
        '2026-08-10' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-10',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-10' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-10' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-10' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-10' and record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-10' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-10' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-10' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-10'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-10' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-10' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';





--  统计时间: 2026-08-11
with
 t1 as(
    select
        '2026-08-11' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-11',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-11' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-11' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-11' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-11' and record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-11' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-11' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-11' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-11'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-11' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-11' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';






--  统计时间: 2026-08-12
with
 t1 as(
    select
        '2026-08-12' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-12',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-12' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-12' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-12' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-12' and record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-12' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-12' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-12' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-12'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-12' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-12' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';





--  统计时间: 2026-08-13
with
 t1 as(
    select
        '2026-08-13' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-13',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-13' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-13' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-13' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-13' and record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-13' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-13' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-13' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-13'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-13' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-13' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';




--  统计时间: 2026-08-14
with
 t1 as(
    select
        '2026-08-14' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-14',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-14' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-14' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-14' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-14' and  record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-14' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-14' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-14' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-14'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-14' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-14' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';





--  统计时间: 2026-08-15
with
 t1 as(
    select
        '2026-08-15' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-15',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-15' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-15' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-15' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-15' and   record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-15' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-15' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-15' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-15'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-15' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-15' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';






--  统计时间: 2026-08-16
with
 t1 as(
    select
        '2026-08-16' as trade_date,
        zt_id,
        if(date_format(reg_time,'yyyy-MM-dd')='2026-08-16',1,0) as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-16' as dt
    -- 注意: 此处第一次导入:  start_date 更改为 <=
    -- 但是第二次及其后续, 直接用 = 获取当天的日期注册数据
    from dwd.dwd_mem_member_union_i where start_date<='2026-08-16' and end_date = '9999-99-99'
 ),
 t2 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        1 as is_recharge,
        times as recharge_times,
        change_amount as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-16' as dt
     from dwd.dwd_mem_balance_change_i where dt='2026-08-16' and record_type = 2
 ),
 t3 as(
    select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,

        1 as is_consume,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as consume_times,
        sum(real_paid_amount) as consume_amount,

        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,

        max(if(is_balance_consume = 1,1,0)) as is_balance_consume,
        count(distinct if(trade_type = 0 and is_balance_consume = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_balance_consume = 1,parent_order_no,null)) as balance_consume_times,
        sum(coalesce(balance_amount,0)) as balance_pay_amount,
        sum(if(is_balance_consume=1,real_paid_amount,0)) as balance_consume_amount,

        max(if(point_amount!=0,1,0)) as is_point_consume,
        count(distinct if(trade_type = 0 and point_amount!=0,parent_order_no,null)) - count(distinct if(trade_type = 5 and point_amount!=0,parent_order_no,null)) as point_consume_times,
        sum(coalesce(point_amount,0)) as point_pay_amount,
        sum(if(point_amount!=0,real_paid_amount,0)) as point_consume_amount,

        0 as point_add,
        0 as point_reduce,
        0 as point_change,

        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_consume_times,
        sum(if(is_online_order = 1,real_paid_amount,0)) as online_consume_amount,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_consume_times,
        sum(if(is_online_order = 0,real_paid_amount,0))  as offline_consume_amount,
        '2026-08-16' as dt
    from dwm.dwm_mem_sell_order_i where dt='2026-08-16' and zt_id is not null
    group by trade_date, zt_id
 ),
 t4 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,

        1 as is_first_consume,
        store_no as first_consume_store,
        sale_amount as first_consume_amount,

        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,
        0 as point_add,
        0 as point_reduce,
        0 as point_change,
        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-16' as dt
     from dwm.dwm_mem_first_buy_i where dt='2026-08-16'
 ),
 t5 as(
     select
        trade_date,
        zt_id,
        0 as is_register,
        0 as is_recharge,
        0 as recharge_times,
        0 as recharge_amount,
        0 as is_consume,
        0 as consume_times,
        0 as consume_amount,
        0 as is_first_consume,
        '' as first_consume_store,
        0 as first_consume_amount,
        0 as is_balance_consume,
        0 as balance_consume_times,
        0 as balance_pay_amount,
        0 as balance_consume_amount,
        0 as is_point_consume,
        0 as point_consume_times,
        0 as point_pay_amount,
        0 as point_consume_amount,

        point_add,
        point_reduce,
        point_change,

        0 as online_consume_times,
        0 as online_consume_amount,
        0 as offline_consume_times,
        0 as offline_consume_amount,
        '2026-08-16' as dt
     from dwd.dwd_mem_member_point_change_i where dt='2026-08-16' and occupy_subject_id = 0
 ),
 t6 as(
     select * from t1
     union all
     select * from t2
     union all
     select * from t3
     union all
     select * from t4
     union all
     select * from t5
 ),
 t7 as (
    select
        trade_date,
        zt_id,
        max(is_register) as is_register,

        max(is_recharge) as is_recharge,
        sum(recharge_times) as recharge_times,
        sum(recharge_amount) as recharge_amount,

        max(is_consume) as is_consume,
        sum(consume_times) as consume_times,
        sum(consume_amount) as consume_amount,

        max(is_first_consume) as is_first_consume,
        max(first_consume_store) as first_consume_store,
        sum(first_consume_amount) as first_consume_amount,

        max(is_balance_consume) as is_balance_consume,
        sum(balance_consume_times) as balance_consume_times,
        sum(balance_pay_amount) as balance_pay_amount,
        sum(balance_consume_amount) as balance_consume_amount,

        max(is_point_consume) as is_point_consume,
        sum(point_consume_times) as point_consume_times,
        sum(point_pay_amount) as point_pay_amount,
        sum(point_consume_amount) as point_consume_amount,

        sum(point_add) as point_add,
        sum(point_reduce) as point_reduce,
        sum(point_change) as point_change,

        sum(online_consume_times) as online_consume_times,
        sum(online_consume_amount) as online_consume_amount,
        sum(offline_consume_times) as offline_consume_times,
        sum(offline_consume_amount) as offline_consume_amount,
        dt
    from t6
    group by trade_date,zt_id,dt
)
insert overwrite table dwm.dwm_mem_member_behavior_day_i partition (dt)
select
    t7.trade_date,
    d.week_trade_date,
    d.month_trade_date,
    t7.zt_id,
    if(m.bind_md is null or m.bind_md = '',m.reg_md,m.bind_md) as bind_md,
    m.reg_md,
    m.reg_time,
    t7.is_register,
    t7.is_recharge,
    t7.recharge_times,
    t7.recharge_amount,
    t7.is_consume,
    t7.consume_times,
    t7.consume_amount,
    t7.is_first_consume,
    t7.first_consume_store,
    t7.first_consume_amount,
    t7.is_balance_consume,
    t7.balance_consume_times,
    t7.balance_pay_amount,
    t7.balance_consume_amount,
    t7.is_point_consume,
    t7.point_consume_times,
    t7.point_pay_amount,
    t7.point_consume_amount,
    t7.point_add,
    t7.point_reduce,
    t7.point_change,
    t7.online_consume_times,
    t7.online_consume_amount,
    t7.offline_consume_times,
    t7.offline_consume_amount,
    t7.dt
from t7 left join dim.dwd_dim_date_f d on t7.trade_date = d.trade_date
left join dwd.dwd_mem_member_union_i m on t7.zt_id = m.zt_id and m.end_date = '9999-99-99';