-- 模拟mysql退款表有新增数据
insert into sale.shop_refund (id, refund_no, refund_status, refund_code, refund_msg, refund_desc, create_time, update_time,
                         cancel_time, refund_amount, refund_point_amount, return_pay_point, return_point_amount,
                         refund_time, less_weight, pick_weight, is_deleted, refund_type, order_no, refund_apply_type,
                         refund_delivery, sync_erp_status, sync_erp_msg, create_sys_user_id, create_sys_user_name,
                         store_no, store_leader_id)
values (13,'220731Y28899211128',2,999,'其他原因','','2026-08-19 17:50:24','2026-08-19  17:50:24',null,5.26,5.00,null,null,'2026-08-19 17:50:23',null,null,0,1,'BL22073199620677',1,0.00,1,null,1001107,1001107,'Y288',null);




-- 首次导入: 默认select * from mysql表;
-- 增量仅新增: 只筛选新增的数据
select now();
-- 获取上一天增量的sql语句
SELECT * from sale.shop_refund where
                                   date_format(create_time,'%Y-%m-%d') = DATE_FORMAT(date_sub(NOW(),INTERVAL 1 DAY),'%Y-%m-%d');

-- 或者:
select * from sale.shop_refund where
                                   create_time between concat(date_sub(current_date,INTERVAL 1 DAY),' 00:00:00') and concat(date_sub(current_date,INTERVAL 1 DAY),' 23:59:59')



