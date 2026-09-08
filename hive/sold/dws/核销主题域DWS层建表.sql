drop database if exists dws cascade ;
create database if not exists dws;

CREATE TABLE IF NOT EXISTS dws.dws_goods_store_goods_statistics_quarter_i(
    trade_date                  STRING COMMENT '交易日期',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',
    hourly                      BIGINT COMMENT '交易小时(0-23)',
    quarter                     BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                    BIGINT COMMENT '刻钟数:hourly*4+quarters',

    store_no                    STRING COMMENT '店铺编码',
    store_name                  STRING COMMENT '店铺名称',
    store_sale_type             BIGINT COMMENT '店铺销售类型',
    store_type_code             BIGINT COMMENT '分店类型',
    worker_num                  BIGINT COMMENT '员工人数',
    store_area                  DECIMAL(27, 2) COMMENT '门店面积',
    city_id                     BIGINT COMMENT '城市ID',
    city_name                   STRING COMMENT '城市名称',
    region_code                 STRING COMMENT '区域编码',
    region_name                 STRING COMMENT '区域名称',
    is_day_clear                BIGINT COMMENT '是否日清:0否,1是',

    first_category_no           STRING COMMENT '一级分类编码',
    first_category_name         STRING COMMENT '一级分类名称',
    second_category_no          STRING COMMENT '二级分类编码',
    second_category_name        STRING COMMENT '二级分类名称',
    third_category_no           STRING COMMENT '三级分类编码',
    third_category_name         STRING COMMENT '三级分类名称',
    goods_no                    STRING COMMENT '商品编码',
    goods_name                  STRING COMMENT '商品名称',
    is_clean                    BIGINT COMMENT '商品是否日清:0否,1是',

    order_num                   BIGINT COMMENT '销售单量',
    sale_qty                    DECIMAL(27, 3) COMMENT '销售数量',
    sale_amount                 DECIMAL(27, 2) COMMENT '销售金额',
    dis_amount                  DECIMAL(27, 2) COMMENT '折扣金额',
    sale_cost                   DECIMAL(27, 2) COMMENT '销售成本',
    balance_amount              DECIMAL(27, 2) COMMENT '余额支付金额',
    cancel_sale_amount          DECIMAL(27, 2) COMMENT '取消商品销售金额',
    refund_sale_amount          DECIMAL(27, 2) COMMENT '退款商品销售金额',
    online_order_num            BIGINT COMMENT '线上单量',
    offline_order_num           BIGINT COMMENT '线下单量',
    online_sale_qty             DECIMAL(27, 3) COMMENT '线上销售数量',
    offline_sale_qty            DECIMAL(27, 3) COMMENT '线下销售数量',
    online_sale_amount          DECIMAL(27, 2) COMMENT '线上销售金额',
    offline_sale_amount         DECIMAL(27, 2) COMMENT '线下销售金额',
    online_sale_cost            DECIMAL(27, 2) COMMENT '线上销售成本',
    offline_sale_cost           DECIMAL(27, 2) COMMENT '线下销售成本',
    loss_qty                    DECIMAL(27, 3) COMMENT '损耗数量',
    loss_amount                 DECIMAL(27, 2) COMMENT '损耗金额',
    receipt_qty                 DECIMAL(27, 3) COMMENT '收货数量',
    receipt_amount              DECIMAL(27, 2) COMMENT '收货金额（收货-退货-退配+调入-调出）',
    require_qty                 DECIMAL(27, 3) COMMENT '要货数量',
    require_amount              DECIMAL(27, 2) COMMENT '要货金额'
)
COMMENT '门店商品分析刻表'
partitioned by(dt STRING COMMENT '统计时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


CREATE TABLE IF NOT EXISTS dws.dws_store_manage_statistics_quarter_i(
    trade_date          STRING COMMENT '交易日期',
    week_trade_date     STRING COMMENT '周一日期',
    month_trade_date    STRING COMMENT '月一日期',
    hourly              BIGINT COMMENT '交易小时(0-23)',
    quarter             BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters            BIGINT COMMENT '刻钟数:hourly*4+quarters',

    store_no            STRING COMMENT '店铺编码',
    store_name          STRING COMMENT '店铺名称',
    store_sale_type     BIGINT COMMENT '店铺销售类型',
    store_type_code     BIGINT COMMENT '分店类型',
    worker_num          BIGINT COMMENT '员工人数',
    store_area          DECIMAL(27, 2) COMMENT '门店面积',
    city_id             BIGINT COMMENT '城市ID',
    city_name           STRING COMMENT '城市名称',
    region_code         STRING COMMENT '区域编码',
    region_name         STRING COMMENT '区域名称',
    is_day_clear        BIGINT COMMENT '是否日清:0否,1是',

    order_num           BIGINT COMMENT '销售单量',
    sale_qty            DECIMAL(27, 3) COMMENT '销售数量',
    sale_amount         DECIMAL(27, 2) COMMENT '销售金额',
    dis_amount          DECIMAL(27, 2) COMMENT '折扣金额',
    sale_cost           DECIMAL(27, 2) COMMENT '销售成本',
    balance_amount      DECIMAL(27, 2) COMMENT '余额支付金额',
    cancel_sale_amount  DECIMAL(27, 2) COMMENT '取消商品销售金额',
    refund_sale_amount  DECIMAL(27, 2) COMMENT '退款商品销售金额',
    online_order_num    BIGINT COMMENT '线上单量',
    offline_order_num   BIGINT COMMENT '线下单量',
    online_sale_amount  DECIMAL(27, 2) COMMENT '线上销售金额',
    offline_sale_amount DECIMAL(27, 2) COMMENT '线下销售金额',
    online_sale_cost    DECIMAL(27, 2) COMMENT '线上销售成本',
    offline_sale_cost   DECIMAL(27, 2) COMMENT '线下销售成本',
    loss_amount         DECIMAL(27, 2) COMMENT '损耗金额',
    receipt_amount      DECIMAL(27, 2) COMMENT '收货金额（收货-退货-退配+调入-调出）',
    require_amount      DECIMAL(27, 2) COMMENT '要货金额',

    ol_mem_order_num    BIGINT COMMENT '线上会员单量',
    vip_mem_order_num   BIGINT COMMENT '实体卡会员单量',
    ol_mem_sale_amount  DECIMAL(27, 2) COMMENT '线上会员销售金额',
    vip_mem_sale_amount DECIMAL(27, 2) COMMENT '实体卡会员销售金额',
    ol_mem_sale_cost    DECIMAL(27, 2) COMMENT '线上会员销售成本',
    vip_mem_sale_cost   DECIMAL(27, 2) COMMENT '实体卡会员销售成本',
    ol_mem_trade_num    BIGINT COMMENT '线上会员下单人数',
    vip_mem_trade_num   BIGINT COMMENT '实体卡会员下单人数',

    balance_sale_amount DECIMAL(27, 2) COMMENT '使用余额销售金额',
    balance_order_num   BIGINT COMMENT '使用余额单量',
    balance_sale_cost   DECIMAL(27, 2) COMMENT '使用余额的销售成本',
    balance_people_num  BIGINT COMMENT '使用余额的下单人数'
)
COMMENT '门店经营分析刻表'
partitioned by(dt STRING COMMENT '统计时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');