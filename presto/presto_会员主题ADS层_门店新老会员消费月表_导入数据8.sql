set session hive.insert_existing_partitions_behavior = 'overwrite';
insert into hive.ads.ads_mem_store_new_old_member_month_i
with t1 as (
    select
        trade_date,
        date_format(date_add('day',-30,date '2026-08-16'),'%Y-%m-%d') as day30,
        month_trade_date,
        month_end_date
    from hive.dim.dwd_dim_date_f where trade_date = (
        select
            max(dt)
        from hive.dws.dws_mem_store_member_statistics_day_i
        where  dt >= date_format(date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16'),'%Y-%m-%d')
            and  dt < date_format(date_add('month',1,date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16')),'%Y-%m-%d')
    )
),
t2 as (
    -- 获取最近30天有过消费的新用户
    select
        temp1.trade_date,
        temp1.zt_id,
        temp1.store_no
    from hive.dwm.dwm_mem_first_buy_i temp1
      cross join t1
    where temp1.dt >= t1.day30 and temp1.dt <= t1.trade_date
),
t3 as (
    -- 获取 最近30天新用户的消费
    select
        1 as member_type,
        temp2.bind_md as store_no,
        count(distinct temp2.zt_id) as member_num,
        sum(consume_amount) as sale_amount,
        sum(consume_times) as order_num
    from hive.dwm.dwm_mem_member_behavior_day_i temp2
        join t2 on temp2.zt_id = t2.zt_id and temp2.bind_md = t2.store_no
    where dt >= date_format(date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16'),'%Y-%m-%d')
                and  dt < date_format(date_add('month',1,date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16')),'%Y-%m-%d')
                and consume_times > 0
                and bind_md is not null
    group by
        temp2.bind_md
    union all
    -- 获取 老会员
    select
        2 as member_type,
        temp2.bind_md as store_no,
        count(distinct temp2.zt_id) as member_num,
        sum(consume_amount) as sale_amount,
        sum(consume_times) as order_num
    from hive.dwm.dwm_mem_member_behavior_day_i temp2
        left join t2 on temp2.zt_id = t2.zt_id and temp2.bind_md = t2.store_no
    where dt >= date_format(date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16'),'%Y-%m-%d')
                and  dt < date_format(date_add('month',1,date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16')),'%Y-%m-%d')
                and consume_times > 0 and t2.zt_id is null
                and bind_md is not null
    group by
        temp2.bind_md
    union all
    -- 获取 全部会员
    select
        3 as member_type,
        temp2.bind_md as store_no,
        count(distinct temp2.zt_id) as member_num,
        sum(consume_amount) as sale_amount,
        sum(consume_times) as order_num
    from hive.dwm.dwm_mem_member_behavior_day_i temp2
    where dt >= date_format(date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16'),'%Y-%m-%d')
                and  dt < date_format(date_add('month',1,date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16')),'%Y-%m-%d')
                and consume_times > 0
                and bind_md is not null
    group by
        temp2.bind_md
    union all
    -- 非会员数据
    select
        4 as member_type,
        store_no,

        0 as  member_num,
        sum(real_paid_amount) as sale_amount,
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as order_num
    from hive.dwm.dwm_sell_o2o_order_i
    where dt >= date_format(date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16'),'%Y-%m-%d')
                    and  dt < date_format(date_add('month',1,date_add('day', -day(date '2026-08-16') + 1 ,date '2026-08-16')),'%Y-%m-%d')
                    and  member_type = 0
    group by store_no
)
select
    t1.month_trade_date as trade_date,
    t3.store_no,
    t4.store_name,
    t4.store_sale_type,
    t4.store_type_code,
    t4.city_id,
    t4.city_name,
    t4.region_code,
    t4.region_name,
    t4.is_day_clear,
    t3.member_type,
    t3.member_num,
    cast(t3.sale_amount as decimal(27,2)),
    t3.order_num,
    t1.month_trade_date as dt
from t3 cross join t1
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join hive.dim.dwd_dim_store_i t4 on t3.store_no = t4.store_no and t4.dt = '2026-08-18';
