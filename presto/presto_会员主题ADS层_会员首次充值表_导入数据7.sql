set session hive.insert_existing_partitions_behavior = 'overwrite';
insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-10'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-10' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-10'
where rn = 1 and t.zt_id is null;









insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-11'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-11' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-11'
where rn = 1 and t.zt_id is null;











insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-12'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-12' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-12'
where rn = 1 and t.zt_id is null;










insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-13'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-13' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-13'
where rn = 1 and t.zt_id is null;










insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-14'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-14' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-14'
where rn = 1 and t.zt_id is null;












insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-15'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-15' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-15'
where rn = 1 and t.zt_id is null;






insert into  hive.ads.ads_mem_member_first_recharge_i
with t1 as (
    select
        date_format(trade_date,'%Y-%m-%d %H:%i:%s') as trade_date_time,
        date_format(trade_date,'%Y-%m-%d') as trade_date,
        trade_order_id,
        zt_id,
        store_no,
        city_id,
        amount as recharge_amount,
        row_number() over(partition by zt_id order by trade_date) as rn
    from hive.ods.ods_mem_store_amount_record_i where record_type = 2 and date_format(trade_date,'%Y-%m-%d') = '2026-08-16'
)
select
    t1.trade_date_time,
    t1.trade_date,
    t1.trade_order_id,
    t1.zt_id,
    t1.store_no,
    t1.city_id,
    t1.recharge_amount,
    '2026-08-16' as dt
from t1
    left join hive.ads.ads_mem_member_first_recharge_i t
        on t1.zt_id = t.zt_id and t1.store_no = t.store_no and t.dt < '2026-08-16'
where rn = 1 and t.zt_id is null;


