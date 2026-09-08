insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-10' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;








insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-11' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;









insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-12' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;








insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-13' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;








insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-14' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;







insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-15' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;








insert into  hive.ads.ads_mem_contribution_day_i
select
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id) as zt_id
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear

    ,count(distinct case when trade_type=0 then parent_order_no end) - count(distinct case when trade_type=5 then parent_order_no end) as consume_times
    ,cast(sum(order_paid_amount) as decimal(27,2)) as consume_amount
    ,cast(sum(sale_cost) as decimal(27,2)) as consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=1 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=1 then parent_order_no end) as online_consume_times
    ,cast(sum(if(is_online_order=1,order_paid_amount,0)) as decimal(27,2)) as online_consume_amount
    ,cast(sum(if(is_online_order=1,sale_cost,0)) as decimal(27,2)) as online_consume_cost
    ,count(distinct case when trade_type=0 and is_online_order=0 then parent_order_no end) - count(distinct case when trade_type=5 and is_online_order=0 then parent_order_no end) as offline_consume_times
    ,cast(sum(if(is_online_order=0,order_paid_amount,0)) as decimal(27,2)) as offline_consume_amount
    ,cast(sum(if(is_online_order=0,sale_cost,0)) as decimal(27,2)) as offline_consume_cost

    ,trade_date as dt
from hive.dwm.dwm_sold_goods_sold_dtl_i
where dt='2026-08-16' and member_type = 1
group by
    trade_date
    ,week_trade_date
    ,month_trade_date
    ,if(zt_id is null, 139040, zt_id)
    ,store_no
    ,store_name
    ,store_sale_type
    ,store_type_code
    ,city_id
    ,city_name
    ,region_code
    ,region_name
    ,is_day_clear
;