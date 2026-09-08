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



-- 注意: 以后工作中都是跑脚本,把日期改为inputdate,然后ds海豚调度器执行脚本,直接传递日期即可!

-- DWS层: 门店会员分类天表
-- 1.统计2026-08-10
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-10' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-10',30) and trade_date <= '2026-08-10'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-10' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-10',90) and trade_date <= '2026-08-10' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-10',30) and trade_date <= '2026-08-10'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-10'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-10' as trade_date,
        store_no,
        if(start_date = '2026-08-10',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-10' and end_date > '2026-08-10'

    union all

    select
        '2026-08-10' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-10',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-10' and end_date > '2026-08-10'

    union all

    select
        '2026-08-10' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-10',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-10' and end_date > '2026-08-10'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;




-- 2.统计2026-08-11
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-11' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-11',30) and trade_date <= '2026-08-11'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-11' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-11',90) and trade_date <= '2026-08-11' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-11',30) and trade_date <= '2026-08-11'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-11'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-11' as trade_date,
        store_no,
        if(start_date = '2026-08-11',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-11' and end_date > '2026-08-11'

    union all

    select
        '2026-08-11' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-11',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-11' and end_date > '2026-08-11'

    union all

    select
        '2026-08-11' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-11',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-11' and end_date > '2026-08-11'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;




-- 3.统计2026-08-12
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-12' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-12',30) and trade_date <= '2026-08-12'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-12' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-12',90) and trade_date <= '2026-08-12' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-12',30) and trade_date <= '2026-08-12'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-12'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-12' as trade_date,
        store_no,
        if(start_date = '2026-08-12',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-12' and end_date > '2026-08-12'

    union all

    select
        '2026-08-12' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-12',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-12' and end_date > '2026-08-12'

    union all

    select
        '2026-08-12' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-12',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-12' and end_date > '2026-08-12'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;





-- 4.统计2026-08-13
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-13' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-13',30) and trade_date <= '2026-08-13'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-13' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-13',90) and trade_date <= '2026-08-13' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-13',30) and trade_date <= '2026-08-13'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-13'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-13' as trade_date,
        store_no,
        if(start_date = '2026-08-13',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-13' and end_date > '2026-08-13'

    union all

    select
        '2026-08-13' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-13',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-13' and end_date > '2026-08-13'

    union all

    select
        '2026-08-13' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-13',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-13' and end_date > '2026-08-13'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;




-- 5.统计2026-08-14
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-14' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-14',30) and trade_date <= '2026-08-14'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-14' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-14',90) and trade_date <= '2026-08-14' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-14',30) and trade_date <= '2026-08-14'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-14'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-14' as trade_date,
        store_no,
        if(start_date = '2026-08-14',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-14' and end_date > '2026-08-14'

    union all

    select
        '2026-08-14' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-14',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-14' and end_date > '2026-08-14'

    union all

    select
        '2026-08-14' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-14',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-14' and end_date > '2026-08-14'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;






-- 6.统计2026-08-15
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-15' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-15',30) and trade_date <= '2026-08-15'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-15' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-15',90) and trade_date <= '2026-08-15' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-15',30) and trade_date <= '2026-08-15'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-15'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-15' as trade_date,
        store_no,
        if(start_date = '2026-08-15',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-15' and end_date > '2026-08-15'

    union all

    select
        '2026-08-15' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-15',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-15' and end_date > '2026-08-15'

    union all

    select
        '2026-08-15' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-15',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-15' and end_date > '2026-08-15'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;





-- 7.统计2026-08-16
with t1 as (
    select
        trade_date as start_date,
        store_no,
        reg_num_add,  -- 新增注册会员数
        -- 注意: 以下sum默认统计的是每个门店第一行数据到当前行的数据结果
        -- 此处省略了rows between unbounded preceding and current row
        sum(reg_num_add) over(partition by store_no order by trade_date ) as reg_num_sum,  -- 累计注册会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from
        (  -- 先对数据分组聚合,统计每天每个门店新增注册会员数
            select
                trade_date,
                reg_md as store_no,
                count(1) as reg_num_add
            from dwm.dwm_mem_member_behavior_day_i
            where is_register = 1
            group by
                trade_date, reg_md
        ) temp1
),
t2 as (
    select
        trade_date as start_date,
        store_no,
        consume_num_add, -- 新增消费会员数
        sum(consume_num_add) over(partition by store_no order by trade_date) as consume_num_sum,  -- 累计消费会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from ( -- 先对数据分组聚合,统计每天每个门店新增消费会员数
            select
                trade_date,
                store_no,
                count(1) as consume_num_add
            from dwm.dwm_mem_first_buy_i
            group by  trade_date, store_no
         ) temp2
),
t3 as (
    select
        trade_date as start_date,
        store_no,
        repurchase_num_add, -- 新增复购会员数
        sum(repurchase_num_add) over(partition by store_no order by trade_date) as repurchase_num_sum,  -- 累计复购会员数
        lead(trade_date,1,'9999-99-99') over (partition by store_no order by  trade_date) as end_date
    from (-- 先对数据分组聚合,统计每天每个门店新增复购会员数
            select
                trade_date,
                store_no,
                count(1) as repurchase_num_add
            from dwm.dwm_mem_second_buy_i
            group by  trade_date, store_no
         ) temp2
),
t4 as (
    -- 活跃会员数(最近30天有消费)
    select
        '2026-08-16' as trade_date,
        bind_md as store_no,
        count(distinct zt_id) as  active_member_num
    from dwm.dwm_mem_member_behavior_day_i
    where trade_date >= date_sub('2026-08-16',30) and trade_date <= '2026-08-16'   and is_consume = 1 and bind_md is not null
    group by bind_md
),
t5 as (
    -- 沉睡会员数:  最近90天有消费 , 但是最近30天无消费
    select
        '2026-08-16' as trade_date,
        temp3.bind_md as store_no,
        count(temp3.zt_id) as sleep_member_num
    from
        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-16',90) and trade_date <= '2026-08-16' and is_consume = 1 and bind_md is not null
            group by bind_md,zt_id
        ) temp3

        LEFT JOIN

        (
            select
                bind_md,
                zt_id
            from dwm.dwm_mem_member_behavior_day_i
            where trade_date >= date_sub('2026-08-16',30) and trade_date <= '2026-08-16'  and is_consume = 1 and bind_md is not null
            group by  bind_md,zt_id
        ) temp4  on  temp3.bind_md = temp4.bind_md and temp3.zt_id =  temp4.zt_id
    where temp4.zt_id is null
    group by  temp3.bind_md
),
t6 as ( -- 统计每天每个门店会员消费金额
    select
        trade_date,
        store_no,
        sum(real_paid_amount) as sale_amount_bind
    from dwm.dwm_mem_sell_order_i
    where trade_date = '2026-08-16'
    group by trade_date,store_no
),
t7 as (
    select
        '2026-08-16' as trade_date,
        store_no,
        if(start_date = '2026-08-16',reg_num_add,0) as reg_num_add,
        reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t1
    where start_date <= '2026-08-16' and end_date > '2026-08-16'

    union all

    select
        '2026-08-16' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        if( start_date = '2026-08-16',consume_num_add,0) as consume_num_add,
        consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t2
    where start_date <= '2026-08-16' and end_date > '2026-08-16'

    union all

    select
        '2026-08-16' as trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        if(start_date = '2026-08-16',repurchase_num_add,0) as repurchase_num_add,
        repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t3
    where start_date <= '2026-08-16' and end_date > '2026-08-16'

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        active_member_num,
        0 as sleep_member_num,
        0 as sale_amount_bind
    from t4

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        sleep_member_num,
        0 as sale_amount_bind
    from t5

    union all

    select
        trade_date,
        store_no,
        0 reg_num_add,
        0 as reg_num_sum,
        0 as consume_num_add,
        0 as consume_num_sum,
        0 as repurchase_num_add,
        0 as repurchase_num_sum,
        0 as active_member_num,
        0 as sleep_member_num,
        sale_amount_bind
    from t6
)
insert overwrite table dws.dws_mem_store_member_classify_day_i partition (dt)
select
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear,

    sum(t7.reg_num_add) as reg_num_add,
    sum(t7.reg_num_sum) as reg_num_sum,
    sum(t7.consume_num_add) as consume_num_add,
    sum(t7.consume_num_sum) as consume_num_sum,
    sum(t7.repurchase_num_add) as repurchase_num_add,
    sum(t7.repurchase_num_sum) as repurchase_num_sum,
    sum(t7.active_member_num) as active_member_num,
    sum(t7.sleep_member_num) as sleep_member_num,
    sum(t7.sale_amount_bind) as sale_amount_bind,
    t7.trade_date as dt
from t7
    left join dim.dwd_dim_date_f t8 on t7.trade_date = t8.trade_date
    -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
    left join dim.dwd_dim_store_i t9 on t7.store_no = t9.store_no and t9.dt ='2026-08-18'
group by
    t7.trade_date,
    t8.week_trade_date,
    t8.month_trade_date,
    t7.store_no,
    t9.store_name,
    t9.store_sale_type,
    t9.store_type_code,
    t9.city_id,
    t9.city_name,
    t9.region_code,
    t9.region_name,
    t9.is_day_clear;



