-- 建库
create database if not exists ads;
-- 需求一: 各类会员数量
-- 1.门店会员分类周表
CREATE TABLE IF NOT EXISTS ads.ads_mem_store_member_classify_week_i(
    trade_date                  STRING COMMENT '周一日期',

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
comment '门店会员分类周表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 2.门店会员分类月表
CREATE TABLE IF NOT EXISTS ads.ads_mem_store_member_classify_month_i(
    trade_date                  STRING COMMENT '月一日期',

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
comment '门店会员分类月表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');




-- 需求二:门店会员相关
-- 1.门店会员统计周表
CREATE TABLE IF NOT EXISTS ads.ads_mem_store_member_statistics_week_i(
    trade_date                  STRING COMMENT '周一日期',

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
    remain_member_num           BIGINT COMMENT '当周最后一天有余额的会员人数',
    remain_member_amount        DECIMAL(27, 2) COMMENT '当周最后一天会员余额',

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
comment '门店会员统计周表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


-- 2.门店会员统计月表
CREATE TABLE IF NOT EXISTS ads.ads_mem_store_member_statistics_month_i(
    trade_date                  STRING COMMENT '月一日期',

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
    remain_member_num           BIGINT COMMENT '当月最后一天有余额的会员人数',
    remain_member_amount        DECIMAL(27, 2) COMMENT '当月最后一天会员余额',

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
    member_nofirst_num          BIGINT COMMENT '会员非首单人数（非去重）',
    member_nofirst_order_num    BIGINT COMMENT '会员非首单订单量',
    member_nofirst_amount       DECIMAL(27, 2) COMMENT '会员非首单销售额'
)
comment '门店会员统计月表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 需求: 会员其他需求
-- 1.会员首次充值表
CREATE TABLE IF NOT EXISTS ads.ads_mem_member_first_recharge_i(
    trade_date_time     STRING COMMENT '交易时间',
    trade_date          STRING COMMENT '日期',
    trade_order_id      STRING COMMENT '对应的交易单id',
    zt_id               BIGINT COMMENT '中台 会员id',
    store_no            STRING COMMENT '门店编号',
    city_id             BIGINT COMMENT '城市ID',
    recharge_amount     DECIMAL(27, 2) COMMENT '充值金额'
)
comment '会员首次充值表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 2.门店新老会员消费月表
CREATE TABLE IF NOT EXISTS ads.ads_mem_store_new_old_member_month_i(
    trade_date                  STRING COMMENT '月一时间',
    store_no                    STRING COMMENT '店铺编码',
    store_name                  STRING COMMENT '店铺名称',
    store_sale_type             BIGINT COMMENT '店铺销售类型',
    store_type_code             BIGINT COMMENT '分店类型',
    city_id                     BIGINT COMMENT '城市ID',
    city_name                   STRING COMMENT '城市名称',
    region_code                 STRING COMMENT '区域编码',
    region_name                 STRING COMMENT '区域名称',
    is_day_clear                BIGINT COMMENT '是否日清:0否,1是',

    member_type                 BIGINT COMMENT '会员类型:1新会员,2老会员,3会员,4非会员',
    member_num                  BIGINT COMMENT '消费会员数',
    sale_amount                 DECIMAL(27, 2) COMMENT '消费金额',
    order_num                   BIGINT COMMENT '消费单量'
)
comment '门店新老会员消费月表'
partitioned by (dt STRING COMMENT '消费日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


-- 3.会员复购天表
CREATE TABLE IF NOT EXISTS ads.ads_mem_repurchase_day_i(
    trade_date                  STRING COMMENT '统计时间',

    store_no                    STRING COMMENT '店铺编码',
    store_name                  STRING COMMENT '店铺名称',
    store_sale_type             BIGINT COMMENT '店铺销售类型',
    store_type_code             BIGINT COMMENT '分店类型',
    city_id                     BIGINT COMMENT '城市ID',
    city_name                   STRING COMMENT '城市名称',
    region_code                 STRING COMMENT '区域编码',
    region_name                 STRING COMMENT '区域名称',
    is_day_clear                BIGINT COMMENT '是否日清:0否,1是',

    member_count                BIGINT COMMENT '统计日期用户量',
    next_member_count_1         BIGINT COMMENT '一日后用户量',
    next_member_count_2         BIGINT COMMENT '二日后用户量',
    next_member_count_3         BIGINT COMMENT '三日后用户量',
    next_member_count_4         BIGINT COMMENT '四日后用户量',
    next_member_count_5         BIGINT COMMENT '五日后用户量',
    next_member_count_6         BIGINT COMMENT '六日后用户量'
)
comment '会员复购统计天表'
partitioned by (dt STRING COMMENT '消费日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


-- 4.会员贡献天表
CREATE TABLE IF NOT EXISTS ads.ads_mem_contribution_day_i(
    trade_date                  STRING COMMENT '统计时间',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',

    zt_id                       BIGINT COMMENT '会员id',
    store_no                    STRING COMMENT '店铺编码',
    store_name                  STRING COMMENT '店铺名称',
    store_sale_type             BIGINT COMMENT '店铺销售类型',
    store_type_code             BIGINT COMMENT '分店类型',
    city_id                     BIGINT COMMENT '城市ID',
    city_name                   STRING COMMENT '城市名称',
    region_code                 STRING COMMENT '区域编码',
    region_name                 STRING COMMENT '区域名称',
    is_day_clear                BIGINT COMMENT '是否日清:0否,1是',

    consume_times               BIGINT  COMMENT '消费单量',
    consume_amount              DECIMAL(27, 2) COMMENT '消费金额',
    consume_cost                DECIMAL(27, 2) COMMENT '消费成本',
    online_consume_times        BIGINT COMMENT '线上订单量',
    online_consume_amount       DECIMAL(27, 2) COMMENT '线上消费金额',
    online_consume_cost         DECIMAL(27, 2) COMMENT '线上消费成本',
    offline_consume_times       BIGINT COMMENT '线下订单量',
    offline_consume_amount      DECIMAL(27, 2) COMMENT '线下消费金额',
    offline_consume_cost        DECIMAL(27, 2) COMMENT '线下消费成本'
)
comment '会员贡献天表'
partitioned by (dt STRING COMMENT '消费日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');