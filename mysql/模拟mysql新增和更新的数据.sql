-- 新增一条
insert into member.member_union (zt_id, member_id, user_id, card_no, member_name, mobile, user_email, sex, birthday_date, address,reg_time, reg_md, bind_md, flag, is_black, user_state, user_type, member_type, member_status, expired_time, user_source, member_level, growth, invite_member_id, invite_type, register_store_leader_id,last_update_time)
values ('32015926',2160344,NULL,'','32015925',114,163,0,'','不详','2026-08-20 17:09:28','W121','W121',0,0,1,-1,10,-1,NULL,-1,0,0,NULL,NULL,NULL,'2026-08-20 17:09:28');
-- 更新一条
UPDATE member.member_union SET SEX = 1, last_update_time = '2026-08-20 17:10:20' WHERE zt_id = '32015925';



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