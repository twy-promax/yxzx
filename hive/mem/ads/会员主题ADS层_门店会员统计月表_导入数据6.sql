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




-- 以下以2026-08-10为例
with t1 as (
-- 第一部分:　基于ＤＷＳ层门店会员统计天表 获取指定天的对应这一周的数据, 对这一周进行聚合统计
select
    month_trade_date as trade_date,
    store_no,

    sum(store_sale_amount) as store_sale_amount,
    sum(store_orders_number) as store_orders_number,
    sum(register_member_num) as register_member_num,
    sum(register_recharge_num) as register_recharge_num,
    sum(rg_rc_td_num) as rg_rc_td_num,
    sum(register_trade_num) as register_trade_num,
    sum(recharge_amount) as recharge_amount,
    sum(balance_member_order_num) as balance_member_order_num,
    sum(balance_pay_amount) as balance_pay_amount,
    sum(balance_member_amount) as balance_member_amount,
    sum(member_order_num) as member_order_num,
    sum(member_amount) as member_amount,
    sum(member_first_num) as member_first_num,
    sum(member_first_order_num) as member_first_order_num,
    sum(member_first_amount) as member_first_amount,
    sum(member_nofirst_order_num) as member_nofirst_order_num,
    sum(member_nofirst_amount) as member_nofirst_amount

from dws.dws_mem_store_member_statistics_day_i
where dt >= date_sub('2026-08-10',if(dayofweek('2026-08-10') = 1,6, dayofweek('2026-08-10')-2 ))
          and dt <= date_add('2026-08-10',if(dayofweek('2026-08-10') = 1,0,-dayofweek('2026-08-10')+8))
group by month_trade_date,store_no
),

t2 as (
    select
        month_trade_date as trade_date,
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,

        register_member_num_all,
        recharge_amount_all,
        remain_member_num,
        remain_member_amount
    from dws.dws_mem_store_member_statistics_day_i where dt in (
        select
            max(dt)
        from dws.dws_mem_store_member_statistics_day_i t
        where dt >= date_sub('2026-08-10',if(dayofweek('2026-08-10') = 1,6, dayofweek('2026-08-10')-2 ))
              and dt <= date_add('2026-08-10',if(dayofweek('2026-08-10') = 1,0,-dayofweek('2026-08-10')+8))
    )
),

t3 as (
    select
        month_trade_date as trade_date,
        bind_md as store_no,

        count( DISTINCT  if(is_recharge = 1,zt_id,NULL) ) AS recharge_member_num,
        count( DISTINCT  if(is_balance_consume = 1,zt_id,NULL) ) AS balance_member_num,
        count( DISTINCT  if(is_consume = 1,zt_id,NULL) ) AS member_num,
        count( DISTINCT  if(is_first_consume = 0 and consume_times > 0,zt_id,NULL) ) AS member_nofirst_num
    from dwm.dwm_mem_member_behavior_day_i
    where dt >= date_sub('2026-08-10',if(dayofweek('2026-08-10') = 1,6, dayofweek('2026-08-10')-2 ))
                  and dt <= date_add('2026-08-10',if(dayofweek('2026-08-10') = 1,0,-dayofweek('2026-08-10')+8))
                  and bind_md is not null
    group by month_trade_date,bind_md
)

insert overwrite table ads.ads_mem_store_member_statistics_month_i partition (dt)
select
    t2.trade_date,
    t2.store_no,
    t2.store_name,
    t2.store_sale_type,
    t2.store_type_code,
    t2.city_id,
    t2.city_name,
    t2.region_code,
    t2.region_name,
    t2.is_day_clear,
    t1.store_sale_amount,
    t1.store_orders_number,
    t1.register_member_num,
    t2.register_member_num_all,
    t1.register_recharge_num,
    t1.rg_rc_td_num,
    t1.register_trade_num,
    t3.recharge_member_num,
    t1.recharge_amount,
    t2.recharge_amount_all,
    t2.remain_member_num,
    t2.remain_member_amount,
    t3.balance_member_num,
    t1.balance_member_order_num,
    t1.balance_pay_amount,
    t1.balance_member_amount,
    t3.member_num,
    t1.member_order_num,
    t1.member_amount,
    t1.member_first_num,
    t1.member_first_order_num,
    t1.member_first_amount,
    t3.member_nofirst_num,
    t1.member_nofirst_order_num,
    t1.member_nofirst_amount,
    t2.trade_date as dt
from t2 left join t1 on t2.trade_date = t1.trade_date and t2.store_no = t1.store_no
    left join  t3 on t2.trade_date = t3.trade_date and t2.store_no = t3.store_no;


