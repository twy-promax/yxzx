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


-- 1.门店商品分析刻表: dws_goods_store_goods_statistics_quarter_i
-- DWS层: 门店 商品的分析刻表
-- 第一步: 先计算销售相关的数据
-- 第二步 计算 损耗数量 和 损耗金额
-- 第三步: 收货数量 和 收货金额
-- 第四步: 要货数量 和 要货金额
-- 第五步: 进行合并  FULL JOIN  / Union all 均可以
with t1 as (
    -- 第一步: 先计算销售相关的数据
    select
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean,
        -- 指标
        -- 销售单量/数量/金额
        -- 先统计正常交易订单的数量 ,再统计取消交易订单的数量,最后取差值就是最终销售单量
        count( if(trade_type = 0,parent_order_no,null)) - count(if(trade_type = 5,parent_order_no,null)) as order_num,
        sum(sale_qty) as sale_qty,
        sum(sale_amount) as sale_amount,
        -- 折扣金额
        sum(dis_amount) as dis_amount,
        -- 销售成本
        sum(sale_cost) as sale_cost,
        -- 余额支付金额
        -- 只统计余额支付的金额
        sum(if(is_balance_consume = 1,balance_amount,0)) as balance_amount,
        -- 取消商品销售金额
        sum(if(trade_type = 5,sale_amount,0)) as cancel_sale_amount,
        -- -- 退款商品销售金额
        sum(if(trade_type = 2,sale_amount,0)) as refund_sale_amount,
        -- -- 线上线下单量
        count( if(trade_type = 0 and is_online_order = 1,parent_order_no,null)) - count(if(trade_type = 5 and is_online_order = 1,parent_order_no,null)) as online_order_num,
        count( if(trade_type = 0 and is_online_order = 0,parent_order_no,null)) - count(if(trade_type = 5 and is_online_order = 0,parent_order_no,null)) as offline_order_num,
        -- -- 线上线下销售数量
        sum(if(is_online_order = 1,sale_qty,0)) as online_sale_qty,
        sum(if(is_online_order = 0,sale_qty,0))  as offline_sale_qty,
        -- -- 线上线下销售金额
        sum(if(is_online_order = 1,sale_amount,0)) as online_sale_amount,
        sum(if(is_online_order = 0,sale_amount,0))  as offline_sale_amount,
        -- 线上线下销售成本
        sum(if(is_online_order = 1,sale_cost,0)) as online_sale_cost,
        sum(if(is_online_order = 0,sale_cost,0))  as offline_sale_cost,
        0 as loss_qty,
        0 as loss_amount,
        0 as receipt_qty,
        0 as receipt_amount,
        0 as require_qty,
        0 as require_amount
    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean
    union all
    -- 第二步 计算 损耗数量 和 损耗金额
    select
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean,
        0 as order_num,
        0 as sale_qty,
        0 as sale_amount,
        0 as dis_amount,
        0 as sale_cost,
        0 as balance_amount,
        0 as cancel_sale_amount,
        0 as refund_sale_amount,
        0 as online_order_num,
        0 as offline_order_num,
        0 as online_sale_qty,
        0 as offline_sale_qty,
        0 as online_sale_amount,
        0 as offline_sale_amount,
        0 as online_sale_cost,
        0 as offline_sale_cost,
        sum(loss_qty) as loss_qty,
        sum(loss_amount) as loss_amount,
        0 as receipt_qty,
        0 as receipt_amount,
        0 as require_qty,
        0 as require_amount
    from dwm.dwm_stock_store_goods_loss_quarter_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean
    union all

    -- 第三步: 收货数量 和 收货金额
    select
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean,
        0 as order_num,
        0 as sale_qty,
        0 as sale_amount,
        0 as dis_amount,
        0 as sale_cost,
        0 as balance_amount,
        0 as cancel_sale_amount,
        0 as refund_sale_amount,
        0 as online_order_num,
        0 as offline_order_num,
        0 as online_sale_qty,
        0 as offline_sale_qty,
        0 as online_sale_amount,
        0 as offline_sale_amount,
        0 as online_sale_cost,
        0 as offline_sale_cost,
        0 as loss_qty,
        0 as loss_amount,
        sum(receipt_qty) as receipt_qty,
        sum(receipt_amount) as receipt_amount,
        0 as require_qty,
        0 as require_amount
    from dwm.dwm_order_store_goods_receipt_quarter_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean
    union all
    -- 第四步: 要货数量 和 要货金额
    select
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean,
        0 as order_num,
        0 as sale_qty,
        0 as sale_amount,
        0 as dis_amount,
        0 as sale_cost,
        0 as balance_amount,
        0 as cancel_sale_amount,
        0 as refund_sale_amount,
        0 as online_order_num,
        0 as offline_order_num,
        0 as online_sale_qty,
        0 as offline_sale_qty,
        0 as online_sale_amount,
        0 as offline_sale_amount,
        0 as online_sale_cost,
        0 as offline_sale_cost,
        0 as loss_qty,
        0 as loss_amount,
        0 as receipt_qty,
        0 as receipt_amount,
        sum(require_qty) as require_qty,
        sum(require_amount) as require_amount
    from dwm.dwm_order_store_goods_require_quarter_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        -- 商品维度
        first_category_no,
        first_category_name,
        second_category_no,
        second_category_name,
        third_category_no,
        third_category_name,
        goods_no,
        goods_name,
        is_clean
)
insert overwrite table dws.dws_goods_store_goods_statistics_quarter_i partition (dt)
select
    -- 时间维度
    trade_date,
    max(week_trade_date) as week_trade_date,
    max(month_trade_date) as month_trade_date,
    max(hourly) as hourly,
    max(quarter) as quarter,
    quarters,
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
    sum(order_num) as order_num ,
    cast(sum(sale_qty) as decimal(27,3)) as sale_qty ,
    cast(sum(sale_amount) as decimal(27,2)) as sale_amount ,
    cast(sum(dis_amount) as decimal(27,2)) as dis_amount ,
    cast(sum(sale_cost) as decimal(27,2)) as sale_cost ,
    cast(sum(balance_amount) as decimal(27,2)) as balance_amount ,
    cast(sum(cancel_sale_amount) as decimal(27,2)) as cancel_sale_amount ,
    cast(sum(refund_sale_amount) as decimal(27,2)) as refund_sale_amount ,
    sum(online_order_num)as online_order_num ,
    sum(offline_order_num) as offline_order_num ,
    cast(sum(online_sale_qty) as decimal(27,3)) as online_sale_qty ,
    cast(sum(offline_sale_qty) as decimal(27,3)) as offline_sale_qty ,
    cast(sum(online_sale_amount) as decimal(27,2)) as online_sale_amount ,
    cast(sum(offline_sale_amount) as decimal(27,2)) as offline_sale_amount ,
    cast(sum(online_sale_cost) as decimal(27,2)) as online_sale_cost ,
    cast(sum(offline_sale_cost) as decimal(27,2)) as offline_sale_cost ,
    cast(sum(loss_qty) as decimal(27,3)) as loss_qty ,
    cast(sum(loss_amount) as decimal(27,2)) as loss_amount ,
    cast(sum(receipt_qty) as decimal(27,3)) as receipt_qty ,
    cast(sum(receipt_amount) as decimal(27,2)) as receipt_amount ,
    cast(sum(require_qty) as decimal(27,3)) as require_qty ,
    cast(sum(require_amount)as decimal(27,2)) as require_amount,
    trade_date as dt
from t1
where store_no is not null
and goods_no is not null
and trade_date is not null
and quarters is not null
group by
    trade_date,
    quarters,
    store_no,
    goods_no;



-- 注意: 门店经营分析刻表其中销售相关指标在dws_goods_store_goods_statistics_quarter_i都计算了,咱们会直接从该表取对应指标结果,其他会员余额指标需要单独计算
-- 2.门店经营分析刻表: dws_store_manage_statistics_quarter_i
-- DWS 门店经营分析刻表
--  1.先在dws.dws_goods_store_goods_statistics_quarter_i表中上卷出销售,损耗,收获,要货指标
with t1 as (
    select
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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

        sum(order_num) as order_num,
        sum(sale_qty) as sale_qty,
        sum(sale_amount) as sale_amount,
        sum(dis_amount) as dis_amount,
        sum(sale_cost) as sale_cost,
        sum(balance_amount) as balance_amount,
        sum(cancel_sale_amount) as cancel_sale_amount,
        sum(refund_sale_amount) as refund_sale_amount,
        sum(online_order_num) as online_order_num,
        sum(offline_order_num) as offline_order_num,
        sum(online_sale_amount) as online_sale_amount,
        sum(offline_sale_amount) as offline_sale_amount,
        sum(online_sale_cost) as online_sale_cost,
        sum(offline_sale_cost) as offline_sale_cost,
        sum(loss_amount) as loss_amount,
        sum(receipt_amount) as receipt_amount,
        sum(require_amount) as require_amount

    from dws.dws_goods_store_goods_statistics_quarter_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
),
 -- 2.然后去dwm_sold_goods_sold_dtl_i表中根据字段计算出会员/余额等相关指标
t2 as (

    select
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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

        count( if( trade_type = 0 and member_type = 1,parent_order_no,null)) - count( if( trade_type = 5 and member_type = 1,parent_order_no,null)) as ol_mem_order_num,
        count( if( trade_type = 0 and member_type = 2,parent_order_no,null)) - count( if( trade_type = 5 and member_type = 2,parent_order_no,null)) as vip_mem_order_num,
        sum( if( member_type = 1,sale_amount,0)) as ol_mem_sale_amount,
        sum( if( member_type = 2,sale_amount,0)) as vip_mem_sale_amount,
        sum( if( member_type = 1,sale_cost,0)) as ol_mem_sale_cost,
        sum( if( member_type = 2,sale_cost,0)) as vip_mem_sale_cost,
        count(distinct if(member_type = 1 and trade_type = 0, member_id,null)) as ol_mem_trade_num,
        count(distinct if(member_type = 2 and trade_type = 0, member_id,null)) as vip_mem_trade_num,
        sum(if(is_balance_consume = 1,balance_amount,0) ) as balance_sale_amount,
        count(if(is_balance_consume = 1 and trade_type = 0,parent_order_no,null)) - count(if(is_balance_consume = 1 and trade_type = 5,parent_order_no,null)) as balance_order_num,
        sum(if(is_balance_consume = 1,sale_cost,0) ) as balance_sale_cost,
        count(distinct if(is_balance_consume = 1 and trade_type = 0,member_id,null)) as balance_people_num

    from dwm.dwm_sold_goods_sold_dtl_i
    group by
        -- 时间维度
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
-- 3.结果1 left join 结果2  ,然后把对应所有指标取出即可
insert overwrite table dws.dws_store_manage_statistics_quarter_i partition (dt)
select
    -- 时间维度
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.hourly,
    t1.quarter,
    t1.quarters,
    -- 门店维度
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

    t2.ol_mem_order_num,
    t2.vip_mem_order_num,
    t2.ol_mem_sale_amount,
    t2.vip_mem_sale_amount,
    t2.ol_mem_sale_cost,
    t2.vip_mem_sale_cost,
    t2.ol_mem_trade_num,
    t2.vip_mem_trade_num,
    t2.balance_sale_amount,
    t2.balance_order_num,
    t2.balance_sale_cost,
    t2.balance_people_num,
    t1.trade_date as dt
from t1 left join t2 on t1.trade_date = t2.trade_date and t1.quarters = t2.quarters and t1.store_no = t2.store_no;







