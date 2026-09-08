CREATE TABLE IF NOT EXISTS dws_mem_store_member_classify_day_i(
    trade_date                  DATE          ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    reg_num_add                 INT            ,
    reg_num_sum                 INT            ,
    consume_num_add             INT            ,
    consume_num_sum             INT            ,
    repurchase_num_add          INT            ,
    repurchase_num_sum          INT            ,
    active_member_num           INT            ,
    sleep_member_num            INT            ,
    sale_amount_bind            DECIMAL(27, 2) ,
	PRIMARY KEY (trade_date,store_no)
);

CREATE TABLE IF NOT EXISTS ads_mem_store_member_classify_week_i(
    trade_date                  DATE          ,
											  
    store_no                    VARCHAR(50)   ,
    store_name                  VARCHAR(50)   ,
    store_sale_type             INT           ,
    store_type_code             INT           ,
    city_id                     INT           ,
    city_name                   VARCHAR(50)   ,
    region_code                 VARCHAR(50)   ,
    region_name                 VARCHAR(50)   ,
    is_day_clear                INT           ,
											  
    reg_num_add                 INT           ,
    reg_num_sum                 INT           ,
    consume_num_add             INT           ,
    consume_num_sum             INT           ,
    repurchase_num_add          INT           ,
    repurchase_num_sum          INT           ,
    active_member_num           INT           ,
    sleep_member_num            INT           ,
    sale_amount_bind            DECIMAL(27, 2),
	PRIMARY KEY (trade_date,store_no)
);



CREATE TABLE IF NOT EXISTS ads_mem_store_member_classify_month_i(
    trade_date                  DATE          ,
											  
    store_no                    VARCHAR(50)   ,
    store_name                  VARCHAR(50)   ,
    store_sale_type             INT           ,
    store_type_code             INT           ,
    city_id                     INT           ,
    city_name                   VARCHAR(50)   ,
    region_code                 VARCHAR(50)   ,
    region_name                 VARCHAR(50)   ,
    is_day_clear                INT           ,
											  
    reg_num_add                 INT           ,
    reg_num_sum                 INT           ,
    consume_num_add             INT           ,
    consume_num_sum             INT           ,
    repurchase_num_add          INT           ,
    repurchase_num_sum          INT           ,
    active_member_num           INT           ,
    sleep_member_num            INT           ,
    sale_amount_bind            DECIMAL(27, 2),
	PRIMARY KEY (trade_date,store_no)
);


CREATE TABLE IF NOT EXISTS dws_mem_store_member_statistics_day_i(
    trade_date                  DATE           ,
    week_trade_date             DATE           ,
    month_trade_date            DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    store_sale_amount           DECIMAL(27, 2) ,
    store_orders_number         INT            ,
											   
    register_member_num         INT            ,
    register_member_num_all     INT            ,
    register_recharge_num       INT            ,
    rg_rc_td_num                INT            ,
    register_trade_num          INT            ,
											   
    recharge_member_num         INT            ,
    recharge_amount             DECIMAL(27, 2) ,
    recharge_amount_all         DECIMAL(27, 2) ,
    remain_member_num           INT            ,
    remain_member_amount        DECIMAL(27, 2) ,
											   
    balance_member_num          INT            ,
    balance_member_order_num    INT            ,
    balance_pay_amount          DECIMAL(27, 2) ,
    balance_member_amount       DECIMAL(27, 2) ,
											   
    member_num                  INT            ,
    member_order_num            INT            ,
    member_amount               DECIMAL(27, 2) ,
											   
    member_first_num            INT            ,
    member_first_order_num      INT            ,
    member_first_amount         DECIMAL(27, 2) ,
    member_nofirst_num          INT            ,
    member_nofirst_order_num    INT            ,
    member_nofirst_amount       DECIMAL(27, 2) ,
	
	PRIMARY KEY (trade_date,store_no)
);


CREATE TABLE IF NOT EXISTS ads_mem_store_member_statistics_week_i(
    trade_date                  DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    store_sale_amount           DECIMAL(27, 2) ,
    store_orders_number         INT            ,
											   
    register_member_num         INT            ,
    register_member_num_all     INT            ,
    register_recharge_num       INT            ,
    rg_rc_td_num                INT            ,
    register_trade_num          INT            ,
											   
    recharge_member_num         INT            ,
    recharge_amount             DECIMAL(27, 2) ,
    recharge_amount_all         DECIMAL(27, 2) ,
    remain_member_num           INT            ,
    remain_member_amount        DECIMAL(27, 2) ,
											   
    balance_member_num          INT            ,
    balance_member_order_num    INT            ,
    balance_pay_amount          DECIMAL(27, 2) ,
    balance_member_amount       DECIMAL(27, 2) ,
											   
    member_num                  INT            ,
    member_order_num            INT            ,
    member_amount               DECIMAL(27, 2) ,
											   
    member_first_num            INT            ,
    member_first_order_num      INT            ,
    member_first_amount         DECIMAL(27, 2) ,
    member_nofirst_num          INT            ,
    member_nofirst_order_num    INT            ,
    member_nofirst_amount       DECIMAL(27, 2) ,
	
	PRIMARY KEY (trade_date,store_no)
);

CREATE TABLE IF NOT EXISTS ads_mem_store_member_statistics_month_i(
    trade_date                  DATE           ,
											   
    store_no                    VARCHAR(50)    ,
    store_name                  VARCHAR(50)    ,
    store_sale_type             INT            ,
    store_type_code             INT            ,
    city_id                     INT            ,
    city_name                   VARCHAR(50)    ,
    region_code                 VARCHAR(50)    ,
    region_name                 VARCHAR(50)    ,
    is_day_clear                INT            ,
											   
    store_sale_amount           DECIMAL(27, 2) ,
    store_orders_number         INT            ,
											   
    register_member_num         INT            ,
    register_member_num_all     INT            ,
    register_recharge_num       INT            ,
    rg_rc_td_num                INT            ,
    register_trade_num          INT            ,
											   
    recharge_member_num         INT            ,
    recharge_amount             DECIMAL(27, 2) ,
    recharge_amount_all         DECIMAL(27, 2) ,
    remain_member_num           INT            ,
    remain_member_amount        DECIMAL(27, 2) ,
											   
    balance_member_num          INT            ,
    balance_member_order_num    INT            ,
    balance_pay_amount          DECIMAL(27, 2) ,
    balance_member_amount       DECIMAL(27, 2) ,
											   
    member_num                  INT            ,
    member_order_num            INT            ,
    member_amount               DECIMAL(27, 2) ,
											   
    member_first_num            INT            ,
    member_first_order_num      INT            ,
    member_first_amount         DECIMAL(27, 2) ,
    member_nofirst_num          INT            ,
    member_nofirst_order_num    INT            ,
    member_nofirst_amount       DECIMAL(27, 2) ,
	
	PRIMARY KEY (trade_date,store_no)
);



CREATE TABLE IF NOT EXISTS ads_mem_store_new_old_member_month_i(
    trade_date                  DATE          ,
    store_no                    VARCHAR(50)   ,
    store_name                  VARCHAR(50)   ,
    store_sale_type             INT           ,
    store_type_code             INT           ,
    city_id                     INT           ,
    city_name                   VARCHAR(50)   ,
    region_code                 VARCHAR(50)   ,
    region_name                 VARCHAR(50)   ,
    is_day_clear                INT           ,
											  
    member_type                 INT           ,
    member_num                  INT           ,
    sale_amount                 DECIMAL(27, 2),
    order_num                   INT           ,
	
	PRIMARY KEY (trade_date,store_no,member_type)
);



CREATE TABLE IF NOT EXISTS ads_mem_repurchase_day_i(
    trade_date                  DATE        ,
											
    store_no                    VARCHAR(50) ,
    store_name                  VARCHAR(50) ,
    store_sale_type             INT         ,
    store_type_code             INT         ,
    city_id                     INT         ,
    city_name                   VARCHAR(50) ,
    region_code                 VARCHAR(50) ,
    region_name                 VARCHAR(50) ,
    is_day_clear                INT         ,
											
    member_count                INT         ,
    next_member_count_1         INT         ,
    next_member_count_2         INT         ,
    next_member_count_3         INT         ,
    next_member_count_4         INT         ,
    next_member_count_5         INT         ,
    next_member_count_6         INT         ,
	
	PRIMARY KEY (trade_date,store_no)
);


CREATE TABLE IF NOT EXISTS ads_mem_contribution_day_i(
    trade_date                  DATE          ,
    week_trade_date             DATE          ,
    month_trade_date            DATE          ,
											  
    zt_id                       INT           ,
    store_no                    VARCHAR(50)   ,
    store_name                  VARCHAR(50)   ,
    store_sale_type             INT           ,
    store_type_code             INT           ,
    city_id                     INT           ,
    city_name                   VARCHAR(50)   ,
    region_code                 VARCHAR(50)   ,
    region_name                 VARCHAR(50)   ,
    is_day_clear                INT           ,
											  
    consume_times               INT           ,
    consume_amount              DECIMAL(27, 2),
    consume_cost                DECIMAL(27, 2),
    online_consume_times        INT           ,
    online_consume_amount       DECIMAL(27, 2),
    online_consume_cost         DECIMAL(27, 2),
    offline_consume_times       INT           ,
    offline_consume_amount      DECIMAL(27, 2),
    offline_consume_cost        DECIMAL(27, 2),
	
	PRIMARY KEY (trade_date,zt_id,store_no)
);
