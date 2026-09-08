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



-- 基于DWS层门店商品销售刻表进行上卷统计
insert overwrite table ads.ads_goods_store_goods_statistics_day_i partition (dt)
select
    -- 日期维度(天)
    trade_date,
    max(week_trade_date) as week_trade_date,
    max(month_trade_date) as month_trade_date,
    -- 门店维度
    store_no,
    max(store_name) as store_name,
    max(coalesce(store_sale_type,0)) as store_sale_type,
    max(coalesce(store_type_code,0)) as store_type_code,
    max(worker_num) as worker_num,
    max(store_area) as store_area,
    max(coalesce(city_id,-1)) as city_id,
    max(city_name) as city_name,
    max(region_code) as region_code,
    max(region_name) as region_name,
    max(coalesce(is_day_clear,0)) as is_day_clear,
    -- 商品维度
    max(coalesce(first_category_no,'-1')) as first_category_no,
    max(first_category_name) as first_category_name,
    max(coalesce(second_category_no,'-1')) as second_category_no,
    max(second_category_name) as second_category_name,
    max(coalesce(third_category_no,'-1')) as third_category_no,
    max(third_category_name) as third_category_name,
    goods_no,
    max(goods_name) as goods_name,
    max(coalesce(is_clean,0)) as is_clean,

    -- 指标计算
    sum(order_num) as order_num,
    cast(sum(sale_qty) as decimal(27,3)) as sale_qty,
    cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
    cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
    cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
    cast(sum(balance_amount) as decimal(27,2)) as balance_amount,
    cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount,
    cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount,
    sum(online_order_num)as online_order_num,
    sum(offline_order_num)as offline_order_num,
    cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty,
    cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty,
    cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount,
    cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount,
    cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost,
    cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost,
    cast(sum(loss_qty) as decimal(27,3)) as loss_qty,
    cast(sum(loss_amount) as decimal(27,2)) as loss_amount,
    cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty,
    cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount,
    cast(sum(require_qty) as decimal(27,3)) as require_qty,
    cast(sum(require_amount) as decimal(27,2)) as require_amount,
    trade_date as dt
from dws.dws_goods_store_goods_statistics_quarter_i
where store_no is not null
and goods_no is not null
and trade_date is not null
group by
    trade_date,
    store_no,
    goods_no;





-- 城市商品销售天表
insert overwrite table ads.ads_goods_city_goods_statistics_day_i partition (dt)
select
    -- 日期维度(天)
    trade_date,
    max(week_trade_date) as week_trade_date,
    max(month_trade_date) as month_trade_date,
    -- 城市维度
    store_sale_type,
    store_type_code,
    city_id,
    max(city_name) as city_name,
    max(region_code) as region_code,
    max(region_name) as region_name,
    is_day_clear,
    -- 商品维度
    max(coalesce(first_category_no,'-1')) as first_category_no,
    max(first_category_name) as first_category_name,
    max(coalesce(second_category_no,'-1')) as second_category_no,
    max(second_category_name) as second_category_name,
    max(coalesce(third_category_no,'-1')) as third_category_no,
    max(third_category_name) as third_category_name,
    goods_no,
    max(goods_name) as goods_name,
    is_clean,

    -- 指标计算
    sum(order_num) as order_num,
    cast(sum(sale_qty) as decimal(27,3)) as sale_qty,
    cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
    cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
    cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
    cast(sum(balance_amount) as decimal(27,2)) as balance_amount,
    cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount,
    cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount,
    sum(online_order_num)as online_order_num,
    sum(offline_order_num)as offline_order_num,
    cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty,
    cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty,
    cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount,
    cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount,
    cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost,
    cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost,
    cast(sum(loss_qty) as decimal(27,3)) as loss_qty,
    cast(sum(loss_amount) as decimal(27,2)) as loss_amount,
    cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty,
    cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount,
    cast(sum(require_qty) as decimal(27,3)) as require_qty,
    cast(sum(require_amount) as decimal(27,2)) as require_amount,
    trade_date as dt
from dws.dws_goods_store_goods_statistics_quarter_i
where city_id is not null
and goods_no is not null
and trade_date is not null
group by
    trade_date,
    store_sale_type,
    store_type_code,
    is_day_clear,
    city_id,
    goods_no,
    is_clean;





-- 门店第三品类销售天表
-- 注意: 与订单量相关的指标是无法直接从DWS层的结果中上卷得出的, 因为订单是跨越多个商品的, 比商品的范围更大,
-- 如果直接聚合, 会导致同一个订单会被重复计算多次
with t1 as (
    -- 第一步: 基于DWS层的结果表, 进行上卷统计, 得到除了订单量相关指标的其他指标
    select
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第三品类维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,

        -- 指标计算
        cast(sum(sale_qty) as decimal(27,3)) as sale_qty,
        cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
        cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
        cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
        cast(sum(balance_amount) as decimal(27,2)) as balance_amount,
        cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount,
        cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount,
        cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty,
        cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty,
        cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount,
        cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount,
        cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost,
        cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost,
        cast(sum(loss_qty) as decimal(27,3)) as loss_qty,
        cast(sum(loss_amount) as decimal(27,2)) as loss_amount,
        cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty,
        cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount,
        cast(sum(require_qty) as decimal(27,3)) as require_qty,
        cast(sum(require_amount) as decimal(27,2)) as require_amount,
        trade_date as dt
    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第三品类维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name
),
t2 as (
    -- 第二步: 基于DWM层 商品销售明细表 根据 门店 第三品类 天 统计 订单量 线上订单量 和 线下订单量
    select
        -- 维度:  天 + 门店 + 第三品类
        trade_date,
        store_no,
        third_category_no,

        -- 指标
        count(distinct if(trade_type = 0,parent_order_no,null)) - count( distinct if(trade_type = 5,parent_order_no,null)) as order_num,
        -- 线上线下单量
        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_order_num,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_order_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        trade_date,store_no,third_category_no
)
insert overwrite table ads.ads_category_store_third_category_statistics_day_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.store_no,
    t1.store_name,
    t1.store_sale_type,
    t1.store_type_code,
    t1.worker_num,
    t1.store_area,
    t1.city_id,
    t1.city_name,
    t1.region_code,
    t1.region_name,
    t1.is_day_clear,
    t1.first_category_no,
    t1.first_category_name,
    t1.second_category_no,
    t1.second_category_name,
    t1.third_category_no,
    t1.third_category_name,

    t2.order_num,
    t1.sale_qty,
    t1.sale_amount,
    t1.dis_amount,
    t1.sale_cost,
    t1.balance_amount,
    t1.cancel_sale_amount,
    t1.refund_sale_amount,
    t2.online_order_num,
    t2.offline_order_num,
    t1.online_sale_amount,
    t1.offline_sale_amount,
    t1.online_sale_cost,
    t1.offline_sale_cost,
    t1.loss_amount,
    t1.receipt_amount,
    t1.require_amount,

    t1.trade_date as dt
from t1 left join t2
    on t1.trade_date = t2.trade_date and t1.store_no = t2.store_no and t1.third_category_no = t2.third_category_no;




-- 门店第二品类销售天表
-- 注意: 与订单量相关的指标是无法直接从DWS层的结果中上卷得出的, 因为订单是跨越多个商品的, 比商品的范围更大, 如果直接聚合, 会导致同一个订单会被重复计算多次
with t1 as (
    -- 第一步: 基于DWS层的结果表, 进行上卷统计, 得到除了订单量相关指标的其他指标
    select
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第二品类维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,

        -- 指标计算
        cast(sum(sale_qty) as decimal(27,3)) as sale_qty,
        cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
        cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
        cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
        cast(sum(balance_amount) as decimal(27,2)) as balance_amount,
        cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount,
        cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount,
        cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty,
        cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty,
        cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount,
        cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount,
        cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost,
        cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost,
        cast(sum(loss_qty) as decimal(27,3)) as loss_qty,
        cast(sum(loss_amount) as decimal(27,2)) as loss_amount,
        cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty,
        cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount,
        cast(sum(require_qty) as decimal(27,3)) as require_qty,
        cast(sum(require_amount) as decimal(27,2)) as require_amount,
        trade_date as dt
    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第二品类维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name
),
t2 as (
    -- 第二步: 基于DWM层 商品销售明细表 根据 门店 第三品类 天 统计 订单量 线上订单量 和 线下订单量
    select
        -- 维度:  天 + 门店 + 第二品类
        trade_date,
        store_no,
        second_category_no,

        -- 指标
        count(distinct if(trade_type = 0,parent_order_no,null)) - count( distinct if(trade_type = 5,parent_order_no,null)) as order_num,
        -- 线上线下单量
        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_order_num,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_order_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        trade_date,store_no,second_category_no
)
insert overwrite table ads.ads_category_store_second_category_statistics_day_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.store_no,
    t1.store_name,
    t1.store_sale_type,
    t1.store_type_code,
    t1.worker_num,
    t1.store_area,
    t1.city_id,
    t1.city_name,
    t1.region_code,
    t1.region_name,
    t1.is_day_clear,
    t1.first_category_no,
    t1.first_category_name,
    t1.second_category_no,
    t1.second_category_name,

    t2.order_num,
    t1.sale_qty,
    t1.sale_amount,
    t1.dis_amount,
    t1.sale_cost,
    t1.balance_amount,
    t1.cancel_sale_amount,
    t1.refund_sale_amount,
    t2.online_order_num,
    t2.offline_order_num,
    t1.online_sale_amount,
    t1.offline_sale_amount,
    t1.online_sale_cost,
    t1.offline_sale_cost,
    t1.loss_amount,
    t1.receipt_amount,
    t1.require_amount,

    t1.trade_date as dt
from t1 left join t2
    on t1.trade_date = t2.trade_date and t1.store_no = t2.store_no and t1.second_category_no = t2.second_category_no;



-- 门店第一品类销售天表
-- 注意: 与订单量相关的指标是无法直接从DWS层的结果中上卷得出的, 因为订单是跨越多个商品的, 比商品的范围更大, 如果直接聚合, 会导致同一个订单会被重复计算多次
with t1 as (
    -- 第一步: 基于DWS层的结果表, 进行上卷统计, 得到除了订单量相关指标的其他指标
    select
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第一品类维度
        first_category_no,
        first_category_name,

        -- 指标计算
        cast(sum(sale_qty) as decimal(27,3)) as sale_qty,
        cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
        cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
        cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
        cast(sum(balance_amount) as decimal(27,2)) as balance_amount,
        cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount,
        cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount,
        cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty,
        cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty,
        cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount,
        cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount,
        cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost,
        cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost,
        cast(sum(loss_qty) as decimal(27,3)) as loss_qty,
        cast(sum(loss_amount) as decimal(27,2)) as loss_amount,
        cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty,
        cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount,
        cast(sum(require_qty) as decimal(27,3)) as require_qty,
        cast(sum(require_amount) as decimal(27,2)) as require_amount,
        trade_date as dt
    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第一品类维度
        first_category_no,
        first_category_name
),
t2 as (
    -- 第二步: 基于DWM层 商品销售明细表 根据 门店 第三品类 天 统计 订单量 线上订单量 和 线下订单量
    select
        -- 维度:  天 + 门店 + 第一品类
        trade_date,
        store_no,
        first_category_no,

        -- 指标
        count(distinct if(trade_type = 0,parent_order_no,null)) - count( distinct if(trade_type = 5,parent_order_no,null)) as order_num,
        -- 线上线下单量
        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_order_num,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_order_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        trade_date,store_no,first_category_no
)
insert overwrite table ads.ads_category_store_first_category_statistics_day_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.store_no,
    t1.store_name,
    t1.store_sale_type,
    t1.store_type_code,
    t1.worker_num,
    t1.store_area,
    t1.city_id,
    t1.city_name,
    t1.region_code,
    t1.region_name,
    t1.is_day_clear,
    t1.first_category_no,
    t1.first_category_name,

    t2.order_num,
    t1.sale_qty,
    t1.sale_amount,
    t1.dis_amount,
    t1.sale_cost,
    t1.balance_amount,
    t1.cancel_sale_amount,
    t1.refund_sale_amount,
    t2.online_order_num,
    t2.offline_order_num,
    t1.online_sale_amount,
    t1.offline_sale_amount,
    t1.online_sale_cost,
    t1.offline_sale_cost,
    t1.loss_amount,
    t1.receipt_amount,
    t1.require_amount,

    t1.trade_date as dt
from t1 left join t2
    on t1.trade_date = t2.trade_date and t1.store_no = t2.store_no and t1.first_category_no = t2.first_category_no;



-- 门店经营分析天表
-- 第一步从dws刻表上卷到天(除了线上/线下会员数)
with t1 as (select
                -- 日期维度
                date_format(trade_date, 'yyyy-MM-dd') as  trade_date,
                week_trade_date,
                month_trade_date,
                -- 门店维度
                store_no,
                store_name,
                store_sale_type,
                store_type_code,
                worker_num,
                store_area,
                city_id,
                city_name,
                region_code,
                region_name,
                is_day_clear,
                -- 指标
                sum(order_num)                                   as order_num,
                cast(sum(sale_qty) as decimal(27, 3))            as sale_qty,
                cast(sum(sale_amount) as decimal(27, 2))         as sale_amount,
                cast(sum(dis_amount) as decimal(27, 2))          as dis_amount,
                cast(sum(sale_cost) as decimal(27, 2))           as sale_cost,
                cast(sum(balance_amount) as decimal(27, 2))      as balance_amount,
                cast(sum(cancel_sale_amount) as decimal(27, 2))  as cancel_sale_amount,
                cast(sum(refund_sale_amount) as decimal(27, 2))  as refund_sale_amount,
                sum(online_order_num)                            as online_order_num,
                sum(offline_order_num)                           as offline_order_num,
                cast(sum(online_sale_amount) as decimal(27, 2))  as online_sale_amount,
                cast(sum(offline_sale_amount) as decimal(27, 2)) as offline_sale_amount,
                cast(sum(online_sale_cost) as decimal(27, 2))    as online_sale_cost,
                cast(sum(offline_sale_cost) as decimal(27, 2))   as offline_sale_cost,
                cast(sum(loss_amount) as decimal(27, 2))         as loss_amount,
                cast(sum(receipt_amount) as decimal(27, 2))      as receipt_amount,
                cast(sum(require_amount) as decimal(27, 2))      as require_amount,
                sum(ol_mem_order_num)                            as ol_mem_order_num,
                sum(vip_mem_order_num)                           as vip_mem_order_num,
                cast(sum(ol_mem_sale_amount) as decimal(27, 2))  as ol_mem_sale_amount,
                cast(sum(vip_mem_sale_amount) as decimal(27, 2)) as vip_mem_sale_amount,
                cast(sum(ol_mem_sale_cost) as decimal(27, 2))    as ol_mem_sale_cost,
                cast(sum(vip_mem_sale_cost) as decimal(27, 2))   as vip_mem_sale_cost,
                cast(sum(balance_sale_amount) as decimal(27, 2)) as balance_sale_amount,
                sum(balance_order_num)                           as balance_order_num,
                cast(sum(balance_sale_cost) as decimal(27, 2))   as balance_sale_cost,
                sum(balance_people_num)                          as balance_people_num,
                date_format(trade_date, 'yyyy-MM-dd')            as dt

            from dws.dws_store_manage_statistics_quarter_i
            group by
                -- 日期维度
                trade_date,
                week_trade_date,
                month_trade_date,
                -- 门店维度
                store_no,
                store_name,
                store_sale_type,
                store_type_code,
                worker_num,
                store_area,
                city_id,
                city_name,
                region_code,
                region_name,
                is_day_clear
),
  -- 第二步从dwm层重新计算线上/线下会员数
t2 as(
    select
        -- 时间维度
        date_format(trade_date,'yyyy-MM-dd') as trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        region_code,
        city_name,
        region_name,
        is_day_clear,
        count(distinct if(member_type = 1 and trade_type = 0, member_id,null)) as ol_mem_trade_num,
        count(distinct if(member_type = 2 and trade_type = 0, member_id,null)) as vip_mem_trade_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        region_code,
        city_name,
        region_name,
        is_day_clear
)

insert overwrite table ads.ads_store_manage_statistics_day_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.store_no,
    t1.store_name,
    t1.store_sale_type,
    t1.store_type_code,
    t1.worker_num,
    t1.store_area,
    t1.city_id,
    t1.city_name,
    t1.region_code,
    t1.region_name,
    t1.is_day_clear,
    t1.order_num,
    t1.sale_qty,
    t1.sale_amount,
    t1.dis_amount,
    t1.sale_cost,
    t1.balance_amount,
    t1.cancel_sale_amount,
    t1.refund_sale_amount,
    t1.online_order_num,
    t1.offline_order_num,
    t1.online_sale_amount,
    t1.offline_sale_amount,
    t1.online_sale_cost,
    t1.offline_sale_cost,
    t1.loss_amount,
    t1.receipt_amount,
    t1.require_amount,
    t1.ol_mem_order_num,
    t1.vip_mem_order_num,
    t1.ol_mem_sale_amount,
    t1.vip_mem_sale_amount,
    t1.ol_mem_sale_cost,
    t1.vip_mem_sale_cost,
    t2.ol_mem_trade_num,
    t2.vip_mem_trade_num,
    t1.balance_sale_amount,
    t1.balance_order_num,
    t1.balance_sale_cost,
    t1.balance_people_num,
    t1.dt
from t1 left join t2 on t1.trade_date = t2.trade_date and t1.store_no = t2.store_no;





-- 城市经营分析天表
-- 第一步从dws刻表上卷到天(除了线上/线下会员数)
with t1 as (select
                -- 日期维度
                date_format(trade_date, 'yyyy-MM-dd') as  trade_date,
                week_trade_date,
                month_trade_date,
                -- 门店维度
                store_sale_type,
                store_type_code,
                city_id,
                city_name,
                region_code,
                region_name,
                is_day_clear,
                -- 指标
                sum(order_num)                                   as order_num,
                cast(sum(sale_qty) as decimal(27, 3))            as sale_qty,
                cast(sum(sale_amount) as decimal(27, 2))         as sale_amount,
                cast(sum(dis_amount) as decimal(27, 2))          as dis_amount,
                cast(sum(sale_cost) as decimal(27, 2))           as sale_cost,
                cast(sum(balance_amount) as decimal(27, 2))      as balance_amount,
                cast(sum(cancel_sale_amount) as decimal(27, 2))  as cancel_sale_amount,
                cast(sum(refund_sale_amount) as decimal(27, 2))  as refund_sale_amount,
                sum(online_order_num)                            as online_order_num,
                sum(offline_order_num)                           as offline_order_num,
                cast(sum(online_sale_amount) as decimal(27, 2))  as online_sale_amount,
                cast(sum(offline_sale_amount) as decimal(27, 2)) as offline_sale_amount,
                cast(sum(online_sale_cost) as decimal(27, 2))    as online_sale_cost,
                cast(sum(offline_sale_cost) as decimal(27, 2))   as offline_sale_cost,
                cast(sum(loss_amount) as decimal(27, 2))         as loss_amount,
                cast(sum(receipt_amount) as decimal(27, 2))      as receipt_amount,
                cast(sum(require_amount) as decimal(27, 2))      as require_amount,
                sum(ol_mem_order_num)                            as ol_mem_order_num,
                sum(vip_mem_order_num)                           as vip_mem_order_num,
                cast(sum(ol_mem_sale_amount) as decimal(27, 2))  as ol_mem_sale_amount,
                cast(sum(vip_mem_sale_amount) as decimal(27, 2)) as vip_mem_sale_amount,
                cast(sum(ol_mem_sale_cost) as decimal(27, 2))    as ol_mem_sale_cost,
                cast(sum(vip_mem_sale_cost) as decimal(27, 2))   as vip_mem_sale_cost,
                cast(sum(balance_sale_amount) as decimal(27, 2)) as balance_sale_amount,
                sum(balance_order_num)                           as balance_order_num,
                cast(sum(balance_sale_cost) as decimal(27, 2))   as balance_sale_cost,
                sum(balance_people_num)                          as balance_people_num,
                date_format(trade_date, 'yyyy-MM-dd')            as dt

            from dws.dws_store_manage_statistics_quarter_i
            group by
                -- 日期维度
                trade_date,
                week_trade_date,
                month_trade_date,
                -- 门店维度
                store_sale_type,
                store_type_code,
                city_id,
                city_name,
                region_code,
                region_name,
                is_day_clear
),
  -- 第二步从dwm层重新计算线上/线下会员数
t2 as(
    select
        -- 时间维度
        date_format(trade_date,'yyyy-MM-dd') as trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        city_id,
        region_code,
        city_name,
        region_name,
        is_day_clear,
        count(distinct if(member_type = 1 and trade_type = 0, member_id,null)) as ol_mem_trade_num,
        count(distinct if(member_type = 2 and trade_type = 0, member_id,null)) as vip_mem_trade_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        city_id,
        region_code,
        city_name,
        region_name,
        is_day_clear
)

insert overwrite table ads.ads_store_city_manage_statistics_day_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.store_sale_type,
    t1.store_type_code,
    t1.city_id,
    t1.city_name,
    t1.region_code,
    t1.region_name,
    t1.is_day_clear,
    t1.order_num,
    t1.sale_qty,
    t1.sale_amount,
    t1.dis_amount,
    t1.sale_cost,
    t1.balance_amount,
    t1.cancel_sale_amount,
    t1.refund_sale_amount,
    t1.online_order_num,
    t1.offline_order_num,
    t1.online_sale_amount,
    t1.offline_sale_amount,
    t1.online_sale_cost,
    t1.offline_sale_cost,
    t1.loss_amount,
    t1.receipt_amount,
    t1.require_amount,
    t1.ol_mem_order_num,
    t1.vip_mem_order_num,
    t1.ol_mem_sale_amount,
    t1.vip_mem_sale_amount,
    t1.ol_mem_sale_cost,
    t1.vip_mem_sale_cost,
    t2.ol_mem_trade_num,
    t2.vip_mem_trade_num,
    t1.balance_sale_amount,
    t1.balance_order_num,
    t1.balance_sale_cost,
    t1.balance_people_num,
    t1.dt
from t1 left join t2 on t1.trade_date = t2.trade_date and t1.city_id = t2.city_id;






-- 门店销售渠道分析天表
insert overwrite table ads.ads_marketing_store_source_type_day_i partition (dt)
select
    -- 日期维度
    trade_date,
    week_trade_date,
    month_trade_date,
    -- 门店维度
    store_no,
    store_name,
    store_sale_type,
    store_type_code,
    worker_num,
    store_area,
    city_id,
    city_name,
    region_code,
    region_name,
    is_day_clear,
    -- 销售渠道
    source_type,
    source_type_name,

    -- 指标
    count(distinct if(trade_type = 0,parent_order_no,null)) - count(distinct if(trade_type = 5,parent_order_no,null)) as order_num,
    count(distinct if(trade_type = 2,parent_order_no,null) ) as refund_order_num,
    count(distinct if(trade_type = 5 and is_cancel = 1,parent_order_no,null) ) as cancel_order_num,
    cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
    cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
    cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
    trade_date as dt
from dwm.dwm_sold_goods_sold_dtl_i
group by
    -- 日期维度
    trade_date,
    week_trade_date,
    month_trade_date,
    -- 门店维度
    store_no,
    store_name,
    store_sale_type,
    store_type_code,
    worker_num,
    store_area,
    city_id,
    city_name,
    region_code,
    region_name,
    is_day_clear,
    -- 销售渠道
    source_type,
    source_type_name;



-- 门店第一品类日清分析天表
-- 注意: 与订单量相关的指标是无法直接从DWS层的结果中上卷得出的,
-- 因为订单是跨越多个商品的, 比商品的范围更大, 如果直接聚合, 会导致同一个订单会被重复计算多次
with t1 as (
    -- 第一步: 基于DWS层的结果表, 进行上卷统计, 得到除了订单量相关指标的其他指标
    select
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第一品类维度
        first_category_no,
        first_category_name,
        -- 日清
        is_clean,

        -- 指标计算
        cast(sum(sale_qty) as decimal(27,3)) as sale_qty,
        cast(sum(sale_amount) as decimal(27,2)) as sale_amount,
        cast(sum(dis_amount) as decimal(27,2)) as dis_amount,
        cast(sum(sale_cost) as decimal(27,2)) as sale_cost,
        cast(sum(balance_amount) as decimal(27,2)) as balance_amount,
        cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount,
        cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount,
        cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty,
        cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty,
        cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount,
        cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount,
        cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost,
        cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost,
        cast(sum(loss_qty) as decimal(27,3)) as loss_qty,
        cast(sum(loss_amount) as decimal(27,2)) as loss_amount,
        cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty,
        cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount,
        cast(sum(require_qty) as decimal(27,3)) as require_qty,
        cast(sum(require_amount) as decimal(27,2)) as require_amount,
        trade_date as dt
    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 日期维度(天)
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,
        -- 第一品类维度
        first_category_no,
        first_category_name,
       -- 日清
       is_clean
),
t2 as (
    -- 第二步: 基于DWM层 商品销售明细表 根据 门店 第三品类 天 统计 订单量 线上订单量 和 线下订单量
    select
        -- 维度:  天 + 门店 + 第一品类 + 日清
        trade_date,
        store_no,
        first_category_no,
        is_clean,

        -- 指标
        count(distinct goods_no) as sku_num,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count( distinct if(trade_type = 5,parent_order_no,null)) as order_num,
        -- 线上线下单量
        count(distinct if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_order_num,
        count(distinct if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(distinct if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_order_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        trade_date,store_no,first_category_no,is_clean
)
insert overwrite table ads.ads_marketing_store_category_clean_data_day_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.store_no,
    t1.store_name,
    t1.store_sale_type,
    t1.store_type_code,
    t1.worker_num,
    t1.store_area,
    t1.city_id,
    t1.city_name,
    t1.region_code,
    t1.region_name,
    t1.is_day_clear,
    t1.first_category_no,
    t1.first_category_name,
    t1.is_clean,
    t2.sku_num,
    t2.order_num,
    t1.sale_qty,
    t1.sale_amount,
    t1.dis_amount,
    t1.sale_cost,
    t2.online_order_num,
    t2.offline_order_num,
    t1.online_sale_amount,
    t1.offline_sale_amount,
    t1.online_sale_cost,
    t1.offline_sale_cost,
    t1.loss_amount,
    t1.receipt_amount,
    t1.require_amount,

    t1.trade_date as dt
from t1 left join t2
    on t1.trade_date = t2.trade_date and t1.store_no = t2.store_no
           and t1.first_category_no = t2.first_category_no and t1.is_clean = t2.is_clean;



-- 门店日清商品的分析天表
-- 需要计算, 全部商品的各个指标以及, 日清和非日清的商品指标
-- 第一步: 计算日清商品和非日清商品各个门店分析情况
with t1 as (
    select
        -- 日期维度
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_name,
        region_code,
        is_day_clear,
        -- 是否日清商品
        is_clean,

        sum(sale_amount) as sale_amount,
        sum(if(quarters <=74,sale_amount,0)) as sale_amount_pre,
        sum(if(quarters >74,sale_amount,0)) as sale_amount_after,

        sum(dis_amount) as dis_amount,
        sum(if(quarters <=74,dis_amount,0)) as dis_amount_pre,
        sum(if(quarters >74,dis_amount,0)) as dis_amount_after,

        sum(sale_cost) as sale_cost,
        sum(if(quarters <=74,sale_cost,0)) as sale_cost_pre,
        sum(if(quarters >74,sale_cost,0)) as sale_cost_after,

        sum(loss_amount) as loss_amount,
        sum(if(quarters <=74,loss_amount,0)) as loss_amount_pre,
        sum(if(quarters >74,loss_amount,0)) as loss_amount_after,

        sum(receipt_amount) as receipt_amount,
        sum(require_amount) as require_amount

    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 日期维度
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_name,
        region_code,
        is_day_clear,
        -- 是否日清商品
        is_clean
),
t2 as (
    select
        -- 维度
        trade_date,store_no,is_clean,
        -- 指标
        count(distinct goods_no) as sku_num,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count( distinct if(trade_type = 5,parent_order_no,null)) as order_num,
        count(distinct if(trade_type = 0 and quarters <=74 ,parent_order_no,null)) - count( distinct if(trade_type = 5 and quarters <=74 ,parent_order_no,null)) as order_num_pre,
        count(distinct if(trade_type = 0 and quarters >74 ,parent_order_no,null)) - count( distinct if(trade_type = 5 and quarters >74,parent_order_no,null)) as order_num_after
    from dwm.dwm_sold_goods_sold_dtl_i
    group by trade_date,store_no,is_clean
),
t3 as (
    select
        -- 日期维度
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_name,
        region_code,
        is_day_clear,
        -- 是否日清商品
        -1 as is_clean,

        sum(sale_amount) as sale_amount,
        sum(if(quarters <=74,sale_amount,0)) as sale_amount_pre,
        sum(if(quarters >74,sale_amount,0)) as sale_amount_after,

        sum(dis_amount) as dis_amount,
        sum(if(quarters <=74,dis_amount,0)) as dis_amount_pre,
        sum(if(quarters >74,dis_amount,0)) as dis_amount_after,

        sum(sale_cost) as sale_cost,
        sum(if(quarters <=74,sale_cost,0)) as sale_cost_pre,
        sum(if(quarters >74,sale_cost,0)) as sale_cost_after,

        sum(loss_amount) as loss_amount,
        sum(if(quarters <=74,loss_amount,0)) as loss_amount_pre,
        sum(if(quarters >74,loss_amount,0)) as loss_amount_after,

        sum(receipt_amount) as receipt_amount,
        sum(require_amount) as require_amount

    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 日期维度
        trade_date,
        week_trade_date,
        month_trade_date,
        -- 门店维度
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        worker_num,
        store_area,
        city_id,
        city_name,
        region_name,
        region_code,
        is_day_clear
),
t4 as (
    select
        -- 维度
        trade_date,store_no,
        -- 指标
        count(distinct goods_no) as sku_num,
        count(distinct if(trade_type = 0,parent_order_no,null)) - count( distinct if(trade_type = 5,parent_order_no,null)) as order_num,
        count(distinct if(trade_type = 0 and quarters <=74 ,parent_order_no,null)) - count( distinct if(trade_type = 5 and quarters <=74 ,parent_order_no,null)) as order_num_pre,
        count(distinct if(trade_type = 0 and quarters >74 ,parent_order_no,null)) - count( distinct if(trade_type = 5 and quarters >74,parent_order_no,null)) as order_num_after
    from dwm.dwm_sold_goods_sold_dtl_i
    group by trade_date,store_no
)
insert  overwrite table ads.ads_marketing_store_clean_data_day_i partition (dt)
select
        -- 日期维度
        t1.trade_date,
        t1.week_trade_date,
        t1.month_trade_date,
        -- 门店维度
        t1.store_no,
        t1.store_name,
        t1.store_sale_type,
        t1.store_type_code,
        t1.worker_num,
        t1.store_area,
        t1.city_id,
        t1.city_name,
        t1.region_name,
        t1.region_code,
        t1.is_day_clear,
        -- 是否日清商品
        t1.is_clean,
        t2.sku_num,
        t2.order_num,
        t2.order_num_pre,
        t2.order_num_after,
        t1.sale_amount,
        t1.sale_amount_pre,
        t1.sale_amount_after,
        t1.dis_amount,
        t1.dis_amount_pre,
        t1.dis_amount_after,
        t1.sale_cost,
        t1.sale_cost_pre,
        t1.sale_cost_after,
        (t1.sale_amount - t1.sale_cost) as sale_profit,
        (t1.sale_amount_pre - t1.sale_cost_pre) as sale_profit_pre,
        (t1.sale_amount_after - t1.sale_cost_after) as sale_profit_after,
        t1.loss_amount,
        t1.loss_amount_pre,
        t1.loss_amount_after,
        t1.receipt_amount,
        t1.require_amount,
        t1.trade_date as  dt
from t1 left join t2 on t1.trade_date = t2.trade_date and t1.store_no = t2.store_no and t1.is_clean = t2.is_clean

union all

select
        -- 日期维度
        t3.trade_date,
        t3.week_trade_date,
        t3.month_trade_date,
        -- 门店维度
        t3.store_no,
        t3.store_name,
        t3.store_sale_type,
        t3.store_type_code,
        t3.worker_num,
        t3.store_area,
        t3.city_id,
        t3.city_name,
        t3.region_name,
        t3.region_code,
        t3.is_day_clear,
        -- 是否日清商品
        t3.is_clean,
        -- 指标
        t4.sku_num,
        t4.order_num,
        t4.order_num_pre,
        t4.order_num_after,
        t3.sale_amount,
        t3.sale_amount_pre,
        t3.sale_amount_after,
        t3.dis_amount,
        t3.dis_amount_pre,
        t3.dis_amount_after,
        t3.sale_cost,
        t3.sale_cost_pre,
        t3.sale_cost_after,
        (t3.sale_amount - t3.sale_cost) as sale_profit,
        (t3.sale_amount_pre - t3.sale_cost_pre) as sale_profit_pre,
        (t3.sale_amount_after - t3.sale_cost_after) as sale_profit_after,
        t3.loss_amount,
        t3.loss_amount_pre,
        t3.loss_amount_after,
        t3.receipt_amount,
        t3.require_amount,
        t3.trade_date as  dt
from t3 left join t4 on t3.trade_date = t4.trade_date and t3.store_no = t4.store_no;




















