drop database if exists dwd cascade ;
CREATE DATABASE IF NOT EXISTS dwd;


CREATE TABLE IF NOT EXISTS dwd.dwd_sale_store_sale_dtl_i(
	-- 门店销售信息表
    trade_date_time         timestamp comment '销售时间',
    trade_date       timestamp comment '交易日期',

    -- 时间维度表
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',

    -- 门店销售信息表 
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',
    parent_store_no         STRING COMMENT '母店编码',
    store_no                STRING COMMENT '店铺编码',

    -- 门店表
    store_name              STRING COMMENT '店铺名称',
    store_sale_type         BIGINT COMMENT '店铺销售类型',
    store_type_code         BIGINT COMMENT '分店类型',
    worker_num              BIGINT COMMENT '员工人数',
    store_area              DECIMAL(27, 2) COMMENT '门店面积',
    city_id                 BIGINT COMMENT '城市ID',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',
    region_name             STRING COMMENT '区域名称',
    is_day_clear            BIGINT COMMENT '是否日清:0否,1是',

	-- 门店销售信息表
    trade_type              BIGINT COMMENT '结算类型(0.正常交易,1.赠品发放,2.退货,4.培训,5.取消交易)',

    -- 交易类型映射表
    source_type             BIGINT COMMENT '交易来源1:线下POS;2:三方平台;3:云鲜商城;4:甄选团购;5:云鲜大客户;6:云鲜其他;7:甄选;8:优选海淘;9:优选大客户;10:优选POS;11:优选APP;12:优选H5;13:店长工具线下;14:店长工具线上;15:甄选其他',
    source_type_name        STRING COMMENT '交易来源名称',

    -- 门店销售信息表
    sale_type               BIGINT COMMENT '销售类型 1.实物,2.代客,3.优选小程序,4.离店,5.云鲜小程序,6.第三方平台,7.其他,8.大客户',
    member_type             BIGINT COMMENT '会员类型:0非会员,1线上会员,2实体卡会员',
    is_balance_consume      BIGINT COMMENT '是否有余额支付:0否,1是',
    parent_order_no         STRING COMMENT '母订单编号',
    order_no                STRING COMMENT '订单编号',
    pos_no                  STRING COMMENT 'Pos机号',
    ser_id                  STRING COMMENT 'POS机当天序号从1开始递增',
    item                    BIGINT COMMENT '商品在小票的位置',
    `sort`                  BIGINT COMMENT '组合商品分割商品拆出位置',
    pay_time                STRING COMMENT '支付时间',
    last_update_time        STRING COMMENT '最后更新时间',
    cashier_no              STRING COMMENT '收银员编码',
    cashier_name            STRING COMMENT '收银员名称',
    share_user_id           STRING COMMENT '分享人用户ID',
    commission_amount       DECIMAL(27, 2) COMMENT '佣金',

    zt_id                   BIGINT COMMENT '中台ID',
    member_id               BIGINT COMMENT '会员ID',
    card_no                 STRING COMMENT '卡号',
	-- 商品表
    first_category_no       STRING COMMENT '一级分类编码',
    first_category_name     STRING COMMENT '一级分类名称',
    second_category_no      STRING COMMENT '二级分类编码',
    second_category_name    STRING COMMENT '二级分类名称',
    third_category_no       STRING COMMENT '三级分类编码',
    third_category_name     STRING COMMENT '三级分类名称',

    -- 门店销售明细表
    goods_no                STRING COMMENT '商品编码',

    -- 商品表
    goods_name              STRING COMMENT '商品名称',
    spec                    STRING COMMENT '单位',

    -- 门店销售明细表
    is_component            BIGINT COMMENT '是否为组合商品:0否,1是',

	-- 门店商品表
    supply_team             BIGINT COMMENT '供应链团队 1.平台商品,2.优选标品,3.云鲜标品,4.云鲜生鲜,5优选POS商品',
    dc_no                   STRING COMMENT '采购仓库编号',
    dc_name                 STRING COMMENT '采购仓库名称',
    group_no                STRING COMMENT '采购柜组编号',
    group_name              STRING COMMENT '采购柜组名称',

    -- 门店销售明细表
    trade_mode_id           BIGINT COMMENT '结算方式:1购销,2联营',
    vendor_id               BIGINT COMMENT '供应商ID',
    contract_no             STRING COMMENT '合同编号',

    -- 门店商品表
    is_clean                BIGINT COMMENT '商品是否日清:0否,1是',

    -- 门店销售明细表
    is_daily_clear          BIGINT COMMENT '商品是否参加日清活动:0否,1是',
    sale_qty                DECIMAL(27, 3) COMMENT '商品销售数量',
    sale_amount             DECIMAL(27, 2) COMMENT '商品销售金额',
    dis_amount              DECIMAL(27, 2) COMMENT '商品折扣金额',
    sale_cost               DECIMAL(27, 2) COMMENT '商品销售成本',

    -- 门店销售支付表
    balance_amount          DECIMAL(27, 2) COMMENT '余额支付',

	-- 当前写入时间: current_timestamp
    write_time              TIMESTAMP COMMENT '写入时间'
)
COMMENT '门店销售明细表'
partitioned by(dt STRING COMMENT '核销日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_sale_shop_sale_balance_pay_i(
    store_no                STRING COMMENT '门店编码',
    store_name              STRING COMMENT '门店名称',
    trade_date              TIMESTAMP COMMENT '交易日期',
    member_id               BIGINT COMMENT '会员ID',
    zt_id                   BIGINT COMMENT '中台会员ID',
    trade_order_id          STRING COMMENT '关联的交易单ID',
    pay_order_id            STRING COMMENT '支付单id',
    order_no                STRING COMMENT '订单号',
    pay_channel             STRING COMMENT '支付渠道',
    pay_channel_name        STRING COMMENT '支付渠道名称',
    trade_order_type        BIGINT COMMENT '交易单类型，1消费,2充值,3提现,4退货退款',
    trade_order_type_name   STRING COMMENT '交易单类型名称',
    pay_amount              DECIMAL(27, 2) COMMENT '支付对等RMB的金额，比如是积分支付，那这里就是积分所对应的RMB的金额',
    trade_merchant          STRING COMMENT '交易商家'
)
COMMENT '线上余额支付明细'
partitioned by (dt STRING COMMENT '交易日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_sold_shop_order_i(
    id                      BIGINT COMMENT '编号',
    parent_order_no         STRING COMMENT '父单订单号',
    order_id                STRING COMMENT '订单编号',
    is_split                BIGINT COMMENT '是否拆单：0-不需要拆单；1-待拆单；2-已拆单',
    platform_id             BIGINT COMMENT '平台id：1-有赞，2-京东到家，3-美团外卖，4-饿了么',
    tid                     STRING COMMENT '平台订单号',
    source_type             BIGINT COMMENT '订单来源：10,20,30,40,41,50,60,70',
    source_name             STRING COMMENT '订单来源名称：10-有赞，20-京东到家，30-美团外卖，40-饿了么，41-百度外卖，50-云鲜精选，60-甄选，70-抖店',
    store_no                STRING COMMENT '门店编码',
    city_id                 BIGINT COMMENT '城市编号',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',

    order_status            BIGINT,
    order_status_desc       STRING COMMENT '主订单状态描述：0-新建; 1-待出票；2-待备货；3-待揽件；4-待自提; 5-配送中；6-已完成；7-已取消',
    pay_type                BIGINT COMMENT '支付类型：1-线下支付；2-线上支付',
    trade_type              STRING COMMENT '交易类型。取值范围：fixed(一口价) gift(送礼）bulk_purchase（来自分销商的采购）present （赠品领取）group （拼团订单） pifa （批发订单） cod （货到付款） peer （代付） qrcode（扫码商家二维码直接支付的交易）qrcode_3rd（线下收银台二维码交易)',
    is_deleted              BIGINT COMMENT '是否有效，1：已删除，0：正常',

    order_create_time       TIMESTAMP COMMENT '平台订单创建时间',
    order_pay_time          TIMESTAMP COMMENT '订单支付时间',
    create_time             TIMESTAMP COMMENT '创建时间',
    print_status            BIGINT COMMENT '打印状态：0-未打票;1-已打票',
    print_time              TIMESTAMP COMMENT '出票时间',
    stock_up_status         BIGINT COMMENT '门店处理状态：0-待备货/1-已备货',
    stock_up_time           TIMESTAMP COMMENT '备货完成时间',

    order_type              BIGINT COMMENT '配送类型（真正的订单类型由业务类型来决定）：1-及时送；2-隔日送；3-自提单',
    express_type            BIGINT COMMENT '配送方式：0-三方平台配送；1-自配送；2-快递；3-自提',
    receive_time            TIMESTAMP COMMENT '要求送达/自提时间',
    express_code            STRING COMMENT '配送单号',
    delivery_status         BIGINT COMMENT '配送状态：0-待配送；1-配送中；2-已送达',
    delivery_time           TIMESTAMP COMMENT '配送时间',
    pick_up_status          BIGINT COMMENT '自提状态：0-待自提；1-已自提',
    qr_code                 STRING COMMENT 'qr提货码',
    pick_up_time            TIMESTAMP COMMENT '自提时间',

    complete_time           TIMESTAMP COMMENT '订单完结时间',
    is_cancel               BIGINT COMMENT '是否取消',
    cancel_time             TIMESTAMP COMMENT '取消时间',
    cancel_reason           STRING COMMENT '取消原因',
    refund_status           BIGINT COMMENT '退款状态：0未退款，1部分退款，2已全额退款',
    refund_time             TIMESTAMP COMMENT '已退款时间',
    last_update_time        TIMESTAMP COMMENT '最新更新时间',

    order_total_amount      DECIMAL(27, 2) COMMENT '订单总金额',
    product_total_amount    DECIMAL(27, 2) COMMENT '商品总金额（原价）',
    pack_amount             DECIMAL(27, 2) COMMENT '餐盒费/打包费',
    delivery_amount         DECIMAL(27, 2) COMMENT '配送费',
    discount_amount         DECIMAL(27, 2) COMMENT '订单优惠金额=商家承担优惠金额+平台补贴金额',
    seller_discount_amount  DECIMAL(27, 2) COMMENT '商家承担优惠金额',
    platform_allowance_amount DECIMAL(27, 2) COMMENT '平台补贴金额',
    real_paid_amount        DECIMAL(27, 2) COMMENT '实付金额',
    product_discount        DECIMAL(27, 2) COMMENT '商品优惠金额',
    real_product_amount     DECIMAL(27, 2) COMMENT '商品实际金额',

    buyer_id                BIGINT COMMENT '买家id',
    buyer_phone             STRING COMMENT '买家电话',
    buyer_remark            STRING COMMENT '买家备注',
    r_name                  STRING COMMENT '收货人姓名',
    r_tel                   STRING COMMENT '收货人电话',
    r_province              STRING COMMENT '收货人省份',
    r_city                  STRING COMMENT '收货人城市',
    r_district              STRING COMMENT '收货人区域',
    r_address               STRING COMMENT '收货人地址',
    r_zipcode               STRING COMMENT '收货人邮编',

    is_tuan_head            BIGINT COMMENT '是否为团长订单',
    store_leader_id         BIGINT COMMENT '团长id',
    order_group_no          STRING COMMENT '团单号',
    commision_amount        DECIMAL(27, 2) COMMENT '抽佣金额',
    settle_amount           DECIMAL(27, 2) COMMENT '结算金额',

    points_amount           DECIMAL(27, 2) COMMENT '积分抵扣金额',
    pay_point               BIGINT COMMENT '消费积分数',
    balance_amount          DECIMAL(27, 2) COMMENT '余额扣除金额',
    pay_channel_amount      DECIMAL(27, 2) COMMENT '通过支付渠道支付的金额',
    point_amount            DECIMAL(27, 2) COMMENT '消费赠送积分',

    sync_erp_status         BIGINT COMMENT '同步erp状态',
    sync_erp_msg            STRING COMMENT '同步erp失败消息'
)
COMMENT '商城订单表(核销表)'
partitioned by (dt STRING COMMENT '完成日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');


CREATE TABLE IF NOT EXISTS dwd.dwd_sold_shop_order_item_i(
    id                          BIGINT COMMENT '自增id',
    order_id                    STRING COMMENT '订单编号',
    goods_no                    STRING COMMENT '商品编码',
    goods_name                  STRING COMMENT '商品名称',

    weight                      DECIMAL(27, 3) COMMENT '重量，单位kg',
    quantity                    BIGINT COMMENT '数量',
    unit                        STRING COMMENT '单位',
    sale_qty                    DECIMAL(27, 3) COMMENT '销售数量',
    disp_price                  DECIMAL(27, 2) COMMENT 'sku展示价格',
    pay_price                   DECIMAL(27, 2) COMMENT '价格',
    sale_amount                 DECIMAL(27, 2) COMMENT '单品销售金额',
    dis_amount                  DECIMAL(27, 2) COMMENT '单品总折扣金额',
    sale_cost                   DECIMAL(27, 2) COMMENT '销售成本',

    sale_type                   BIGINT COMMENT '类型：1-常规；2-赠品',
    create_time                 TIMESTAMP COMMENT '创建时间',
    complete_time               TIMESTAMP COMMENT '完成时间',
    last_update_time            TIMESTAMP COMMENT '更新时间',

    activity_plat_city_goods_id BIGINT COMMENT '活动商品区域id',
    activity_type               BIGINT COMMENT '活动类型(11:拼团 21:秒杀)',
    item_goods_key              STRING COMMENT '虚拟字段，itemgoodskey',
    is_deleted                  BIGINT COMMENT '是否删除：0-否；1-删除',

    transfer_paper_no           STRING COMMENT '要货单号',
    serial_no                   BIGINT COMMENT '商品序号，每个订单下起始都为1',
    is_delivery                 BIGINT COMMENT '仓发是否配送；1:配送',
    goods_source_type           BIGINT COMMENT '商品来源类型：1-生鲜品；2-标品',

    trade_mode_id               BIGINT COMMENT '结算方式:1购销,2联营',
    vendor_id                   BIGINT COMMENT '供应商ID',
    contract_no                 STRING COMMENT '合同编号'
)
COMMENT '订单明细表（核销表）'
partitioned by (dt STRING COMMENT '完成日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_sold_shop_order_dtl_i(
    complete_time           STRING COMMENT '订单完成时间',
    trade_date              STRING COMMENT '交易日期',
    -- 日期表
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',
    
    parent_order_no         STRING COMMENT '父单订单号/源单号',
    order_id                STRING COMMENT '订单编号',
    trade_type              BIGINT COMMENT '结算类型(0.正常交易,1.赠品发放,2.退货,4.培训,5.取消交易)',
    is_split                BIGINT COMMENT '是否拆单：0-不需要拆单；1-待拆单；2-已拆单',
    platform_id             BIGINT COMMENT '平台id：1-有赞，2-京东到家，3-美团外卖，4-饿了么',
    tid                     STRING COMMENT '平台订单号',
    source_type             BIGINT COMMENT '订单来源：10,20,30,40,41,50,60,70',
    source_name             STRING COMMENT '订单来源名称：10-有赞，20-京东到家，30-美团外卖，40-饿了么，41-百度外卖，50-云鲜精选，60-甄选，70-抖店',
    order_type              BIGINT COMMENT '配送类型（真正的订单类型由业务类型来决定）：1-及时送；2-隔日送；3-自提单',
    express_type            BIGINT COMMENT '配送方式：0-三方平台配送；1-自配送；2-快递；3-自提',
    
    order_status            BIGINT,
    order_status_desc       STRING COMMENT '主订单状态描述：0-新建; 1-待出票；2-待备货；3-待揽件；4-待自提; 5-配送中；6-已完成；7-已取消',
    pay_type                BIGINT COMMENT '支付类型：1-线下支付；2-线上支付',
    is_balance_consume      BIGINT COMMENT '是否余额支付：1是，0否',
    
    store_no                STRING COMMENT '店铺编码',
    -- 分店信息表
    store_name              STRING COMMENT '店铺名称',
    store_sale_type         BIGINT COMMENT '店铺销售类型',
    store_type_code         BIGINT COMMENT '分店类型',
    worker_num              BIGINT COMMENT '员工人数',
    store_area              DECIMAL(27, 2) COMMENT '门店面积',
    city_id                 BIGINT COMMENT '城市ID',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',
    region_name             STRING COMMENT '区域名称',
    is_day_clear            BIGINT COMMENT '是否日清:0否,1是',
    
    order_create_time       TIMESTAMP COMMENT '平台订单创建时间',
    order_pay_time          TIMESTAMP COMMENT '订单支付时间',
    create_time             TIMESTAMP COMMENT '创建时间',
    is_cancel               BIGINT COMMENT '是否取消',
    cancel_time             TIMESTAMP COMMENT '取消时间',
    cancel_reason           STRING COMMENT '取消原因',
    last_update_time        TIMESTAMP COMMENT '最新更新时间',
    -- 会员基础信息表
    zt_id                   BIGINT COMMENT '中台ID',
    
    buyer_id                BIGINT COMMENT '买家id',
    buyer_phone             STRING COMMENT '买家电话',
    buyer_remark            STRING COMMENT '买家备注',
    r_name                  STRING COMMENT '收货人姓名',
    r_tel                   STRING COMMENT '收货人电话',
    r_province              STRING COMMENT '收货人省份',
    r_city                  STRING COMMENT '收货人城市',
    r_district              STRING COMMENT '收货人区域',
    r_address               STRING COMMENT '收货人地址',
    r_zipcode               STRING COMMENT '收货人邮编',
    
    is_tuan_head            BIGINT COMMENT '是否为团长订单',
    store_leader_id         BIGINT COMMENT '团长id',
    order_group_no          STRING COMMENT '团单号',
    commission_amount       DECIMAL(27, 2) COMMENT '抽佣金额',
    settle_amount           DECIMAL(27, 2) COMMENT '结算金额',
   	-- 商品表 
    first_category_no       STRING COMMENT '一级分类编码',
    first_category_name     STRING COMMENT '一级分类名称',
    second_category_no      STRING COMMENT '二级分类编码',
    second_category_name    STRING COMMENT '二级分类名称',
    third_category_no       STRING COMMENT '三级分类编码',
    third_category_name     STRING COMMENT '三级分类名称',
    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    
    weight                  DECIMAL(27, 3) COMMENT '重量，单位kg',
    quantity                DECIMAL(27, 3) COMMENT '数量',
    unit                    STRING COMMENT '单位',
    sale_qty                DECIMAL(27, 3) COMMENT '销售数量',
    disp_price              DECIMAL(27, 2) COMMENT 'sku展示价格',
    pay_price               DECIMAL(27, 2) COMMENT '价格',
    sale_amount             DECIMAL(27, 2) COMMENT '单品销售金额',
    dis_amount              DECIMAL(27, 2) COMMENT '单品总折扣金额',
    sale_cost               DECIMAL(27, 2) COMMENT '销售成本',
    
    sale_type               BIGINT COMMENT '类型：1-常规；2-赠品',
    activity_plat_city_goods_id BIGINT COMMENT '活动商品区域id',
    activity_type           BIGINT COMMENT '活动类型(11:拼团 21:秒杀)',
    
    order_total_amount      DECIMAL(27, 2) COMMENT '订单总金额(平摊)',
    order_discount_amount   DECIMAL(27, 2) COMMENT '订单优惠金额=商家承担优惠金额+平台补贴金额(平摊)',
    order_paid_amount       DECIMAL(27, 2) COMMENT '实付金额(平摊)',
    balance_amount          DECIMAL(27, 2) COMMENT '余额支付',
    -- 门店商品信息表
    supply_team             BIGINT COMMENT '供应链团队 1.平台商品,2.优选标品,3.云鲜标品,4.云鲜生鲜,5优选POS商品',
    dc_no                   STRING COMMENT '采购仓库编号',
    dc_name                 STRING COMMENT '采购仓库名称',
    group_no                STRING COMMENT '采购柜组编号',
    group_name              STRING COMMENT '采购柜组名称',
    
    trade_mode_id           BIGINT COMMENT '结算方式:1购销,2联营',
    vendor_id               BIGINT COMMENT '供应商ID',
    contract_no             STRING COMMENT '合同编号'
)
COMMENT '商城核销明细表'
partitioned by (dt STRING COMMENT '核销日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_stock_store_stock_adj_i(
    trade_date              STRING COMMENT '库存处理日期',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                      BIGINT COMMENT '主键',
    uid                     STRING COMMENT '唯一标识',
    order_id                STRING COMMENT '库调单号',
    order_source            BIGINT COMMENT '下单来源，小程序、pc等', 

    store_no                STRING COMMENT '店铺编码',
    store_name              STRING COMMENT '店铺名称',
    store_sale_type         BIGINT COMMENT '店铺销售类型',
    store_type_code         BIGINT COMMENT '分店类型',
    worker_num              BIGINT COMMENT '员工人数',
    store_area              DECIMAL(27, 2) COMMENT '门店面积',
    city_id                 BIGINT COMMENT '城市ID',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',
    region_name             STRING COMMENT '区域名称',
    is_day_clear            BIGINT COMMENT '是否日清:0否,1是',

    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    adj_type_big            STRING COMMENT '库调类型（大类）',
    adj_type_small          STRING COMMENT '库调类型（小类）',
    adj_reason_big          STRING COMMENT '库调原因（大类）',
    adj_reason_small        STRING COMMENT '库调原因（小类）',
    adj_qty                 DECIMAL(27, 3) COMMENT '库调数量',
    adj_price               DECIMAL(27, 2) COMMENT '库调单价',
    adj_amount              DECIMAL(27, 2) COMMENT '库调金额',
    create_time             TIMESTAMP COMMENT '创建时间',
    stock_deal_time         TIMESTAMP COMMENT '库存处理时间',
    sync_time               TIMESTAMP COMMENT '数据同步时间',
    vendor_no               STRING COMMENT '供应商编码',
    vendor_name             STRING COMMENT '供应商名称'
) 
COMMENT '门店库调单'
partitioned by(dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_order_store_receive_i(
    trade_date              STRING COMMENT '库存处理日期',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                      BIGINT COMMENT '主键',
    uid                     STRING COMMENT '唯一标识',
    order_id                STRING COMMENT '收货单号',
    order_source            BIGINT COMMENT '下单来源，小程序、pc等',

    store_no                STRING COMMENT '店铺编码',
    store_name              STRING COMMENT '店铺名称',
    store_sale_type         BIGINT COMMENT '店铺销售类型',
    store_type_code         BIGINT COMMENT '分店类型',
    worker_num              BIGINT COMMENT '员工人数',
    store_area              DECIMAL(27, 2) COMMENT '门店面积',
    city_id                 BIGINT COMMENT '城市ID',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',
    region_name             STRING COMMENT '区域名称',
    is_day_clear            BIGINT COMMENT '是否日清:0否,1是',

    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    dc_no                   STRING COMMENT '配送中心编码',
    dc_name                 STRING COMMENT '配送中心名称',
    vendor_no               STRING COMMENT '供应商编码',
    vendor_name             STRING COMMENT '供应商名称',
    order_type              BIGINT COMMENT '订单类型，1-直送，2-配送，3-代发',
    receive_price           DECIMAL(27, 2) COMMENT '收货价',
    receive_qty             DECIMAL(27, 3) COMMENT '收货数量',
    git_qty                 DECIMAL(27, 3) COMMENT '赠品数量',
    create_time             TIMESTAMP COMMENT '创建时间',
    stock_deal_time         TIMESTAMP COMMENT '库存处理时间',
    dc_send_order_id        STRING COMMENT '仓库发货单号',
    red_order_id            STRING COMMENT '被红冲单号',
    contract_no             STRING COMMENT '合同编号',
    contract_name           STRING COMMENT '合同名称',
    trade_mode              BIGINT COMMENT '1-直营，2-联营',
    order_source_type       BIGINT COMMENT '订货标识，0-门店订货，1-采购配货',
    sync_time               TIMESTAMP COMMENT '数据同步时间'
)
COMMENT '门店收货单'
partitioned by (dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_order_store_return_to_vendor_i(
    trade_date              STRING COMMENT '库存处理日期',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                      BIGINT COMMENT '主键',
    uid                     STRING COMMENT '唯一标识',
    order_id                STRING COMMENT '退配单号',
    order_source            BIGINT COMMENT '下单来源，小程序、pc、智能补货、系统等',

    store_no                STRING COMMENT '门店编码',
    store_name              STRING COMMENT '门店名称',
    store_sale_type         BIGINT COMMENT '店铺销售类型',
    store_type_code         BIGINT COMMENT '分店类型',
    worker_num              BIGINT COMMENT '员工人数',
    store_area              DECIMAL(27, 2) COMMENT '门店面积',
    city_id                 BIGINT COMMENT '城市ID',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',
    region_name             STRING COMMENT '区域名称',
    is_day_clear            BIGINT COMMENT '是否日清:0否,1是',

    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    dc_no                   STRING COMMENT '配送中心编码',
    dc_name                 STRING COMMENT '配送中心名称',
    vendor_no               STRING COMMENT '供应商编码',
    vendor_name             STRING COMMENT '供应商名称',
    return_price            DECIMAL(27, 2) COMMENT '退配价',
    return_qty              DECIMAL(27, 3) COMMENT '退配数量',
    create_time             TIMESTAMP COMMENT '创建时间',
    stock_deal_time         TIMESTAMP COMMENT '库存处理时间',
    original_order_id       STRING COMMENT '退配原单号',
    is_fresh                BIGINT COMMENT '是否为生鲜店，0-否，1-是',
    is_entity               BIGINT COMMENT '是否实物退回，0-否，1-是',
    responsible_person      STRING COMMENT '责任归属方',
    return_reason_big       STRING COMMENT '退配原因（大类）',
    return_desc_big         STRING COMMENT '退配说明（大类）',
    return_reason_small     STRING COMMENT '退配原因（小类）',
    return_desc_small       STRING COMMENT '退配说明（小类）',
    sync_time               TIMESTAMP COMMENT '数据同步时间'
)
COMMENT '门店退货单'
partitioned by (dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_order_store_return_to_dc_i(
    trade_date              STRING COMMENT '库存处理日期',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                      BIGINT COMMENT '主键',
    uid                     STRING COMMENT '唯一标识',
    order_id                STRING COMMENT '退配单号',
    order_source            BIGINT COMMENT '下单来源，小程序、pc、智能补货、系统等',

    store_no                STRING COMMENT '门店编码',
    store_name              STRING COMMENT '门店名称',
    store_sale_type         BIGINT COMMENT '店铺销售类型',
    store_type_code         BIGINT COMMENT '分店类型',
    worker_num              BIGINT COMMENT '员工人数',
    store_area              DECIMAL(27, 2) COMMENT '门店面积',
    city_id                 BIGINT COMMENT '城市ID',
    city_name               STRING COMMENT '城市名称',
    region_code             STRING COMMENT '区域编码',
    region_name             STRING COMMENT '区域名称',
    is_day_clear            BIGINT COMMENT '是否日清:0否,1是',

    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    dc_no                   STRING COMMENT '配送中心编码',
    dc_name                 STRING COMMENT '配送中心名称',
    vendor_no               STRING COMMENT '供应商编码',
    vendor_name             STRING COMMENT '供应商名称',
    return_price            DECIMAL(27, 2) COMMENT '退配价',
    return_qty              DECIMAL(27, 3) COMMENT '退配数量',
    create_time             TIMESTAMP COMMENT '创建时间',
    stock_deal_time         TIMESTAMP COMMENT '库存处理时间',
    original_order_id       STRING COMMENT '退配原单号',
    is_fresh                BIGINT COMMENT '是否为生鲜店，0-否，1-是',
    is_entity               BIGINT COMMENT '是否实物退回，0-否，1-是',
    responsible_person      STRING COMMENT '责任归属方',
    return_reason_big       STRING COMMENT '退配原因（大类）',
    return_desc_big         STRING COMMENT '退配说明（大类）',
    return_reason_small     STRING COMMENT '退配原因（小类）',
    return_desc_small       STRING COMMENT '退配说明（小类）',
    sync_time               TIMESTAMP COMMENT '数据同步时间',
    batch_type_id           STRING COMMENT '批次类型id'
)
COMMENT '门店退配单'
partitioned by (dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_order_store_alloc_in_i(
    trade_date                  STRING COMMENT '库存处理日期',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',
    hourly                      BIGINT COMMENT '交易小时(0-23)',
    quarter                     BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                    BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                          BIGINT COMMENT '主键',
    uid                         STRING COMMENT '唯一标识',
    order_id                    STRING COMMENT '调拨单号',
    order_source                BIGINT COMMENT '下单来源，小程序、PC等',

    goods_no                    STRING COMMENT '商品编码',
    goods_name                  STRING COMMENT '商品名称',

    alloc_in_store_no           STRING COMMENT '调入门店编码',
    alloc_in_store_name         STRING COMMENT '调入门店名称',
    alloc_in_store_sale_type    BIGINT COMMENT '调入店铺销售类型',
    alloc_in_store_type_code    BIGINT COMMENT '调入分店类型',
    alloc_in_worker_num         BIGINT COMMENT '调入门店员工人数',
    alloc_in_store_area         DECIMAL(27, 2) COMMENT '调入门店面积',
    alloc_in_city_id            BIGINT COMMENT '调入门店城市ID',
    alloc_in_city_name          STRING COMMENT '调入门店城市名称',
    alloc_in_region_code        STRING COMMENT '调入门店区域编码',
    alloc_in_region_name        STRING COMMENT '调入门店区域名称',
    alloc_in_is_day_clear       BIGINT COMMENT '调入门店是否日清:0否,1是',

    alloc_out_store_no          STRING COMMENT '调出门店编码',
    alloc_out_store_name        STRING COMMENT '调出门店名称',
    alloc_price                 DECIMAL(27, 2) COMMENT '调拨单价',
    alloc_qty                   DECIMAL(27, 3) COMMENT '调拨数量',
    alloc_reason                STRING COMMENT '调拨原因',
    alloc_amount                DECIMAL(27, 2) COMMENT '调拨金额',
    create_time                 TIMESTAMP COMMENT '创建时间',
    stock_deal_time             TIMESTAMP COMMENT '库存处理时间',
    sync_time                   TIMESTAMP COMMENT '数据同步时间',
    vendor_no                   STRING COMMENT '供应商编码',
    vendor_name                 STRING COMMENT '供应商名称'
)
COMMENT '门店调入单'
partitioned by (dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_order_store_alloc_out_i(
    trade_date                   STRING COMMENT '库存处理日期',
    week_trade_date              STRING COMMENT '周一日期',
    month_trade_date             STRING COMMENT '月一日期',
    hourly                       BIGINT COMMENT '交易小时(0-23)',
    quarter                      BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                     BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                           BIGINT COMMENT '主键',
    uid                          STRING COMMENT '唯一标识',
    order_id                     STRING COMMENT '调拨单号',
    order_source                 BIGINT COMMENT '下单来源，小程序、PC等',

    goods_no                     STRING COMMENT '商品编码',
    goods_name                   STRING COMMENT '商品名称',

    alloc_in_store_no            STRING COMMENT '调入门店编码',
    alloc_in_store_name          STRING COMMENT '调入门店名称',

    alloc_out_store_no           STRING COMMENT '调出门店编码',
    alloc_out_store_name         STRING COMMENT '调出门店名称',
    alloc_out_store_sale_type    BIGINT COMMENT '调出店铺销售类型',
    alloc_out_store_type_code    BIGINT COMMENT '调出分店类型',
    alloc_out_worker_num         BIGINT COMMENT '调出门店员工人数',
    alloc_out_store_area         DECIMAL(27, 2) COMMENT '调出门店面积',
    alloc_out_city_id            BIGINT COMMENT '调出门店城市ID',
    alloc_out_city_name          STRING COMMENT '调出门店城市名称',
    alloc_out_region_code        STRING COMMENT '调出门店区域编码',
    alloc_out_region_name        STRING COMMENT '调出门店区域名称',
    alloc_out_is_day_clear       BIGINT COMMENT '调出门店是否日清:0否,1是',

    alloc_price                  DECIMAL(27, 2) COMMENT '调拨单价',
    alloc_qty                    DECIMAL(27, 3) COMMENT '调拨数量',
    alloc_reason                 STRING COMMENT '调拨原因',
    alloc_amount                 DECIMAL(27, 2) COMMENT '调拨金额',
    create_time                  TIMESTAMP COMMENT '创建时间',
    stock_deal_time              TIMESTAMP COMMENT '库存处理时间',
    sync_time                    TIMESTAMP COMMENT '数据同步时间',
    vendor_no                    STRING COMMENT '供应商编码',
    vendor_name                  STRING COMMENT '供应商名称'
)
COMMENT '门店调出单'
partitioned by (dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwd.dwd_order_store_require_i(
    trade_date               STRING COMMENT '确认日期',
    week_trade_date          STRING COMMENT '周一日期',
    month_trade_date         STRING COMMENT '月一日期',
    hourly                   BIGINT COMMENT '交易小时(0-23)',
    quarter                  BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                 BIGINT COMMENT '刻钟数:hourly*4+quarters',

    id                       BIGINT COMMENT '主键',
    uid                      STRING COMMENT '唯一标识',
    order_id                 STRING COMMENT '要货单号',
    order_source             BIGINT COMMENT '下单来源，小程序、pc、智能补货、系统等',

    store_no                 STRING COMMENT '门店编码',
    store_name               STRING COMMENT '门店名称',
    store_sale_type          BIGINT COMMENT '店铺销售类型',
    store_type_code          BIGINT COMMENT '分店类型',
    worker_num               BIGINT COMMENT '员工人数',
    store_area               DECIMAL(27, 2) COMMENT '门店面积',
    city_id                  BIGINT COMMENT '城市ID',
    city_name                STRING COMMENT '城市名称',
    region_code              STRING COMMENT '区域编码',
    region_name              STRING COMMENT '区域名称',
    is_day_clear             BIGINT COMMENT '是否日清:0否,1是',

    goods_no                 STRING COMMENT '商品编码',
    goods_name               STRING COMMENT '商品名称',
    dc_no                    STRING COMMENT '配送中心编码',
    dc_name                  STRING COMMENT '配送中心名称',
    vendor_no                STRING COMMENT '供应商编码',
    vendor_name              STRING COMMENT '供应商名称',
    group_no                 STRING COMMENT '采购柜组编号',
    require_price            DECIMAL(27, 2) COMMENT '要货价格',
    require_qty              DECIMAL(27, 3) COMMENT '要货数量',
    create_time              TIMESTAMP COMMENT '创建时间',
    send_time                TIMESTAMP COMMENT '预计送货时间',
    collect_require_order_id STRING COMMENT '要货汇总单号',
    require_type_code        BIGINT COMMENT '要货类型：1-直送，2-配送，3-代发',
    is_online                BIGINT COMMENT '1-线上，0-线下',
    confirm_time             TIMESTAMP COMMENT '审核时间',
    is_canceled              BIGINT COMMENT '1-取消，0-正常',
    sync_time                TIMESTAMP COMMENT '数据同步时间',
    is_urgent                BIGINT COMMENT '是否加急 0,否 1，是',
    original_order_price     DECIMAL(27, 2) COMMENT '原单价'
)
COMMENT '门店要货单'
partitioned by (dt STRING COMMENT 'confirm_time时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');