CREATE TABLE IF NOT EXISTS dws_goods_store_goods_statistics_quarter_i(
    trade_date                  DATE,
    week_trade_date             DATE,
    month_trade_date            DATE,
    hourly                      INT,
    quarter                     INT,
    quarters                    INT,

    store_no                    VARCHAR(50),
    store_name                  VARCHAR(50),
    store_sale_type             INT,
    store_type_code             INT,
    worker_num                  INT,
    store_area                  DECIMAL(27, 2),
    city_id                     INT,
    city_name                   VARCHAR(50),
    region_code                 VARCHAR(50),
    region_name                 VARCHAR(50),
    is_day_clear                INT,

    first_category_no           VARCHAR(50),
    first_category_name         VARCHAR(50),
    second_category_no          VARCHAR(50),
    second_category_name        VARCHAR(50),
    third_category_no           VARCHAR(50),
    third_category_name         VARCHAR(50),
    goods_no                    VARCHAR(50),
    goods_name                  VARCHAR(200),
    is_clean                    INT,

    order_num                   INT,
    sale_qty                    DECIMAL(27, 3),
    sale_amount                 DECIMAL(27, 2),
    dis_amount                  DECIMAL(27, 2),
    sale_cost                   DECIMAL(27, 2),
    balance_amount              DECIMAL(27, 2),
    cancel_sale_amount          DECIMAL(27, 2),
    refund_sale_amount          DECIMAL(27, 2),
    online_order_num            INT,
    offline_order_num           INT,
    online_sale_qty             DECIMAL(27, 3),
    offline_sale_qty            DECIMAL(27, 3),
    online_sale_amount          DECIMAL(27, 2),
    offline_sale_amount         DECIMAL(27, 2),
    online_sale_cost            DECIMAL(27, 2),
    offline_sale_cost           DECIMAL(27, 2),
    loss_qty                    DECIMAL(27, 3),
    loss_amount                 DECIMAL(27, 2),
    receipt_qty                 DECIMAL(27, 3),
    receipt_amount              DECIMAL(27, 2),
    require_qty                 DECIMAL(27, 3),
    require_amount              DECIMAL(27, 2),
    PRIMARY KEY (trade_date, quarters, store_no, goods_no)
)
;
COMMENT on table dws_goods_store_goods_statistics_quarter_i is '门店商品分析刻表';

COMMENT on column dws_goods_store_goods_statistics_quarter_i.trade_date                is  '交易日期';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.week_trade_date           is  '周一日期';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.month_trade_date          is  '月一日期';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.hourly                    is  '交易小时(0-23)';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.quarter                   is  '刻钟:1.0-15,2.15-30,3.30-45,4.45-60';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.quarters                  is  '刻钟数:hourly*4+quarters';

COMMENT on column dws_goods_store_goods_statistics_quarter_i.store_no                  is  '店铺编码';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.store_name                is  '店铺名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.store_sale_type           is  '店铺销售类型';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.store_type_code           is  '分店类型';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.worker_num                is  '员工人数';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.store_area                is  '门店面积';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.city_id                   is  '城市ID';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.city_name                 is  '城市名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.region_code               is  '区域编码';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.region_name               is  '区域名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.is_day_clear              is  '是否日清:0否,1是';

COMMENT on column dws_goods_store_goods_statistics_quarter_i.first_category_no         is  '一级分类编码';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.first_category_name       is  '一级分类名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.second_category_no        is  '二级分类编码';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.second_category_name      is  '二级分类名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.third_category_no         is  '三级分类编码';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.third_category_name       is  '三级分类名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.goods_no                  is  '商品编码';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.goods_name                is  '商品名称';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.is_clean                  is  '商品是否日清:0否,1是';

COMMENT on column dws_goods_store_goods_statistics_quarter_i.order_num                 is  '销售单量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.sale_qty                  is  '销售数量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.sale_amount               is  '销售金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.dis_amount                is  '折扣金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.sale_cost                 is  '销售成本';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.balance_amount            is  '余额支付金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.cancel_sale_amount        is  '取消商品销售金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.refund_sale_amount        is  '退款商品销售金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.online_order_num          is  '线上单量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.offline_order_num         is  '线下单量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.online_sale_qty           is  '线上销售数量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.offline_sale_qty          is  '线下销售数量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.online_sale_amount        is  '线上销售金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.offline_sale_amount       is  '线下销售金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.online_sale_cost          is  '线上销售成本';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.offline_sale_cost         is  '线下销售成本';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.loss_qty                  is  '损耗数量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.loss_amount               is  '损耗金额';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.receipt_qty               is  '收货数量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.receipt_amount            is  '收货金额（收货-退货-退配+调入-调出）';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.require_qty               is  '要货数量';
COMMENT on column dws_goods_store_goods_statistics_quarter_i.require_amount            is  '要货金额';


CREATE TABLE IF NOT EXISTS ads_goods_store_goods_statistics_day_i (
    trade_date                   DATE
    ,week_trade_date             DATE          
    ,month_trade_date            DATE          
	
    ,store_no                    VARCHAR(50)          
    ,store_name                  VARCHAR(50)          
    ,store_sale_type             INT          
    ,store_type_code             INT          
    ,worker_num                  INT          
    ,store_area                  DECIMAL(27,2)   
    ,city_id                     INT          
    ,city_name                   VARCHAR(50)          
    ,region_code                 VARCHAR(50)          
    ,region_name                 VARCHAR(50)          
    ,is_day_clear                INT          
	
    ,first_category_no           VARCHAR(50)          
    ,first_category_name         VARCHAR(50)          
    ,second_category_no          VARCHAR(50)          
    ,second_category_name        VARCHAR(50)          
    ,third_category_no           VARCHAR(50)          
    ,third_category_name         VARCHAR(50)          
    ,goods_no                    VARCHAR(50)          
    ,goods_name                  VARCHAR(200)          
    ,is_clean                    INT          
	
    ,order_num                   INT          
    ,sale_qty                    DECIMAL(27, 3)  
    ,sale_amount                 DECIMAL(27, 2)  
    ,dis_amount                  DECIMAL(27, 2)  
    ,sale_cost                   DECIMAL(27, 2)  
    ,balance_amount              DECIMAL(27, 2)  
    ,cancel_sale_amount          DECIMAL(27, 2)  
    ,refund_sale_amount          DECIMAL(27, 2)  
    ,online_order_num            INT          
    ,offline_order_num           INT          
    ,online_sale_qty             DECIMAL(27, 3)  
    ,offline_sale_qty            DECIMAL(27, 3)  
    ,online_sale_amount          DECIMAL(27, 2)  
    ,offline_sale_amount         DECIMAL(27, 2)  
    ,online_sale_cost            DECIMAL(27, 2)  
    ,offline_sale_cost           DECIMAL(27, 2)  
    ,loss_qty                    DECIMAL(27, 3)  
    ,loss_amount                 DECIMAL(27, 2)  
    ,receipt_qty                 DECIMAL(27, 3)  
    ,receipt_amount              DECIMAL(27, 2)  
    ,require_qty                 DECIMAL(27, 3)  
    ,require_amount              DECIMAL(27, 2)
    ,PRIMARY KEY (trade_date,store_no,goods_no)	
);

comment on table ads_goods_store_goods_statistics_day_i                             is '门店商品销售天表';
comment on column ads_goods_store_goods_statistics_day_i.trade_date                                 is '交易日期';
comment on column ads_goods_store_goods_statistics_day_i.week_trade_date                            is '周一日期';
comment on column ads_goods_store_goods_statistics_day_i.month_trade_date                           is '月一日期';
comment on column ads_goods_store_goods_statistics_day_i.store_no                      is '店铺编码';
comment on column ads_goods_store_goods_statistics_day_i.store_name                    is '店铺名称';
comment on column ads_goods_store_goods_statistics_day_i.store_sale_type               is '店铺销售类型';
comment on column ads_goods_store_goods_statistics_day_i.store_type_code               is '分店类型';
comment on column ads_goods_store_goods_statistics_day_i.worker_num                    is '员工人数';
comment on column ads_goods_store_goods_statistics_day_i.store_area                           is '门店面积';
comment on column ads_goods_store_goods_statistics_day_i.city_id                       is '城市ID';
comment on column ads_goods_store_goods_statistics_day_i.city_name                     is '城市名称';
comment on column ads_goods_store_goods_statistics_day_i.region_code                   is '区域编码';
comment on column ads_goods_store_goods_statistics_day_i.region_name                   is '区域名称';
comment on column ads_goods_store_goods_statistics_day_i.is_day_clear                  is '是否日清:0否;1是';
comment on column ads_goods_store_goods_statistics_day_i.first_category_no             is '一级分类编码';
comment on column ads_goods_store_goods_statistics_day_i.first_category_name           is '一级分类名称';
comment on column ads_goods_store_goods_statistics_day_i.second_category_no            is '二级分类编码';
comment on column ads_goods_store_goods_statistics_day_i.second_category_name          is '二级分类名称';
comment on column ads_goods_store_goods_statistics_day_i.third_category_no             is '三级分类编码';
comment on column ads_goods_store_goods_statistics_day_i.third_category_name           is '三级分类名称';
comment on column ads_goods_store_goods_statistics_day_i.goods_no                      is '商品编码';
comment on column ads_goods_store_goods_statistics_day_i.goods_name                    is '商品名称';
comment on column ads_goods_store_goods_statistics_day_i.is_clean                      is '商品是否日清:0否;1是';
comment on column ads_goods_store_goods_statistics_day_i.order_num                     is '销售单量';
comment on column ads_goods_store_goods_statistics_day_i.sale_qty                              is '销售数量';
comment on column ads_goods_store_goods_statistics_day_i.sale_amount                           is '销售金额';
comment on column ads_goods_store_goods_statistics_day_i.dis_amount                            is '折扣金额';
comment on column ads_goods_store_goods_statistics_day_i.sale_cost                             is '销售成本';
comment on column ads_goods_store_goods_statistics_day_i.balance_amount                        is '余额支付金额';
comment on column ads_goods_store_goods_statistics_day_i.cancel_sale_amount                    is '取消商品销售金额';
comment on column ads_goods_store_goods_statistics_day_i.refund_sale_amount                    is '退款商品销售金额';
comment on column ads_goods_store_goods_statistics_day_i.online_order_num              is '线上单量';
comment on column ads_goods_store_goods_statistics_day_i.offline_order_num             is '线下单量';
comment on column ads_goods_store_goods_statistics_day_i.online_sale_qty                       is '线上销售数量';
comment on column ads_goods_store_goods_statistics_day_i.offline_sale_qty                      is '线上销售数量';
comment on column ads_goods_store_goods_statistics_day_i.online_sale_amount                    is '线上销售金额';
comment on column ads_goods_store_goods_statistics_day_i.offline_sale_amount                   is '线下销售金额';
comment on column ads_goods_store_goods_statistics_day_i.online_sale_cost                      is '线上销售成本';
comment on column ads_goods_store_goods_statistics_day_i.offline_sale_cost                     is '线下销售成本';
comment on column ads_goods_store_goods_statistics_day_i.loss_qty                              is '损耗数量';
comment on column ads_goods_store_goods_statistics_day_i.loss_amount                           is '损耗金额';
comment on column ads_goods_store_goods_statistics_day_i.receipt_qty                           is '收货数量';
comment on column ads_goods_store_goods_statistics_day_i.receipt_amount                        is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_goods_store_goods_statistics_day_i.require_qty                           is '要货数量';
comment on column ads_goods_store_goods_statistics_day_i.require_amount                        is '要货金额';


CREATE TABLE IF NOT EXISTS ads_goods_city_goods_statistics_day_i (
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,

    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    first_category_no           VARCHAR(50)    ,
    first_category_name         VARCHAR(50)    ,
    second_category_no          VARCHAR(50)    ,
    second_category_name        VARCHAR(50)    ,
    third_category_no           VARCHAR(50)    ,
    third_category_name         VARCHAR(50)    ,
    goods_no                    VARCHAR(50)    ,
    goods_name                  VARCHAR(200)   ,
    is_clean                    INT            ,
											   
    order_num                   INT            ,
    sale_qty                    DECIMAL(27, 3) ,
    sale_amount                 DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    balance_amount              DECIMAL(27, 2) ,
    cancel_sale_amount          DECIMAL(27, 2) ,
    refund_sale_amount          DECIMAL(27, 2) ,
    online_order_num            INT            ,
    offline_order_num           INT            ,
    online_sale_qty             DECIMAL(27, 3) ,
    offline_sale_qty            DECIMAL(27, 3) ,
    online_sale_amount          DECIMAL(27, 2) ,
    offline_sale_amount         DECIMAL(27, 2) ,
    online_sale_cost            DECIMAL(27, 2) ,
    offline_sale_cost           DECIMAL(27, 2) ,
    loss_qty                    DECIMAL(27, 3) ,
    loss_amount                 DECIMAL(27, 2) ,
    receipt_qty                 DECIMAL(27, 3) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_qty                 DECIMAL(27, 3) ,
    require_amount              DECIMAL(27, 2) ,
        PRIMARY KEY (trade_date,store_sale_type,store_type_code,is_day_clear,city_id,goods_no,is_clean)
);


CREATE TABLE IF NOT EXISTS ads_category_store_third_category_statistics_day_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    worker_num                  INT            ,
    store_area                  DECIMAL(27,2)  ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    first_category_no           VARCHAR(50)    ,
    first_category_name         VARCHAR(50)    ,
    second_category_no          VARCHAR(50)    ,
    second_category_name        VARCHAR(50)    ,
    third_category_no           VARCHAR(50)    ,
    third_category_name         VARCHAR(50)    ,
											   
    order_num                   INT            ,
    sale_qty                    DECIMAL(27, 3) ,
    sale_amount                 DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    balance_amount              DECIMAL(27, 2) ,
    cancel_sale_amount          DECIMAL(27, 2) ,
    refund_sale_amount          DECIMAL(27, 2) ,
    online_order_num            INT            ,
    offline_order_num           INT            ,
    online_sale_amount          DECIMAL(27, 2) ,
    offline_sale_amount         DECIMAL(27, 2) ,
    online_sale_cost            DECIMAL(27, 2) ,
    offline_sale_cost           DECIMAL(27, 2) ,
    loss_amount                 DECIMAL(27, 2) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_amount              DECIMAL(27, 2) ,
	PRIMARY KEY (trade_date,store_no,first_category_no,second_category_no,third_category_no)
);

CREATE TABLE IF NOT EXISTS ads_category_store_second_category_statistics_day_i(
    trade_date                  DATE            ,
    week_trade_date             DATE            ,
    month_trade_date            DATE            ,
												
    store_no                    VARCHAR(50)     ,
    store_name                  VARCHAR(50)     ,
    store_sale_type             INT             ,
    store_type_code             INT             ,
    worker_num                  INT             ,
    store_area                  DECIMAL(27,2)   ,
    city_id                     INT             ,
    city_name                   VARCHAR(50)     ,
    region_code                 VARCHAR(50)     ,
    region_name                 VARCHAR(50)     ,
    is_day_clear                INT             ,
												
    first_category_no           VARCHAR(50)     ,
    first_category_name         VARCHAR(50)     ,
    second_category_no          VARCHAR(50)     ,
    second_category_name        VARCHAR(50)     ,
												
    order_num                   INT             ,
    sale_qty                    DECIMAL(27, 3)  ,
    sale_amount                 DECIMAL(27, 2)  ,
    dis_amount                  DECIMAL(27, 2)  ,
    sale_cost                   DECIMAL(27, 2)  ,
    balance_amount              DECIMAL(27, 2)  ,
    cancel_sale_amount          DECIMAL(27, 2)  ,
    refund_sale_amount          DECIMAL(27, 2)  ,
    online_order_num            INT             ,
    offline_order_num           INT             ,
    online_sale_amount          DECIMAL(27, 2)  ,
    offline_sale_amount         DECIMAL(27, 2)  ,
    online_sale_cost            DECIMAL(27, 2)  ,
    offline_sale_cost           DECIMAL(27, 2)  ,
    loss_amount                 DECIMAL(27, 2)  ,
    receipt_amount              DECIMAL(27, 2)  ,
    require_amount              DECIMAL(27, 2)  ,
	PRIMARY KEY (trade_date,store_no,first_category_no,second_category_no)
);

CREATE TABLE IF NOT EXISTS ads_category_store_first_category_statistics_day_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    worker_num                  INT            ,
    store_area                  DECIMAL(27,2)  ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    first_category_no           VARCHAR(50)    ,
    first_category_name         VARCHAR(50)    ,
											   
    order_num                   INT            ,
    sale_qty                    DECIMAL(27, 3) ,
    sale_amount                 DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    balance_amount              DECIMAL(27, 2) ,
    cancel_sale_amount          DECIMAL(27, 2) ,
    refund_sale_amount          DECIMAL(27, 2) ,
    online_order_num            INT            ,
    offline_order_num           INT            ,
    online_sale_amount          DECIMAL(27, 2) ,
    offline_sale_amount         DECIMAL(27, 2) ,
    online_sale_cost            DECIMAL(27, 2) ,
    offline_sale_cost           DECIMAL(27, 2) ,
    loss_amount                 DECIMAL(27, 2) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_amount              DECIMAL(27, 2) ,
	PRIMARY KEY (trade_date,store_no,first_category_no)
);

CREATE TABLE IF NOT EXISTS dws_store_manage_statistics_quarter_i(
    trade_date          DATE           ,
    week_trade_date     DATE           ,
    month_trade_date    DATE           ,
    hourly              INT            ,
    quarter             INT            ,
    quarters            INT            ,
									   
    store_no            VARCHAR(50)    ,
    store_name          VARCHAR(50)    ,
    store_sale_type     INT            ,
    store_type_code     INT            ,
    worker_num          INT            ,
    store_area          DECIMAL(27, 2) ,
    city_id             INT            ,
    city_name           VARCHAR(50)    ,
    region_code         VARCHAR(50)    ,
    region_name         VARCHAR(50)    ,
    is_day_clear        INT            ,
									   
    order_num           INT            ,
    sale_qty            DECIMAL(27, 3) ,
    sale_amount         DECIMAL(27, 2) ,
    dis_amount          DECIMAL(27, 2) ,
    sale_cost           DECIMAL(27, 2) ,
    balance_amount      DECIMAL(27, 2) ,
    cancel_sale_amount  DECIMAL(27, 2) ,
    refund_sale_amount  DECIMAL(27, 2) ,
    online_order_num    INT            ,
    offline_order_num   INT            ,
    online_sale_amount  DECIMAL(27, 2) ,
    offline_sale_amount DECIMAL(27, 2) ,
    online_sale_cost    DECIMAL(27, 2) ,
    offline_sale_cost   DECIMAL(27, 2) ,
    loss_amount         DECIMAL(27, 2) ,
    receipt_amount      DECIMAL(27, 2) ,
    require_amount      DECIMAL(27, 2) ,
									   
    ol_mem_order_num    INT            ,
    vip_mem_order_num   INT            ,
    ol_mem_sale_amount  DECIMAL(27, 2) ,
    vip_mem_sale_amount DECIMAL(27, 2) ,
    ol_mem_sale_cost    DECIMAL(27, 2) ,
    vip_mem_sale_cost   DECIMAL(27, 2) ,
    ol_mem_trade_num    INT            ,
    vip_mem_trade_num   INT            ,
									   
    balance_sale_amount DECIMAL(27, 2) ,
    balance_order_num   INT            ,
    balance_sale_cost   DECIMAL(27, 2) ,
    balance_people_num  INT            ,
	PRIMARY KEY (trade_date, quarters, store_no)
);

CREATE TABLE IF NOT EXISTS ads_store_manage_statistics_day_i(
    trade_date                  DATE            ,
    week_trade_date             DATE            ,
    month_trade_date            DATE            ,
												
    store_no                    VARCHAR(50)     ,
    store_name                  VARCHAR(50)     ,
    store_sale_type             INT             ,
    store_type_code             INT             ,
    worker_num                  INT             ,
    store_area                  DECIMAL(27,2)   ,
    city_id                     INT             ,
    city_name                   VARCHAR(50)     ,
    region_code                 VARCHAR(50)     ,
    region_name                 VARCHAR(50)     ,
    is_day_clear                INT             ,
												
    order_num                   INT             ,
    sale_qty                    DECIMAL(27, 3)  ,
    sale_amount                 DECIMAL(27, 2)  ,
    dis_amount                  DECIMAL(27, 2)  ,
    sale_cost                   DECIMAL(27, 2)  ,
    balance_amount              DECIMAL(27, 2)  ,
    cancel_sale_amount          DECIMAL(27, 2)  ,
    refund_sale_amount          DECIMAL(27, 2)  ,
    online_order_num            INT             ,
    offline_order_num           INT             ,
    online_sale_amount          DECIMAL(27, 2)  ,
    offline_sale_amount         DECIMAL(27, 2)  ,
    online_sale_cost            DECIMAL(27, 2)  ,
    offline_sale_cost           DECIMAL(27, 2)  ,
    loss_amount                 DECIMAL(27, 2)  ,
    receipt_amount              DECIMAL(27, 2)  ,
    require_amount              DECIMAL(27, 2)  ,
												
    ol_mem_order_num            INT             ,
   vip_mem_order_num           INT              ,
   ol_mem_sale_amount          DECIMAL(27, 2)   ,
   vip_mem_sale_amount         DECIMAL(27, 2)   ,
   ol_mem_sale_cost            DECIMAL(27, 2)   ,
   vip_mem_sale_cost           DECIMAL(27, 2)   ,
   ol_mem_trade_num            INT              ,
   vip_mem_trade_num           INT              ,
												
   balance_sale_amount         DECIMAL(27, 2)   ,
   balance_order_num           INT              ,
   balance_sale_cost           DECIMAL(27, 2)   ,
   balance_people_num          INT              ,
   PRIMARY KEY (trade_date,store_no)
);

CREATE TABLE IF NOT EXISTS ads_store_city_manage_statistics_quarter_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
    hourly                      INT            ,
    quarter                     INT            ,
    quarters                    INT            ,
											   
    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    order_num                   INT            ,
    sale_qty                    DECIMAL(27, 3) ,
    sale_amount                 DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    balance_amount              DECIMAL(27, 2) ,
    cancel_sale_amount          DECIMAL(27, 2) ,
    refund_sale_amount          DECIMAL(27, 2) ,
    online_order_num            INT            ,
    offline_order_num           INT            ,
    online_sale_amount          DECIMAL(27, 2) ,
    offline_sale_amount         DECIMAL(27, 2) ,
    online_sale_cost            DECIMAL(27, 2) ,
    offline_sale_cost           DECIMAL(27, 2) ,
    loss_amount                 DECIMAL(27, 2) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_amount              DECIMAL(27, 2) ,
											   
    ol_mem_order_num            INT            ,
   vip_mem_order_num           INT             ,
   ol_mem_sale_amount          DECIMAL(27, 2)  ,
   vip_mem_sale_amount         DECIMAL(27, 2)  ,
   ol_mem_sale_cost            DECIMAL(27, 2)  ,
   vip_mem_sale_cost           DECIMAL(27, 2)  ,
   ol_mem_trade_num            INT             ,
   vip_mem_trade_num           INT             ,
											   
   balance_sale_amount         DECIMAL(27, 2)  ,
   balance_order_num           INT             ,
   balance_sale_cost           DECIMAL(27, 2)  ,
   balance_people_num          INT             ,
   PRIMARY KEY (trade_date,quarters,city_id,store_sale_type,store_type_code,is_day_clear)
);

CREATE TABLE IF NOT EXISTS ads_store_city_manage_statistics_day_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    order_num                   INT            ,
    sale_qty                    DECIMAL(27, 3) ,
    sale_amount                 DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    balance_amount              DECIMAL(27, 2) ,
    cancel_sale_amount          DECIMAL(27, 2) ,
    refund_sale_amount          DECIMAL(27, 2) ,
    online_order_num            INT            ,
    offline_order_num           INT            ,
    online_sale_amount          DECIMAL(27, 2) ,
    offline_sale_amount         DECIMAL(27, 2) ,
    online_sale_cost            DECIMAL(27, 2) ,
    offline_sale_cost           DECIMAL(27, 2) ,
    loss_amount                 DECIMAL(27, 2) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_amount              DECIMAL(27, 2) ,
											   
    ol_mem_order_num            INT            ,
   vip_mem_order_num           INT             ,
   ol_mem_sale_amount          DECIMAL(27, 2)  ,
   vip_mem_sale_amount         DECIMAL(27, 2)  ,
   ol_mem_sale_cost            DECIMAL(27, 2)  ,
   vip_mem_sale_cost           DECIMAL(27, 2)  ,
   ol_mem_trade_num            INT             ,
   vip_mem_trade_num           INT             ,
											   
   balance_sale_amount         DECIMAL(27, 2)  ,
   balance_order_num           INT             ,
   balance_sale_cost           DECIMAL(27, 2)  ,
   balance_people_num          INT             ,
   PRIMARY KEY (trade_date,city_id,store_sale_type,store_type_code,is_day_clear)
);

CREATE TABLE IF NOT EXISTS ads_marketing_store_source_type_day_i(
    trade_date                  DATE            ,
    week_trade_date             DATE            ,
    month_trade_date            DATE            ,
												
    store_no                    VARCHAR(50)     ,
    store_name                  VARCHAR(50)     ,
    store_sale_type             INT             ,
    store_type_code             INT             ,
    worker_num                  INT             ,
    store_area                  DECIMAL(27,2)   ,
    city_id                     INT             ,
    city_name                   VARCHAR(50)     ,
    region_code                 VARCHAR(50)     ,
    region_name                 VARCHAR(50)     ,
    is_day_clear                INT             ,
												
    source_type                 INT             ,
    source_type_name            VARCHAR(50)     ,
												
    order_num                   INT             ,
    refund_order_num            INT             ,
    cancel_order_num            INT             ,
    sale_amount                 DECIMAL(27, 2)  ,
    sale_cost                   DECIMAL(27, 2)  ,
    dis_amount                  DECIMAL(27, 2)  ,
	PRIMARY KEY (trade_date,store_no,source_type)
);

CREATE TABLE IF NOT EXISTS ads_marketing_store_category_clean_data_day_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    worker_num                  INT            ,
    store_area                  DECIMAL(27,2)  ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    first_category_no           VARCHAR(50)    ,
    first_category_name         VARCHAR(50)    ,
											   
    is_clean                    INT            ,
											   
    sku_num                     INT            ,
    order_num                   INT            ,
    sale_qty                    DECIMAL(27, 3) ,
    sale_amount                 DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    online_order_num            INT            ,
    offline_order_num           INT            ,
    online_sale_amount          DECIMAL(27, 2) ,
    offline_sale_amount         DECIMAL(27, 2) ,
    online_sale_cost            DECIMAL(27, 2) ,
    offline_sale_cost           DECIMAL(27, 2) ,
    loss_amount                 DECIMAL(27, 2) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_amount              DECIMAL(27, 2) ,
	PRIMARY KEY (trade_date,store_no,first_category_no,is_clean)
);

CREATE TABLE IF NOT EXISTS ads_marketing_store_clean_data_day_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    worker_num                  INT            ,
    store_area                  DECIMAL(27,2)  ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    is_clean                    INT            ,
											   
    sku_num                     INT            ,
    order_num                   INT            ,
    order_num_pre               INT            ,
    order_num_after             INT            ,
    sale_amount                 DECIMAL(27, 2) ,
    sale_amount_pre             DECIMAL(27, 2) ,
    sale_amount_after           DECIMAL(27, 2) ,
    dis_amount                  DECIMAL(27, 2) ,
    dis_amount_pre              DECIMAL(27, 2) ,
    dis_amount_after            DECIMAL(27, 2) ,
    sale_cost                   DECIMAL(27, 2) ,
    sale_cost_pre               DECIMAL(27, 2) ,
    sale_cost_after             DECIMAL(27, 2) ,
    sale_profit                 DECIMAL(27, 2) ,
    sale_profit_pre             DECIMAL(27, 2) ,
    sale_profit_after           DECIMAL(27, 2) ,
    loss_amount                 DECIMAL(27, 2) ,
    loss_amount_pre             DECIMAL(27, 2) ,
    loss_amount_after           DECIMAL(27, 2) ,
    receipt_amount              DECIMAL(27, 2) ,
    require_amount              DECIMAL(27, 2) ,
	PRIMARY KEY (trade_date,store_no,is_clean)
);

comment on table ads_goods_city_goods_statistics_day_i is '城市商品销售天表';
comment on column ads_goods_city_goods_statistics_day_i.trade_date                     is '交易日期';
comment on column ads_goods_city_goods_statistics_day_i.week_trade_date                is '周一日期';
comment on column ads_goods_city_goods_statistics_day_i.month_trade_date               is '月一日期';

comment on column ads_goods_city_goods_statistics_day_i.store_sale_type               is '店铺销售类型';
comment on column ads_goods_city_goods_statistics_day_i.store_type_code               is '分店类型';
comment on column ads_goods_city_goods_statistics_day_i.city_id                       is '城市ID';
comment on column ads_goods_city_goods_statistics_day_i.city_name                             is '城市名称';
comment on column ads_goods_city_goods_statistics_day_i.region_code                           is '区域编码';
comment on column ads_goods_city_goods_statistics_day_i.region_name                           is '区域名称';
comment on column ads_goods_city_goods_statistics_day_i.is_day_clear                  is '是否日清:0否;1是';

comment on column ads_goods_city_goods_statistics_day_i.first_category_no                     is '一级分类编码';
comment on column ads_goods_city_goods_statistics_day_i.first_category_name                   is '一级分类名称';
comment on column ads_goods_city_goods_statistics_day_i.second_category_no                    is '二级分类编码';
comment on column ads_goods_city_goods_statistics_day_i.second_category_name                  is '二级分类名称';
comment on column ads_goods_city_goods_statistics_day_i.third_category_no                     is '三级分类编码';
comment on column ads_goods_city_goods_statistics_day_i.third_category_name                   is '三级分类名称';
comment on column ads_goods_city_goods_statistics_day_i.goods_no                              is '商品编码';
comment on column ads_goods_city_goods_statistics_day_i.goods_name                            is '商品名称';
comment on column ads_goods_city_goods_statistics_day_i.is_clean                      is '商品是否日清:0否;1是';

comment on column ads_goods_city_goods_statistics_day_i.order_num                     is '销售单量';
comment on column ads_goods_city_goods_statistics_day_i.sale_qty                                 is '销售数量';
comment on column ads_goods_city_goods_statistics_day_i.sale_amount                              is '销售金额';
comment on column ads_goods_city_goods_statistics_day_i.dis_amount                               is '折扣金额';
comment on column ads_goods_city_goods_statistics_day_i.sale_cost                                is '销售成本';
comment on column ads_goods_city_goods_statistics_day_i.balance_amount                           is '余额支付金额';
comment on column ads_goods_city_goods_statistics_day_i.cancel_sale_amount                       is '取消商品销售金额';
comment on column ads_goods_city_goods_statistics_day_i.refund_sale_amount                       is '退款商品销售金额';
comment on column ads_goods_city_goods_statistics_day_i.online_order_num              is '线上单量';
comment on column ads_goods_city_goods_statistics_day_i.offline_order_num             is '线下单量';
comment on column ads_goods_city_goods_statistics_day_i.online_sale_qty                          is '线上销售数量';
comment on column ads_goods_city_goods_statistics_day_i.offline_sale_qty                         is '线上销售数量';
comment on column ads_goods_city_goods_statistics_day_i.online_sale_amount                       is '线上销售金额';
comment on column ads_goods_city_goods_statistics_day_i.offline_sale_amount                      is '线下销售金额';
comment on column ads_goods_city_goods_statistics_day_i.online_sale_cost                         is '线上销售成本';
comment on column ads_goods_city_goods_statistics_day_i.offline_sale_cost                        is '线下销售成本';
comment on column ads_goods_city_goods_statistics_day_i.loss_qty                                 is '损耗数量';
comment on column ads_goods_city_goods_statistics_day_i.loss_amount                              is '损耗金额';
comment on column ads_goods_city_goods_statistics_day_i.receipt_qty                              is '收货数量';
comment on column ads_goods_city_goods_statistics_day_i.receipt_amount                           is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_goods_city_goods_statistics_day_i.require_qty                              is '要货数量';
comment on column ads_goods_city_goods_statistics_day_i.require_amount                           is '要货金额';



comment on table ads_category_store_third_category_statistics_day_i                            is '门店第三品类分析天表';
comment on column ads_category_store_third_category_statistics_day_i.trade_date                  is '交易日期';
comment on column ads_category_store_third_category_statistics_day_i.week_trade_date             is '周一日期';
comment on column ads_category_store_third_category_statistics_day_i.month_trade_date            is '月一日期';

comment on column ads_category_store_third_category_statistics_day_i.store_no                           is '店铺编码';
comment on column ads_category_store_third_category_statistics_day_i.store_name                         is '店铺名称';
comment on column ads_category_store_third_category_statistics_day_i.store_sale_type            is '店铺销售类型';
comment on column ads_category_store_third_category_statistics_day_i.store_type_code            is '分店类型';
comment on column ads_category_store_third_category_statistics_day_i.worker_num                 is '员工人数';
comment on column ads_category_store_third_category_statistics_day_i.store_area                           is '门店面积';
comment on column ads_category_store_third_category_statistics_day_i.city_id                    is '城市ID';
comment on column ads_category_store_third_category_statistics_day_i.city_name                          is '城市名称';
comment on column ads_category_store_third_category_statistics_day_i.region_code                        is '区域编码';
comment on column ads_category_store_third_category_statistics_day_i.region_name                        is '区域名称';
comment on column ads_category_store_third_category_statistics_day_i.is_day_clear               is '是否日清:0否,1是';

comment on column ads_category_store_third_category_statistics_day_i.first_category_no                  is '一级分类编码';
comment on column ads_category_store_third_category_statistics_day_i.first_category_name                is '一级分类名称';
comment on column ads_category_store_third_category_statistics_day_i.second_category_no                 is '二级分类编码';
comment on column ads_category_store_third_category_statistics_day_i.second_category_name               is '二级分类名称';
comment on column ads_category_store_third_category_statistics_day_i.third_category_no                  is '三级分类编码';
comment on column ads_category_store_third_category_statistics_day_i.third_category_name                is '三级分类名称';

comment on column ads_category_store_third_category_statistics_day_i.order_num                  is '销售单量';
comment on column ads_category_store_third_category_statistics_day_i.sale_qty                              is '销售数量';
comment on column ads_category_store_third_category_statistics_day_i.sale_amount                           is '销售金额';
comment on column ads_category_store_third_category_statistics_day_i.dis_amount                            is '折扣金额';
comment on column ads_category_store_third_category_statistics_day_i.sale_cost                             is '销售成本';
comment on column ads_category_store_third_category_statistics_day_i.balance_amount                        is '余额支付金额';
comment on column ads_category_store_third_category_statistics_day_i.cancel_sale_amount                    is '取消商品销售金额';
comment on column ads_category_store_third_category_statistics_day_i.refund_sale_amount                    is '退款商品销售金额';
comment on column ads_category_store_third_category_statistics_day_i.online_order_num           is '线上单量';
comment on column ads_category_store_third_category_statistics_day_i.offline_order_num          is '线下单量';
comment on column ads_category_store_third_category_statistics_day_i.online_sale_amount                    is '线上销售金额';
comment on column ads_category_store_third_category_statistics_day_i.offline_sale_amount                   is '线下销售金额';
comment on column ads_category_store_third_category_statistics_day_i.online_sale_cost                      is '线上销售成本';
comment on column ads_category_store_third_category_statistics_day_i.offline_sale_cost                     is '线下销售成本';
comment on column ads_category_store_third_category_statistics_day_i.loss_amount                           is '损耗金额';
comment on column ads_category_store_third_category_statistics_day_i.receipt_amount                        is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_category_store_third_category_statistics_day_i.require_amount                        is '要货金额';


comment on table ads_category_store_second_category_statistics_day_i                             is '门店第二品类分析天表';
comment on column  ads_category_store_second_category_statistics_day_i.trade_date                   is '交易日期';
comment on column  ads_category_store_second_category_statistics_day_i.week_trade_date              is '周一日期';
comment on column  ads_category_store_second_category_statistics_day_i.month_trade_date             is '月一日期';

comment on column  ads_category_store_second_category_statistics_day_i.store_no                            is '店铺编码';
comment on column  ads_category_store_second_category_statistics_day_i.store_name                          is '店铺名称';
comment on column  ads_category_store_second_category_statistics_day_i.store_sale_type             is '店铺销售类型';
comment on column  ads_category_store_second_category_statistics_day_i.store_type_code             is '分店类型';
comment on column  ads_category_store_second_category_statistics_day_i.worker_num                  is '员工人数';
comment on column  ads_category_store_second_category_statistics_day_i.store_area                            is '门店面积';
comment on column  ads_category_store_second_category_statistics_day_i.city_id                     is '城市ID';
comment on column  ads_category_store_second_category_statistics_day_i.city_name                           is '城市名称';
comment on column  ads_category_store_second_category_statistics_day_i.region_code                         is '区域编码';
comment on column  ads_category_store_second_category_statistics_day_i.region_name                         is '区域名称';
comment on column  ads_category_store_second_category_statistics_day_i.is_day_clear                is '是否日清:0否,1是';

comment on column  ads_category_store_second_category_statistics_day_i.first_category_no                   is '一级分类编码';
comment on column  ads_category_store_second_category_statistics_day_i.first_category_name                 is '一级分类名称';
comment on column  ads_category_store_second_category_statistics_day_i.second_category_no                  is '二级分类编码';
comment on column  ads_category_store_second_category_statistics_day_i.second_category_name                is '二级分类名称';

comment on column  ads_category_store_second_category_statistics_day_i.order_num                   is '销售单量';
comment on column  ads_category_store_second_category_statistics_day_i.sale_qty                               is '销售数量';
comment on column  ads_category_store_second_category_statistics_day_i.sale_amount                            is '销售金额';
comment on column  ads_category_store_second_category_statistics_day_i.dis_amount                             is '折扣金额';
comment on column  ads_category_store_second_category_statistics_day_i.sale_cost                              is '销售成本';
comment on column  ads_category_store_second_category_statistics_day_i.balance_amount                         is '余额支付金额';
comment on column  ads_category_store_second_category_statistics_day_i.cancel_sale_amount                     is '取消商品销售金额';
comment on column  ads_category_store_second_category_statistics_day_i.refund_sale_amount                     is '退款商品销售金额';
comment on column  ads_category_store_second_category_statistics_day_i.online_order_num            is '线上单量';
comment on column  ads_category_store_second_category_statistics_day_i.offline_order_num           is '线下单量';
comment on column  ads_category_store_second_category_statistics_day_i.online_sale_amount                     is '线上销售金额';
comment on column  ads_category_store_second_category_statistics_day_i.offline_sale_amount                    is '线下销售金额';
comment on column  ads_category_store_second_category_statistics_day_i.online_sale_cost                       is '线上销售成本';
comment on column  ads_category_store_second_category_statistics_day_i.offline_sale_cost                      is '线下销售成本';
comment on column  ads_category_store_second_category_statistics_day_i.loss_amount                            is '损耗金额';
comment on column  ads_category_store_second_category_statistics_day_i.receipt_amount                         is '收货金额（收货-退货-退配+调入-调出）';
comment on column  ads_category_store_second_category_statistics_day_i.require_amount                         is '要货金额';


comment on table ads_category_store_first_category_statistics_day_i             is '门店第一品类分析天表';
comment on column  ads_category_store_first_category_statistics_day_i.trade_date                    is '交易日期';
comment on column  ads_category_store_first_category_statistics_day_i.week_trade_date               is '周一日期';
comment on column  ads_category_store_first_category_statistics_day_i.month_trade_date              is '月一日期';

comment on column  ads_category_store_first_category_statistics_day_i.store_no                             is '店铺编码';
comment on column  ads_category_store_first_category_statistics_day_i.store_name                           is '店铺名称';
comment on column  ads_category_store_first_category_statistics_day_i.store_sale_type              is '店铺销售类型';
comment on column  ads_category_store_first_category_statistics_day_i.store_type_code              is '分店类型';
comment on column  ads_category_store_first_category_statistics_day_i.worker_num                   is '员工人数';
comment on column  ads_category_store_first_category_statistics_day_i.store_area                             is '门店面积';
comment on column  ads_category_store_first_category_statistics_day_i.city_id                      is '城市ID';
comment on column  ads_category_store_first_category_statistics_day_i.city_name                            is '城市名称';
comment on column  ads_category_store_first_category_statistics_day_i.region_code                          is '区域编码';
comment on column  ads_category_store_first_category_statistics_day_i.region_name                          is '区域名称';
comment on column  ads_category_store_first_category_statistics_day_i.is_day_clear                 is '是否日清:0否,1是';

comment on column  ads_category_store_first_category_statistics_day_i.first_category_no                    is '一级分类编码';
comment on column  ads_category_store_first_category_statistics_day_i.first_category_name                  is '一级分类名称';

comment on column  ads_category_store_first_category_statistics_day_i.order_num                    is '销售单量';
comment on column  ads_category_store_first_category_statistics_day_i.sale_qty                                is '销售数量';
comment on column  ads_category_store_first_category_statistics_day_i.sale_amount                             is '销售金额';
comment on column  ads_category_store_first_category_statistics_day_i.dis_amount                              is '折扣金额';
comment on column  ads_category_store_first_category_statistics_day_i.sale_cost                               is '销售成本';
comment on column  ads_category_store_first_category_statistics_day_i.balance_amount                          is '余额支付金额';
comment on column  ads_category_store_first_category_statistics_day_i.cancel_sale_amount                      is '取消商品销售金额';
comment on column  ads_category_store_first_category_statistics_day_i.refund_sale_amount                      is '退款商品销售金额';
comment on column  ads_category_store_first_category_statistics_day_i.online_order_num             is '线上单量';
comment on column  ads_category_store_first_category_statistics_day_i.offline_order_num            is '线下单量';
comment on column  ads_category_store_first_category_statistics_day_i.online_sale_amount                      is '线上销售金额';
comment on column  ads_category_store_first_category_statistics_day_i.offline_sale_amount                     is '线下销售金额';
comment on column  ads_category_store_first_category_statistics_day_i.online_sale_cost                        is '线上销售成本';
comment on column  ads_category_store_first_category_statistics_day_i.offline_sale_cost                       is '线下销售成本';
comment on column  ads_category_store_first_category_statistics_day_i.loss_amount                             is '损耗金额';
comment on column  ads_category_store_first_category_statistics_day_i.receipt_amount                          is '收货金额（收货-退货-退配+调入-调出）';
comment on column  ads_category_store_first_category_statistics_day_i.require_amount                          is '要货金额';


comment on table dws_store_manage_statistics_quarter_i                          is '门店经营分析刻表';
comment on column dws_store_manage_statistics_quarter_i.trade_date             is '交易日期';
comment on column dws_store_manage_statistics_quarter_i.week_trade_date        is '周一日期';
comment on column dws_store_manage_statistics_quarter_i.month_trade_date       is '月一日期';
comment on column dws_store_manage_statistics_quarter_i.hourly                is '交易小时(0-23)';
comment on column dws_store_manage_statistics_quarter_i.quarter               is '刻钟:1.0-15,2.15-30,3.30-45,4.45-60';
comment on column dws_store_manage_statistics_quarter_i.quarters              is '刻钟数:hourly*4+quarters';

comment on column dws_store_manage_statistics_quarter_i.store_no                      is '店铺编码';
comment on column dws_store_manage_statistics_quarter_i.store_name                    is '店铺名称';
comment on column dws_store_manage_statistics_quarter_i.store_sale_type       is '店铺销售类型';
comment on column dws_store_manage_statistics_quarter_i.store_type_code       is '分店类型';
comment on column dws_store_manage_statistics_quarter_i.worker_num            is '员工人数';
comment on column dws_store_manage_statistics_quarter_i.store_area                       is '门店面积';
comment on column dws_store_manage_statistics_quarter_i.city_id               is '城市ID';
comment on column dws_store_manage_statistics_quarter_i.city_name                     is '城市名称';
comment on column dws_store_manage_statistics_quarter_i.region_code                   is '区域编码';
comment on column dws_store_manage_statistics_quarter_i.region_name                   is '区域名称';
comment on column dws_store_manage_statistics_quarter_i.is_day_clear          is '是否日清:0否,1是';

comment on column dws_store_manage_statistics_quarter_i.order_num             is '销售单量';
comment on column dws_store_manage_statistics_quarter_i.sale_qty                         is '销售数量';
comment on column dws_store_manage_statistics_quarter_i.sale_amount                      is '销售金额';
comment on column dws_store_manage_statistics_quarter_i.dis_amount                       is '折扣金额';
comment on column dws_store_manage_statistics_quarter_i.sale_cost                        is '销售成本';
comment on column dws_store_manage_statistics_quarter_i.balance_amount                   is '余额支付金额';
comment on column dws_store_manage_statistics_quarter_i.cancel_sale_amount               is '取消商品销售金额';
comment on column dws_store_manage_statistics_quarter_i.refund_sale_amount               is '退款商品销售金额';
comment on column dws_store_manage_statistics_quarter_i.online_order_num      is '线上单量';
comment on column dws_store_manage_statistics_quarter_i.offline_order_num     is '线下单量';
comment on column dws_store_manage_statistics_quarter_i.online_sale_amount               is '线上销售金额';
comment on column dws_store_manage_statistics_quarter_i.offline_sale_amount              is '线下销售金额';
comment on column dws_store_manage_statistics_quarter_i.online_sale_cost                 is '线上销售成本';
comment on column dws_store_manage_statistics_quarter_i.offline_sale_cost                is '线下销售成本';
comment on column dws_store_manage_statistics_quarter_i.loss_amount                      is '损耗金额';
comment on column dws_store_manage_statistics_quarter_i.receipt_amount                   is '收货金额（收货-退货-退配+调入-调出）';
comment on column dws_store_manage_statistics_quarter_i.require_amount                   is '要货金额';

comment on column dws_store_manage_statistics_quarter_i.ol_mem_order_num      is '线上会员单量';
comment on column dws_store_manage_statistics_quarter_i.vip_mem_order_num     is '实体卡会员单量';
comment on column dws_store_manage_statistics_quarter_i.ol_mem_sale_amount               is '线上会员销售金额';
comment on column dws_store_manage_statistics_quarter_i.vip_mem_sale_amount              is '实体卡会员销售金额';
comment on column dws_store_manage_statistics_quarter_i.ol_mem_sale_cost                 is '线上会员销售成本';
comment on column dws_store_manage_statistics_quarter_i.vip_mem_sale_cost                is '实体卡会员销售成本';
comment on column dws_store_manage_statistics_quarter_i.ol_mem_trade_num      is '线上会员下单人数';
comment on column dws_store_manage_statistics_quarter_i.vip_mem_trade_num     is '实体卡会员下单人数';

comment on column dws_store_manage_statistics_quarter_i.balance_sale_amount                is '使用余额销售金额';
comment on column dws_store_manage_statistics_quarter_i.balance_order_num       is '使用余额单量';
comment on column dws_store_manage_statistics_quarter_i.balance_sale_cost                  is '使用余额的销售成本';
comment on column dws_store_manage_statistics_quarter_i.balance_people_num      is '使用余额的下单人数';


comment on table ads_store_manage_statistics_day_i                                is '门店经营分析天表';
comment on column ads_store_manage_statistics_day_i.trade_date                      is '交易日期';
comment on column ads_store_manage_statistics_day_i.week_trade_date                 is '周一日期';
comment on column ads_store_manage_statistics_day_i.month_trade_date                is '月一日期';

comment on column ads_store_manage_statistics_day_i.store_no                               is '店铺编码';
comment on column ads_store_manage_statistics_day_i.store_name                             is '店铺名称';
comment on column ads_store_manage_statistics_day_i.store_sale_type                is '店铺销售类型';
comment on column ads_store_manage_statistics_day_i.store_type_code                is '分店类型';
comment on column ads_store_manage_statistics_day_i.worker_num                     is '员工人数';
comment on column ads_store_manage_statistics_day_i.store_area                               is '门店面积';
comment on column ads_store_manage_statistics_day_i.city_id                        is '城市ID';
comment on column ads_store_manage_statistics_day_i.city_name                              is '城市名称';
comment on column ads_store_manage_statistics_day_i.region_code                            is '区域编码';
comment on column ads_store_manage_statistics_day_i.region_name                            is '区域名称';
comment on column ads_store_manage_statistics_day_i.is_day_clear                   is '是否日清:0否,1是';

comment on column ads_store_manage_statistics_day_i.order_num                      is '销售单量';
comment on column ads_store_manage_statistics_day_i.sale_qty                                  is '销售数量';
comment on column ads_store_manage_statistics_day_i.sale_amount                               is '销售金额';
comment on column ads_store_manage_statistics_day_i.dis_amount                                is '折扣金额';
comment on column ads_store_manage_statistics_day_i.sale_cost                                 is '销售成本';
comment on column ads_store_manage_statistics_day_i.balance_amount                            is '余额支付金额';
comment on column ads_store_manage_statistics_day_i.cancel_sale_amount                        is '取消商品销售金额';
comment on column ads_store_manage_statistics_day_i.refund_sale_amount                        is '退款商品销售金额';
comment on column ads_store_manage_statistics_day_i.online_order_num               is '线上单量';
comment on column ads_store_manage_statistics_day_i.offline_order_num              is '线下单量';
comment on column ads_store_manage_statistics_day_i.online_sale_amount                        is '线上销售金额';
comment on column ads_store_manage_statistics_day_i.offline_sale_amount                       is '线下销售金额';
comment on column ads_store_manage_statistics_day_i.online_sale_cost                          is '线上销售成本';
comment on column ads_store_manage_statistics_day_i.offline_sale_cost                         is '线下销售成本';
comment on column ads_store_manage_statistics_day_i.loss_amount                               is '损耗金额';
comment on column ads_store_manage_statistics_day_i.receipt_amount                            is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_store_manage_statistics_day_i.require_amount                            is '要货金额';

comment on column ads_store_manage_statistics_day_i.ol_mem_order_num               is '线上会员单量';
comment on column ads_store_manage_statistics_day_i.vip_mem_order_num              is '实体卡会员单量';
comment on column ads_store_manage_statistics_day_i.ol_mem_sale_amount                        is '线上会员销售金额';
comment on column ads_store_manage_statistics_day_i.vip_mem_sale_amount                       is '实体卡会员销售金额';
comment on column ads_store_manage_statistics_day_i.ol_mem_sale_cost                          is '线上会员销售成本';
comment on column ads_store_manage_statistics_day_i.vip_mem_sale_cost                         is '实体卡会员销售成本';
comment on column ads_store_manage_statistics_day_i.ol_mem_trade_num               is '线上会员下单人数';
comment on column ads_store_manage_statistics_day_i.vip_mem_trade_num              is '实体卡会员下单人数';

comment on column ads_store_manage_statistics_day_i.balance_sale_amount                       is '使用余额销售金额';
comment on column ads_store_manage_statistics_day_i.balance_order_num              is '使用余额单量';
comment on column ads_store_manage_statistics_day_i.balance_sale_cost                         is '使用余额的销售成本';
comment on column ads_store_manage_statistics_day_i.balance_people_num             is '使用余额的下单人数';


comment on table ads_store_city_manage_statistics_quarter_i                           is '城市经营分析刻表';
comment on column ads_store_city_manage_statistics_quarter_i.trade_date                       is '交易日期';
comment on column ads_store_city_manage_statistics_quarter_i.week_trade_date                  is '周一日期';
comment on column ads_store_city_manage_statistics_quarter_i.month_trade_date                 is '月一日期';
comment on column ads_store_city_manage_statistics_quarter_i.hourly                          is '交易小时(0-23)';
comment on column ads_store_city_manage_statistics_quarter_i.quarter                         is '刻钟:1.0-15,2.15-30,3.30-45,4.45-60';
comment on column ads_store_city_manage_statistics_quarter_i.quarters                        is '刻钟数:hourly*4+quarters';

comment on column ads_store_city_manage_statistics_quarter_i.store_sale_type                 is '店铺销售类型';
comment on column ads_store_city_manage_statistics_quarter_i.store_type_code                 is '分店类型';
comment on column ads_store_city_manage_statistics_quarter_i.city_id                         is '城市ID';
comment on column ads_store_city_manage_statistics_quarter_i.city_name                               is '城市名称';
comment on column ads_store_city_manage_statistics_quarter_i.region_code                             is '区域编码';
comment on column ads_store_city_manage_statistics_quarter_i.region_name                             is '区域名称';
comment on column ads_store_city_manage_statistics_quarter_i.is_day_clear                    is '是否日清:0否,1是';

comment on column ads_store_city_manage_statistics_quarter_i.order_num                       is '销售单量';
comment on column ads_store_city_manage_statistics_quarter_i.sale_qty                                   is '销售数量';
comment on column ads_store_city_manage_statistics_quarter_i.sale_amount                                is '销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.dis_amount                                 is '折扣金额';
comment on column ads_store_city_manage_statistics_quarter_i.sale_cost                                  is '销售成本';
comment on column ads_store_city_manage_statistics_quarter_i.balance_amount                             is '余额支付金额';
comment on column ads_store_city_manage_statistics_quarter_i.cancel_sale_amount                         is '取消商品销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.refund_sale_amount                         is '退款商品销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.online_order_num                is '线上单量';
comment on column ads_store_city_manage_statistics_quarter_i.offline_order_num               is '线下单量';
comment on column ads_store_city_manage_statistics_quarter_i.online_sale_amount                         is '线上销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.offline_sale_amount                        is '线下销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.online_sale_cost                           is '线上销售成本';
comment on column ads_store_city_manage_statistics_quarter_i.offline_sale_cost                          is '线下销售成本';
comment on column ads_store_city_manage_statistics_quarter_i.loss_amount                                is '损耗金额';
comment on column ads_store_city_manage_statistics_quarter_i.receipt_amount                             is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_store_city_manage_statistics_quarter_i.require_amount                             is '要货金额';

comment on column ads_store_city_manage_statistics_quarter_i.ol_mem_order_num                is '线上会员单量';
comment on column ads_store_city_manage_statistics_quarter_i.vip_mem_order_num               is '实体卡会员单量';
comment on column ads_store_city_manage_statistics_quarter_i.ol_mem_sale_amount                         is '线上会员销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.vip_mem_sale_amount                        is '实体卡会员销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.ol_mem_sale_cost                           is '线上会员销售成本';
comment on column ads_store_city_manage_statistics_quarter_i.vip_mem_sale_cost                          is '实体卡会员销售成本';
comment on column ads_store_city_manage_statistics_quarter_i.ol_mem_trade_num                is '线上会员下单人数';
comment on column ads_store_city_manage_statistics_quarter_i.vip_mem_trade_num               is '实体卡会员下单人数';

comment on column ads_store_city_manage_statistics_quarter_i.balance_sale_amount                        is '使用余额销售金额';
comment on column ads_store_city_manage_statistics_quarter_i.balance_order_num               is '使用余额单量';
comment on column ads_store_city_manage_statistics_quarter_i.balance_sale_cost                          is '使用余额的销售成本';
comment on column ads_store_city_manage_statistics_quarter_i.balance_people_num              is '使用余额的下单人数';


comment on table  ads_store_city_manage_statistics_day_i                     is '城市经营分析天表';
comment on column ads_store_city_manage_statistics_day_i.trade_date                     is '交易日期';
comment on column ads_store_city_manage_statistics_day_i.week_trade_date                is '周一日期';
comment on column ads_store_city_manage_statistics_day_i.month_trade_date               is '月一日期';

comment on column ads_store_city_manage_statistics_day_i.store_sale_type               is '店铺销售类型';
comment on column ads_store_city_manage_statistics_day_i.store_type_code               is '分店类型';
comment on column ads_store_city_manage_statistics_day_i.city_id                       is '城市ID';
comment on column ads_store_city_manage_statistics_day_i.city_name                             is '城市名称';
comment on column ads_store_city_manage_statistics_day_i.region_code                           is '区域编码';
comment on column ads_store_city_manage_statistics_day_i.region_name                           is '区域名称';
comment on column ads_store_city_manage_statistics_day_i.is_day_clear                  is '是否日清:0否,1是';

comment on column ads_store_city_manage_statistics_day_i.order_num                     is '销售单量';
comment on column ads_store_city_manage_statistics_day_i.sale_qty                                 is '销售数量';
comment on column ads_store_city_manage_statistics_day_i.sale_amount                              is '销售金额';
comment on column ads_store_city_manage_statistics_day_i.dis_amount                               is '折扣金额';
comment on column ads_store_city_manage_statistics_day_i.sale_cost                                is '销售成本';
comment on column ads_store_city_manage_statistics_day_i.balance_amount                           is '余额支付金额';
comment on column ads_store_city_manage_statistics_day_i.cancel_sale_amount                       is '取消商品销售金额';
comment on column ads_store_city_manage_statistics_day_i.refund_sale_amount                       is '退款商品销售金额';
comment on column ads_store_city_manage_statistics_day_i.online_order_num              is '线上单量';
comment on column ads_store_city_manage_statistics_day_i.offline_order_num             is '线下单量';
comment on column ads_store_city_manage_statistics_day_i.online_sale_amount                       is '线上销售金额';
comment on column ads_store_city_manage_statistics_day_i.offline_sale_amount                      is '线下销售金额';
comment on column ads_store_city_manage_statistics_day_i.online_sale_cost                         is '线上销售成本';
comment on column ads_store_city_manage_statistics_day_i.offline_sale_cost                        is '线下销售成本';
comment on column ads_store_city_manage_statistics_day_i.loss_amount                              is '损耗金额';
comment on column ads_store_city_manage_statistics_day_i.receipt_amount                           is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_store_city_manage_statistics_day_i.require_amount                           is '要货金额';

comment on column ads_store_city_manage_statistics_day_i.ol_mem_order_num              is '线上会员单量';
comment on column ads_store_city_manage_statistics_day_i.vip_mem_order_num             is '实体卡会员单量';
comment on column ads_store_city_manage_statistics_day_i.ol_mem_sale_amount                       is '线上会员销售金额';
comment on column ads_store_city_manage_statistics_day_i.vip_mem_sale_amount                      is '实体卡会员销售金额';
comment on column ads_store_city_manage_statistics_day_i.ol_mem_sale_cost                         is '线上会员销售成本';
comment on column ads_store_city_manage_statistics_day_i.vip_mem_sale_cost                        is '实体卡会员销售成本';
comment on column ads_store_city_manage_statistics_day_i.ol_mem_trade_num              is '线上会员下单人数';
comment on column ads_store_city_manage_statistics_day_i.vip_mem_trade_num             is '实体卡会员下单人数';

comment on column ads_store_city_manage_statistics_day_i.balance_sale_amount                      is '使用余额销售金额';
comment on column ads_store_city_manage_statistics_day_i.balance_order_num             is '使用余额单量';
comment on column ads_store_city_manage_statistics_day_i.balance_sale_cost                        is '使用余额的销售成本';
comment on column ads_store_city_manage_statistics_day_i.balance_people_num            is '使用余额的下单人数';


comment on table  ads_marketing_store_source_type_day_i                     is '门店销售渠道分析天表';
comment on column ads_marketing_store_source_type_day_i.trade_date                    is '交易日期';
comment on column ads_marketing_store_source_type_day_i.week_trade_date               is '周一日期';
comment on column ads_marketing_store_source_type_day_i.month_trade_date              is '月一日期';

comment on column ads_marketing_store_source_type_day_i.store_no                             is '店铺编码';
comment on column ads_marketing_store_source_type_day_i.store_name                           is '店铺名称';
comment on column ads_marketing_store_source_type_day_i.store_sale_type              is '店铺销售类型';
comment on column ads_marketing_store_source_type_day_i.store_type_code              is '分店类型';
comment on column ads_marketing_store_source_type_day_i.worker_num                   is '员工人数';
comment on column ads_marketing_store_source_type_day_i.store_area                             is '门店面积';
comment on column ads_marketing_store_source_type_day_i.city_id                      is '城市ID';
comment on column ads_marketing_store_source_type_day_i.city_name                            is '城市名称';
comment on column ads_marketing_store_source_type_day_i.region_code                          is '区域编码';
comment on column ads_marketing_store_source_type_day_i.region_name                          is '区域名称';
comment on column ads_marketing_store_source_type_day_i.is_day_clear                 is '是否日清:0否,1是';

comment on column ads_marketing_store_source_type_day_i.source_type                  is '交易来源';
comment on column ads_marketing_store_source_type_day_i.source_type_name                     is '交易来源名称';

comment on column ads_marketing_store_source_type_day_i.order_num                    is '订单量';
comment on column ads_marketing_store_source_type_day_i.refund_order_num             is '退款订单量';
comment on column ads_marketing_store_source_type_day_i.cancel_order_num             is '取消订单量';
comment on column ads_marketing_store_source_type_day_i.sale_amount                             is '商品销售金额';
comment on column ads_marketing_store_source_type_day_i.sale_cost                               is '商品销售成本';
comment on column ads_marketing_store_source_type_day_i.dis_amount                              is '商品折扣金额';


comment on table  ads_marketing_store_category_clean_data_day_i                      is '门店品类日清商品分析天表';
comment on column ads_marketing_store_category_clean_data_day_i.trade_date                       is '交易日期';
comment on column ads_marketing_store_category_clean_data_day_i.week_trade_date                  is '周一日期';
comment on column ads_marketing_store_category_clean_data_day_i.month_trade_date                 is '月一日期';

comment on column ads_marketing_store_category_clean_data_day_i.store_no                                is '店铺编码';
comment on column ads_marketing_store_category_clean_data_day_i.store_name                              is '店铺名称';
comment on column ads_marketing_store_category_clean_data_day_i.store_sale_type                 is '店铺销售类型';
comment on column ads_marketing_store_category_clean_data_day_i.store_type_code                 is '分店类型';
comment on column ads_marketing_store_category_clean_data_day_i.worker_num                      is '员工人数';
comment on column ads_marketing_store_category_clean_data_day_i.store_area                                is '门店面积';
comment on column ads_marketing_store_category_clean_data_day_i.city_id                         is '城市ID';
comment on column ads_marketing_store_category_clean_data_day_i.city_name                               is '城市名称';
comment on column ads_marketing_store_category_clean_data_day_i.region_code                             is '区域编码';
comment on column ads_marketing_store_category_clean_data_day_i.region_name                             is '区域名称';
comment on column ads_marketing_store_category_clean_data_day_i.is_day_clear                    is '是否日清:0否,1是';

comment on column ads_marketing_store_category_clean_data_day_i.first_category_no                       is '一级分类编码';
comment on column ads_marketing_store_category_clean_data_day_i.first_category_name                     is '一级分类名称';

comment on column ads_marketing_store_category_clean_data_day_i.is_clean                        is '是否是日清商品';

comment on column ads_marketing_store_category_clean_data_day_i.sku_num                         is '销售SKU数';
comment on column ads_marketing_store_category_clean_data_day_i.order_num                       is '销售单量';
comment on column ads_marketing_store_category_clean_data_day_i.sale_qty                                   is '销售数量';
comment on column ads_marketing_store_category_clean_data_day_i.sale_amount                                is '销售金额';
comment on column ads_marketing_store_category_clean_data_day_i.dis_amount                                 is '折扣金额';
comment on column ads_marketing_store_category_clean_data_day_i.sale_cost                                  is '销售成本';
comment on column ads_marketing_store_category_clean_data_day_i.online_order_num                is '线上单量';
comment on column ads_marketing_store_category_clean_data_day_i.offline_order_num               is '线下单量';
comment on column ads_marketing_store_category_clean_data_day_i.online_sale_amount                         is '线上销售金额';
comment on column ads_marketing_store_category_clean_data_day_i.offline_sale_amount                        is '线下销售金额';
comment on column ads_marketing_store_category_clean_data_day_i.online_sale_cost                           is '线上销售成本';
comment on column ads_marketing_store_category_clean_data_day_i.offline_sale_cost                          is '线下销售成本';
comment on column ads_marketing_store_category_clean_data_day_i.loss_amount                                is '损耗金额';
comment on column ads_marketing_store_category_clean_data_day_i.receipt_amount                             is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_marketing_store_category_clean_data_day_i.require_amount                             is '要货金额';


comment on table  ads_marketing_store_clean_data_day_i                             is '门店日清商品分析天表';
comment on column ads_marketing_store_clean_data_day_i.trade_date                     is '交易日期';
comment on column ads_marketing_store_clean_data_day_i.week_trade_date                is '周一日期';
comment on column ads_marketing_store_clean_data_day_i.month_trade_date               is '月一日期';

comment on column ads_marketing_store_clean_data_day_i.store_no                              is '店铺编码';
comment on column ads_marketing_store_clean_data_day_i.store_name                            is '店铺名称';
comment on column ads_marketing_store_clean_data_day_i.store_sale_type               is '店铺销售类型';
comment on column ads_marketing_store_clean_data_day_i.store_type_code               is '分店类型';
comment on column ads_marketing_store_clean_data_day_i.worker_num                    is '员工人数';
comment on column ads_marketing_store_clean_data_day_i.store_area                              is '门店面积';
comment on column ads_marketing_store_clean_data_day_i.city_id                       is '城市ID';
comment on column ads_marketing_store_clean_data_day_i.city_name                             is '城市名称';
comment on column ads_marketing_store_clean_data_day_i.region_code                           is '区域编码';
comment on column ads_marketing_store_clean_data_day_i.region_name                           is '区域名称';
comment on column ads_marketing_store_clean_data_day_i.is_day_clear                  is '是否日清:0否,1是';

comment on column ads_marketing_store_clean_data_day_i.is_clean                      is '是否是日清商品(-1：不区分，0：否，1：是)';

comment on column ads_marketing_store_clean_data_day_i.sku_num                       is '销售SKU数';
comment on column ads_marketing_store_clean_data_day_i.order_num                     is '销售单量';
comment on column ads_marketing_store_clean_data_day_i.order_num_pre                 is '18:30前销售单量';
comment on column ads_marketing_store_clean_data_day_i.order_num_after               is '18:30后销售单量';
comment on column ads_marketing_store_clean_data_day_i.sale_amount                              is '销售金额';
comment on column ads_marketing_store_clean_data_day_i.sale_amount_pre                          is '18:30前销售金额';
comment on column ads_marketing_store_clean_data_day_i.sale_amount_after                        is '18:30后销售金额';
comment on column ads_marketing_store_clean_data_day_i.dis_amount                               is '折扣金额';
comment on column ads_marketing_store_clean_data_day_i.dis_amount_pre                           is '18:30前折扣金额';
comment on column ads_marketing_store_clean_data_day_i.dis_amount_after                         is '18:30后折扣金额';
comment on column ads_marketing_store_clean_data_day_i.sale_cost                                is '销售成本';
comment on column ads_marketing_store_clean_data_day_i.sale_cost_pre                            is '18:30前销售成本';
comment on column ads_marketing_store_clean_data_day_i.sale_cost_after                          is '18:30后销售成本';
comment on column ads_marketing_store_clean_data_day_i.sale_profit                              is '销售利润';
comment on column ads_marketing_store_clean_data_day_i.sale_profit_pre                          is '18:30前销售利润';
comment on column ads_marketing_store_clean_data_day_i.sale_profit_after                        is '18:30后销售利润';
comment on column ads_marketing_store_clean_data_day_i.loss_amount                              is '损耗额';
comment on column ads_marketing_store_clean_data_day_i.loss_amount_pre                          is '18:30前损耗额';
comment on column ads_marketing_store_clean_data_day_i.loss_amount_after                        is '18:30后损耗额';
comment on column ads_marketing_store_clean_data_day_i.receipt_amount                           is '收货金额（收货-退货-退配+调入-调出）';
comment on column ads_marketing_store_clean_data_day_i.require_amount                           is '要货金额';