drop database if exists dwm cascade ;
create database if not exists dwm;


CREATE TABLE IF NOT EXISTS dwm.dwm_sold_goods_sold_dtl_i(
    trade_date_time             STRING COMMENT '核销时间',
    trade_date                  STRING COMMENT '交易日期',
    week_trade_date             STRING COMMENT '周一日期',
    month_trade_date            STRING COMMENT '月一日期',
    hourly                      BIGINT COMMENT '交易小时(0-23)',
    quarter                     BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                    BIGINT COMMENT '刻钟数:hourly*4+quarters',

    parent_store_no             STRING COMMENT '母店编码',
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

    trade_type                  BIGINT COMMENT '结算类型(0.正常交易,1.赠品发放,2.退货,4.培训,5.取消交易)',
    source_type                 BIGINT COMMENT '交易来源1:线下POS;2:三方平台;3:云鲜商城;4:甄选团购;5:云鲜大客户;6:云鲜其他;7:甄选;8:优选海淘;9:优选大客户;10:优选POS;11:优选APP;12:优选H5;13:店长工具线下;14:店长工具线上;15:甄选其他',
    source_type_name            STRING COMMENT '交易来源名称',
    sale_type                   BIGINT COMMENT '销售类型 1.实物,2.代客,3.优选小程序,4.离店,5.云鲜小程序,6.第三方平台,7.其他,8.大客户',
    is_online_order             BIGINT COMMENT '是否为线上单:0否,1是',
    member_type                 BIGINT COMMENT '会员类型:0非会员,1线上会员,2实体卡会员',
    is_balance_consume          BIGINT COMMENT '是否有余额支付:0否,1是',
    order_type                  BIGINT COMMENT '配送类型（真正的订单类型由业务类型来决定）：1-及时送；2-隔日送；3-自提单；4-线下单',
    express_type                BIGINT COMMENT '配送方式：0-三方平台配送；1-自配送；2-快递；3-自提；4-线下',

    parent_order_no             STRING COMMENT '母订单编号',
    order_no                    STRING COMMENT '订单编号',

    create_time                 STRING COMMENT '创建时间',
    is_cancel                   BIGINT COMMENT '是否取消',
    cancel_time                 STRING COMMENT '取消时间',
    last_update_time            STRING COMMENT 'pos_sale表最后一次更新时间',

    zt_id                       BIGINT COMMENT '中台ID',
    member_id                   BIGINT COMMENT '会员ID',
    card_no                     STRING COMMENT '卡号',

    share_user_id               STRING COMMENT '分享人用户ID',
    commission_amount           DECIMAL(27, 2) COMMENT '佣金',
    is_tuan_head                BIGINT COMMENT '是否为团长订单',
    store_leader_id             BIGINT COMMENT '团长id',
    order_group_no              STRING COMMENT '团单号',

    first_category_no           STRING COMMENT '一级分类编码',
    first_category_name         STRING COMMENT '一级分类名称',
    second_category_no          STRING COMMENT '二级分类编码',
    second_category_name        STRING COMMENT '二级分类名称',
    third_category_no           STRING COMMENT '三级分类编码',
    third_category_name         STRING COMMENT '三级分类名称',
    goods_no                    STRING COMMENT '商品编码',
    goods_name                  STRING COMMENT '商品名称',

    supply_team                 BIGINT COMMENT '供应链团队 1.平台商品,2.优选标品,3.云鲜标品,4.云鲜生鲜,5优选POS商品',
    dc_no                       STRING COMMENT '采购仓库编号',
    dc_name                     STRING COMMENT '采购仓库名称',
    group_no                    STRING COMMENT '采购柜组编号',
    group_name                  STRING COMMENT '采购柜组名称',
    trade_mode_id               BIGINT COMMENT '结算方式:1购销,2联营',
    vendor_id                   BIGINT COMMENT '供应商ID',
    contract_no                 STRING COMMENT '合同编号',
    is_clean                    BIGINT COMMENT '商品是否日清:0否,1是',
    is_daily_clear              BIGINT COMMENT '商品是否参加日清活动:0否,1是',

    sale_qty                    DECIMAL(27, 3) COMMENT '商品销售数量',
    sale_amount                 DECIMAL(27, 2) COMMENT '商品销售金额',
    dis_amount                  DECIMAL(27, 2) COMMENT '商品折扣金额',
    sale_cost                   DECIMAL(27, 2) COMMENT '商品销售成本',
    balance_amount              DECIMAL(27, 2) COMMENT '余额支付',

    order_total_amount          DECIMAL(27, 2) COMMENT '订单总金额(平摊)',
    order_discount_amount       DECIMAL(27, 2) COMMENT '订单优惠金额=商家承担优惠金额+平台补贴金额(平摊)',
    order_paid_amount           DECIMAL(27, 2) COMMENT '实付金额(平摊)'
)
COMMENT '商品销售明细(核销)刻表'
partitioned by(dt STRING COMMENT '核销日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwm.dwm_stock_store_goods_loss_quarter_i(
    trade_date              STRING COMMENT '交易日期',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',

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
    
    first_category_no       STRING COMMENT '一级分类编码',
    first_category_name     STRING COMMENT '一级分类名称',
    second_category_no      STRING COMMENT '二级分类编码',
    second_category_name    STRING COMMENT '二级分类名称',
    third_category_no       STRING COMMENT '三级分类编码',
    third_category_name     STRING COMMENT '三级分类名称',
    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    is_clean                BIGINT COMMENT '商品是否日清',

    loss_qty                DECIMAL(27, 3) COMMENT '损耗数量',
    loss_amount             DECIMAL(27, 2) COMMENT '损耗金额'
)
COMMENT '门店商品损耗刻表'
partitioned by(dt STRING COMMENT '库存处理时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwm.dwm_order_store_goods_receipt_quarter_i(
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
    is_clean                    BIGINT COMMENT '商品是否日清',

    receive_qty                 DECIMAL(27, 3) COMMENT '收货数量(从供应商或者仓库)',
    receive_amount              DECIMAL(27, 2) COMMENT '收货金额',
    return_vendor_qty           DECIMAL(27, 3) COMMENT '退货数量(退给供应商)',
    return_vendor_amount        DECIMAL(27, 2) COMMENT '退货金额',
    return_dc_qty               DECIMAL(27, 3) COMMENT '退配数量(退给仓库)',
    return_dc_amount            DECIMAL(27, 2) COMMENT '退配金额',
    allocation_in_qty           DECIMAL(27, 3) COMMENT '调入数量',
    allocation_in_amount        DECIMAL(27, 2) COMMENT '调入金额',
    allocation_out_qty          DECIMAL(27, 3) COMMENT '调出数量',
    allocation_out_amount       DECIMAL(27, 2) COMMENT '调出金额',
    receipt_qty                 DECIMAL(27, 3) COMMENT '净收货数量',
    receipt_amount              DECIMAL(27, 2) COMMENT '净收货金额(收货-退货-退配+调入-调出)',
    receipt_cost                DECIMAL(27, 2) COMMENT '净收货成本'
)
COMMENT '门店商品收货刻表'
partitioned by(dt STRING COMMENT '收货日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

CREATE TABLE IF NOT EXISTS dwm.dwm_order_store_goods_require_quarter_i(
    trade_date              STRING COMMENT '交易日期',
    week_trade_date         STRING COMMENT '周一日期',
    month_trade_date        STRING COMMENT '月一日期',
    hourly                  BIGINT COMMENT '交易小时(0-23)',
    quarter                 BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                BIGINT COMMENT '刻钟数:hourly*4+quarters',

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

    first_category_no       STRING COMMENT '一级分类编码',
    first_category_name     STRING COMMENT '一级分类名称',
    second_category_no      STRING COMMENT '二级分类编码',
    second_category_name    STRING COMMENT '二级分类名称',
    third_category_no       STRING COMMENT '三级分类编码',
    third_category_name     STRING COMMENT '三级分类名称',
    goods_no                STRING COMMENT '商品编码',
    goods_name              STRING COMMENT '商品名称',
    is_clean                BIGINT COMMENT '商品是否日清',

    require_qty             DECIMAL(27, 3) COMMENT '要货数量',
    require_amount          DECIMAL(27, 2) COMMENT '要货金额'
)
COMMENT '门店商品要货刻表'
partitioned by(dt STRING COMMENT 'confirm_time确认时间')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');