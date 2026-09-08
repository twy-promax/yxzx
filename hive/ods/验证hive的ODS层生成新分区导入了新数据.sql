-- datax增量导入数据后查看分区,观察效果
show partitions ods.ods_sale_shop_refund_i;
select * from ods.ods_sale_shop_refund_i;


MSCK REPAIR TABLE ods.ods_sale_shop_refund_i;

