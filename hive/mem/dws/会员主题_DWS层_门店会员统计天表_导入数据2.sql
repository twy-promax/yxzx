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


-- DWS 门店会员统计宽表
-- 1.统计日期为2026-08-10
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-10'
    group by trade_date,store_no ),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-10' and bind_md is not null
    group by trade_date,bind_md  ),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-10' and end_date > '2026-08-10'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-10'
    group by trade_date,store_no  ),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;






-- 2.统计日期为2026-08-11
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-11'
    group by trade_date,store_no),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-11' and bind_md is not null
    group by trade_date,bind_md),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-11' and end_date > '2026-08-11'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-11'
    group by trade_date,store_no),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;




-- 3.统计日期为2026-08-12
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-12'
    group by trade_date,store_no),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-12' and bind_md is not null
    group by trade_date,bind_md),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-12' and end_date > '2026-08-12'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-12'
    group by trade_date,store_no),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;




-- 4.统计日期为2026-08-13
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-13'
    group by trade_date,store_no),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-13' and bind_md is not null
    group by trade_date,bind_md),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-13' and end_date > '2026-08-13'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-13'
    group by trade_date,store_no),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;



-- 5.统计日期为2026-08-14
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-14'
    group by trade_date,store_no),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-14' and bind_md is not null
    group by trade_date,bind_md),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-14' and end_date > '2026-08-14'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-14'
    group by trade_date,store_no),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;




-- 6.统计日期为2026-08-15
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-15'
    group by trade_date,store_no),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-15' and bind_md is not null
    group by trade_date,bind_md),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-15' and end_date > '2026-08-15'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-15'
    group by trade_date,store_no),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;




-- 7.统计日期为2026-08-16
with t1 as (
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as store_sale_amount,-- 门店销售额
        count(if(trade_type = 0,parent_order_no,NULL)) - count(if(trade_type = 5,parent_order_no,NULL)) as store_orders_number, -- 门店总订单量
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,
        0 as remain_member_num,
        0 as remain_member_amount,
        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from dwm.dwm_sell_o2o_order_i where dt = '2026-08-16'
    group by trade_date,store_no),

t2 as (
    select
        trade_date,
        bind_md as store_no,

        0 as store_sale_amount,
        0 as store_orders_number,

        sum(is_register) as register_member_num, -- 当日注册人数
        0 as register_member_num_all,
        sum(if( is_register = 1 and  is_recharge = 1, 1,0 ) ) as register_recharge_num, -- 当日注册且充值会员数
        sum(if( is_register = 1 and  is_recharge = 1 and is_consume = 1, 1,0 ) ) as rg_rc_td_num, -- 当日注册 且充值且消费会员数
        sum(if( is_register = 1 and  is_consume = 1, 1,0 )) as register_trade_num, -- 当日注册且消费会员数

        sum(is_recharge) as recharge_member_num, -- 充值会员数
        sum(if( is_recharge = 1,recharge_amount,0) ) as recharge_amount, -- 充值金额
        0 as recharge_amount_all,

        0 as remain_member_num,
        0 as remain_member_amount,

        sum(is_balance_consume) as balance_member_num,  --余额消费人数
        sum(if(is_balance_consume = 1, balance_consume_times, 0)) as balance_member_order_num, --余额消费单量
        sum(if(is_balance_consume = 1, balance_pay_amount, 0))  as balance_pay_amount,  -- 余额支付金额
        sum(if(is_balance_consume = 1, balance_consume_amount, 0))  as balance_member_amount, -- 余额消费金额

        sum(is_consume) as member_num, -- 会员消费人数
        sum(if(is_consume = 1, consume_times, 0)) as member_order_num, -- 会员消费单量
        sum(if(is_consume = 1, consume_amount, 0))  as member_amount,  -- 会员消费金额

        sum(is_first_consume) as member_first_num, -- 会员首单人数
        sum(is_first_consume) as member_first_order_num, -- 会员首单订单量
        sum(if(is_first_consume = 1, first_consume_amount,0)) as member_first_amount, -- 会员首单销售额

        sum(is_consume) - sum(is_first_consume) as member_nofirst_num, -- 会员非首单人数
        sum(if(is_consume = 1, consume_times, 0)) -  sum(is_first_consume) as member_nofirst_order_num, -- 会员非首单订单量
        sum(if(is_consume = 1, consume_amount, 0)) - sum(if(is_first_consume = 1, first_consume_amount,0)) as member_nofirst_amount -- 会员非首单销售额

    from dwm.dwm_mem_member_behavior_day_i where dt = '2026-08-16' and bind_md is not null
    group by trade_date,bind_md),

t3 as (
    select
        start_date as trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        register_member_num_all,-- 累计注册人数
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        recharge_amount_all,-- 累计会员充值金额

        0 as remain_member_num,
        0 as remain_member_amount,

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount

    from(
        select
            trade_date as start_date,
            store_no,
            sum(reg_num_add) over(partition by store_no order by trade_date) as register_member_num_all,  -- 累计注册会员数
            sum(recharge_amount) over(partition by store_no order by trade_date) as recharge_amount_all,  -- 累计充值金额
            lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
        from
            (  -- 先统计每天每个门店注册会员数
                select
                    trade_date,
                    bind_md as store_no,
                    sum(is_register) as reg_num_add,
                    sum(if(is_recharge = 1,recharge_amount,0)) as recharge_amount
                from dwm.dwm_mem_member_behavior_day_i
                where bind_md is not null
                group by
                    trade_date, bind_md
            ) temp1
    ) t
    where start_date <= '2026-08-16' and end_date > '2026-08-16'
),

t4 as (
    select
        trade_date,
        store_no,

        0 as store_sale_amount,
        0 as store_orders_number,
        0 as register_member_num,
        0 as register_member_num_all,
        0 as register_recharge_num,
        0 as rg_rc_td_num,
        0 as register_trade_num,
        0 as recharge_member_num,
        0 as recharge_amount,
        0 as recharge_amount_all,

        count(1) as remain_member_num,-- 当日有余额的会员人数
        sum(balance_amount) as remain_member_amount,-- 当日会员余额

        0 as balance_member_num,
        0 as balance_member_order_num,
        0 as balance_pay_amount,
        0 as balance_member_amount,
        0 as member_num,
        0 as member_order_num,
        0 as member_amount,
        0 as member_first_num,
        0 as member_first_order_num,
        0 as member_first_amount,
        0 as member_nofirst_num,
        0 as member_nofirst_order_num,
        0 as member_nofirst_amount
    from dwd.dwd_mem_balance_online_i where dt = '2026-08-16'
    group by trade_date,store_no),

t5 as (
    select * from t1
    union all
    select * from t2
    union all
    select * from t3
    union all
    select * from t4
)
insert overwrite table dws.dws_mem_store_member_statistics_day_i partition(dt)
select
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear,

    sum(t5.store_sale_amount) as store_sale_amount,
    sum(t5.store_orders_number) as store_orders_number,
    sum(t5.register_member_num) as register_member_num,
    sum(t5.register_member_num_all) as register_member_num_all,
    sum(t5.register_recharge_num) as register_recharge_num,
    sum(t5.rg_rc_td_num) as rg_rc_td_num,
    sum(t5.register_trade_num) as register_trade_num,
    sum(t5.recharge_member_num) as recharge_member_num,
    sum(t5.recharge_amount) as recharge_amount,
    sum(t5.recharge_amount_all) as recharge_amount_all,
    sum(t5.remain_member_num) as remain_member_num,
    sum(t5.remain_member_amount) as remain_member_amount,
    sum(t5.balance_member_num) as balance_member_num,
    sum(t5.balance_member_order_num) as balance_member_order_num,
    sum(t5.balance_pay_amount) as balance_pay_amount,
    sum(t5.balance_member_amount) as balance_member_amount,
    sum(t5.member_num) as member_num,
    sum(t5.member_order_num) as member_order_num,
    sum(t5.member_amount) as member_amount,
    sum(t5.member_first_num) as member_first_num,
    sum(t5.member_first_order_num) as member_first_order_num,
    sum(t5.member_first_amount) as member_first_amount,
    sum(t5.member_nofirst_num) as member_nofirst_num,
    sum(t5.member_nofirst_order_num) as member_nofirst_order_num,
    sum(t5.member_nofirst_amount) as member_nofirst_amount,
    date_format(t5.trade_date,'yyyy-MM-dd') as dt
from t5
    left join dim.dwd_dim_date_f t6 on t5.trade_date = t6.trade_date
        -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t7 on t5.store_no = t7.store_no and t7.dt ='2026-08-18'
group by
    t5.trade_date,
    t6.week_trade_date,
    t6.month_trade_date,
    t5.store_no,
    t7.store_name,
    t7.store_sale_type,
    t7.store_type_code,
    t7.city_id,
    t7.city_name,
    t7.region_code,
    t7.region_name,
    t7.is_day_clear;


