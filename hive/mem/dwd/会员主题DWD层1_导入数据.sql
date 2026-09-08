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


-- 会员基础信息表首次导入
insert overwrite table dwd.dwd_mem_member_union_i partition (start_date)
select
    zt_id,
    member_id,
    user_id,
    card_no,
    member_name,
    mobile,
    user_email,
    sex,
    birthday_date,
    address,
    reg_time,
    reg_md,
    bind_md,
    flag,
    is_black,
    user_state,
    user_type,
    member_type,
    member_status,
    expired_time,
    user_source,
    member_level,
    growth,
    invite_member_id,
    invite_type,
    register_store_leader_id,
    last_update_time,
    '9999-99-99' as end_date,
    '2026-08-16' as start_date

from ods.ods_mem_member_union_i;




-- 会员主题 DWD层开发  会员积分变动表
-- 需求: 统计每天各个会员积分变动情况
-- 注意: 主体分为两部分 , 一部分是全部  一部分为各个主体
insert overwrite table dwd.dwd_mem_member_point_change_i partition(dt)
select
    dt as trade_date,
    zt_id,
    occupy_subject_id,
    sum( if( change_type = 1,point_c,0) ) as point_add,
    sum( if( change_type = 0,-point_c,0) ) as point_reduce,
    sum( if( change_type = 1,point_c,-point_c)) as point_change,
    dt
from ods.ods_mem_user_point_log_detailed_i
group by
    dt,
    zt_id,
    occupy_subject_id

union  all

select
    dt as trade_date,
    zt_id,
    0 as occupy_subject_id,
    sum( if( change_type = 1,point_c,0) ) as point_add,
    sum( if( change_type = 0,-point_c,0) ) as point_reduce,
    sum(if( change_type = 1,point_c,-point_c)) as point_change,
    dt
from ods.ods_mem_user_point_log_detailed_i
group by
    dt,
    zt_id;





-- DWD 会员余额变动表
-- 需求: 统计每天各个会员余额变动情况
-- 注意:  记录类型也分为二部分  一个是全部  一个是 各个记录类型  union all 将两部分结果进行合并
insert overwrite table dwd.dwd_mem_balance_change_i partition (dt)
select
    dt as trade_date,
    zt_id,
    member_id,
    record_type,

    count(1) as times,
    sum(amount) as change_amount,
    dt
from ods.ods_mem_store_amount_record_i
group by
    dt,
    zt_id,
    member_id,
    record_type

union all

select
    dt as trade_date,
    zt_id,
    member_id,
    0 as record_type,
    count(1) as times,
    sum(amount) as change_amount,
    dt
from ods.ods_mem_store_amount_record_i
group by
    dt,
    zt_id,
    member_id;

