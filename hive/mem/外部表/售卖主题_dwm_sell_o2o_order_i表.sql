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




CREATE TABLE IF NOT EXISTS dwd.dwd_sale_pay_dtl_i (
    trade_date         STRING COMMENT '时间',
    order_no           STRING COMMENT '订单号',
    trade_source       BIGINT COMMENT '交易来源，2：线上、1：线下',
    wechat_amount      DECIMAL(27, 4) COMMENT '微信支付',
    ali_pay_amount     DECIMAL(27, 4) COMMENT '支付宝支付',
    cash_amount        DECIMAL(27, 4) COMMENT '现金支付',
    balance_amount     DECIMAL(27, 4) COMMENT '余额支付',
    point_amount       DECIMAL(27, 4) COMMENT '积分支付',
    unionpay_amount    DECIMAL(27, 4) COMMENT '银行支付',
    member_card_amount DECIMAL(27, 4) COMMENT '线下实体卡支付',
    gift_amount        DECIMAL(27, 4) COMMENT '礼品卡支付',
    yxapi_amount       DECIMAL(27, 4) COMMENT '云鲜支付',
    other_pay_amount   DECIMAL(27, 4) COMMENT '其他支付'
) comment '订单支付渠道表'
partitioned by (dt STRING COMMENT '交易日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;

-- 插入数据
insert overwrite table dwd.dwd_sale_pay_dtl_i partition(dt)
select
    trade_date,
    order_no,
    2 as trade_source,
    sum(wechat_amount) as wechat_amount,
    sum(ali_pay_amount) as ali_pay_amount,
    sum(cash_amount) as cash_amount,
    sum(balance_amount) as balance_amount,
    sum(point_amount) as point_amount,
    sum(unionpay_amount) as unionpay_amount,
    sum(member_card_amount) as member_card_amount,
    sum(gift_amount) as gift_amount,
    sum(yxapi_amount) as yxapi_amount,
    sum(other_pay_amount) as other_pay_amount,
    trade_date as dt
from (
     select
         dt as trade_date,
         order_no,
         if(pay_channel_name in ('微信支付','微信代'),pay_amount,0) as wechat_amount,
         if(pay_channel_name in ('支付宝','支付宝代'),pay_amount,0) as ali_pay_amount,
         if(pay_channel_name = '现金支付',pay_amount,0) as cash_amount,
         if(pay_channel_name = '余额支付',pay_amount,0) as balance_amount,
         if(pay_channel_name = '积分支付',pay_amount,0) as point_amount,
         if(pay_channel_name = '银行支付',pay_amount,0) as unionpay_amount,
         if(pay_channel_name = '线下实体卡支付',pay_amount,0) as member_card_amount,
         0 as gift_amount,
         if(pay_channel_name = '云鲜支付',pay_amount,0) as yxapi_amount,
         if(pay_channel_name = '其他支付',pay_amount,0) as other_pay_amount
     from ods.ods_sale_shop_sale_pay_i
    ) t
group by trade_date,order_no

union all

select
    trade_date,
    order_no,
    1 as trade_source,
    sum(wechat_amount) as wechat_amount,
    sum(ali_pay_amount) as ali_pay_amount,
    sum(cash_amount) as cash_amount,
    sum(balance_amount) as balance_amount,
    sum(point_amount) as point_amount,
    sum(unionpay_amount) as unionpay_amount,
    sum(member_card_amount) as member_card_amount,
    sum(gift_amount) as gift_amount,
    sum(yxapi_amount) as yxapi_amount,
    sum(other_pay_amount) as other_pay_amount,
    trade_date as ds
from (
     select
         dt as trade_date,
         order_no,
         if(pay_type_id in ('54', '153', '120'),pay_amount,0) as wechat_amount,
         if(pay_type_id in ('53'),pay_amount,0) as ali_pay_amount,
         if(pay_type_id = '1',pay_amount,0) as cash_amount,
         if(pay_type_id = '201',pay_amount,0) as balance_amount,
         if(pay_type_id = '10',pay_amount,0) as point_amount,
         if(pay_type_id = '151',pay_amount,0) as unionpay_amount,
         if(pay_type_id = '102',pay_amount,0) as member_card_amount,
         if(pay_type_id in ('104', '84'), pay_amount,0) as gift_amount,
         if(pay_type_id in('910', '908'), pay_amount,0) as yxapi_amount,
         if(pay_type_id not in ('54', '153', '120', '53', '1', '201', '10', '151', '102', '104', '84', '910', '908') ,pay_amount,0) as other_pay_amount
     from ods.ods_sale_store_sale_pay_i
	) t
group by trade_date,order_no
;





CREATE TABLE IF NOT EXISTS dwd.dwd_sale_store_sale_info_i(
    id                      BIGINT COMMENT '主键',
    order_no                STRING COMMENT '单据唯一编号',
    order_id                BIGINT COMMENT '单据唯一编号',
    sale_store_no           STRING COMMENT '销售门店编码',
    store_no                STRING COMMENT '门店编码',
    store_name              STRING COMMENT '门店名称',
    trade_date              TIMESTAMP COMMENT '交易日期',
    pay_date                TIMESTAMP COMMENT '支付日期',
    deal_date               TIMESTAMP COMMENT '库存处理时间',
    pos_no                  STRING COMMENT 'pos机编号',
    ser_id                  BIGINT COMMENT '交易序号',
    trade_id                BIGINT COMMENT '销售类型:1-销售，2-退货，3-拒收，4-取消',
    parent_order_sn         STRING COMMENT '母单号，如果单据是子单有值',
    source_order_sn         STRING COMMENT '原始单据，退款的单据，则代表是原始销售单据',

    source_type             BIGINT COMMENT '销售渠道：1-门店pos，2-商城小程序，3-团购销售',
    cashier_no              STRING COMMENT '收银员编号',
    cashier_name            STRING COMMENT '收银员名称',
    sale_amount             DECIMAL(27, 2) COMMENT '单据总金额(支付+折扣+舍分)//total_amount',
    total_pay_amount        DECIMAL(27, 2) COMMENT '单据总支付金额',
    total_dis_amount        DECIMAL(27, 2) COMMENT '单据总折扣金额',
    round_amount            DECIMAL(27, 2) COMMENT '单据舍分金额',
    member_type             BIGINT COMMENT '会员类型',
    member_name             STRING COMMENT '会员名',
    member_center_sn        STRING COMMENT '会员中台编码',
    member_id               BIGINT COMMENT '会员编号',
    member_channel          BIGINT COMMENT '会员渠道：1-云鲜，2-甄选',
    card_no                 STRING COMMENT '实体卡号',  
    business_code           STRING COMMENT '业务类型:预售、及时达、b2c',
    create_time             TIMESTAMP COMMENT '记录创建时间',
    last_update_time        TIMESTAMP COMMENT '最后更新时间'
) comment '门店销售信息表'
partitioned by (dt STRING COMMENT '交易日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;
-- 插入数据
insert overwrite table dwd.dwd_sale_store_sale_info_i partition(dt)
select
    id
    ,order_no
    ,order_id
    ,sale_store_no
    ,store_no
    ,store_name
    ,trade_date
    ,pay_date
    ,deal_date
    ,pos_no
    ,ser_id
    ,trade_id
    ,parent_order_sn
    ,source_order_sn

    ,source_type
    ,cashier_no
    ,cashier_name
    ,sale_amount
    ,total_pay_amount
    ,total_dis_amount
    ,round_amount
    ,member_type
    ,member_name
    ,member_center_sn
    ,member_id
    ,member_channel
    ,card_no
    ,business_code
    ,create_time
    ,last_update_time

    ,dt
from ods.ods_sale_store_sale_info_i;








CREATE TABLE IF NOT EXISTS dwd.dwd_sale_shop_refund_i(
    id                    BIGINT COMMENT '主键',
    refund_no             STRING COMMENT '退款单号',
    refund_status         BIGINT COMMENT '退款状态：1-退款中；2-退款成功；3-退款失败',
    refund_code           BIGINT COMMENT '退款原因code',
    refund_msg            STRING COMMENT '退款原因',
    refund_desc           STRING COMMENT '退款描述',
    create_time           TIMESTAMP COMMENT '创建时间/退款申请时间',
    update_time           TIMESTAMP COMMENT '更新时间',
    cancel_time           TIMESTAMP COMMENT '退款申请取消时间',
    refund_amount         DECIMAL(27, 2) COMMENT '退款金额',
    refund_point_amount   DECIMAL(27, 2) COMMENT '扣减已赠积分',
    return_pay_point      BIGINT COMMENT '退还支付积分',
    return_point_amount   DECIMAL(27, 2) COMMENT '退还积分抵扣金额',
    refund_time           TIMESTAMP COMMENT '退款成功时间',
    less_weight           DECIMAL(27, 3) COMMENT '差额重量,单位kg',
    pick_weight           DECIMAL(27, 3) COMMENT '拣货重量,单位kg',
    is_deleted            BIGINT COMMENT '失效标志：0-正常；1-失效',
    refund_type           BIGINT COMMENT '退款类型：1-部分退；2-全额退; 3-差额退',
    order_no              STRING COMMENT '订单号',
    refund_apply_type     BIGINT COMMENT '退款申请类型：1-仅退款；2-退货退款',
    refund_delivery       DECIMAL(27, 2) COMMENT '运费退款',
    sync_erp_status       BIGINT COMMENT '同步erp状态：-1-失败，0-未同步，1-成功',
    sync_erp_msg          STRING COMMENT '同步erp失败消息',
    create_sys_user_id    BIGINT COMMENT '操作人id',
    create_sys_user_name  STRING COMMENT '操作人名称',
    store_no              STRING COMMENT '门店编码',
    store_leader_id       BIGINT COMMENT '团长id' 
) COMMENT '订单退款表'
partitioned by (dt STRING COMMENT '退款日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;
-- 插入数据
insert overwrite table dwd.dwd_sale_shop_refund_i partition(dt)
select
    id
    ,refund_no
    ,refund_status
    ,refund_code
    ,refund_msg
    ,refund_desc
    ,create_time
    ,update_time
    ,cancel_time
    ,refund_amount
    ,refund_point_amount
    ,return_pay_point
    ,return_point_amount
    ,refund_time
    ,less_weight
    ,pick_weight
    ,is_deleted
    ,refund_type
    ,order_no
    ,refund_apply_type
    ,refund_delivery
    ,sync_erp_status
    ,sync_erp_msg
    ,create_sys_user_id
    ,create_sys_user_name
    ,store_no
    ,store_leader_id
    ,dt
from ods.ods_sale_shop_refund_i
;







CREATE TABLE IF NOT EXISTS dwd.dwd_sell_shop_order_i (
    id                        BIGINT COMMENT '编号',
    parent_order_no           STRING COMMENT '父单订单号',
    order_id                  STRING COMMENT '订单编号',
    is_split                  BIGINT COMMENT '是否拆单：0-不需要拆单；1-待拆单；2-已拆单',
    platform_id               BIGINT COMMENT '平台id：1-有赞，2-京东到家，3-美团外卖，4-饿了么',
    tid                       STRING COMMENT '平台订单号',
    source_type               BIGINT COMMENT '订单来源：10,20,30,40,41,50,60,70',
    source_name               STRING COMMENT '订单来源名称：10-有赞，20-京东到家，30-美团外卖，40-饿了么，41-百度外卖，50-云鲜精选，60-甄选，70-抖店',
    store_no                  STRING COMMENT '门店编码',
    city_id                   BIGINT COMMENT '城市编号',
    city_name                 STRING COMMENT '城市名称',
    region_code               STRING COMMENT '区域编码',

    order_status              BIGINT,
    order_status_desc         STRING COMMENT '主订单状态描述：0-新建; 1-待出票；2-待备货；3-待揽件；4-待自提; 5-配送中；6-已完成；7-已取消',
    pay_type                  BIGINT COMMENT '支付类型：1-线下支付；2-线上支付',
    trade_type                STRING COMMENT '交易类型。取值范围：fixed(一口价) gift(送礼）bulk_purchase（来自分销商的采购）present （赠品领取）group （拼团订单） pifa （批发订单） cod （货到付款） peer （代付） qrcode（扫码商家二维码直接支付的交易）qrcode_3rd（线下收银台二维码交易)',
    is_deleted                BIGINT COMMENT '是否有效，1：已删除，0：正常',

    order_create_time         TIMESTAMP COMMENT '平台订单创建时间',
    order_pay_time            TIMESTAMP COMMENT '订单支付时间',
    create_time               TIMESTAMP COMMENT '创建时间',
    print_status              BIGINT COMMENT '打印状态：0-未打票;1-已打票',
    print_time                TIMESTAMP COMMENT '出票时间',
    stock_up_status           BIGINT COMMENT '门店处理状态：0-待备货/1-已备货',
    stock_up_time             TIMESTAMP COMMENT '备货完成时间',

    order_type                BIGINT COMMENT '配送类型（真正的订单类型由业务类型来决定）：1-及时送；2-隔日送；3-自提单',
    express_type              BIGINT COMMENT '配送方式：0-三方平台配送；1-自配送；2-快递；3-自提',
    receive_time              TIMESTAMP COMMENT '要求送达/自提时间',
    express_code              STRING COMMENT '配送单号',
    delivery_status           BIGINT COMMENT '配送状态：0-待配送；1-配送中；2-已送达',
    delivery_time             TIMESTAMP COMMENT '配送时间',
    pick_up_status            BIGINT COMMENT '自提状态：0-待自提；1-已自提',
    qr_code                   STRING COMMENT 'qr提货码',
    pick_up_time              TIMESTAMP COMMENT '自提时间',

    complete_time             TIMESTAMP COMMENT '订单完结时间',
    is_cancel                 BIGINT COMMENT '是否取消',
    cancel_time               TIMESTAMP COMMENT '取消时间',
    cancel_reason             STRING COMMENT '取消原因',
    refund_status             BIGINT COMMENT '退款状态：0未退款，1部分退款，2已全额退款',
    refund_time               TIMESTAMP COMMENT '已退款时间',
    last_update_time          TIMESTAMP COMMENT '最新更新时间',

    order_total_amount        DECIMAL(27, 2) COMMENT '订单总金额',
    product_total_amount      DECIMAL(27, 2) COMMENT '商品总金额（原价）',
    pack_amount               DECIMAL(27, 2) COMMENT '餐盒费/打包费',
    delivery_amount           DECIMAL(27, 2) COMMENT '配送费',
    discount_amount           DECIMAL(27, 2) COMMENT '订单优惠金额=商家承担优惠金额+平台补贴金额',
    seller_discount_amount    DECIMAL(27, 2) COMMENT '商家承担优惠金额',
    platform_allowance_amount DECIMAL(27, 2) COMMENT '平台补贴金额',
    real_paid_amount          DECIMAL(27, 2) COMMENT '实付金额',
    product_discount          DECIMAL(27, 2) COMMENT '商品优惠金额',
    real_product_amount       DECIMAL(27, 2) COMMENT '商品实际金额',

    buyer_id                  BIGINT COMMENT '买家id',
    buyer_phone               STRING COMMENT '买家电话',
    buyer_remark              STRING COMMENT '买家备注',
    r_name                    STRING COMMENT '收货人姓名',
    r_tel                     STRING COMMENT '收货人电话',
    r_province                STRING COMMENT '收货人省份',
    r_city                    STRING COMMENT '收货人城市',
    r_district                STRING COMMENT '收货人区域',
    r_address                 STRING COMMENT '收货人地址',
    r_zipcode                 STRING COMMENT '收货人邮编',

    is_tuan_head              BIGINT COMMENT '是否为团长订单',
    store_leader_id           BIGINT COMMENT '团长id',
    order_group_no            STRING COMMENT '团单号',
    commision_amount          DECIMAL(27, 2) COMMENT '抽佣金额',
    settle_amount             DECIMAL(27, 2) COMMENT '结算金额',

    points_amount             DECIMAL(27, 2) COMMENT '积分抵扣金额',
    pay_point                 BIGINT COMMENT '消费积分数',
    balance_amount            DECIMAL(27, 2) COMMENT '余额扣除金额',
    pay_channel_amount        DECIMAL(27, 2) COMMENT '通过支付渠道支付的金额',
    point_amount              DECIMAL(27, 2) COMMENT '消费赠送积分',

    sync_erp_status           BIGINT COMMENT '同步erp状态',
    sync_erp_msg              STRING COMMENT '同步erp失败消息'
) comment '商城订单表(销售表)'
    partitioned by (dt STRING COMMENT '创建日期')
    row format delimited fields terminated by ','
    stored as orc
    tblproperties ('orc.compress' = 'SNAPPY')
;
-- 插入数据
insert overwrite table dwd.dwd_sell_shop_order_i partition(dt)
select
    id                      
    ,parent_order_no         
    ,order_id                
    ,is_split                
    ,platform_id             
    ,tid                     
    ,source_type             
    ,source_name             
    ,store_no                
    ,city_id                 
    ,city_name               
    ,region_code             
                    
    ,order_status            
    ,order_status_desc       
    ,pay_type                
    ,trade_type              
    ,is_deleted              
                   
    ,order_create_time       
    ,order_pay_time          
    ,create_time             
    ,print_status            
    ,print_time              
    ,stock_up_status         
    ,stock_up_time           
                 
    ,order_type              
    ,express_type            
    ,receive_time            
    ,express_code            
    ,delivery_status         
    ,delivery_time           
    ,pick_up_status          
    ,qr_code                 
    ,pick_up_time            
                  
    ,complete_time           
    ,is_cancel               
    ,cancel_time             
    ,cancel_reason           
    ,refund_status           
    ,refund_time             
    ,last_update_time        
                   
    ,order_total_amount      
    ,product_total_amount    
    ,pack_amount             
    ,delivery_amount         
    ,discount_amount         
    ,seller_discount_amount  
    ,platform_allowance_amount 
    ,real_paid_amount        
    ,product_discount        
    ,real_product_amount     
                   
    ,buyer_id                
    ,buyer_phone             
    ,buyer_remark            
    ,r_name                  
    ,r_tel                   
    ,r_province              
    ,r_city                  
    ,r_district              
    ,r_address               
    ,r_zipcode               
                   
    ,is_tuan_head            
    ,store_leader_id         
    ,order_group_no          
    ,commision_amount        
    ,settle_amount           
                  
    ,points_amount           
    ,pay_point               
    ,balance_amount          
    ,pay_channel_amount      
    ,point_amount            
                  
    ,sync_erp_status         
    ,sync_erp_msg            
    
    ,date_format(create_time, 'yyyy-MM-dd') as dt
from ods.ods_sale_shop_order_i;










CREATE TABLE IF NOT EXISTS dwm.dwm_sell_o2o_order_i (
    create_time               STRING COMMENT '订单创建时间',
    trade_date                STRING COMMENT '交易日期',
    week_trade_date           STRING COMMENT '周一日期',
    month_trade_date          STRING COMMENT '月一日期',
    hourly                    BIGINT COMMENT '交易小时(0-23)',
    quarter                   BIGINT COMMENT '刻钟:1.0-15,2.15-30,3.30-45,4.45-60',
    quarters                  BIGINT COMMENT '刻钟数:hourly*4+quarters',

    parent_order_no           STRING COMMENT '父单订单号/源单号',
    order_no                  STRING COMMENT '订单编号',
    trade_type                BIGINT COMMENT '结算类型(0.正常交易,1.赠品发放,2.退货,4.培训,5.取消交易)',
    source_type               BIGINT COMMENT '交易来源1:线下POS;2:三方平台;3:云鲜商城;4:甄选团购;5:云鲜大客户;6:云鲜其他;7:甄选;8:优选海淘;9:优选大客户;10:优选POS;11:优选APP;12:优选H5;13:店长工具线下;14:店长工具线上;15:甄选其他',
    source_type_name          STRING COMMENT '交易来源名称',
    sale_type                 BIGINT COMMENT '销售类型 1.实物,2.代客,3.优选小程序,4.离店,5.云鲜小程序,6.第三方平台,7.其他,8.大客户',
    is_online_order           BIGINT COMMENT '是否为线上单:0否,1是',
    member_type               BIGINT COMMENT '会员类型:0非会员,1线上会员,2实体卡会员',
    is_balance_consume        BIGINT COMMENT '是否有余额支付:0否,1是',
    order_type                BIGINT COMMENT '配送类型（真正的订单类型由业务类型来决定）：1-及时送；2-隔日送；3-自提单；4-线下单',
    express_type              BIGINT COMMENT '配送方式：0-三方平台配送；1-自配送；2-快递；3-自提；4-线下',

    store_no                  STRING COMMENT '店铺编码',
    store_name                STRING COMMENT '店铺名称',
    store_sale_type           BIGINT COMMENT '店铺销售类型',
    store_type_code           BIGINT COMMENT '分店类型',
    worker_num                BIGINT COMMENT '员工人数',
    store_area                DECIMAL(27, 2) COMMENT '门店面积',
    city_id                   BIGINT COMMENT '城市ID',
    city_name                 STRING COMMENT '城市名称',
    region_code               STRING COMMENT '区域编码',
    region_name               STRING COMMENT '区域名称',
    is_day_clear              BIGINT COMMENT '是否日清:0否,1是',

    is_cancel                 BIGINT COMMENT '是否取消',
    cancel_time               STRING COMMENT '取消时间',
    cancel_reason             STRING COMMENT '取消原因',
    last_update_time          TIMESTAMP COMMENT '最新更新时间',

    cashier_no                STRING COMMENT '收银员编码',
    cashier_name              STRING COMMENT '收银员名称',

    zt_id                     BIGINT COMMENT '中台ID',
    member_id                 BIGINT COMMENT '会员ID',
    card_no                   STRING COMMENT '卡号',
    r_name                    STRING COMMENT '收货人姓名',
    r_province                STRING COMMENT '收货人省份',
    r_city                    STRING COMMENT '收货人城市',
    r_district                STRING COMMENT '收货人区域',

    is_tuan_head              BIGINT COMMENT '是否为团长订单',
    store_leader_id           BIGINT COMMENT '团长id',
    order_group_no            STRING COMMENT '团单号',

    settle_amount             DECIMAL(27, 2) COMMENT '结算金额',
    share_user_id             BIGINT COMMENT '分享人用户ID',
    commission_amount         DECIMAL(27, 2) COMMENT '佣金',

    order_total_amount        DECIMAL(27, 2) COMMENT '订单总金额',
    product_total_amount      DECIMAL(27, 2) COMMENT '商品总金额（原价）',
    pack_amount               DECIMAL(27, 2) COMMENT '餐盒费/打包费',
    delivery_amount           DECIMAL(27, 2) COMMENT '配送费',
    discount_amount           DECIMAL(27, 2) COMMENT '订单优惠金额=商家承担优惠金额+平台补贴金额',
    seller_discount_amount    DECIMAL(27, 2) COMMENT '商家承担优惠金额',
    platform_allowance_amount DECIMAL(27, 2) COMMENT '平台补贴金额',
    real_paid_amount          DECIMAL(27, 2) COMMENT '实付金额',
    product_discount          DECIMAL(27, 2) COMMENT '商品优惠金额',
    real_product_amount       DECIMAL(27, 2) COMMENT '商品实际金额',

    round_amount              DECIMAL(27, 2) COMMENT '舍分金额',
    wechat_amount             DECIMAL(27, 4) COMMENT '微信支付',
    ali_pay_amount            DECIMAL(27, 4) COMMENT '支付宝支付',
    cash_amount               DECIMAL(27, 4) COMMENT '现金支付',
    balance_amount            DECIMAL(27, 4) COMMENT '余额支付',
    point_amount              DECIMAL(27, 4) COMMENT '积分支付',
    unionpay_amount           DECIMAL(27, 4) COMMENT '银行支付',
    member_card_amount        DECIMAL(27, 4) COMMENT '线下实体卡支付',
    gift_amount               DECIMAL(27, 4) COMMENT '礼品卡支付',
    yxapi_amount              DECIMAL(27, 4) COMMENT '云鲜支付',
    other_pay_amount          DECIMAL(27, 4) COMMENT '其他支付'
) comment '线上线下销售订单表-售卖维度'
partitioned by (dt STRING COMMENT '销售日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress' = 'SNAPPY')
;

-- 插入数据
insert overwrite table dwm.dwm_sell_o2o_order_i partition(dt)
select
    date_format(se.create_time,'yyyy-MM-dd HH:mm:ss') as create_time
    ,date_format(se.create_time,'yyyy-MM-dd') as trade_date
    ,dd.week_trade_date
    ,dd.month_trade_date
    ,hour(se.create_time) as hourly
    ,case when minute(se.create_time)>=0  and minute(se.create_time)<15 then 1
          when minute(se.create_time)>=15 and minute(se.create_time)<30 then 2
          when minute(se.create_time)>=30 and minute(se.create_time)<45 then 3
          when minute(se.create_time)>=45 and minute(se.create_time)<60 then 4
    end as `quarter`
    ,hour(se.create_time)*4 + case when minute(se.create_time)>=0  and minute(se.create_time)<15 then 1
         when minute(se.create_time)>=15 and minute(se.create_time)<30 then 2
         when minute(se.create_time)>=30 and minute(se.create_time)<45 then 3
         when minute(se.create_time)>=45 and minute(se.create_time)<60 then 4
    end as quarters

    ,se.parent_order_no
    ,se.order_id as order_no
    ,if(se.is_cancel = 1, 5,0) as trade_type
    ,case when se.source_type in (10,20,30,40,70) then 2
          when se.source_type = 50 then 3
          when se.source_type = 60 then 4
          else 6 end as source_type
    ,case when se.source_type in (10,20,30,40,70) then '三方平台'
          when se.source_type = 50 then '云鲜商城'
          when se.source_type = 60 then '甄选团购'
          else '云鲜其他' end as source_type_name
    ,case when se.source_type in (10,20,30,40,70) then 6
          when se.source_type = 50 then 5
          when se.source_type = 60 then 3
          else 7 end as sale_type
    ,1 as is_online_order
    ,1 as member_type
    ,if(sp.balance_amount>0, 1, 0) as is_balance_consume
    ,se.order_type
    ,se.express_type

    ,se.store_no
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

    ,se.is_cancel
    ,date_format(se.cancel_time,'yyyy-MM-dd HH:mm:ss') as cancel_time
    ,se.cancel_reason
    ,se.last_update_time

    ,'' as cashier_no
    ,'' as cashier_name

    ,mm.zt_id
    ,se.buyer_id as member_id
    ,'' as card_no
    ,se.r_name
    ,se.r_province
    ,se.r_city
    ,se.r_district

    ,se.is_tuan_head
    ,se.store_leader_id
    ,se.order_group_no

    ,se.settle_amount
    ,0 as share_user_id
    ,0 as commission_amount

    ,se.order_total_amount
    ,se.product_total_amount
    ,se.pack_amount
    ,se.delivery_amount
    ,se.discount_amount
    ,se.seller_discount_amount
    ,se.platform_allowance_amount
    ,se.real_paid_amount
    ,se.product_discount
    ,se.real_product_amount

    ,0 as round_amount
    ,coalesce(sp.wechat_amount, 0) as wechat_amount
    ,coalesce(sp.ali_pay_amount, 0) as ali_pay_amount
    ,coalesce(sp.cash_amount, 0) as  cash_amount
    ,coalesce(sp.balance_amount, 0) as balance_amount
    ,coalesce(sp.point_amount, 0) as  point_amount
    ,coalesce(sp.unionpay_amount, 0) as unionpay_amount
    ,coalesce(sp.member_card_amount, 0) as member_card_amount
    ,coalesce(sp.gift_amount, 0) as  gift_amount
    ,coalesce(sp.yxapi_amount, 0) as   yxapi_amount
    ,coalesce(sp.other_pay_amount, 0) as other_pay_amount

    ,se.dt
from dwd.dwd_sell_shop_order_i se
inner join dim.dwd_dim_date_f dd on date_format(se.create_time,'yyyy-MM-dd')=dd.trade_date
inner join dim.dwd_dim_store_i bs on se.store_no=bs.store_no and bs.dt='2026-08-18'
left join dwd.dwd_sale_pay_dtl_i sp
  on se.order_id=sp.order_no  and sp.trade_source=2
left join (select distinct member_id,zt_id from ods.ods_mem_member_union_i) mm
  on se.buyer_id=mm.member_id

union all

select
    date_format(sr.create_time,'yyyy-MM-dd HH:mm:ss') as create_time
    ,date_format(sr.create_time,'yyyy-MM-dd') as trade_date
    ,dd.week_trade_date
    ,dd.month_trade_date
    ,hour(sr.create_time) as hourly
    ,case when minute(sr.create_time)>=0  and minute(sr.create_time)<15 then 1
          when minute(sr.create_time)>=15 and minute(sr.create_time)<30 then 2
          when minute(sr.create_time)>=30 and minute(sr.create_time)<45 then 3
          when minute(sr.create_time)>=45 and minute(sr.create_time)<60 then 4
    end as `quarter`
    ,hour(sr.create_time)*4 + case when minute(sr.create_time)>=0  and minute(sr.create_time)<15 then 1
         when minute(sr.create_time)>=15 and minute(sr.create_time)<30 then 2
         when minute(sr.create_time)>=30 and minute(sr.create_time)<45 then 3
         when minute(sr.create_time)>=45 and minute(sr.create_time)<60 then 4
    end as quarters

    ,sr.order_no as  parent_order_no
    ,sr.refund_no as order_no
    ,if(sr.cancel_time is not null, 5,2) as trade_type
    ,case when aso.source_type in (10,20,30,40,70) then 2
          when aso.source_type = 50 then 3
          when aso.source_type = 60 then 4
          else 6 end as source_type
    ,case when aso.source_type in (10,20,30,40,70) then '三方平台'
          when aso.source_type = 50 then '云鲜商城'
          when aso.source_type = 60 then '甄选团购'
          else '云鲜其他' end as source_type_name
    ,case when aso.source_type in (10,20,30,40,70) then 6
          when aso.source_type = 50 then 5
          when aso.source_type = 60 then 3
          else 7 end as sale_type
    ,1 as is_online_order
    ,1 as member_type
    ,if(sp.balance_amount<0, 1, 0) as is_balance_consume
    ,aso.order_type
    ,aso.express_type

    ,sr.store_no
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

    ,if(sr.cancel_time is not null, 1, 0) as is_cancel
    ,date_format(sr.cancel_time,'yyyy-MM-dd HH:mm:ss') as cancel_time
    ,aso.cancel_reason
    ,sr.update_time as last_update_time

    ,'' as cashier_no
    ,'' as cashier_name

    ,mm.zt_id
    ,aso.buyer_id as member_id
    ,'' as card_no
    ,aso.r_name
    ,aso.r_province
    ,aso.r_city
    ,aso.r_district

    ,aso.is_tuan_head
    ,aso.store_leader_id
    ,aso.order_group_no

    ,aso.settle_amount
    ,0 as share_user_id
    ,0 as commission_amount

    ,sr.refund_amount as order_total_amount
    ,sr.refund_amount as product_total_amount
    ,0 as pack_amount
    ,0 as delivery_amount
    ,0 as discount_amount
    ,0 as seller_discount_amount
    ,0 as platform_allowance_amount
    ,sr.refund_amount as real_paid_amount
    ,0 as product_discount
    ,sr.refund_amount as real_product_amount

    ,0 as round_amount
    ,coalesce(- sp.wechat_amount, 0) as wechat_amount
    ,coalesce(- sp.ali_pay_amount, 0) as ali_pay_amount
    ,coalesce(- sp.cash_amount, 0)  as cash_amount
    ,coalesce(- sp.balance_amount, 0) as balance_amount
    ,coalesce(- sp.point_amount, 0)  as point_amount
    ,coalesce(- sp.unionpay_amount, 0)  as unionpay_amount
    ,coalesce(- sp.member_card_amount, 0)  as member_card_amount
    ,coalesce(- sp.gift_amount, 0) as gift_amount
    ,coalesce(- sp.yxapi_amount, 0)  as yxapi_amount
    ,coalesce(- sp.other_pay_amount, 0) as other_pay_amount

    ,sr.dt
from dwd.dwd_sale_shop_refund_i sr
inner join dim.dwd_dim_date_f dd on date_format(sr.create_time,'yyyy-MM-dd')=dd.trade_date
inner join dim.dwd_dim_store_i bs on sr.store_no=bs.store_no and bs.dt='2026-08-18'
left join ods.ods_sale_shop_order_i aso
  on sr.order_no = aso.order_id
left join dwd.dwd_sale_pay_dtl_i sp
  on sr.refund_no=sp.order_no and sp.trade_source=2
left join (select distinct member_id,zt_id from ods.ods_mem_member_union_i) mm
  on aso.buyer_id=mm.member_id

union all

select
    date_format(ss.trade_date,'yyyy-MM-dd HH:mm:ss') as create_time
    ,date_format(ss.trade_date,'yyyy-MM-dd') as trade_date
    ,dd.week_trade_date
    ,dd.month_trade_date
    ,hour(ss.trade_date) as hourly
    ,case when minute(ss.trade_date)>=0  and minute(ss.trade_date)<15 then 1
          when minute(ss.trade_date)>=15 and minute(ss.trade_date)<30 then 2
          when minute(ss.trade_date)>=30 and minute(ss.trade_date)<45 then 3
          when minute(ss.trade_date)>=45 and minute(ss.trade_date)<60 then 4
    end as `quarter`
    ,hour(ss.trade_date)*4 + case when minute(ss.trade_date)>=0  and minute(ss.trade_date)<15 then 1
         when minute(ss.trade_date)>=15 and minute(ss.trade_date)<30 then 2
         when minute(ss.trade_date)>=30 and minute(ss.trade_date)<45 then 3
         when minute(ss.trade_date)>=45 and minute(ss.trade_date)<60 then 4
    end as quarters

    ,coalesce(if(ss.sale_amount<0, ss.source_order_sn, ss.parent_order_sn), ss.order_no) as parent_order_no
    ,ss.order_no
    ,case when ss.trade_id=1 then 0
          when ss.trade_id in (2, 3) then 2
          when ss.trade_id=4 then 5
          end as trade_type
    ,st.source_type
    ,st.source_type_name
    ,case when ss.source_type is null or ss.source_type=1 then 1
         when ss.source_type=9 then 5
         when ss.source_type in (4,5,6,7,8) then 6
         when ss.source_type=11 then 8
         else 7 end as sale_type
     ,0 as  is_online_order
     ,case when ss.card_no is null and ss.member_id is not null then 1 -- 线上会员线上消费
         when ss.card_no like 'OL-%' or ss.card_no like 'SF-%' then 1 -- 线上会员线下消费
         when ss.card_no is not null then 2 --实体卡会员
         else 0 end as member_type
    ,if(sp.balance_amount is not null or sp.balance_amount<>0, 1, 0) as is_balance_consume
    ,4 as order_type
    ,4 as express_type

    ,ss.store_no
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

    ,if(trade_id=4,1,0) as is_cancel
    ,if(trade_id=4, date_format(ss.last_update_time,'yyyy-MM-dd HH:mm:ss'), '') as cancel_time
    ,'' as cancel_reason
    ,ss.last_update_time

    ,ss.cashier_no
    ,ss.cashier_name

    ,cast(coalesce(ss.member_center_sn, '0') as BIGINT) as zt_id
    ,ss.member_id
    ,ss.card_no
    ,'' as r_name
    ,'' as r_province
    ,'' as r_city
    ,'' as r_district

    ,0 as is_tuan_head
    ,0 as store_leader_id
    ,'' as order_group_no

    ,ss.sale_amount as settle_amount
    ,0 as share_user_id
    ,0 as commission_amount

    ,ss.sale_amount as order_total_amount
    ,coalesce(ss.total_pay_amount, 0) + coalesce(ss.total_dis_amount, 0)  as product_total_amount
    ,0 as pack_amount
    ,0 as delivery_amount
    ,ss.total_dis_amount as discount_amount
    ,ss.total_dis_amount as seller_discount_amount
    ,0 as platform_allowance_amount
    ,ss.total_pay_amount as real_paid_amount
    ,ss.total_dis_amount as product_discount
    ,ss.total_pay_amount as real_product_amount
    ,coalesce(ss.round_amount, 0) as round_amount
    ,coalesce(sp.wechat_amount, 0) as wechat_amount
    ,coalesce(sp.ali_pay_amount, 0) as ali_pay_amount
    ,coalesce(sp.cash_amount, 0) as  cash_amount
    ,coalesce(sp.balance_amount, 0) as balance_amount
    ,coalesce(sp.point_amount, 0) as  point_amount
    ,coalesce(sp.unionpay_amount, 0) as unionpay_amount
    ,coalesce(sp.member_card_amount, 0) as member_card_amount
    ,coalesce(sp.gift_amount, 0) as  gift_amount
    ,coalesce(sp.yxapi_amount, 0) as   yxapi_amount
    ,coalesce(sp.other_pay_amount, 0) as other_pay_amount
    ,ss.dt
from dwd.dwd_sale_store_sale_info_i ss
inner join dim.dwd_dim_date_f dd on date_format(ss.trade_date,'yyyy-MM-dd')=dd.trade_date
inner join dim.dwd_dim_source_type_map_i  st on ss.source_type=st.original_source_type and st.company='1' and st.dt='2026-08-18'
inner join dim.dwd_dim_store_i bs on ss.store_no=bs.store_no and bs.dt='2026-08-18'
left join dwd.dwd_sale_pay_dtl_i sp
  on ss.order_no=sp.order_no and sp.trade_source=2;
  
