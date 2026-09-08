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



-- 以下以2026-08-10为例
with t1 as (
    -- 计算非累加值
    select
        month_trade_date,
        store_no,

        sum(reg_num_add) as reg_num_add,
        sum(consume_num_add) as consume_num_add,
        sum(repurchase_num_add) as repurchase_num_add,
        sum(sale_amount_bind) as sale_amount_bind
    from dws.dws_mem_store_member_classify_day_i
    where dt >= date_sub('2026-08-10',dayofmonth('2026-08-10')-1)
              and dt <= last_day('2026-08-10')
    group by month_trade_date,store_no
),
t2 as (
-- 计算 累计值
-- 如果获取这一月的最后一天呢?
    select
        month_trade_date as trade_date,
        store_no,
        store_name,
        store_sale_type,
        store_type_code,
        city_id,
        city_name,
        region_code,
        region_name,
        is_day_clear,

        reg_num_sum,
        consume_num_sum,
        repurchase_num_sum,
        active_member_num,
        sleep_member_num
    from dws.dws_mem_store_member_classify_day_i where dt in (
        select
            max(dt) as c1
        from dws.dws_mem_store_member_classify_day_i as t
        where dt >= date_sub('2026-08-10',dayofmonth('2026-08-10')-1)
          and dt <= last_day('2026-08-10')
    )
)
insert overwrite table ads.ads_mem_store_member_classify_month_i partition (dt)
select
    t2.trade_date,
    t2.store_no,
    t2.store_name,
    t2.store_sale_type,
    t2.store_type_code,
    t2.city_id,
    t2.city_name,
    t2.region_code,
    t2.region_name,
    t2.is_day_clear,
    t1.reg_num_add,
    t2.reg_num_sum,
    t1.consume_num_add,
    t2.consume_num_sum,
    t1.repurchase_num_add,
    t2.repurchase_num_sum,
    t2.active_member_num,
    t2.sleep_member_num,
    t1.sale_amount_bind,
    t2.trade_date as dt
from t2 left join  t1 on t2.trade_date = t1.month_trade_date and t2.store_no = t1.store_no;


