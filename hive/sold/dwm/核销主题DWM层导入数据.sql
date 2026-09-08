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


-- 注意:dwd所有的维度表在关联的时候一定修改成最新分区目录


-- 1.商品销售明细刻表: dwm_sold_goods_sold_dtl_i

-- DWM层: 销售明细宽表(将线上和线下的两部分数据进行union all 合并)
insert overwrite table dwm.dwm_sold_goods_sold_dtl_i partition(dt)
select
    trade_date_time,
    date(trade_date) as trade_date,
    week_trade_date,
    month_trade_date,
    hourly,
    quarter,
    quarters,
    parent_store_no,
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
    trade_type,
    source_type,
    source_type_name,
    sale_type,
    0 as is_online_order,
    member_type,
    is_balance_consume,
    4 as order_type,
    4 as express_type,
    parent_order_no,
    order_no,
    trade_date_time as create_time,
    if(
        trade_type = 5,
        1,
        0
    ) as is_cancel,
    if(
        trade_type = 5,
        last_update_time,
        ''
    ) as cancel_time,
    last_update_time,
    zt_id,
    member_id,
    card_no,
    cast(share_user_id as int) as share_user_id,
    commission_amount,
    0 as is_tuan_head,
    0 as store_leader_id,
    '0' as order_group_no,
    first_category_no,
    first_category_name,
    second_category_no,
    second_category_name,
    third_category_no,
    third_category_name,
    goods_no,
    goods_name,
    supply_team,
    dc_no,
    dc_name,
    group_no,
    group_name,
    trade_mode_id,
    vendor_id,
    contract_no,
    is_clean,
    is_daily_clear,
    sale_qty,
    sale_amount,
    dis_amount,
    sale_cost,
    balance_amount,
    sale_amount as order_total_amount,
    dis_amount as order_discount_amount,
    sale_amount as order_paid_amount,
    dt
from dwd.dwd_sale_store_sale_dtl_i  -- 后续增量加上 where  dt = '昨天'

union all

select
    cast(complete_time as timestamp) as trade_date_time,
    date(trade_date) as trade_date,
    week_trade_date,
    month_trade_date,
    hourly,
    quarter,
    quarters,
    store_no as parent_store_no,
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
    trade_type,
    if(
        source_type in(10,20,30,40,41,70),
        2,
        if(
            source_type = 50,
            3,
            7
        )
    ) as source_type,
    if(
       source_type in(10,20,30,40,41,70),
        '三方平台',
        if(
            source_type = 50,
            '云鲜商城',
            '甄选'
        )
    ) as source_type_name,
    if(
        source_type in(10,20,30,40,41,70),
        6,
        if(
            source_type = 50,
            5,
            3
        )

    ) as sale_type,
    1 as is_online_order,
    1 as member_type,
    is_balance_consume,
    order_type,
    express_type,
    parent_order_no,
    order_id as order_no,
    create_time,
    is_cancel,
    date_format(cancel_time,'yyyy-MM-dd HH:mm:ss') as cancel_time,
    date_format(last_update_time,'yyyy-MM-dd HH:mm:ss') as last_update_time,
    zt_id,
    buyer_id as member_id,
    '' as card_no,
    0 as share_user_id,
    commission_amount,
    is_tuan_head,
    store_leader_id,
    order_group_no,
    first_category_no,
    first_category_name,
    second_category_no,
    second_category_name,
    third_category_no,
    third_category_name,
    goods_no,
    goods_name,
    supply_team,
    dc_no,
    dc_name,
    group_no,
    group_name,
    trade_mode_id,
    vendor_id,
    contract_no,
    0 as is_clean,
    0 as is_daily_clear,
    sale_qty,
    sale_amount,
    dis_amount,
    sale_cost,
    balance_amount,
    order_total_amount,
    order_discount_amount,
    order_paid_amount,
    dt
from dwd.dwd_sold_shop_order_dtl_i;




-- 2.门店商品损耗刻表: dwm_stock_store_goods_loss_quarter_i
-- 注意: select 后的字段要么在聚合函数内出现,要么在group by后出现
-- 计算损耗
with t1 as (
    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        goods_no,

        sum(adj_qty) as loss_qty,
        sum(adj_amount) as loss_amount
    from dwd.dwd_stock_store_stock_adj_i where adj_type_big in ('日清','报损/溢','人工盘点','盘点更正','周清')
    group by
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
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
        goods_no
)
insert overwrite table dwm.dwm_stock_store_goods_loss_quarter_i partition (dt)
select
    t1.trade_date,
    t1.week_trade_date,
    t1.month_trade_date,
    t1.hourly,
    t1.quarter,
    t1.quarters,
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
    t2.first_category_no,
    t2.first_category_name,
    t2.second_category_no,
    t2.second_category_name,
    t2.third_category_no,
    t2.third_category_name,
    t1.goods_no,
    t2.goods_name,
    t2.is_clear as is_clean,
    t1.loss_qty,
    t1.loss_amount,
    trade_date as dt
from  t1
    join dim.dwd_dim_store_goods_i t2
    on t1.store_no = t2.store_no and t1.goods_no = t2.goods_no and t2.dt = date_sub(current_date(),1)
    left join dim.dwd_dim_store_clear_goods_i as bsg
    on t1.store_no=bsg.store_no and t1.goods_no=bsg.goods_no and bsg.dt=date_sub(current_date(),1);




-- 3.门店商品收货刻表: dwm_order_store_goods_receipt_quarter_i
with t1 as (
    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        store_no,
        goods_no,
        receive_qty,
        receive_qty*receive_price as receive_amount,
        0 as return_vendor_qty,
        0 as return_vendor_amount,
        0 as return_dc_qty,
        0 as return_dc_amount,
        0 as allocation_in_qty,
        0 as allocation_in_amount,
        0 as allocation_out_qty,
        0 as allocation_out_amount,
        receive_qty as receipt_qty,
        receive_qty*receive_price as receipt_amount


    from dwd.dwd_order_store_receive_i

    union all

    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        store_no,
        goods_no,
        0 as receive_qty,
        0 as receive_amount,
        return_qty as return_vendor_qty,
        return_qty*return_price as return_vendor_amount,
        0 as return_dc_qty,
        0 as return_dc_amount,
        0 as allocation_in_qty,
        0 as allocation_in_amount,
        0 as allocation_out_qty,
        0 as allocation_out_amount,
        return_qty as receipt_qty,
        return_qty*return_price as receipt_amount

    from dwd.dwd_order_store_return_to_vendor_i

    union all

    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        store_no,
        goods_no,
        0 as receive_qty,
        0 as receive_amount,
        0 as return_vendor_qty,
        0 as return_vendor_amount,
        return_qty as return_dc_qty,
        return_price as return_dc_amount,
        0 as allocation_in_qty,
        0 as allocation_in_amount,
        0 as allocation_out_qty,
        0 as allocation_out_amount,
        return_qty as receipt_qty,
        return_qty*return_price as receipt_amount

    from dwd.dwd_order_store_return_to_dc_i

    union all

    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        alloc_in_store_no as store_no,
        goods_no,
        0 as receive_qty,
        0 as receive_amount,
        0 as return_vendor_qty,
        0 as return_vendor_amount,
        0 as return_dc_qty,
        0 as return_dc_amount,
        - alloc_qty as allocation_in_qty,
        - alloc_amount as allocation_in_amount,
        0 as allocation_out_qty,
        0 as allocation_out_amount,
        - alloc_qty as receipt_qty,
        - alloc_amount as receipt_amount

    from dwd.dwd_order_store_alloc_in_i

    union all

    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        alloc_out_store_no as store_no,
        goods_no,
        0 as receive_qty,
        0 as receive_amount,
        0 as return_vendor_qty,
        0 as return_vendor_amount,
        0 as return_dc_qty,
        0 as return_dc_amount,
        0 as allocation_in_qty,
        0 as allocation_in_amount,
        alloc_qty as allocation_out_qty,
        alloc_amount as allocation_out_amount,
        alloc_qty as receipt_qty,
        alloc_amount as receipt_amount

    from dwd.dwd_order_store_alloc_out_i
),
t2 as (
    select
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        store_no,
        goods_no,

        sum(receive_qty) as receive_qty,
        sum(receive_qty * receive_amount) as receive_amount,
        sum(return_vendor_qty) as return_vendor_qty,
        sum(return_vendor_amount) as return_vendor_amount,
        sum(return_dc_qty) as return_dc_qty,
        sum(return_dc_amount) as return_dc_amount,
        sum(allocation_in_qty) as allocation_in_qty,
        sum(allocation_in_amount) as allocation_in_amount,
        sum(allocation_out_qty) as allocation_out_qty,
        sum(allocation_out_amount) as allocation_out_amount,
        sum(receipt_qty) as receipt_qty,
        sum(receipt_amount) as receipt_amount,
        sum(receipt_amount)*0.95 as receipt_cost
    from t1
    group by
        trade_date,
        week_trade_date,
        month_trade_date,
        hourly,
        quarter,
        quarters,
        store_no,
        goods_no
)
insert overwrite table dwm.dwm_order_store_goods_receipt_quarter_i partition (dt)
select
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    t2.hourly,
    t2.quarter,
    t2.quarters,
    t2.store_no,
    t3.store_name,
    t3.store_sale_type,
    t3.store_type_code,
    t3.worker_num,
    t3.store_area,
    t3.city_id,
    t3.city_name,
    t3.region_code,
    t3.region_name,
    t3.is_day_clear,
    gm.first_category_no,
    gm.first_category_name,
    gm.second_category_no,
    gm.second_category_name,
    gm.third_category_no,
    gm.third_category_name,
    gm.goods_no,
    gm.goods_name,
    coalesce(bsg.is_clear,0) as is_clean,
    t2.receive_qty,
    t2.receive_amount,

    t2.return_vendor_qty,
    t2.return_vendor_amount,

    t2.return_dc_qty,
    t2.return_dc_amount,

    t2.allocation_in_qty,
    t2.allocation_in_amount,

    t2.allocation_out_qty,
    t2.allocation_out_amount,

    t2.receipt_qty,
    t2.receipt_amount,
    t2.receipt_cost,
    t2.trade_date  as dt
from t2
    join dim.dwd_dim_store_i t3 on t2.store_no=t3.store_no and t3.dt=date_sub(current_date(),1)
    join dim.dwd_dim_goods_i gm on t2.goods_no=gm.goods_no and gm.dt=date_sub(current_date(),1)
    left join dim.dwd_dim_store_clear_goods_i as bsg on t2.store_no=bsg.store_no and t2.goods_no=bsg.goods_no and bsg.dt=date_sub(current_date(),1);








-- 4.门店商品要货刻表: dwm_order_store_goods_require_quarter_i
-- 门店商品要货刻表
insert overwrite table dwm.dwm_order_store_goods_require_quarter_i partition(dt)
select
    t.trade_date
     ,t.week_trade_date
     ,t.month_trade_date
     ,t.hourly
     ,t.quarter
     ,t.quarters

     ,t.store_no
     ,t.store_name
     ,t.store_sale_type
     ,t.store_type_code
     ,t.worker_num
     ,t.store_area
     ,t.city_id
     ,t.city_name
     ,t.region_code
     ,t.region_name
     ,t.is_day_clear

     ,gm.first_category_no
     ,gm.first_category_name
     ,gm.second_category_no
     ,gm.second_category_name
     ,gm.third_category_no
     ,gm.third_category_name
     ,gm.goods_no
     ,gm.goods_name
     ,coalesce(bsg.is_clear,0) as is_clean

     ,cast(sum(require_qty) as decimal(27, 3)) as require_qty
     ,cast(sum(require_qty * require_price) as decimal(27, 2)) as require_amount

     ,t.trade_date as dt
from dwd.dwd_order_store_require_i t
         inner join dim.dwd_dim_goods_i as gm on t.goods_no=gm.goods_no and gm.dt=date_sub(current_date(),1)
         left join dim.dwd_dim_store_clear_goods_i as bsg
                   on t.store_no=bsg.store_no and t.goods_no=bsg.goods_no and bsg.dt=date_sub(current_date(),1)
where t.dt=date_sub(current_date(),1) and t.require_type_code=2  and t.is_canceled=0
  and t.collect_require_order_id is not null and t.collect_require_order_id <>''
group by
    t.trade_date
       ,t.week_trade_date
       ,t.month_trade_date
       ,t.hourly
       ,t.quarter
       ,t.quarters

       ,t.store_no
       ,t.store_name
       ,t.store_sale_type
       ,t.store_type_code
       ,t.worker_num
       ,t.store_area
       ,t.city_id
       ,t.city_name
       ,t.region_code
       ,t.region_name
       ,t.is_day_clear

       ,gm.first_category_no
       ,gm.first_category_name
       ,gm.second_category_no
       ,gm.second_category_name
       ,gm.third_category_no
       ,gm.third_category_name
       ,gm.goods_no
       ,gm.goods_name
       ,coalesce(bsg.is_clear,0)
