-- 建库
create database if not exists dwd;
-- 1.会员基础信息表
CREATE TABLE IF NOT EXISTS dwd.dwd_mem_member_union_i(
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

-- 2.会员积分变动表
CREATE TABLE IF NOT EXISTS dwd.dwd_mem_member_point_change_i(
    trade_date          STRING COMMENT '快照时间',
    zt_id            BIGINT COMMENT '中台ID',
    occupy_subject_id   BIGINT COMMENT '占用主体ID，0为全部，101优选,102云鲜,103云鲜商城',
    point_add           BIGINT COMMENT '增加积分，没有则为0',
    point_reduce        BIGINT COMMENT '减少积分，没有则为0',
    point_change        BIGINT COMMENT '变动积分，没有则为0'
) 
comment '会员积分变动表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 3.线上会员余额变动表
CREATE TABLE IF NOT EXISTS dwd.dwd_mem_balance_change_i(
    trade_date      STRING COMMENT '统计日期',
    zt_id           BIGINT COMMENT '中台ID',
    member_id       BIGINT COMMENT '会员ID',
    record_type     BIGINT COMMENT '记录类型，0全部,1消费,2充值,3退款,4.清退余额,5.转化,6.系统清除,7.礼品卡兑换,8.现付结余,9.结余退款,10.退卡',
    times           BIGINT COMMENT '次数',
    change_amount   DECIMAL(27, 2) COMMENT '变动金额'
) 
comment '线上会员每日余额变动表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');

-- 4.线上会员每日余额表
CREATE TABLE IF NOT EXISTS dwd.dwd_mem_balance_online_i(
    trade_date          STRING COMMENT '统计日期',
    zt_id               BIGINT COMMENT '中台ID',
    member_id           BIGINT COMMENT '会员ID',    
    member_type         BIGINT COMMENT '会员类型',
    member_type_name    STRING COMMENT '会员类型名称',
    store_no            STRING COMMENT '门店编码',
    city_id             BIGINT COMMENT '城市ID',
    balance_amount      DECIMAL(27, 2) COMMENT '余额'
) 
comment '线上会员每日余额表'
partitioned by (dt STRING COMMENT '统计日期')
row format delimited fields terminated by ','
stored as orc
tblproperties ('orc.compress'='SNAPPY');