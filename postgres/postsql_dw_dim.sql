
-- 注意: 需要手动切换到dw库下
CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_date_f (
    trade_date              DATE        ,
    year_code               INT         ,
    month_code              INT         ,
    day_code                INT         ,
    quanter_code            INT         ,
    quanter_name            VARCHAR(50) ,
    week_trade_date         DATE        ,
    month_trade_date        DATE        ,
    week_end_date           DATE        ,
    month_end_date          DATE        ,
    last_week_trade_date    DATE        ,
    last_month_trade_date   DATE        ,
    last_week_end_date      DATE        ,
    last_month_end_date     DATE        ,
    year_week_code          INT         ,
    week_day_code           INT         ,
    day_year_num            INT         ,
    month_days              INT         ,
    is_weekend              INT         ,
    days_after1             DATE        ,
    days_after2             DATE        ,
    days_after3             DATE        ,
    days_after4             DATE        ,
    days_after5             DATE        ,
    days_after6             DATE        ,
    days_after7             DATE        ,
	PRIMARY KEY (trade_date)
);

CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_store_i(
    id                      INT          ,
    store_no                VARCHAR(50)  ,
    store_name              VARCHAR(50)  ,
    store_sale_type         INT          ,
    store_type_code         INT          ,
    city_id                 INT          ,
    city_name               VARCHAR(50)  ,
    region_code             VARCHAR(50)  ,
    region_name             VARCHAR(50)  ,
    worker_num              INT          ,
    manager_name            VARCHAR(50)  ,
    telephone               VARCHAR(50)  ,
    opening_date            VARCHAR(50)  ,
    open_time               VARCHAR(50)  ,
    close_time              VARCHAR(50)  ,
    status                  INT          ,
    is_deleted              INT          ,
    create_time             TIMESTAMP    ,
    update_time             TIMESTAMP    ,
    store_area              DECIMAL(27,2),
    decoration_code         VARCHAR(50)  ,
    is_day_clear            INT          ,
	PRIMARY KEY (store_no)
);

CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_category_statistics_i(
    first_category_id       INT          ,
    first_category_no       VARCHAR(50)  ,
    first_category_name     VARCHAR(50)  ,
										 
    second_category_id      INT          ,
    second_category_no      VARCHAR(50)  ,
    second_category_name    VARCHAR(50)  ,
										 
    third_category_id       INT          ,
    third_category_no       VARCHAR(50)  ,
    third_category_name     VARCHAR(50)  ,

    status INT,
	PRIMARY KEY (third_category_no)
	);

CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_goods_i(
    goods_id                INT           ,
    goods_no                VARCHAR(50)   ,
    goods_name              VARCHAR(200)  ,
    first_category_id       INT           ,
    first_category_no       VARCHAR(50)   ,
    first_category_name     VARCHAR(50)   ,
    second_category_id      INT           ,
    second_category_no      VARCHAR(50)   ,
    second_category_name    VARCHAR(50)   ,
    third_category_id       INT           ,
    third_category_no       VARCHAR(50)   ,
    third_category_name     VARCHAR(50)   ,
    brand_no                VARCHAR(50)   ,
    spec                    VARCHAR(50)   ,
    sale_unit               VARCHAR(50)   ,
    life_cycle_status       VARCHAR(50)   ,
    tax_rate_status         INT           ,
    tax_rate                VARCHAR(50)   ,
    tax_value               DECIMAL(27, 3),
    order_multiple          DECIMAL(27, 2),
    pack_qty                DECIMAL(27, 3),
    split_type              VARCHAR(50)   ,
    is_sell_by_piece        INT           ,
    is_self_support         INT           ,
    is_variable_price       INT           ,
    is_double_measurement   INT           ,
    is_must_sell            INT           ,
    is_seasonal             INT           ,
    seasonal_start_time     VARCHAR(50)   ,
    seasonal_end_time       VARCHAR(50)   ,
    is_deleted              INT           ,
    goods_type              VARCHAR(50)   ,
    create_time             TIMESTAMP     ,
    update_time             TIMESTAMP     ,
	PRIMARY KEY (goods_no)
	);

CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_store_goods_i(
    uid                     VARCHAR(50)   ,
    store_no                VARCHAR(50)   ,
    goods_no                VARCHAR(50)   ,
    goods_name              VARCHAR(200)  ,
    first_category_no       VARCHAR(50)   ,
    first_category_name     VARCHAR(50)   ,
    second_category_no      VARCHAR(50)   ,
    second_category_name    VARCHAR(50)   ,
    third_category_no       VARCHAR(50)   ,
    third_category_name     VARCHAR(50)   ,
    is_clear                INT           ,
    is_must_order           INT           ,
    is_orderable            INT           ,
    order_multiple          DECIMAL(27,2) ,
    min_order_qty           DECIMAL(27,2) ,
    vendor_no               VARCHAR(50)   ,
    vendor_name             VARCHAR(50)   ,
    group_no                VARCHAR(50)   ,
    group_name              VARCHAR(50)   ,
    dc_no                   VARCHAR(50)   ,
    dc_name                 VARCHAR(50)   ,
    tag                     INT           ,
    create_time             TIMESTAMP     ,
    update_time             TIMESTAMP     ,
    is_deleted              INT           ,
	PRIMARY KEY (store_no,goods_no)
	);


CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_store_clear_goods_i(
    uid                     VARCHAR(50)   ,
    store_no                VARCHAR(50)   ,
    goods_no                VARCHAR(50)   ,
    goods_name              VARCHAR(200)  ,
    first_category_no       VARCHAR(50)   ,
    first_category_name     VARCHAR(50)   ,
    second_category_no      VARCHAR(50)   ,
    second_category_name    VARCHAR(50)   ,
    third_category_no       VARCHAR(50)   ,
    third_category_name     VARCHAR(50)   ,
    is_clear                INT           ,
    is_must_order           INT           ,
    is_orderable            INT           ,
    order_multiple          DECIMAL(27,2) ,
    min_order_qty           DECIMAL(27,2) ,
    vendor_no               VARCHAR(50)   ,
    vendor_name             VARCHAR(50)   ,
    group_no                VARCHAR(50)   ,
    group_name              VARCHAR(50)   ,
    dc_no                   VARCHAR(50)   ,
    dc_name                 VARCHAR(50)   ,
    tag                     INT           ,
    create_time             TIMESTAMP     ,
    update_time             TIMESTAMP     ,
    is_deleted              INT           ,
	PRIMARY KEY (store_no,goods_no)
	);


CREATE TABLE IF NOT EXISTS dw.public.dwd_dim_source_type_map_i(
    company                     VARCHAR(50) ,
    original_source_type        INT         ,
    original_source_type_name   VARCHAR(50) ,
    source_type                 INT         ,
    source_type_name            VARCHAR(50) ,
    is_online                   INT         ,
	PRIMARY KEY (company,original_source_type)
	);


COMMENT on table dw.public.dwd_dim_date_f is '时间维度表';
COMMENT on column dw.public.dwd_dim_date_f.trade_date              is '日期编码';
COMMENT on column dw.public.dwd_dim_date_f.year_code               is '年编码';
COMMENT on column dw.public.dwd_dim_date_f.month_code              is '月份编码';
COMMENT on column dw.public.dwd_dim_date_f.day_code                is '日编码';
COMMENT on column dw.public.dwd_dim_date_f.quanter_code            is '季度编码';
COMMENT on column dw.public.dwd_dim_date_f.quanter_name            is '季度名称';
COMMENT on column dw.public.dwd_dim_date_f.week_trade_date         is '周一时间';
COMMENT on column dw.public.dwd_dim_date_f.month_trade_date        is '月一时间';
COMMENT on column dw.public.dwd_dim_date_f.week_end_date           is '周末时间';
COMMENT on column dw.public.dwd_dim_date_f.month_end_date          is '月末时间';
COMMENT on column dw.public.dwd_dim_date_f.last_week_trade_date    is '上周一时间';
COMMENT on column dw.public.dwd_dim_date_f.last_month_trade_date   is '上月一时间';
COMMENT on column dw.public.dwd_dim_date_f.last_week_end_date      is '上周末时间';
COMMENT on column dw.public.dwd_dim_date_f.last_month_end_date     is '上月末时间';
COMMENT on column dw.public.dwd_dim_date_f.year_week_code          is '一年中第几周';
COMMENT on column dw.public.dwd_dim_date_f.week_day_code           is '周几code';
COMMENT on column dw.public.dwd_dim_date_f.day_year_num            is '一年第几天';
COMMENT on column dw.public.dwd_dim_date_f.month_days              is '本月有多少天';
COMMENT on column dw.public.dwd_dim_date_f.is_weekend              is '是否周末（周六和周日）';
COMMENT on column dw.public.dwd_dim_date_f.days_after1             is '1天后的日期';
COMMENT on column dw.public.dwd_dim_date_f.days_after2             is '2天后的日期';
COMMENT on column dw.public.dwd_dim_date_f.days_after3             is '3天后的日期';
COMMENT on column dw.public.dwd_dim_date_f.days_after4             is '4天后的日期';
COMMENT on column dw.public.dwd_dim_date_f.days_after5             is '5天后的日期';
COMMENT on column dw.public.dwd_dim_date_f.days_after6             is '6天后的日期';
COMMENT on column dw.public.dwd_dim_date_f.days_after7             is '7天后的日期';


COMMENT on table dw.public.dwd_dim_store_i is '门店表';
COMMENT on column dw.public.dwd_dim_store_i.id                 is '自增主键';
COMMENT on column dw.public.dwd_dim_store_i.store_no           is '分店编号';
COMMENT on column dw.public.dwd_dim_store_i.store_name         is '分店名称';
COMMENT on column dw.public.dwd_dim_store_i.store_sale_type    is '门店销售类型';
COMMENT on column dw.public.dwd_dim_store_i.store_type_code    is '分店类型';
COMMENT on column dw.public.dwd_dim_store_i.city_id            is '城市ID';
COMMENT on column dw.public.dwd_dim_store_i.city_name          is '城市名称';
COMMENT on column dw.public.dwd_dim_store_i.region_code        is '区域ID';
COMMENT on column dw.public.dwd_dim_store_i.region_name        is '区域名称';
COMMENT on column dw.public.dwd_dim_store_i.worker_num         is '员工人数';
COMMENT on column dw.public.dwd_dim_store_i.manager_name       is '经理姓名';
COMMENT on column dw.public.dwd_dim_store_i.telephone          is '分店电话';
COMMENT on column dw.public.dwd_dim_store_i.opening_date       is '开店日期';
COMMENT on column dw.public.dwd_dim_store_i.open_time          is '营业开始时间';
COMMENT on column dw.public.dwd_dim_store_i.close_time         is '营业结束时间';
COMMENT on column dw.public.dwd_dim_store_i.status           is '状态 1：开店  2：闭店';
COMMENT on column dw.public.dwd_dim_store_i.is_deleted         is '是否删除 0:否  1:是';
COMMENT on column dw.public.dwd_dim_store_i.create_time           is '创建时间';
COMMENT on column dw.public.dwd_dim_store_i.update_time           is '更新时间';
COMMENT on column dw.public.dwd_dim_store_i.store_area                is '经营面积';
COMMENT on column dw.public.dwd_dim_store_i.decoration_code    is '装修标识';
COMMENT on column dw.public.dwd_dim_store_i.is_day_clear       is '是否日清，1-日清，0-非日清';


COMMENT on table dw.public.dwd_dim_category_statistics_i is '分类等级表';
COMMENT on column dw.public.dwd_dim_category_statistics_i.first_category_id       is '一级分类ID';
COMMENT on column dw.public.dwd_dim_category_statistics_i.first_category_no       is '一级分类编码';
COMMENT on column dw.public.dwd_dim_category_statistics_i.first_category_name     is '一级分类';

COMMENT on column dw.public.dwd_dim_category_statistics_i.second_category_id      is '二级分类ID';
COMMENT on column dw.public.dwd_dim_category_statistics_i.second_category_no      is '二级分类编码';
COMMENT on column dw.public.dwd_dim_category_statistics_i.second_category_name    is '二级分类';

COMMENT on column dw.public.dwd_dim_category_statistics_i.third_category_id       is '三级分类ID';
COMMENT on column dw.public.dwd_dim_category_statistics_i.third_category_no       is '三级分类编码';
COMMENT on column dw.public.dwd_dim_category_statistics_i.third_category_name     is '三级分类';



COMMENT on table dw.public.dwd_dim_goods_i is '商品表';
COMMENT on column dw.public.dwd_dim_goods_i.goods_id                      is '商品ID';
COMMENT on column dw.public.dwd_dim_goods_i.goods_no                      is '商品编码';
COMMENT on column dw.public.dwd_dim_goods_i.goods_name                    is '名称';
COMMENT on column dw.public.dwd_dim_goods_i.first_category_id             is '一级分类ID';
COMMENT on column dw.public.dwd_dim_goods_i.first_category_no             is '一级分类编码';
COMMENT on column dw.public.dwd_dim_goods_i.first_category_name           is '一级分类';
COMMENT on column dw.public.dwd_dim_goods_i.second_category_id            is '二级分类ID';
COMMENT on column dw.public.dwd_dim_goods_i.second_category_no            is '二级分类编码';
COMMENT on column dw.public.dwd_dim_goods_i.second_category_name          is '二级分类';
COMMENT on column dw.public.dwd_dim_goods_i.third_category_id             is '三级分类ID';
COMMENT on column dw.public.dwd_dim_goods_i.third_category_no             is '三级分类编码';
COMMENT on column dw.public.dwd_dim_goods_i.third_category_name           is '三级分类';
COMMENT on column dw.public.dwd_dim_goods_i.brand_no                      is '品牌编号';
COMMENT on column dw.public.dwd_dim_goods_i.spec                          is '商品规格';
COMMENT on column dw.public.dwd_dim_goods_i.sale_unit                     is '销售单位';
COMMENT on column dw.public.dwd_dim_goods_i.life_cycle_status             is '生命周期状态';
COMMENT on column dw.public.dwd_dim_goods_i.tax_rate_status               is '税率审核状态 (0：未提交审核 1：待财务审核 2：税率已审核 3：未通过)';
COMMENT on column dw.public.dwd_dim_goods_i.tax_rate                      is '税率code';
COMMENT on column dw.public.dwd_dim_goods_i.tax_value                             is '税率';
COMMENT on column dw.public.dwd_dim_goods_i.order_multiple                        is '订货倍数';
COMMENT on column dw.public.dwd_dim_goods_i.pack_qty                              is '箱装数量';
COMMENT on column dw.public.dwd_dim_goods_i.split_type                    is '分割属性';
COMMENT on column dw.public.dwd_dim_goods_i.is_sell_by_piece              is '是否拆零，0:不拆；1:拆';
COMMENT on column dw.public.dwd_dim_goods_i.is_self_support               is '是否自营 0:非自营；1:自营';
COMMENT on column dw.public.dwd_dim_goods_i.is_variable_price             is '分店可变价 0:不可；1:可以';
COMMENT on column dw.public.dwd_dim_goods_i.is_double_measurement         is '是否双计量商品 0:否；1:是';
COMMENT on column dw.public.dwd_dim_goods_i.is_must_sell                  is '必卖品  0:非；1:是';
COMMENT on column dw.public.dwd_dim_goods_i.is_seasonal                   is '季节性商品  0:非；1:是';
COMMENT on column dw.public.dwd_dim_goods_i.seasonal_start_time           is '季节性开始时间';
COMMENT on column dw.public.dwd_dim_goods_i.seasonal_end_time             is '季节性结束时间';
COMMENT on column dw.public.dwd_dim_goods_i.is_deleted                    is '是否删除0:正常；1:删除';
COMMENT on column dw.public.dwd_dim_goods_i.goods_type                    is '商品类型 1-国产食品 2-进口食品 3-国产非食品 4-进口非食品';
COMMENT on column dw.public.dwd_dim_goods_i.create_time                      is '该记录创建时间';
COMMENT on column dw.public.dwd_dim_goods_i.update_time                      is '该记录最后更新时间';
               

COMMENT on table dw.public.dwd_dim_store_goods_i is '门店商品信息';
COMMENT on column dw.public.dwd_dim_store_goods_i.uid                          is '唯一标识';
COMMENT on column dw.public.dwd_dim_store_goods_i.store_no                     is '门店编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.goods_no                     is '商品编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.goods_name                   is '商品简称';
COMMENT on column dw.public.dwd_dim_store_goods_i.first_category_no            is '一级分类编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.first_category_name          is '一级分类';
COMMENT on column dw.public.dwd_dim_store_goods_i.second_category_no           is '二级分类编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.second_category_name         is '二级分类';
COMMENT on column dw.public.dwd_dim_store_goods_i.third_category_no            is '三级分类编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.third_category_name          is '三级分类';
COMMENT on column dw.public.dwd_dim_store_goods_i.is_clear                     is '商品是否日清，0-否，1-是';
COMMENT on column dw.public.dwd_dim_store_goods_i.is_must_order                is '是否必订品，0-否，1-是';
COMMENT on column dw.public.dwd_dim_store_goods_i.is_orderable                 is '是否可订，0-否，1-是';
COMMENT on column dw.public.dwd_dim_store_goods_i.order_multiple                      is '订货倍数';
COMMENT on column dw.public.dwd_dim_store_goods_i.min_order_qty                       is '最小起订量';
COMMENT on column dw.public.dwd_dim_store_goods_i.vendor_no                    is '主供应商编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.vendor_name                  is '主供应商名称';
COMMENT on column dw.public.dwd_dim_store_goods_i.group_no                     is '采购柜组编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.group_name                   is '采购柜组名称';
COMMENT on column dw.public.dwd_dim_store_goods_i.dc_no                        is '采购仓库编码';
COMMENT on column dw.public.dwd_dim_store_goods_i.dc_name                      is '采购仓库名称';
COMMENT on column dw.public.dwd_dim_store_goods_i.tag                          is '商品标识，1-云鲜标品；2-甄选标品;3-生鲜品;4-其它';
COMMENT on column dw.public.dwd_dim_store_goods_i.create_time                     is '创建时间';
COMMENT on column dw.public.dwd_dim_store_goods_i.update_time                     is '最后修改时间';
COMMENT on column dw.public.dwd_dim_store_goods_i.is_deleted                   is '是否删除0:正常；1:删除';



COMMENT on table dw.public.dwd_dim_store_clear_goods_i is '门店日清商品信息';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.uid                     is '唯一标识';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.store_no                is '门店编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.goods_no                is '商品编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.goods_name              is '商品简称';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.first_category_no       is '一级分类编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.first_category_name     is '一级分类';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.second_category_no      is '二级分类编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.second_category_name    is '二级分类';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.third_category_no       is '三级分类编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.third_category_name     is '三级分类';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.is_clear                is '商品是否日清，0-否，1-是';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.is_must_order           is '是否必订品，0-否，1-是';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.is_orderable            is '是否可订，0-否，1-是';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.order_multiple                 is '订货倍数';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.min_order_qty                  is '最小起订量';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.vendor_no               is '主供应商编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.vendor_name             is '主供应商名称';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.group_no                is '采购柜组编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.group_name              is '采购柜组名称';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.dc_no                   is '采购仓库编码';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.dc_name                 is '采购仓库名称';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.tag                     is '商品标识，1-云鲜标品；2-甄选标品;3-生鲜品;4-其它';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.create_time                is '创建时间';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.update_time                is '最后修改时间';
COMMENT on column dw.public.dwd_dim_store_clear_goods_i.is_deleted          is '是否删除0:正常；1:删除';



COMMENT on table dw.public.dwd_dim_source_type_map_i  is '交易类型映射表';
COMMENT on column dw.public.dwd_dim_source_type_map_i.company                    is '公司:1.云鲜 2.甄选';
COMMENT on column dw.public.dwd_dim_source_type_map_i.original_source_type       is '原交易来源  云鲜1:线下pos;2:线上订单;3:扫码购;4:美团;5:饿了么;6:百度外卖;7:京东到家;8:有赞;9:云鲜精品;10:甄选;11:团购';
COMMENT on column dw.public.dwd_dim_source_type_map_i.original_source_type_name  is '原交易来源名称';
COMMENT on column dw.public.dwd_dim_source_type_map_i.source_type                is '新交易来源：1';
COMMENT on column dw.public.dwd_dim_source_type_map_i.source_type_name           is '新交易来源名称';
COMMENT on column dw.public.dwd_dim_source_type_map_i.is_online                  is '是否线上交易 0否;1是';









	
	