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


-- 1.门店销售明细宽表(8张表降维拉宽): dwd_sale_store_sale_dtl_i
--  先关联3张事实表,再去关联其他5张维度表
with t4 as(
    select
        date_format(t2.deal_date,'yyyy-MM-dd HH:mm:ss') as trade_date_time,
        date_format(t2.trade_date,'yyyy-MM-dd') as trade_date ,
        hour(t2.deal_date) as hourly,
        minute(t2.deal_date) as minute,
        t2.store_no as parent_store_no,
        coalesce(t2.sale_store_no,t2.store_no) as store_no,
        coalesce(t2.source_type,1) as source_type,
        if(
            t2.card_no like 'OL-%' OR t2.card_no like 'SF-%',
            1,
            if(
                t2.card_no = '' OR t2.card_no is null,
                0,
                2
            )
        ) as member_type,
        if(
            t3.order_no is null,
            0,
            1
        ) as is_balance_consume,
        if(
            t2.trade_id = 1,
            0,
            if(
                t2.trade_id = 2,
                2,
                5
            )
        ) as trade_type,
        if(
            t1.sale_amount < 0,
            t2.source_order_sn,
            if(
                t1.sale_amount >= 0,
                t2.parent_order_sn,
                t1.order_no
            )
        ) as parent_order_no,
       t2.order_no,
       t2.pos_no,
       t2.ser_id,
       coalesce(t1.item,0) as item,
       coalesce(t1.`sort`,0) as sort,
       date_format(t2.pay_date,'yyyy-MM-dd HH:mm:ss') as pay_time,
       date_format(t2.deal_date,'yyyy-MM-dd HH:mm:ss') as last_update_time,
       coalesce(t2.cashier_no,0)  as cashier_no,
       coalesce(t2.cashier_name,0) as cashier_name,
       coalesce(t2.member_center_sn,0) as zt_id,
       coalesce(t2.member_id,0) as member_id,
       t2.card_no,
       t1.goods_no,
        if(
            t1.combination_flag = 1,
            1,
            0
        ) as is_component,
       coalesce(t1.trade_mode_id,0) as trade_mode_id,
        t1.vendor_id,
        t1.contract_no,
        t1.is_daily_clear,
        coalesce(t1.share_user_id,0) as share_user_id,
        coalesce(t1.commission_amount,0) as commission_amount,
        t1.sale_qty,
        t1.sale_amount,
        t1.dis_amount,
        t1.sale_cost,
        if(
            t2.total_pay_amount = 0,
            0,
            if(
                t3.pay_amount is null,
                0,
                cast(t3.pay_amount * t1.sale_amount / t2.total_pay_amount as decimal(27,2))
            )
        )as balance_amount

    from (select * from ods.ods_sale_store_sale_dtl_i where coalesce(combination_flag,0) != 2 and offset_flag = 0) t1
        join ods.ods_sale_store_sale_info_i t2 on t2.order_no = t1.order_no
        left join (select * from ods.ods_sale_store_sale_pay_i where pay_type_id = '201') t3 on t2.order_no = t3.order_no
)

insert overwrite table dwd.dwd_sale_store_sale_dtl_i partition(dt)
select
    t4.trade_date_time,
    t4.trade_date,
    t5.week_trade_date,
    t5.month_trade_date,
    t4.hourly,
    case
        when t4.minute between 0 and 14 then 1
        when t4.minute between 15 and 29 then 2
        when t4.minute between 30 and 44 then 3
        when t4.minute between 45 and 59 then 4
    end as quarter,
    (
        t4.hourly * 4
        +
        case
            when t4.minute between 0 and 14 then 1
            when t4.minute between 15 and 29 then 2
            when t4.minute between 30 and 44 then 3
            when t4.minute between 45 and 59 then 4
        end
    ) as quarters,
    t4.parent_store_no,
    t4.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.worker_num,
    t7.store_area,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,
    t4.trade_type,
    t4.source_type,
    t6.source_type_name,
    case
        when t4.source_type = 1 then  1
        when t4.source_type = 9 then  5
        when t4.source_type in (4,5,6,7,8) then 6
        when t4.source_type = 11 then 8
        else 7
    end as sale_type,
    t4.member_type,
    t4.is_balance_consume,
    t4.parent_order_no,
    t4.order_no,
    t4.pos_no,
    t4.ser_id,
    t4.item,
    t4.sort,
    t4.pay_time,
    t4.last_update_time,
    t4.cashier_no,
    t4.cashier_name,
    t4.share_user_id,
    t4.commission_amount,
    t4.zt_id,
    t4.member_id,
    t4.card_no,
    t8.first_category_no,
    t8.first_category_name,
    t8.second_category_no,
    t8.second_category_name,
    t8.third_category_no,
    t8.third_category_name,
    t4.goods_no,
    t8.goods_name,
    t8.spec,
    t4.is_component,
    coalesce(t9.tag,4) as supply_team,
    coalesce(t9.dc_no,-1) as dc_no,
    coalesce(t9.dc_name,'其他仓') as dc_name,
    coalesce(t9.group_no,-1) as group_no,
    coalesce(t9.group_name,'其他柜组') as group_name ,
    t4.trade_mode_id,
    coalesce(t4.vendor_id,0) as vendor_id,
    t4.contract_no,
    coalesce(t9.is_clear,0) as is_clean,
    t4.is_daily_clear,
    t4.sale_qty,
    t4.sale_amount,
    t4.dis_amount,
    t4.sale_cost,
    t4.balance_amount,
    date_sub(current_date(),1) as write_time,
    t4.trade_date as dt
from  t4
    left join dim.dwd_dim_date_f t5 on t4.trade_date = t5.trade_date
    left join dim.dwd_dim_source_type_map_i t6 on t6.dt = date_sub(current_date(),1) and t4.source_type = t6.original_source_type
    left join dim.dwd_dim_store_i t7 on t7.dt = date_sub(current_date(),1) and t4.store_no = t7.store_no
    left join dim.dwd_dim_goods_i t8 on t8.dt = date_sub(current_date(),1) and  t4.goods_no = t8.goods_no
    left join dim.dwd_dim_store_goods_i t9 on t9.dt = date_sub(current_date(),1) and t9.goods_no = t4.goods_no and t9.store_no = t4.store_no;







-- 2.线上余额支付明细表: dwd_sale_shop_sale_balance_pay_i
-- 线上余额支付明细
insert overwrite table dwd.dwd_sale_shop_sale_balance_pay_i partition (dt)
select
    store_no,
    store_name,
    trade_date,
    member_id,
    zt_id,
    trade_order_id,
    pay_order_id,
    order_no,
    pay_channel,
    pay_channel_name,
    trade_order_type,
    trade_order_type_name,
    pay_amount,
    trade_merchant,
    dt
from ods.ods_sale_shop_sale_pay_i where pay_channel_name = '余额支付';


-- 3.商城订单表(核销表):    dwd_sold_shop_order_i
insert overwrite table dwd.dwd_sold_shop_order_i partition (dt)
select
    id,
    parent_order_no,
    order_id,
    is_split,
    platform_id,
    tid,
    source_type,
    source_name,
    store_no,
    city_id,
    city_name,
    region_code,
    order_status,
    order_status_desc,
    pay_type,
    trade_type,
    is_deleted,
    order_create_time,
    order_pay_time,
    create_time,
    print_status,
    print_time,
    stock_up_status,
    stock_up_time,
    order_type,
    express_type,
    receive_time,
    express_code,
    delivery_status,
    delivery_time,
    pick_up_status,
    qr_code,
    pick_up_time,
    complete_time,
    is_cancel,
    cancel_time,
    cancel_reason,
    refund_status,
    refund_time,
    last_update_time,
    order_total_amount,
    product_total_amount,
    pack_amount,
    delivery_amount,
    discount_amount,
    seller_discount_amount,
    platform_allowance_amount,
    real_paid_amount,
    product_discount,
    real_product_amount,
    buyer_id,
    buyer_phone,
    buyer_remark,
    r_name,
    r_tel,
    r_province,
    r_city,
    r_district,
    r_address,
    r_zipcode,
    is_tuan_head,
    store_leader_id,
    order_group_no,
    commision_amount,
    settle_amount,
    points_amount,
    pay_point,
    balance_amount,
    pay_channel_amount,
    point_amount,
    sync_erp_status,
    sync_erp_msg,
    date_format(complete_time,'yyyy-MM-dd') as dt

from ods.ods_sale_shop_order_i where complete_time is not null;
-- 后续增量只需加上where dt = date_sub(current_date(),1) and  date_format(complete_time,'yyyy-MM-dd') = date_sub(current_date(),1);


-- 4.商城订单明细表(核销表): dwd_sold_shop_order_item_i
insert overwrite table dwd.dwd_sold_shop_order_item_i partition (dt)
select
    id,
    order_id,
    goods_no,
    goods_name,
    weight,
    quantity,
    unit,
    sale_qty,
    disp_price,
    pay_price,
    sale_amount,
    dis_amount,
    sale_cost,
    sale_type,
    create_time,
    complete_time,
    last_update_time,
    activity_plat_city_goods_id,
    activity_type,
    item_goods_key,
    is_deleted,
    transfer_paper_no,
    serial_no,
    is_delivery,
    goods_source_type,
    trade_mode_id,
    vendor_id,
    contract_no,
    date_format(complete_time,'yyyy-MM-dd') as dt
from ods.ods_sale_shop_order_item_i where complete_time is not null;
-- 后续增量只需加上where dt = date_sub(current_date(),1) and  date_format(complete_time,'yyyy-MM-dd') = date_sub(current_date(),1);



-- 5.商城订单核销明细宽表(10张表降维拉宽): dwd_sold_shop_order_dtl_i
-- 商城核销明细宽表:
with t5 as (
    -- 步骤一:
    select
        t1.complete_time,
        date_format(t1.complete_time,'yyyy-MM-dd') as trade_date,

        hour(t1.complete_time) as hourly,
        minute(t1.complete_time) as minute,

        t1.parent_order_no,
        t1.order_id,
        '0' as trade_type,
        t1.is_split,
        t1.platform_id,
        t1.tid,
        t1.source_type,
        t1.source_name,
        t1.order_type,
        t1.express_type,
        t1.order_status,
        t1.order_status_desc,
        t1.pay_type,
        if(
            t3.order_no is not null,
            1,
            0
        ) as is_balance_consume,
        t1.store_no,

        t1.order_create_time,
        t1.order_pay_time,
        t1.create_time,
        if(
            t1.is_cancel = 1,
            5,
            0
        ) as is_cancel,
        t1.cancel_time,
        t1.cancel_reason,
        t1.last_update_time,
        t1.buyer_id,
        t1.buyer_phone,
        t1.buyer_remark,
        t1.r_name,
        t1.r_tel,
        t1.r_province,
        t1.r_city,
        t1.r_district,
        t1.r_address,
        t1.r_zipcode,
        t1.is_tuan_head,
        t1.store_leader_id,
        t1.order_group_no,
        t1.commision_amount * t2.sale_amount / t1.real_product_amount as commission_amount, -- 抽佣金额
        t1.settle_amount * t2.sale_amount / t1.real_product_amount  as settle_amount,  -- 结算金额
        t2.goods_no,
        t2.weight,
        t2.quantity,
        t2.unit,
        t2.sale_qty,
        t2.disp_price,
        t2.pay_price,
        t2.sale_amount,
        t2.dis_amount,
        t2.sale_cost,
        t2.sale_type,
        t2.activity_plat_city_goods_id,
        t2.activity_type,
        t1.order_total_amount *  t2.sale_amount / t1.real_product_amount as order_total_amount, -- 订单总金额(平摊)
        t1.discount_amount * t2.sale_amount / t1.real_product_amount as order_discount_amount, -- 订单优惠金额 = 商家承担优惠金额 + 平台补贴金额 (平摊)
        if(
            t1.real_paid_amount = 0,
            0,
            t1.real_paid_amount * t2.sale_amount / t1.real_product_amount
        ) as order_paid_amount, -- 实付金额(平摊)
        if(
            t1.real_paid_amount = 0,
            0,
            if(
                t3.pay_amount is null,
                0,
                t3.pay_amount * t2.sale_amount / t1.real_product_amount
            )

        ) as balance_amount,  -- 余额支付金额 (平摊) 首先判断单据金额是否等于0 , 则结果为0, 如果不是, 判断是否有余额支付金额, 如果有, 使用余额金额 * 商品销售金额 / 单据金额

        t2.trade_mode_id,
        t2.vendor_id,
        t2.contract_no,
        t1.dt
    from dwd.dwd_sold_shop_order_i t1
        join dwd.dwd_sold_shop_order_item_i t2 on t1.order_id = t2.order_id
        left join dwd.dwd_sale_shop_sale_balance_pay_i t3 on t1.order_id = t3.order_no

    -- 合并
    union all

    -- 步骤二:
    select
        t1.create_time as complete_time,
        date_format(t1.create_time,'yyyy-MM-dd') as trade_date,

        hour(t1.create_time) as hourly,
        minute(t1.create_time) as minute,

        t3.parent_order_no,
        t3.order_id,
        if(
            t1.cancel_time is not null,
            '5',
            '2'
        ) as trade_type,
        t3.is_split,
        t3.platform_id,
        t3.tid,
        t3.source_type,
        t3.source_name,
        t3.order_type,
        t3.express_type,
        t3.order_status,
        t3.order_status_desc,
        t3.pay_type,
        if(
            t1.order_no is not null,
            1,
            0
        ) as is_balance_consume,
        t1.store_no,

        t3.order_create_time,
        t3.order_pay_time,
        t3.create_time,
        if(
            t3.is_cancel = 1,
            5,
            0
        ) as is_cancel,
        t1.cancel_time,
        t3.cancel_reason,
        t3.last_update_time,
        t3.buyer_id,
        t3.buyer_phone,
        t3.buyer_remark,
        t3.r_name,
        t3.r_tel,
        t3.r_province,
        t3.r_city,
        t3.r_district,
        t3.r_address,
        t3.r_zipcode,
        t3.is_tuan_head,
        t1.store_leader_id,
        t3.order_group_no,
        -(t3.commision_amount * t2.amount / t3.real_product_amount) as commission_amount, -- 抽佣金额
        -(t3.settle_amount * t2.amount / t3.real_product_amount)  as settle_amount,  -- 结算金额
        t2.goods_no,
        0 as weight,
        -t2.quantity,
        '' as unit,
        -t2.qty,
        t2.amount / t2.quantity as disp_price,
        t2.amount / t2.quantity as pay_price,
        -t2.amount ,
        0 as dis_amount,
        -t2.cost as sale_cost,
        1 as sale_type,
        t2.activity_plat_city_goods_id,
        t2.activity_type,
        -t2.amount as order_total_amount, -- 订单总金额(平摊)
        0 as order_discount_amount, -- 订单优惠金额 = 商家承担优惠金额 + 平台补贴金额 (平摊)
        -t2.amount as order_paid_amount, -- 实付金额(平摊)
        - if(
            t3.real_paid_amount = 0,
            0,
            if(
                t4.pay_amount is null,
                0,
                t4.pay_amount * t2.amount / t3.real_product_amount
            )

        ) as balance_amount,  -- 余额支付金额 (平摊) 首先判断单据金额是否等于0 , 则结果为0, 如果不是, 判断是否有余额支付金额, 如果有, 使用余额金额 * 商品销售金额 / 单据金额

        t2.trade_mode_id,
        t2.vendor_id,
        t2.contract_no,
        t1.dt
    from ods.ods_sale_shop_refund_i t1
        join ods.ods_sale_shop_refund_item_i t2 on t1.refund_no = t2.refund_no
        left join dwd.dwd_sold_shop_order_i t3 on t1.order_no = t3.order_id
        left join dwd.dwd_sale_shop_sale_balance_pay_i t4 on t4.order_no = t1.refund_no
)

insert overwrite table dwd.dwd_sold_shop_order_dtl_i partition (dt)
select
    t5.complete_time,
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.hourly,
    case
        when t5.minute between 0 and 14 then 1
        when t5.minute between 15 and 29 then 2
        when t5.minute between 30 and 44 then 3
        when t5.minute between 45 and 59 then 4
    end as quarter,
    (
        t5.hourly * 4
        +
        case
            when t5.minute between 0 and 14 then 1
            when t5.minute between 15 and 29 then 2
            when t5.minute between 30 and 44 then 3
            when t5.minute between 45 and 59 then 4
        end
    ) as quarters,
    t5.parent_order_no,
    t5.order_id,
    t5.trade_type,
    t5.is_split,
    t5.platform_id,
    t5.tid,
    t5.source_type,
    t5.source_name,
    t5.order_type,
    t5.express_type,
    t5.order_status,
    t5.order_status_desc,
    t5.pay_type,
    t5.is_balance_consume,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.worker_num,
    t7.store_area,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,
    t5.order_create_time,
    t5.order_pay_time,
    t5.create_time,
    t5.is_cancel,
    t5.cancel_time,
    t5.cancel_reason,
    t5.last_update_time,
    t10.zt_id,
    t5.buyer_id,
    t5.buyer_phone,
    t5.buyer_remark,
    t5.r_name,
    t5.r_tel,
    t5.r_province,
    t5.r_city,
    t5.r_district,
    t5.r_address,
    t5.r_zipcode,
    t5.is_tuan_head,
    t5.store_leader_id,
    t5.order_group_no,
    t5.commission_amount,
    t5.settle_amount,
    t8.first_category_no,
    t8.first_category_name,
    t8.second_category_no,
    t8.second_category_name,
    t8.third_category_no,
    t8.third_category_name,
    t5.goods_no,
    t8.goods_name,
    t5.weight,
    t5.quantity,
    t5.unit,
    t5.sale_qty,
    t5.disp_price,
    t5.pay_price,
    t5.sale_amount,
    t5.dis_amount,
    t5.sale_cost,
    t5.sale_type,
    t5.activity_plat_city_goods_id,
    t5.activity_type,
    t5.order_total_amount,
    t5.order_discount_amount,
    t5.order_paid_amount,
    t5.balance_amount,
    coalesce(t9.tag,4) as supply_team,
    coalesce(t9.dc_no,-1) as dc_no,
    coalesce(t9.dc_name,'其他仓') as dc_name,
    coalesce(t9.group_no,-1) as group_no,
    coalesce(t9.group_name,'其他柜组') as group_name ,
    t5.trade_mode_id,
    coalesce(t5.vendor_id,0) as vendor_id,
    t5.contract_no,
    t5.dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt = date_sub(current_date(),1)
    left join dim.dwd_dim_goods_i t8 on t5.goods_no = t8.goods_no and t8.dt = date_sub(current_date(),1)
    left join dim.dwd_dim_store_goods_i t9 on t8.goods_no = t9.goods_no and t7.store_no = t9.store_no and t9.dt = date_sub(current_date(),1)
    left join ods.ods_mem_member_union_i t10 on t5.buyer_id = t10.member_id;






/*
union all
要保证两个查询结果集
个数和类型必须一致,否则报错
上述条件满足的情况下,顺序如果不一致,能够合并成功,但是数据张冠李戴,所以以后顺序也尽量一致
如果原有结果集中没有对应的字段,需要添加字段值以及对应字段名, 例如:  null as 字段名  或者  0 as 字段名

full outer join
自动补充null,而且不同的结果集字段自动分别展示
想要合并一起展示以及转换其他内容,都可以使用if()函数
*/




-- 6.门店库调表(3张表降维拉宽): dwd_stock_store_stock_adj_i
insert overwrite table dwd.dwd_stock_store_stock_adj_i partition (dt)
select
    t2.trade_date,
    t2.week_trade_date,
    t2.month_trade_date,
    hour(t1.stock_deal_time) as hourly,
    case
        when minute(t1.stock_deal_time) between 0 and 14 then 1
        when minute(t1.stock_deal_time) between 15 and 29 then 2
        when minute(t1.stock_deal_time) between 30 and 44 then 3
        when minute(t1.stock_deal_time) between 45 and 59 then 4
    end as quarter,
    (
        hour(t1.stock_deal_time) * 4
        +
        case
            when minute(t1.stock_deal_time) between 0 and 14 then 1
            when minute(t1.stock_deal_time) between 15 and 29 then 2
            when minute(t1.stock_deal_time) between 30 and 44 then 3
            when minute(t1.stock_deal_time) between 45 and 59 then 4
        end
    ) as quarters,
    t1.id,
    t1.uid,
    t1.order_id,
    t1.order_source,
    t1.store_no,
    t1.store_name,
    t3.store_sale_type,
    t3.store_type_code,
    t3.worker_num,
    t3.store_area,
    t3.city_id,
    t3.city_name,
    t3.region_code,
    t3.region_name,
    t3.is_day_clear,
    t1.goods_no,
    t1.goods_name,
    t1.adj_type_big,
    t1.adj_type_small,
    t1.adj_reason_big,
    t1.adj_reason_small,
    t1.adj_qty,
    t1.adj_price,
    t1.adj_amount,
    t1.create_time,
    t1.stock_deal_time,
    t1.sync_time,
    t1.vendor_no,
    t1.vendor_name,
    t2.trade_date as dt
from ods.ods_stock_store_stock_adj_i t1
    join dim.dwd_dim_date_f t2 on  date_format(t1.stock_deal_time,'yyyy-MM-dd') = t2.trade_date
    join dim.dwd_dim_store_i t3 on t3.dt = date_sub(current_date(),1) and t1.store_no = t3.store_no;




-- 7.门店收货表(3张表降维拉宽):dwd_order_store_receive_i
insert overwrite table dwd.dwd_order_store_receive_i partition(dt)
select
    date_format(t.stock_deal_time,'yyyy-MM-dd') as trade_date
     ,dd.week_trade_date
     ,dd.month_trade_date
     ,hour(t.stock_deal_time) as hourly
     ,case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
           when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
           when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
           when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end as `quarter`
     ,hour(t.stock_deal_time)*4 + case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
                                       when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
                                       when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
                                       when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end  as quarters

     ,t.id
     ,t.uid
     ,t.order_id
     ,t.order_source

     ,t.store_no
     ,bs.store_name
     ,bs.store_sale_type
     ,bs.store_type_code
     ,bs.worker_num
     ,bs.store_area
     ,bs.city_id
     ,bs.city_name
     ,bs.region_code
     ,bs.region_name
     ,bs.is_day_clear

     ,t.goods_no
     ,t.goods_name
     ,t.dc_no
     ,t.dc_name
     ,t.vendor_no
     ,t.vendor_name
     ,t.order_type
     ,t.receive_price
     ,t.receive_qty
     ,t.git_qty
     ,t.create_time
     ,t.stock_deal_time
     ,t.dc_send_order_id
     ,t.red_order_id
     ,t.contract_no
     ,t.contract_name
     ,t.trade_mode
     ,t.order_source_type
     ,t.sync_time
     ,date_format(t.stock_deal_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_receive_i t
inner join dim.dwd_dim_date_f as dd
 on date_format(t.stock_deal_time,'yyyy-MM-dd')=dd.trade_date
inner join dim.dwd_dim_store_i as bs
 on t.store_no=bs.store_no and bs.dt= date_sub(current_date(),1);


-- 8.门店退货表(3张表降维拉宽): dwd_order_store_return_to_vendor_i
insert overwrite table dwd.dwd_order_store_return_to_vendor_i partition (dt)
select
    date_format(t.stock_deal_time,'yyyy-MM-dd') as trade_date
     ,dd.week_trade_date
     ,dd.month_trade_date
     ,hour(t.stock_deal_time) as hourly
     ,case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
           when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
           when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
           when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end as `quarter`
     ,hour(t.stock_deal_time)*4 + case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
                                       when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
                                       when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
                                       when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end  as quarters
     ,t.id
     ,t.uid
     ,t.order_id
     ,t.order_source

     ,t.store_no
     ,bs.store_name
     ,bs.store_sale_type
     ,bs.store_type_code
     ,bs.worker_num
     ,bs.store_area
     ,bs.city_id
     ,bs.city_name
     ,bs.region_code
     ,bs.region_name
     ,bs.is_day_clear

     ,t.goods_no
     ,t.goods_name
     ,t.dc_no
     ,t.dc_name
     ,t.vendor_no
     ,t.vendor_name
     ,t.return_price
     ,t.return_qty
     ,t.create_time
     ,t.stock_deal_time
     ,t.original_order_id
     ,t.is_fresh
     ,t.is_entity
     ,t.responsible_person
     ,t.return_reason_big
     ,t.return_desc_big
     ,t.return_reason_small
     ,t.return_desc_small
     ,t.sync_time

     ,date_format(t.stock_deal_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_return_to_vendor_i t
inner join dim.dwd_dim_date_f as dd
 on date_format(t.stock_deal_time,'yyyy-MM-dd') = dd.trade_date
inner join dim.dwd_dim_store_i as bs
 on t.store_no=bs.store_no and bs.dt = date_sub(current_date(),1)
;

-- 9.门店退配表(3张表降维拉宽): dwd_order_store_return_to_dc_i
insert overwrite table dwd.dwd_order_store_return_to_dc_i partition (dt)
select
    date_format(t.stock_deal_time,'yyyy-MM-dd') as trade_date
     ,dd.week_trade_date
     ,dd.month_trade_date
     ,hour(t.stock_deal_time) as hourly
     ,case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
           when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
           when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
           when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end as `quarter`
     ,hour(t.stock_deal_time)*4 + case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
                                       when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
                                       when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
                                       when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end  as quarters

     ,t.id
     ,t.uid
     ,t.order_id
     ,t.order_source

     ,t.store_no
     ,bs.store_name
     ,bs.store_sale_type
     ,bs.store_type_code
     ,bs.worker_num
     ,bs.store_area
     ,bs.city_id
     ,bs.city_name
     ,bs.region_code
     ,bs.region_name
     ,bs.is_day_clear

     ,t.goods_no
     ,t.goods_name
     ,t.dc_no
     ,t.dc_name
     ,t.vendor_no
     ,t.vendor_name
     ,t.return_price
     ,t.return_qty
     ,t.create_time
     ,t.stock_deal_time
     ,t.original_order_id
     ,t.is_fresh
     ,t.is_entity
     ,t.responsible_person
     ,t.return_reason_big
     ,t.return_desc_big
     ,t.return_reason_small
     ,t.return_desc_small
     ,t.sync_time
     ,t.batch_type_id

     ,date_format(t.stock_deal_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_return_to_dc_i t
inner join dim.dwd_dim_date_f as dd
 on date_format(t.stock_deal_time,'yyyy-MM-dd') = dd.trade_date
inner join dim.dwd_dim_store_i as bs
 on t.store_no = bs.store_no and bs.dt = date_sub(current_date(),1)
;


-- 10.门店调入表(3张表降维拉宽):dwd_order_store_alloc_in_i
insert overwrite table dwd.dwd_order_store_alloc_in_i partition (dt)
select
    date_format(t.stock_deal_time,'yyyy-MM-dd') as trade_date
     ,dd.week_trade_date
     ,dd.month_trade_date
     ,hour(t.stock_deal_time) as hourly
     ,case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
           when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
           when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
           when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end as `quarter`
     ,hour(t.stock_deal_time)*4 + case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
                                       when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
                                       when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
                                       when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end  as quarters

     ,t.id
     ,t.uid
     ,t.order_id
     ,t.order_source

     ,t.goods_no
     ,t.goods_name

     ,t.alloc_in_store_no
     ,bs.store_name as alloc_in_store_name
     ,bs.store_sale_type as alloc_in_store_sale_type
     ,bs.store_type_code as alloc_in_store_type_code
     ,bs.worker_num as alloc_in_worker_num
     ,bs.store_area as alloc_in_store_area
     ,bs.city_id as alloc_in_city_id
     ,bs.city_name as alloc_in_city_name
     ,bs.region_code as alloc_in_region_code
     ,bs.region_name as alloc_in_region_name
     ,bs.is_day_clear as alloc_in_is_clear

     ,t.alloc_out_store_no
     ,t.alloc_out_store_name
     ,t.alloc_price
     ,t.alloc_qty
     ,t.alloc_reason
     ,t.alloc_amount
     ,t.create_time
     ,t.stock_deal_time
     ,t.sync_time
     ,t.vendor_no
     ,t.vendor_name

     ,date_format(t.stock_deal_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_alloc_in_i t
inner join dim.dwd_dim_date_f as dd
 on date_format(t.stock_deal_time,'yyyy-MM-dd') = dd.trade_date
inner join dim.dwd_dim_store_i as bs
 on t.alloc_in_store_no=bs.store_no and bs.dt = date_sub(current_date(),1)
;


-- 11.门店调出表(3张表降维拉宽):dwd_order_store_alloc_out_i
insert overwrite table dwd.dwd_order_store_alloc_out_i partition (dt)
select
    date_format(t.stock_deal_time,'yyyy-MM-dd') as trade_date
     ,dd.week_trade_date
     ,dd.month_trade_date
     ,hour(t.stock_deal_time) as hourly
     ,case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
           when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
           when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
           when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end as `quarter`
     ,hour(t.stock_deal_time)*4 + case when minute(t.stock_deal_time)>=0  and minute(t.stock_deal_time)<15 then 1
                                       when minute(t.stock_deal_time)>=15 and minute(t.stock_deal_time)<30 then 2
                                       when minute(t.stock_deal_time)>=30 and minute(t.stock_deal_time)<45 then 3
                                       when minute(t.stock_deal_time)>=45 and minute(t.stock_deal_time)<60 then 4
    end  as quarters

     ,t.id
     ,t.uid
     ,t.order_id
     ,t.order_source

     ,t.goods_no
     ,t.goods_name

     ,t.alloc_in_store_no
     ,t.alloc_in_store_name

     ,t.alloc_out_store_no
     ,bs.store_name as alloc_out_store_name
     ,bs.store_sale_type as alloc_out_store_sale_type
     ,bs.store_type_code as alloc_out_store_type_code
     ,bs.worker_num as alloc_out_worker_num
     ,bs.store_area as alloc_out_store_area
     ,bs.city_id as alloc_out_city_id
     ,bs.city_name as alloc_out_city_name
     ,bs.region_code as alloc_out_region_code
     ,bs.region_name as alloc_out_region_name
     ,bs.is_day_clear as alloc_out_is_clear

     ,t.alloc_price
     ,t.alloc_qty
     ,t.alloc_reason
     ,t.alloc_amount
     ,t.create_time
     ,t.stock_deal_time
     ,t.sync_time
     ,t.vendor_no
     ,t.vendor_name

     ,date_format(t.stock_deal_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_alloc_out_i t
inner join dim.dwd_dim_date_f as dd
 on date_format(t.stock_deal_time,'yyyy-MM-dd') = dd.trade_date
inner join dim.dwd_dim_store_i as bs
 on t.alloc_out_store_no=bs.store_no and bs.dt = date_sub(current_date(),1)
;


-- 12.门店要货表(3张表降维拉宽):dwd_order_store_require_i
insert overwrite table dwd.dwd_order_store_require_i partition (dt)
select
    date_format(t.confirm_time,'yyyy-MM-dd') as trade_date
     ,dd.week_trade_date
     ,dd.month_trade_date
     ,hour(t.confirm_time) as hourly
     ,case when minute(t.confirm_time)>=0  and minute(t.confirm_time)<15 then 1
           when minute(t.confirm_time)>=15 and minute(t.confirm_time)<30 then 2
           when minute(t.confirm_time)>=30 and minute(t.confirm_time)<45 then 3
           when minute(t.confirm_time)>=45 and minute(t.confirm_time)<60 then 4
    end as `quarter`
     ,hour(t.confirm_time)*4 + case when minute(t.confirm_time)>=0  and minute(t.confirm_time)<15 then 1
                                    when minute(t.confirm_time)>=15 and minute(t.confirm_time)<30 then 2
                                    when minute(t.confirm_time)>=30 and minute(t.confirm_time)<45 then 3
                                    when minute(t.confirm_time)>=45 and minute(t.confirm_time)<60 then 4
    end  as quarters
     ,t.id
     ,t.uid
     ,t.order_id
     ,t.order_source

     ,t.store_no
     ,bs.store_name
     ,bs.store_sale_type
     ,bs.store_type_code
     ,bs.worker_num
     ,bs.store_area
     ,bs.city_id
     ,bs.city_name
     ,bs.region_code
     ,bs.region_name
     ,bs.is_day_clear

     ,t.goods_no
     ,t.goods_name
     ,t.dc_no
     ,t.dc_name
     ,t.vendor_no
     ,t.vendor_name
     ,t.group_no
     ,t.require_price
     ,t.require_qty
     ,t.create_time
     ,t.send_time
     ,t.collect_require_order_id
     ,t.require_type_code
     ,t.is_online
     ,t.confirm_time
     ,t.is_canceled
     ,t.sync_time
     ,t.is_urgent
     ,t.original_order_price

     ,date_format(t.confirm_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_require_i t
inner join dim.dwd_dim_date_f as dd
 on date_format(t.confirm_time,'yyyy-MM-dd') = dd.trade_date
inner join dim.dwd_dim_store_i as bs
 on t.store_no=bs.store_no and bs.dt = date_sub(current_date(),1)
;

















