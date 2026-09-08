-- 1.首次导入:
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
    date_format(date_sub(current_date(),2),'yyyy-MM-dd') as start_date

from ods.ods_mem_member_union_i;


-- 2.拉链表整个循环流程
-- 步骤一: 在MySQL中, 添加增量的测试数据, 包含 新增 和 更新的数据 (测试)
/*
-- 新增一条
insert into member.member_union (zt_id, member_id, user_id, card_no, member_name, mobile, user_email, sex, birthday_date, address,reg_time, reg_md, bind_md, flag, is_black, user_state, user_type, member_type, member_status, expired_time, user_source, member_level, growth, invite_member_id, invite_type, register_store_leader_id,last_update_time)
values ('32015926',2160344,NULL,'','32015925',114,163,0,'','不详','2024-05-10 17:09:28','W121','W121',0,0,1,-1,10,-1,NULL,-1,0,0,NULL,NULL,NULL,'2024-05-10 17:09:28');
-- 更新一条
UPDATE member.member_union SET SEX = 1, last_update_time = '2024-05-10 17:10:20' WHERE zt_id = '32015925';

-- 验证数据
-- 筛选条件
select * from member.member_union where
reg_time between concat(date_sub(current_date,INTERVAL 1 DAY),' 00:00:00') and concat(date_sub(current_date,INTERVAL 1 DAY),' 23:59:59')
OR
last_update_time between concat(date_sub(current_date,INTERVAL 1 DAY),' 00:00:00') and concat(date_sub(current_date,INTERVAL 1 DAY),' 23:59:59');

-- 或者:
select * from member.member_union where
date_format(reg_time,'%Y-%m-%d') = DATE_FORMAT(date_sub(NOW(),INTERVAL 1 DAY),'%Y-%m-%d')
OR
date_format(last_update_time,'%Y-%m-%d') = DATE_FORMAT(date_sub(NOW(),INTERVAL 1 DAY),'%Y-%m-%d');
*/


-- 注意: 日期需要写为上一天的日期


-- 步骤二: 执行DataX, 将新增数据和增量数据导入到ODS层  (应该在数据采集中执行)
-- 说明: 此步骤详细过程参考day02实施mysql位置where 条件如下:
/*
date_format(reg_time,'%Y-%m-%d') = DATE_FORMAT(date_sub(NOW(),INTERVAL 1 DAY),'%Y-%m-%d')
OR
date_format(last_update_time,'%Y-%m-%d') = DATE_FORMAT(date_sub(NOW(),INTERVAL 1 DAY),'%Y-%m-%d')
*/
-- 说明: datax创建的分区默认hive不识别,建议添加后置sql如下:
/*
"postSql":["MSCK REPAIR TABLE ods.ods_mem_member_union_i"],
*/
-- 验证hive的ODS层数据新增和更新的数据是否成功导入
select * from ods.ods_mem_member_union_i where dt = '2026-08-20';  -- 新增和更新的数据
select * from ods.ods_mem_member_union_i WHERE zt_id = '32015925';  -- 历史和更新的数据


-- 步骤三: 执行增量数据导入
-- 先创建一张目标表的临时表, 用于放置计算后的结果
CREATE TABLE IF NOT EXISTS dwd.dwd_mem_member_union_i_temp(
    zt_id                    BIGINT COMMENT '中台会员ID',
    member_id                BIGINT COMMENT '会员ID',
    user_id                  BIGINT COMMENT '用户ID',
    card_no                  STRING COMMENT '卡号',
    member_name              STRING COMMENT '会员名称',
    mobile                   STRING COMMENT '手机号',
    user_email               STRING COMMENT '邮箱',
    sex                      BIGINT COMMENT '用户的性别，1男性，2女性，0未知',
    birthday_date            STRING COMMENT '生日',
    address                  STRING COMMENT '地址',
    reg_time                 TIMESTAMP COMMENT '注册时间',
    reg_md                   STRING COMMENT '注册门店',
    bind_md                  STRING COMMENT '绑定门店',
    flag                     BIGINT COMMENT '0正常,1删除',
    is_black                 BIGINT COMMENT '是否被拉黑 1被拉黑,0正常用户',
    user_state               BIGINT COMMENT '会员状态，0停用/注销,1正常,2冻结',
    user_type                STRING COMMENT '用户类型（-1:云鲜用户;0:普通用户;1:企业用户 2:内部员工 3:甄选门店 4:商铺会员 5:大买家 6:中间商 7:军区员工）',
    member_type              BIGINT COMMENT '会员状态 10：未付费会员 20：付费会员',
    member_status            BIGINT COMMENT '付费会员状态 -1:未付费会员 1：正常 2：试用 3：过期 4:试用已过期',
    expired_time             TIMESTAMP COMMENT '过期时间',
    user_source              BIGINT COMMENT '用户来源 ',
    member_level             BIGINT COMMENT '会员等级',
    growth                   BIGINT COMMENT '成长值',
    invite_member_id         BIGINT COMMENT '邀请人标识',
    invite_type              BIGINT COMMENT '邀请类型，0为内部',
    register_store_leader_id BIGINT COMMENT '注册归属团长 ID',
    last_update_time         TIMESTAMP COMMENT '更新日期',
    end_date                 STRING COMMENT '生效结束日期'
)
comment '会员基础信息表'
partitioned by (start_date STRING COMMENT '生效开始日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');



-- 原始拉链表中验证历史数据
select * from dwd.dwd_mem_member_union_i WHERE zt_id = '32015925'; -- 目前end_date还是999-99-99
select * from dwd.dwd_mem_member_union_i WHERE start_date='2026-08-20'; -- 目前还没有数据


-- 接下来执行sql修改历史数据的结束时间,并且把新增和更新的数据都导入到最新拉链表中
-- 拉链表完整sql
with t2 as (
    -- 步骤1: 修改历史数据的结束时间
    select
        t1.zt_id,
        t1.member_id,
        t1.user_id,
        t1.card_no,
        t1.member_name,
        t1.mobile,
        t1.user_email,
        t1.sex,
        t1.birthday_date,
        t1.address,
        t1.reg_time,
        t1.reg_md,
        t1.bind_md,
        t1.flag,
        t1.is_black,
        t1.user_state,
        t1.user_type,
        t1.member_type,
        t1.member_status,
        t1.expired_time,
        t1.user_source,
        t1.member_level,
        t1.growth,
        t1.invite_member_id,
        t1.invite_type,
        t1.register_store_leader_id,
        t1.last_update_time,
        if(
            t2.zt_id is null OR t1.end_date != '9999-99-99',
            t1.end_date,
            t2.dt
        ) as end_date,
        t1.start_date
    from dwd.dwd_mem_member_union_i t1
        left join (select * from ods.ods_mem_member_union_i where dt = date_format(date_sub(current_date(),1),'yyyy-MM-dd')) as t2
        on t1.zt_id = t2.zt_id
    union all
    -- 步骤2: 获取新增和更新的数据
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
        date_format(date_sub(current_date(),1),'yyyy-MM-dd') as start_date
    from ods.ods_mem_member_union_i
    where dt = date_format(date_sub(current_date(),1),'yyyy-MM-dd')
)
-- 注意: 最新的拉链数据建议先保存到临时表中,保证数据安全
insert overwrite table dwd.dwd_mem_member_union_i_temp partition (start_date)
select
*
from t2 ;

-- 验证临时表中数据
select * from dwd.dwd_mem_member_union_i_temp WHERE zt_id = '32015925'; -- 历史数据end_date已经被修改,最新的数据也被导入
select * from dwd.dwd_mem_member_union_i_temp WHERE start_date='2026-08-20'; -- 新增和更新的数据都被查询到


-- 最后将临时表数据覆盖回目标表中
insert overwrite table dwd.dwd_mem_member_union_i partition (start_date)
select * from dwd.dwd_mem_member_union_i_temp;

-- 原始拉链表中验证历史数据
select * from dwd.dwd_mem_member_union_i WHERE zt_id = '32015925'; -- 历史数据end_date已经被修改,最新的数据也被导入
select * from dwd.dwd_mem_member_union_i WHERE start_date='2026-08-20'; -- 新增和更新的数据都被查询到


-- 将临时表删除或者清空数据
truncate table dwd.dwd_mem_member_union_i_temp;