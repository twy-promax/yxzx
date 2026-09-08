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


-- 注意: 先准备好售卖主题表
-- 执行资料中售卖主题_dwm_sell_o2o_order_i表.sql脚本

-- DWM层: 会员销售订单明细表
insert overwrite table dwm.dwm_mem_sell_order_i partition (dt)
select
    create_time,
    trade_date,
    week_trade_date,
    month_trade_date,
    hourly,
    quarter,
    quarters,
    parent_order_no,
    order_no,
    trade_type,
    source_type,
    source_type_name,
    sale_type,
    is_online_order,
    member_type,
    is_balance_consume,
    order_type,
    express_type,
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
    is_cancel,
    cancel_time,
    cancel_reason,
    last_update_time,
    cashier_no,
    cashier_name,
    zt_id,
    member_id,
    card_no,
    r_name,
    r_province,
    r_city,
    r_district,
    is_tuan_head,
    store_leader_id,
    order_group_no,
    settle_amount,
    share_user_id,
    commission_amount,
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
    round_amount,
    wechat_amount,
    ali_pay_amount,
    cash_amount,
    balance_amount,
    point_amount,
    unionpay_amount,
    member_card_amount,
    gift_amount,
    yxapi_amount,
    other_pay_amount,
    dt
from dwm.dwm_sell_o2o_order_i
where member_type = 1;
-- 后续 where dt = '${inputdate}' and member_type = 1;


