-- 六天前消费用户和往后每一天的复购情况
--会员主题: ADS层  会员复购天表
-- 需求: 计算某一天及相对于第一天往后六天每天的复购的人数
-- 思路: 首先知道6天前的那一天的所有的消费用户  基于这个结果 left join 往后1天的所有消费用户 left join  往后2天的所有消费用户 ...往后6天的所有消费用户
set session hive.insert_existing_partitions_behavior = 'overwrite';
insert into hive.ads.ads_mem_repurchase_day_i
select
    date_format(date_add('day',-6,date '2026-08-16'),'%Y-%m-%d') as trade_date,
    s.store_no,
    s.store_name,
    s.store_sale_type,
    s.store_type_code,
    s.city_id,
    s.city_name,
    s.region_code,
    s.region_name,
    s.is_day_clear,
    count(day0.zt_id) as member_count,
    count(day1.zt_id) as next_member_count_1,
    count(day2.zt_id) as next_member_count_2,
    count(day3.zt_id) as next_member_count_3,
    count(day4.zt_id) as next_member_count_4,
    count(day5.zt_id) as next_member_count_5,
    count(day6.zt_id) as next_member_count_6,
    date_format(date_add('day',-6,date '2026-08-16'),'%Y-%m-%d') as dt

from (
    select
        t.zt_id,
        t.bind_md,
        t.dt as after,
        tt.days_after1,
        tt.days_after2,
        tt.days_after3,
        tt.days_after4,
        tt.days_after5,
        tt.days_after6
    from hive.dwm.dwm_mem_member_behavior_day_i t left join hive.dim.dwd_dim_date_f tt on t.trade_date = tt.trade_date
    where dt = date_format(date_add('day',-6,date '2026-08-16'),'%Y-%m-%d')
      and consume_times > 0
) as day0
left join (
    select
        zt_id,
        bind_md,
        dt as after1
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt = date_format(date_add('day',-5,date '2026-08-16'),'%Y-%m-%d') and consume_times>0
) day1 on day0.days_after1 = day1.after1 and day0.zt_id = day1.zt_id
left join (
    select
        zt_id,
        bind_md,
        dt as after2
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt = date_format(date_add('day',-4,date '2026-08-16'),'%Y-%m-%d') and consume_times>0
) day2 on day0.days_after2 = day2.after2 and day0.zt_id = day2.zt_id
left join (
    select
        zt_id,
        bind_md,
        dt as after3
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt = date_format(date_add('day',-3,date '2026-08-16'),'%Y-%m-%d') and consume_times>0
) day3 on day0.days_after3 = day3.after3 and day0.zt_id = day3.zt_id
left join (
    select
        zt_id,
        bind_md,
        dt as after4
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt = date_format(date_add('day',-2,date '2026-08-16'),'%Y-%m-%d') and consume_times>0
) day4 on day0.days_after4 = day4.after4 and day0.zt_id = day4.zt_id
left join (
    select
        zt_id,
        bind_md,
        dt as after5
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt = date_format(date_add('day',-1,date '2026-08-16'),'%Y-%m-%d') and consume_times>0
) day5 on day0.days_after5 = day5.after5 and day0.zt_id = day5.zt_id
left join (
    select
        zt_id,
        bind_md,
        dt as after6
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt = '2026-08-16' and consume_times>0
) day6 on day0.days_after6 = day6.after6 and day0.zt_id = day6.zt_id
       -- 注意: 一定要检查自己的dwd_dim_store_i分区目录,此处填写自己的分区目录时间
join hive.dim.dwd_dim_store_i s on day0.bind_md = s.store_no and s.dt = '2026-08-18'
group by
    s.store_no,
    s.store_name,
    s.store_sale_type,
    s.store_type_code,
    s.city_id,
    s.city_name,
    s.region_code,
    s.region_name,
    s.is_day_clear;








-- 另一种写法: 直接计算出 6天 及其每一天和后面六天的数据
--会员主题: ADS层  会员复购天表
-- 需求: 计算某一天及相对于第一天往后六天每天的复购的人数
-- 思路: 首先知道6天前的那一天的所有的消费用户  基于这个结果 left join 往后1天的所有消费用户 left join  往后2天的所有消费用户 ...往后6天的所有消费用户
/*set session hive.insert_existing_partitions_behavior = 'overwrite';
insert into hive.ads.ads_mem_repurchase_day_i
select
    day0.after as trade_date,
    s.store_no,
    s.store_name,
    s.store_sale_type,
    s.store_type_code,
    s.city_id,
    s.city_name,
    s.region_code,
    s.region_name,
    s.is_day_clear,
    count(day0.zt_id) as member_count,
    count(day1.zt_id) as next_member_count_1,
    count(day2.zt_id) as next_member_count_2,
    count(day3.zt_id) as next_member_count_3,
    count(day4.zt_id) as next_member_count_4,
    count(day5.zt_id) as next_member_count_5,
    count(day6.zt_id) as next_member_count_6,
    date_format(date_add('day',-6,date '2026-08-16'),'%Y-%m-%d') as dt
from (
    -- 获取 统计日期前6天的所有的消费数据
    select
        t.zt_id,
        t.bind_md,
        t.dt as after,
        tt.days_after1,
        tt.days_after2,
        tt.days_after3,
        tt.days_after4,
        tt.days_after5,
        tt.days_after6
    from hive.dwm.dwm_mem_member_behavior_day_i t left join hive.dim.dwd_dim_date_f tt on t.trade_date = tt.trade_date
    where dt >= date_format(date_add('day',-6,date '2026-08-16'),'%Y-%m-%d')
        and dt <= '2026-08-16'
        and consume_times>0
) as day0
left join (
    -- 获取 统计日期前5天和 后1天的的所有的消费数据
    select
        zt_id,
        bind_md,
        dt as after1
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt >= date_format(date_add('day',-5,date '2026-08-16'),'%Y-%m-%d')
      and dt <= date_format(date_add('day',1,date '2026-08-16'),'%Y-%m-%d')
      and consume_times>0
) day1 on day0.days_after1 = day1.after1 and day0.zt_id = day1.zt_id
left join (
    -- 获取 统计日期前4天和 后2天的的所有的消费数据
    select
        zt_id,
        bind_md,
        dt as after2
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt >= date_format(date_add('day',-4,date '2026-08-16'),'%Y-%m-%d')
      and dt <= date_format(date_add('day',2,date '2026-08-16'),'%Y-%m-%d')
      and consume_times>0
) day2 on day0.days_after2 = day2.after2 and day0.zt_id = day2.zt_id
left join (
    -- 获取 统计日期前3天和 后3天的的所有的消费数据
    select
        zt_id,
        bind_md,
        dt as after3
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt >= date_format(date_add('day',-3,date '2026-08-16'),'%Y-%m-%d')
      and dt <= date_format(date_add('day',3,date '2026-08-16'),'%Y-%m-%d')
      and consume_times>0
) day3 on day0.days_after3 = day3.after3 and day0.zt_id = day3.zt_id
left join (
    -- 获取 统计日期前2天和 后4天的的所有的消费数据
    select
        zt_id,
        bind_md,
        dt as after4
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt >= date_format(date_add('day',-2,date '2026-08-16'),'%Y-%m-%d')
      and dt <= date_format(date_add('day',4,date '2026-08-16'),'%Y-%m-%d')
      and consume_times>0
) day4 on day0.days_after4 = day4.after4 and day0.zt_id = day4.zt_id
left join (
    -- 获取 统计日期前1天和 后5天的的所有的消费数据
    select
        zt_id,
        bind_md,
        dt as after5
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt >= date_format(date_add('day',-1,date '2026-08-16'),'%Y-%m-%d')
      and dt <= date_format(date_add('day',5,date '2026-08-16'),'%Y-%m-%d')
      and consume_times>0
) day5 on day0.days_after5 = day5.after5 and day0.zt_id = day5.zt_id
left join (
    -- 获取 统计日期后6天的的所有的消费数据
    select
        zt_id,
        bind_md,
        dt as after6
    from hive.dwm.dwm_mem_member_behavior_day_i
    where dt >= '2026-08-16'
      and dt <= date_format(date_add('day',6,date '2026-08-16'),'%Y-%m-%d')
      and consume_times>0
) day6 on day0.days_after6 = day6.after6 and day0.zt_id = day6.zt_id
join hive.dim.dwd_dim_store_i s on day0.bind_md = s.store_no
group by
    day0.after,
    s.store_no,
    s.store_name,
    s.store_sale_type,
    s.store_type_code,
    s.city_id,
    s.city_name,
    s.region_code,
    s.region_name,
    s.is_day_clear;*/