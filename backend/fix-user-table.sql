-- 修复用户表结构
-- 先删除损坏的用户表
DROP TABLE IF EXISTS `user`;

-- 重新创建正确的用户表
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `icon_path` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- 插入测试用户数据
INSERT INTO `user` VALUES ('1', '345', '/images/user_icon/p1.png', 'abc', 'def', '1234');
INSERT INTO `user` VALUES ('2', '1291288422@qq.com', '/images/user_icon/p1.png', 'TT', 'Xie', '735682cc8dc57b13f7c15d402aa5a041');

-- 清空user_order表中的测试数据，只保留真实订单
DELETE FROM `user_order` WHERE `user_id` = 1;

-- 显示修复结果
SELECT '用户表修复完成！' as message;
SELECT COUNT(*) as user_count FROM `user`;
SELECT COUNT(*) as order_count FROM `user_order`;
