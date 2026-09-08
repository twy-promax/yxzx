-- 建库
create database if not exists dws;
-- 各类会员
CREATE TABLE IF NOT EXISTS dws.dws_mem_store_member_classify_day_i(
    trade_date                   STRING COMMENT '统计时间',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',

    store_no                    STRING COMMENT '店铺编码',
    store_name                  STRING COMMENT '店铺名称',
    store_sale_type             BIGINT COMMENT '店铺销售类型',
    store_type_code             BIGINT COMMENT '分店类型',
    city_id                     BIGINT COMMENT '城市ID',
    city_name                   STRING COMMENT '城市名称',
    region_code                 STRING COMMENT '区域编码',
    region_name                 STRING COMMENT '区域名称',
    is_day_clear                BIGINT COMMENT '是否日清:0否,1是',

    reg_num_add                 BIGINT COMMENT '新增注册会员数',
    reg_num_sum                 BIGINT COMMENT '累计注册会员数',
    consume_num_add             BIGINT COMMENT '新增消费会员数',
    consume_num_sum             BIGINT COMMENT '累计消费会员数',
    repurchase_num_add          BIGINT COMMENT '新增复购会员数',
    repurchase_num_sum          BIGINT COMMENT '累计复购会员数',
    active_member_num           BIGINT COMMENT '活跃会员数',
    sleep_member_num            BIGINT COMMENT '沉睡会员数',
    sale_amount_bind            DECIMAL(27, 2) COMMENT '会员消费金额'
)
comment '门店会员分类天表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


-- 门店会员
CREATE TABLE IF NOT EXISTS dws.dws_mem_store_member_statistics_day_i(
    trade_date                  STRING COMMENT '统计时间',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',

    store_no                    STRING COMMENT '店铺编码',
    store_name                  STRING COMMENT '店铺名称',
    store_sale_type             BIGINT COMMENT '店铺销售类型',
    store_type_code             BIGINT COMMENT '分店类型',
    city_id                     BIGINT COMMENT '城市ID',
    city_name                   STRING COMMENT '城市名称',
    region_code                 STRING COMMENT '区域编码',
    region_name                 STRING COMMENT '区域名称',
    is_day_clear                BIGINT COMMENT '是否日清:0否,1是',

    store_sale_amount           DECIMAL(27, 2) COMMENT '门店销售金额',
    store_orders_number         BIGINT COMMENT '门店总订单量',

    register_member_num         BIGINT COMMENT '当日注册人数',
    register_member_num_all     BIGINT COMMENT '累计注册会员数',
    register_recharge_num       BIGINT COMMENT '当日注册且充值会员数',
    rg_rc_td_num                BIGINT COMMENT '当日注册且充值且消费会员数',
    register_trade_num          BIGINT COMMENT '当日注册且消费会员数',

    recharge_member_num         BIGINT COMMENT '充值会员数',
    recharge_amount             DECIMAL(27, 2) COMMENT '充值金额',
    recharge_amount_all         DECIMAL(27, 2) COMMENT '累计会员充值金额',
    remain_member_num           BIGINT COMMENT '当日有余额的会员人数',
    remain_member_amount        DECIMAL(27, 2) COMMENT '当日会员余额',

    balance_member_num          BIGINT COMMENT '余额消费人数',
    balance_member_order_num    BIGINT COMMENT '余额消费单量',
    balance_pay_amount          DECIMAL(27, 2) COMMENT '余额支付金额',
    balance_member_amount       DECIMAL(27, 2) COMMENT '余额消费金额',

    member_num                  BIGINT COMMENT '会员消费人数',
    member_order_num            BIGINT COMMENT '会员消费单量',
    member_amount               DECIMAL(27, 2) COMMENT '会员消费金额',

    member_first_num            BIGINT COMMENT '会员首单人数',
    member_first_order_num      BIGINT COMMENT '会员首单订单量',
    member_first_amount         DECIMAL(27, 2) COMMENT '会员首单销售额',
    member_nofirst_num          BIGINT COMMENT '会员非首单人数',
    member_nofirst_order_num    BIGINT COMMENT '会员非首单订单量',
    member_nofirst_amount       DECIMAL(27, 2) COMMENT '会员非首单销售额'
)
comment '门店会员统计日表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');