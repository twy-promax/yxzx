-- 开启动态分区方案
-- 开启动态分区支持(默认true)
set hive.exec.dynamic.partition=true;
-- 开启非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;

-- 设置各个节点生成动态分区的最大数量: 默认为100个  (一般在生产环境中, 都需要调整更大)
set hive.exec.max.dynamic.partitions.pernode=100000;
-- 设置最大生成动态分区的数量: 默认为1000 (一般在生产环境中, 都需要调整更大)
set hive.exec.max.dynamic.partitions=100000;
-- hive一次性最大能够创建多少个文件: 默认为10w
set hive.exec.max.created.files=150000;


-- 插入数据
insert overwrite table ods.ods_stock_store_goods_stock_data_day_i partition (dt)
select
       *,
       date_format(last_update_time,'yyyy-MM-dd') as dt
from ods.ods_stock_store_goods_stock_data_day_i_temp;

-- 删临时表表
drop table ods.ods_stock_store_goods_stock_data_day_i_temp;


-- 插入数据
insert overwrite table ods.ods_sale_store_sale_info_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_store_sale_info_i_temp;
-- 删临时表表
drop table ods.ods_sale_store_sale_info_i_temp;



-- 插入数据
insert overwrite table ods.ods_sale_store_sale_dtl_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_store_sale_dtl_i_temp;
-- 删临时表表
drop table ods.ods_sale_store_sale_dtl_i_temp;



-- 插入数据
insert overwrite table ods.ods_sale_shop_refund_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_shop_refund_i_temp;
-- 删临时表表
drop table ods.ods_sale_shop_refund_i_temp;



-- 插入数据
insert overwrite table ods.ods_sale_shop_refund_item_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_shop_refund_item_i_temp;
-- 删临时表表
drop table ods.ods_sale_shop_refund_item_i_temp;



-- 插入数据
insert overwrite table ods.ods_sale_store_sale_pay_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_store_sale_pay_i_temp;
-- 删临时表表
drop table ods.ods_sale_store_sale_pay_i_temp;



-- 插入数据
insert overwrite table ods.ods_sale_shop_sale_pay_i partition (dt)
select
       *,
       date_format(trade_date,'yyyy-MM-dd') as dt
from ods.ods_sale_shop_sale_pay_i_temp;
-- 删临时表表
drop table ods.ods_sale_shop_sale_pay_i_temp;


-- 插入数据
insert overwrite table ods.ods_mem_store_amount_record_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_mem_store_amount_record_i_temp;
-- 删临时表表
drop table ods.ods_mem_store_amount_record_i_temp;



-- 插入数据
insert overwrite table ods.ods_mem_user_point_detailed_i partition (dt)
select
       *,
       date_format(created_time,'yyyy-MM-dd') as dt
from ods.ods_mem_user_point_detailed_i_temp;
-- 删临时表表
drop table ods.ods_mem_user_point_detailed_i_temp;


-- 插入数据
insert overwrite table ods.ods_mem_user_point_log_detailed_i partition (dt)
select
       *,
       date_format(created_time,'yyyy-MM-dd') as dt
from ods.ods_mem_user_point_log_detailed_i_temp;
-- 删临时表表
drop table ods.ods_mem_user_point_log_detailed_i_temp;


-- 插入数据
insert overwrite table ods.ods_order_store_receive_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_receive_i_temp;
-- 删临时表表
drop table ods.ods_order_store_receive_i_temp;



-- 插入数据
insert overwrite table ods.ods_order_store_return_to_dc_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_return_to_dc_i_temp;
-- 删临时表表
drop table ods.ods_order_store_return_to_dc_i_temp;



-- 插入数据
insert overwrite table ods.ods_order_store_return_to_vendor_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_return_to_vendor_i_temp;
-- 删临时表表
drop table ods.ods_order_store_return_to_vendor_i_temp;


-- 插入数据
insert overwrite table ods.ods_order_store_alloc_in_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_alloc_in_i_temp;
-- 删临时表表
drop table ods.ods_order_store_alloc_in_i_temp;



-- 插入数据
insert overwrite table ods.ods_order_store_alloc_out_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_alloc_out_i_temp;
-- 删临时表表
drop table ods.ods_order_store_alloc_out_i_temp;


-- 插入数据
insert overwrite table ods.ods_order_store_require_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_store_require_i_temp;
-- 删临时表表
drop table ods.ods_order_store_require_i_temp;



-- 插入数据
insert overwrite table ods.ods_order_dc_send_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_order_dc_send_i_temp;
-- 删临时表表
drop table ods.ods_order_dc_send_i_temp;



-- 插入数据
insert overwrite table ods.ods_stock_store_stock_adj_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_stock_store_stock_adj_i_temp;
-- 删临时表表
drop table ods.ods_stock_store_stock_adj_i_temp;


-- 插入数据
insert overwrite table ods.ods_sale_shop_order_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_shop_order_i_temp;
-- 删临时表表
drop table ods.ods_sale_shop_order_i_temp;


-- 插入数据
insert overwrite table ods.ods_sale_shop_order_item_i partition (dt)
select
       *,
       date_format(create_time,'yyyy-MM-dd') as dt
from ods.ods_sale_shop_order_item_i_temp;
-- 删临时表表
drop table ods.ods_sale_shop_order_item_i_temp;

/*
-- 插入数据
insert overwrite table ods.ods_mem_member_union_i partition (dt)
select
       *,
       date_format(reg_time,'yyyy-MM-dd') as dt
from ods.ods_mem_member_union_i_temp;

注意: 上述sql执行会报错: code2 原因是动态分区任务数太多导致
[08S01][2] Error while processing statement: FAILED: Execution Error,
return code 2 from org.apache.hadoop.hive.ql.exec.mr.MapRedTask

解决方案: 可以考虑分批导入或者直接一次性导入同一个分区
*/
-- 先验证临时表是否有数据
select count(1) from ods.ods_mem_member_union_i_temp; -- 21208
-- 本次咱们采用一次性导入方式
insert into table ods.ods_mem_member_union_i partition (dt)
select
       *,
       '2024-05-01' as dt
from ods.ods_mem_member_union_i_temp;
-- 最后验证真实表数据是否吻合
select count(1) from ods.ods_mem_member_union_i; -- 21208

-- 删临时表表
drop table ods.ods_mem_member_union_i_temp;



