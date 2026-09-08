-- 建库
create database if not exists dwm;
-- 1.会员销售订单表
CREATE TABLE IF NOT EXISTS dwm.dwm_mem_sell_order_i(
    create_time                 STRING COMMENT '订单创建时间',
    trade_date                  STRING COMMENT '交易日期',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',
    hourly                      BIGINT COMMENT '交易小时(0-23)',
    quarter                     BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                    BIGINT COMMENT '刻钟数:hourly*4+quarters',

    parent_order_no             STRING COMMENT '父单订单号/源单号',
    order_no                    STRING COMMENT '订单编号',
    trade_type                  BIGINT COMMENT '结算类型(0.正常交易,1.赠品发放,2.退货,4.培训,5.取消交易)',
    source_type                 BIGINT COMMENT '交易来源1:线下POS;2:三方平台;3:云鲜商城;4:甄选团购;5:云鲜大客户;6:云鲜其他;7:甄选;8:优选海淘;9:优选大客户;10:优选POS;11:优选APP;12:优选H5;13:店长工具线下;14:店长工具线上;15:甄选其他',
    source_type_name            STRING COMMENT '交易来源名称',
    sale_type                   BIGINT COMMENT '销售类型 1.实物,2.代客,3.优选小程序,4.离店,5.云鲜小程序,6.第三方平台,7.其他,8.大客户',
    is_online_order             BIGINT COMMENT '是否为线上单:0否,1是',
    member_type                 BIGINT COMMENT '会员类型:0非会员,1线上会员,2实体卡会员',
    is_balance_consume          BIGINT COMMENT '是否有余额支付:0否,1是',
    order_type                  BIGINT COMMENT '配送类型（真正的订单类型由业务类型来决定）：1-及时送；2-隔日送；3-自提单；4-线下单',
    express_type                BIGINT COMMENT '配送方式：0-三方平台配送；1-自配送；2-快递；3-自提；4-线下',

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

    is_cancel                   BIGINT COMMENT '是否取消',
    cancel_time                 STRING COMMENT '取消时间',
    cancel_reason               STRING COMMENT '取消原因',
    last_update_time            TIMESTAMP COMMENT '最新更新时间',
    
    cashier_no                  STRING COMMENT '收银员编码',
    cashier_name                STRING COMMENT '收银员名称',

    zt_id                       BIGINT COMMENT '中台ID',
    member_id                   BIGINT COMMENT '会员ID',
    card_no                     STRING COMMENT '卡号',
    r_name                      STRING COMMENT '收货人姓名',
    r_province                  STRING COMMENT '收货人省份',
    r_city                      STRING COMMENT '收货人城市',
    r_district                  STRING COMMENT '收货人区域',

    is_tuan_head                BIGINT COMMENT '是否为团长订单',
    store_leader_id             BIGINT COMMENT '团长id',
    order_group_no              STRING COMMENT '团单号',

    settle_amount               DECIMAL(27, 2) COMMENT '结算金额',
    share_user_id               BIGINT COMMENT '分享人用户ID',
    commission_amount           DECIMAL(27, 2) COMMENT '佣金',

    order_total_amount          DECIMAL(27, 2) COMMENT '订单总金额',
    product_total_amount        DECIMAL(27, 2) COMMENT '商品总金额（原价）',
    pack_amount                 DECIMAL(27, 2) COMMENT '餐盒费/打包费',
    delivery_amount             DECIMAL(27, 2) COMMENT '配送费',
    discount_amount             DECIMAL(27, 2) COMMENT '订单优惠金额=商家承担优惠金额+平台补贴金额',
    seller_discount_amount      DECIMAL(27, 2) COMMENT '商家承担优惠金额',
    platform_allowance_amount   DECIMAL(27, 2) COMMENT '平台补贴金额',
    real_paid_amount            DECIMAL(27, 2) COMMENT '实付金额',
    product_discount            DECIMAL(27, 2) COMMENT '商品优惠金额',
    real_product_amount         DECIMAL(27, 2) COMMENT '商品实际金额',
    
    round_amount                DECIMAL(27, 2) COMMENT '舍分金额',       
    wechat_amount               DECIMAL(27, 4) COMMENT '微信支付',
    ali_pay_amount              DECIMAL(27, 4) COMMENT '支付宝支付',
    cash_amount                 DECIMAL(27, 4) COMMENT '现金支付',
    balance_amount              DECIMAL(27, 4) COMMENT '余额支付',
    point_amount                DECIMAL(27, 4) COMMENT '积分支付',
    unionpay_amount             DECIMAL(27, 4) COMMENT '银行支付',
    member_card_amount          DECIMAL(27, 4) COMMENT '线下实体卡支付',
    gift_amount                 DECIMAL(27, 4) COMMENT '礼品卡支付',
    yxapi_amount                DECIMAL(27, 4) COMMENT '云鲜支付',
    other_pay_amount            DECIMAL(27, 4) COMMENT '其他支付' 
)
comment '会员销售订单表'
partitioned by (dt STRING COMMENT '销售日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 2. 会员首次消费表
CREATE TABLE IF NOT EXISTS dwm.dwm_mem_first_buy_i(
    zt_id                       BIGINT COMMENT '中台 会员id',
    trade_date_time             STRING COMMENT '首次消费时间',
    trade_date                  STRING COMMENT '首次消费日期',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',
    
    store_no                    STRING COMMENT '消费门店',
    sale_amount                 DECIMAL(27, 2) COMMENT '消费金额',
    order_no                    STRING COMMENT '订单编号',
    source_type                 BIGINT COMMENT '交易来源'
) 
comment '会员首次消费表'
partitioned by (dt STRING COMMENT '消费日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 3.会员二次消费表
CREATE TABLE IF NOT EXISTS dwm.dwm_mem_second_buy_i(
    zt_id                       BIGINT COMMENT '中台 会员id',
    trade_date_time             STRING COMMENT '第二次消费时间',
    trade_date                  STRING COMMENT '第二次消费日期',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',

    store_no                    STRING COMMENT '消费门店',
    sale_amount                 DECIMAL(27, 2) COMMENT '消费金额',
    order_no                    STRING COMMENT '订单编号',
    source_type                 BIGINT COMMENT '交易来源'
)
comment '会员第二次消费表'
partitioned by (dt STRING COMMENT '消费日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


-- 4.会员行为天表
CREATE TABLE IF NOT EXISTS dwm.dwm_mem_member_behavior_day_i(
    trade_date              STRING COMMENT '时间',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    
    zt_id                   BIGINT COMMENT '中台 会员id',
    bind_md                 STRING COMMENT '归属门店(绑定门店)',
    reg_md                  STRING COMMENT '注册门店',
    reg_time                TIMESTAMP COMMENT '中台 注册时间',
    is_register             BIGINT COMMENT '当日是否注册',
    is_recharge             BIGINT COMMENT '当日是否充值',
    recharge_times          BIGINT COMMENT '充值次数，没有充值则为0',
    recharge_amount         DECIMAL(27, 2) COMMENT '充值金额，没有充值则为0',
    is_consume              BIGINT COMMENT '当日是否消费',
    consume_times           BIGINT COMMENT '消费次数，没有消费则为0',
    consume_amount          DECIMAL(27, 2) COMMENT '消费金额，没有消费则为0',
    is_first_consume        BIGINT COMMENT '当日是否首次消费',
    first_consume_store     STRING COMMENT '首次消费门店，没有则为null',
    first_consume_amount    DECIMAL(27, 2) COMMENT '首次消费金额，没有消费则为0',
    is_balance_consume      BIGINT COMMENT '当日是否余额消费',
    balance_consume_times   BIGINT COMMENT '余额消费次数，没有消费则为0',
    balance_pay_amount      DECIMAL(27, 2) COMMENT '余额支付金额，没有消费则为0',
    balance_consume_amount  DECIMAL(27, 2) COMMENT '余额消费金额，没有消费则为0',
    is_point_consume        BIGINT COMMENT '当日是否积分消费',
    point_consume_times     BIGINT COMMENT '积分消费次数，没有消费则为0',
    point_pay_amount        DECIMAL(27, 2) COMMENT '积分支付金额，没有消费则为0',
    point_consume_amount    DECIMAL(27, 2) COMMENT '积分消费金额，没有消费则为0',
    point_add               BIGINT COMMENT '增加积分，没有则为0',
    point_reduce            BIGINT COMMENT '减少积分，没有则为0',
    point_change            BIGINT COMMENT '变动积分，没有则为0',
    online_consume_times    BIGINT COMMENT '线上订单量',
    online_consume_amount   DECIMAL(27, 2) COMMENT '线上消费金额',
    offline_consume_times   BIGINT COMMENT '线下订单量',
    offline_consume_amount  DECIMAL(27, 2) COMMENT '线下消费金额'
) 
comment '会员行为天表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');