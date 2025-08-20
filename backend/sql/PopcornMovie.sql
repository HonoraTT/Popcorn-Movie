-- =====================================================
-- PopcornMovie 电影订票系统 - 完整数据库初始化脚本
-- 版本：v2.0
-- 日期：2025-08-20
-- 说明：此脚本包含完整的数据库结构和所有初始数据
-- =====================================================

SET FOREIGN_KEY_CHECKS=0;

-- =====================================================
-- 1. 创建数据库（如果不存在）
-- =====================================================
CREATE DATABASE IF NOT EXISTS `popcornmovie` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `popcornmovie`;

-- =====================================================
-- 2. 电影表 (movie)
-- =====================================================
DROP TABLE IF EXISTS `movie`;
CREATE TABLE `movie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `poster_path` varchar(255) DEFAULT NULL,
  `banner_path` varchar(255) DEFAULT NULL,
  `release_date` varchar(255) DEFAULT NULL,
  `duration` varchar(255) DEFAULT NULL,
  `director` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `genre` varchar(255) DEFAULT NULL,
  `cast_and_crew` varchar(255) DEFAULT NULL,
  `rating_score` decimal(3,1) DEFAULT NULL,
  `rating_count` int(11) DEFAULT NULL,
  `box_office` varchar(100) DEFAULT NULL,
  `synopsis` text,
  `awards` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- 插入电影数据
INSERT INTO `movie` VALUES ('1', '黑客帝国', '/images/The Matrix.jpg', '/images/The MatrixB.jpg', '2000-01-14', '3 hour', '莉莉·沃卓斯基', '英语', '动作', '基努·李维斯等', 9.8, 125430, '4.63亿', '在未来的世界里，人类被机器统治，生活在一个虚拟的矩阵中。尼奥（基努·里维斯饰）发现自己可能是救世主，能够拯救人类。', '奥斯卡最佳视觉效果奖、最佳音效剪辑奖');
INSERT INTO `movie` VALUES ('2', '霍比特人：意外之旅', '/images/The Hobbit.jpg', '/images/The HobbitB.jpg', '2006-05-01', '4 hour', '彼得·杰克逊', '英语', '冒险', '弗兰·威尔士等', 8.9, 98765, '3.21亿', '比尔博·巴金斯（马丁·弗里曼饰）被巫师甘道夫选中，加入矮人队伍前往孤山，夺回被恶龙史矛革占据的矮人王国。', '奥斯卡最佳视觉效果奖提名');
INSERT INTO `movie` VALUES ('3', '指环王：护戒使者', '/images/Lord of the rings.jpg', '/images/Lord of the ringsB.jpg', '2001-01-17', '4 hour', '彼得·杰克逊', '英语', '剧情', '伊利亚·伍德等', 9.2, 156789, '5.12亿', '佛罗多·巴金斯（伊利亚·伍德饰）继承了魔戒，必须前往魔多销毁它，拯救中土世界免于黑暗势力的统治。', '奥斯卡最佳影片奖、最佳导演奖、最佳改编剧本奖');
INSERT INTO `movie` VALUES ('4', '加勒比海盗：黑珍珠号诅咒', '/images/Pirates of the Caribbean.jpg', null, '1996-01-01', '3 hour', '戈尔·维宾斯基', '英语', '动作', '约翰尼·德普等', 8.7, 87654, '2.89亿', '杰克·斯派洛船长（约翰尼·德普饰）与威尔·特纳（奥兰多·布鲁姆饰）和伊丽莎白·斯旺（凯拉·奈特莉饰）一起寻找被诅咒的阿兹特克金币。', '奥斯卡最佳男主角提名');
INSERT INTO `movie` VALUES ('5', '罗小黑战记2', '/images/The Legend of Hei.jpg', null, '2025-07-18', '2 hour', '木头', '日语', '动画', '山新/刘明月等', 8.5, 65432, '1.56亿', '小黑跟随师父在小镇上过着安宁日子，分会馆遇袭，打破了妖精世界维系多年的和平，来自妖灵会馆的「全新任务」也让两人陷入分离危机，更让师父无限的处境发生翻天覆地的变化。', '金鸡奖最佳美术片提名');
INSERT INTO `movie` VALUES ('6', '星际穿越', '/images/Interstellar.jpg', null, '2014-11-12', '3 hour', '克里斯托弗·诺兰', '英语', '科幻', '马修·麦康纳等', 8.3, 54321, '1.23亿', '一名宇航员穿越虫洞为人类寻找新家园，却在时空扭曲中与女儿展开跨越维度的亲情救赎。', '奥斯卡最佳视觉效果奖');
INSERT INTO `movie` VALUES ('7', '南京照相馆', '/images/Dead to Rights.jpg', null, '2025-07-25', '3 hour', '申奥', '普通话', '历史', '刘昊然/王传君等', 7.8, 43210, '0.89亿', '一群生活在南京的百姓躲在吉祥照相馆中避难，他们被迫帮助日军摄影师冲洗底片，却意外冲印出了能证明日军屠城的罪证照片。', '青少年选择奖最佳电影');
INSERT INTO `movie` VALUES ('8', '寻梦环游记', '/images/Coco.jpg', null, '2017-11-24', '2 hour', '李·昂克里奇', '英语', '音乐', '安东尼·冈萨雷斯/盖尔·加西亚·贝纳尔等', 9.1, 76543, '2.34亿', '热爱音乐的墨西哥男孩闯入亡灵世界，揭开家族禁忌真相，领悟「遗忘才是终极死亡」的真谛。', '奥斯卡最佳动画长片奖');
INSERT INTO `movie` VALUES ('9', '沙丘2', '/images/Dune.jpg', null, '2024-03-08', '2 hour', '丹尼斯·维伦纽瓦', '英语', '剧情', '提莫西·查拉梅/赞达亚等', 8.6, 34567, '1.78亿', '保罗·厄崔迪在沙漠星球崛起为救世主，却陷入权力、预言与战争的漩涡，直面命运的残酷抉择。', '奥斯卡最佳影片提名、英国电影学院奖最佳导演提名');
INSERT INTO `movie` VALUES ('10', '你想活出怎样的人生', '/images/The Boy and the Heron.jpg', null, '2024-04-03', '2 hour', '宫崎骏', '日语', '动画', '山时聪真等', 8.4, 56789, '1.45亿', '少年在奇幻异世界邂逅神秘生灵，通过成长与告别探寻生命的意义与自我的价值。', '奥斯卡最佳动画长片奖');

-- =====================================================
-- 3. 场次表 (show) - 包含所有场次数据
-- =====================================================
DROP TABLE IF EXISTS `show`;
CREATE TABLE `show` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `theater_name` varchar(255) DEFAULT NULL,
  `time` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `movie_id` bigint(20) DEFAULT NULL,
  `seat_map` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;

-- 插入所有场次数据（原有 + 新增）
-- 黑客帝国 (电影ID: 1) - 7个场次
INSERT INTO `show` VALUES ('1', 'ABC', '10:30', '130', '1', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('2', 'ABC', '14:30', '100', '1', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('3', 'UKnow', '10:00', '20', '1', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('31', 'BigFeel', '19:30', '45', '1', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('32', 'EyeBrand', '13:00', '80', '1', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('33', 'Happy', '16:30', '55', '1', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('34', 'UKnow', '21:00', '25', '1', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');

-- 霍比特人 (电影ID: 2) - 7个场次
INSERT INTO `show` VALUES ('4', 'UKnow', '14:00', '15', '2', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('7', 'EyeBrand', '10:20', '70', '2', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('16', 'UKnow', '16:00', '20', '2', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('35', 'BigFeel', '11:30', '38', '2', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('36', 'EyeBrand', '18:00', '75', '2', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('37', 'Happy', '14:30', '60', '2', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('38', 'ABC', '20:30', '120', '2', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');

-- 指环王 (电影ID: 3) - 7个场次
INSERT INTO `show` VALUES ('5', 'UKnow', '20:00', '30', '3', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('19', 'BigFeel', '08:00', '30', '3', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('20', 'BigFeel', '10:00', '40', '3', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('39', 'BigFeel', '13:30', '42', '3', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('40', 'EyeBrand', '16:00', '85', '3', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('41', 'Happy', '11:00', '65', '3', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('42', 'UKNow', '19:00', '28', '3', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');

-- 加勒比海盗 (电影ID: 4) - 7个场次
INSERT INTO `show` VALUES ('6', 'UKNow', '22:00', '20', '4', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('10', 'BigFeel', '08:00', '35', '4', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('17', 'BigFeel', '09:00', '35', '4', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('43', 'BigFeel', '15:30', '40', '4', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('44', 'EyeBrand', '12:00', '90', '4', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('45', 'Happy', '18:30', '70', '4', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('46', 'ABC', '17:00', '110', '4', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');

-- 罗小黑战记2 (电影ID: 5) - 7个场次
INSERT INTO `show` VALUES ('8', 'EyeBrand', '15:00', '70', '5', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('21', 'EyeBrand', '17:00', '20', '5', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('22', 'UKNow', '08:28', '100', '5', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('47', 'BigFeel', '10:30', '35', '5', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('48', 'EyeBrand', '14:00', '95', '5', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('49', 'Happy', '20:00', '75', '5', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('50', 'UKNow', '12:30', '22', '5', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');

-- 星际穿越 (电影ID: 6) - 7个场次
INSERT INTO `show` VALUES ('9', 'EyeBrand', '20:00', '70', '6', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('11', 'BigFeel', '10:00', '42', '6', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('18', 'BigFeel', '12:00', '42', '6', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('51', 'BigFeel', '17:30', '45', '6', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('52', 'EyeBrand', '09:00', '100', '6', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('53', 'Happy', '13:00', '80', '6', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('54', 'ABC', '21:00', '125', '6', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');

-- 南京照相馆 (电影ID: 7) - 7个场次
INSERT INTO `show` VALUES ('15', 'Happy', '19:30', '50', '7', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('23', 'Happy', '21:28', '18', '7', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('24', 'EyeBrand', '12:35', '97', '7', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('55', 'BigFeel', '12:30', '38', '7', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('56', 'EyeBrand', '15:30', '85', '7', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('57', 'UKnow', '18:00', '25', '7', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');

-- 寻梦环游记 (电影ID: 8) - 7个场次
INSERT INTO `show` VALUES ('58', 'BigFeel', '10:00', '40', '8', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('59', 'EyeBrand', '14:00', '90', '8', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('60', 'Happy', '16:30', '65', '8', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('61', 'ABC', '19:00', '115', '8', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('62', 'UKnow', '20:30', '28', '8', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('63', 'BigFeel', '13:30', '42', '8', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('64', 'EyeBrand', '17:30', '95', '8', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');

-- 沙丘2 (电影ID: 9) - 7个场次
INSERT INTO `show` VALUES ('65', 'BigFeel', '11:00', '45', '9', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('66', 'EyeBrand', '15:00', '100', '9', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('67', 'Happy', '18:00', '70', '9', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('68', 'ABC', '20:00', '120', '9', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('69', 'UKnow', '21:30', '30', '9', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('70', 'BigFeel', '14:30', '48', '9', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('71', 'EyeBrand', '16:30', '105', '9', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');

-- 你想活出怎样的人生 (电影ID: 10) - 7个场次
INSERT INTO `show` VALUES ('72', 'BigFeel', '09:30', '35', '10', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('73', 'EyeBrand', '13:30', '85', '10', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');
INSERT INTO `show` VALUES ('74', 'Happy', '16:00', '60', '10', 'aaaaaaaa|_aaaaaa_|_aaaaaa_|_aaaaaa_|_aaaaaa_|aaaaaaaa|_aaaaaa_|aaaaaaaa|');
INSERT INTO `show` VALUES ('75', 'ABC', '18:30', '110', '10', 'aaaaaaaa|aaaaaaaa|________|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('76', 'UKnow', '20:00', '25', '10', 'aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|aaaaaaaa|');
INSERT INTO `show` VALUES ('77', 'BigFeel', '12:00', '40', '10', 'aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|aa_aa_aa|');
INSERT INTO `show` VALUES ('78', 'EyeBrand', '15:30', '90', '10', 'aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|aaa__aaa|');

-- =====================================================
-- 4. 用户订单表 (user_order)
-- =====================================================
DROP TABLE IF EXISTS `user_order`;
CREATE TABLE `user_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `movie_id` bigint(20) NOT NULL,
  `show_id` bigint(20) NOT NULL,
  `movie_name` varchar(255) NOT NULL,
  `movie_poster` varchar(255) DEFAULT NULL,
  `cinema_name` varchar(255) NOT NULL,
  `show_time` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'upcoming',
  `order_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `seats` text,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_movie_id` (`movie_id`),
  KEY `idx_show_id` (`show_id`),
  KEY `idx_status` (`status`),
  KEY `idx_order_time` (`order_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试订单数据
INSERT INTO `user_order` (`user_id`, `movie_id`, `show_id`, `movie_name`, `movie_poster`, `cinema_name`, `show_time`, `status`, `order_time`, `total_price`, `seats`) VALUES
(1, 1, 1, '黑客帝国', '/images/The Matrix.jpg', 'CGV影城', '2025-08-15 10:30', 'completed', '2025-08-10 14:30:00', 130.00, '[{"row": 3, "col": 5}, {"row": 3, "col": 6}]'),
(1, 3, 5, '指环王：护戒使者', '/images/Lord of the rings.jpg', 'UKnow影院', '2025-08-20 20:00', 'upcoming', '2025-08-12 16:45:00', 30.00, '[{"row": 4, "col": 3}]'),
(1, 4, 8, '加勒比海盗：黑珍珠号诅咒', '/images/Pirates of the Caribbean.jpg', '万达影城', '2025-08-25 15:00', 'upcoming', '2025-08-15 10:20:00', 70.00, '[{"row": 2, "col": 7}]'),
(1, 2, 3, '霍比特人：意外之旅', '/images/The Hobbit.jpg', 'UKnow影院', '2025-08-18 10:00', 'completed', '2025-08-08 09:15:00', 20.00, '[{"row": 5, "col": 4}, {"row": 5, "col": 5}]'),
(1, 6, 9, '星际穿越', '/images/Interstellar.jpg', '万达影城', '2025-08-30 20:00', 'upcoming', '2025-08-16 11:30:00', 70.00, '[{"row": 6, "col": 2}]'),
(2, 1, 2, '黑客帝国', '/images/The Matrix.jpg', 'CGV影城', '2025-08-15 14:30', 'completed', '2025-08-11 10:20:00', 100.00, '[{"row": 4, "col": 8}]'),
(2, 5, 8, '罗小黑战记2', '/images/The Legend of Hei.jpg', '万达影城', '2025-08-22 15:00', 'upcoming', '2025-08-13 15:45:00', 70.00, '[{"row": 3, "col": 6}]'),
(2, 7, 15, '南京照相馆', '/images/Dead to Rights.jpg', '金逸影城', '2025-08-28 19:30', 'upcoming', '2025-08-14 12:10:00', 50.00, '[{"row": 7, "col": 4}]'),
(3, 3, 19, '指环王：护戒使者', '/images/Lord of the rings.jpg', 'BigFeel影院', '2025-08-16 08:00', 'completed', '2025-08-09 08:30:00', 30.00, '[{"row": 2, "col": 5}]'),
(3, 8, 58, '寻梦环游记', '/images/Coco.jpg', 'BigFeel影院', '2025-08-24 10:00', 'upcoming', '2025-08-15 14:20:00', 40.00, '[{"row": 5, "col": 3}, {"row": 5, "col": 4}]');

-- =====================================================
-- 5. 用户表 (user)
-- =====================================================
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试用户数据
INSERT INTO `user` (`username`, `email`, `password`, `phone`, `avatar`) VALUES
('admin', 'admin@popcornmovie.com', 'admin123', '13800138000', '/images/avatar/admin.jpg'),
('user1', 'user1@example.com', 'password123', '13800138001', '/images/avatar/user1.jpg'),
('user2', 'user2@example.com', 'password123', '13800138002', '/images/avatar/user2.jpg'),
('user3', 'user3@example.com', 'password123', '13800138003', '/images/avatar/user3.jpg');

-- =====================================================
-- 6. 收藏表 (favorite)
-- =====================================================
DROP TABLE IF EXISTS `favorite`;
CREATE TABLE `favorite` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `movie_id` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_movie` (`user_id`, `movie_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_movie_id` (`movie_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试收藏数据
INSERT INTO `favorite` (`user_id`, `movie_id`) VALUES
(1, 1), (1, 3), (1, 6),
(2, 2), (2, 5), (2, 8),
(3, 4), (3, 7), (3, 9);

-- =====================================================
-- 7. 评论表 (review)
-- =====================================================
DROP TABLE IF EXISTS `review`;
CREATE TABLE `review` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `movie_id` bigint(20) NOT NULL,
  `rating` int(1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
  `comment` text,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_movie_id` (`movie_id`),
  KEY `idx_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试评论数据
INSERT INTO `review` (`user_id`, `movie_id`, `rating`, `comment`) VALUES
(1, 1, 5, '非常震撼的科幻电影，特效很棒！'),
(1, 3, 4, '经典的魔幻史诗，值得一看。'),
(2, 2, 4, '霍比特人的冒险故事很有趣。'),
(2, 5, 5, '国产动画的精品之作！'),
(3, 4, 3, '海盗题材很有趣，但剧情有些拖沓。'),
(3, 7, 4, '历史题材很有意义，演员表演到位。');

-- =====================================================
-- 8. 支付表 (payment)
-- =====================================================
DROP TABLE IF EXISTS `payment`;
CREATE TABLE `payment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `transaction_id` varchar(255) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试支付数据
INSERT INTO `payment` (`order_id`, `payment_method`, `amount`, `status`, `transaction_id`) VALUES
(1, 'alipay', 130.00, 'completed', 'ALI202508101430001'),
(2, 'wechat', 30.00, 'pending', 'WX202508121645002'),
(3, 'alipay', 70.00, 'pending', 'ALI202508151020003'),
(4, 'wechat', 20.00, 'completed', 'WX202508080915004'),
(5, 'alipay', 70.00, 'pending', 'ALI202508161130005');

-- =====================================================
-- 9. 优惠券表 (coupon)
-- =====================================================
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `discount_type` varchar(20) NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_amount` decimal(10,2) DEFAULT 0.00,
  `max_discount` decimal(10,2) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `used_count` int(11) DEFAULT 0,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试优惠券数据
INSERT INTO `coupon` (`code`, `name`, `discount_type`, `discount_value`, `min_amount`, `max_discount`, `start_date`, `end_date`, `usage_limit`, `used_count`) VALUES
('WELCOME10', '新用户专享券', 'percentage', 10.00, 50.00, 20.00, '2025-08-01', '2025-12-31', 1000, 50),
('SAVE20', '满减优惠券', 'fixed', 20.00, 100.00, NULL, '2025-08-01', '2025-10-31', 500, 30),
('HALF50', '半价优惠券', 'percentage', 50.00, 30.00, 50.00, '2025-08-01', '2025-09-30', 200, 15);

-- =====================================================
-- 10. 用户优惠券表 (user_coupon)
-- =====================================================
DROP TABLE IF EXISTS `user_coupon`;
CREATE TABLE `user_coupon` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `coupon_id` bigint(20) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'unused',
  `get_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `use_time` datetime DEFAULT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_coupon_id` (`coupon_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试用户优惠券数据
INSERT INTO `user_coupon` (`user_id`, `coupon_id`, `status`, `use_time`, `order_id`) VALUES
(1, 1, 'used', '2025-08-10 14:30:00', 1),
(1, 2, 'unused', NULL, NULL),
(2, 1, 'used', '2025-08-11 10:20:00', 6),
(2, 3, 'unused', NULL, NULL),
(3, 2, 'unused', NULL, NULL);

-- =====================================================
-- 11. 影院表 (theater)
-- =====================================================
DROP TABLE IF EXISTS `theater`;
CREATE TABLE `theater` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` varchar(500) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入影院数据
INSERT INTO `theater` (`code`, `name`, `address`, `phone`, `description`) VALUES
('ABC', 'CGV影城', '北京市朝阳区三里屯路19号', '010-12345678', 'CGV影城是韩国CJ集团旗下的高端影院品牌'),
('UKnow', 'UKnow影院', '上海市浦东新区陆家嘴环路1000号', '021-87654321', 'UKnow影院是上海知名的高端影院'),
('BigFeel', 'BigFeel影院', '广州市天河区珠江新城花城大道85号', '020-11223344', 'BigFeel影院提供舒适的观影体验'),
('EyeBrand', '万达影城', '深圳市南山区深南大道9028号', '0755-55667788', '万达影城是万达集团旗下的影院品牌'),
('Happy', '金逸影城', '杭州市西湖区文三路259号', '0571-99887766', '金逸影城是金逸影视集团旗下的影院品牌');

-- =====================================================
-- 12. 影厅表 (hall)
-- =====================================================
DROP TABLE IF EXISTS `hall`;
CREATE TABLE `hall` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `theater_id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL,
  `screen_type` varchar(50) DEFAULT '2D',
  `sound_system` varchar(100) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `idx_theater_id` (`theater_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入影厅数据
INSERT INTO `hall` (`theater_id`, `name`, `capacity`, `screen_type`, `sound_system`) VALUES
(1, '1号厅', 120, '2D', 'Dolby Atmos'),
(1, '2号厅', 80, '3D', 'DTS:X'),
(2, 'A厅', 150, '2D', 'Dolby Digital'),
(2, 'B厅', 100, '3D', 'DTS'),
(3, '巨幕厅', 200, 'IMAX', 'IMAX Sound'),
(3, 'VIP厅', 50, '2D', 'Dolby Atmos'),
(4, '1号厅', 180, '2D', 'Dolby Digital'),
(4, '2号厅', 120, '3D', 'DTS:X'),
(5, '主厅', 160, '2D', 'Dolby Atmos'),
(5, '小厅', 60, '2D', 'Dolby Digital');

-- =====================================================
-- 13. 座位表 (seat)
-- =====================================================
DROP TABLE IF EXISTS `seat`;
CREATE TABLE `seat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hall_id` bigint(20) NOT NULL,
  `row_number` int(11) NOT NULL,
  `column_number` int(11) NOT NULL,
  `seat_type` varchar(20) DEFAULT 'normal',
  `price_multiplier` decimal(3,2) DEFAULT 1.00,
  `status` varchar(20) NOT NULL DEFAULT 'available',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_hall_row_col` (`hall_id`, `row_number`, `column_number`),
  KEY `idx_hall_id` (`hall_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入座位数据（示例：为1号厅插入座位）
INSERT INTO `seat` (`hall_id`, `row_number`, `column_number`, `seat_type`, `price_multiplier`) VALUES
-- 第1排（普通座位）
(1, 1, 1, 'normal', 1.00), (1, 1, 2, 'normal', 1.00), (1, 1, 3, 'normal', 1.00), (1, 1, 4, 'normal', 1.00),
(1, 1, 5, 'normal', 1.00), (1, 1, 6, 'normal', 1.00), (1, 1, 7, 'normal', 1.00), (1, 1, 8, 'normal', 1.00),
-- 第2排（普通座位）
(1, 2, 1, 'normal', 1.00), (1, 2, 2, 'normal', 1.00), (1, 2, 3, 'normal', 1.00), (1, 2, 4, 'normal', 1.00),
(1, 2, 5, 'normal', 1.00), (1, 2, 6, 'normal', 1.00), (1, 2, 7, 'normal', 1.00), (1, 2, 8, 'normal', 1.00),
-- 第3排（情侣座）
(1, 3, 1, 'couple', 1.20), (1, 3, 2, 'couple', 1.20), (1, 3, 3, 'couple', 1.20), (1, 3, 4, 'couple', 1.20),
(1, 3, 5, 'couple', 1.20), (1, 3, 6, 'couple', 1.20), (1, 3, 7, 'couple', 1.20), (1, 3, 8, 'couple', 1.20);

-- =====================================================
-- 14. 系统配置表 (system_config)
-- =====================================================
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) NOT NULL,
  `config_value` text NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入系统配置数据
INSERT INTO `system_config` (`config_key`, `config_value`, `description`) VALUES
('site_name', 'PopcornMovie电影订票系统', '网站名称'),
('site_description', '专业的在线电影订票平台', '网站描述'),
('contact_email', 'support@popcornmovie.com', '客服邮箱'),
('contact_phone', '400-123-4567', '客服电话'),
('order_timeout_minutes', '15', '订单超时时间（分钟）'),
('max_seats_per_order', '6', '每单最大座位数'),
('min_order_amount', '20.00', '最小订单金额'),
('refund_deadline_hours', '24', '退票截止时间（小时）');

-- =====================================================
-- 15. 操作日志表 (operation_log)
-- =====================================================
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `operation` varchar(100) NOT NULL,
  `target_type` varchar(50) DEFAULT NULL,
  `target_id` bigint(20) DEFAULT NULL,
  `details` text,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_operation` (`operation`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试操作日志数据
INSERT INTO `operation_log` (`user_id`, `operation`, `target_type`, `target_id`, `details`, `ip_address`) VALUES
(1, 'login', 'user', 1, '用户登录成功', '192.168.1.100'),
(1, 'create_order', 'order', 1, '创建订单成功', '192.168.1.100'),
(2, 'login', 'user', 2, '用户登录成功', '192.168.1.101'),
(2, 'add_favorite', 'movie', 2, '添加收藏成功', '192.168.1.101'),
(3, 'login', 'user', 3, '用户登录成功', '192.168.1.102'),
(3, 'write_review', 'movie', 4, '发表评论成功', '192.168.1.102');

-- =====================================================
-- 16. 消息通知表 (notification)
-- =====================================================
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试通知数据
INSERT INTO `notification` (`user_id`, `type`, `title`, `content`, `is_read`) VALUES
(1, 'order', '订单确认', '您的订单已确认，请在15分钟内完成支付', 0),
(1, 'payment', '支付成功', '您的订单支付成功，祝您观影愉快！', 1),
(2, 'movie', '新片上映', '您关注的《沙丘2》现已上映，快来购票吧！', 0),
(2, 'coupon', '优惠券到账', '您获得了一张新用户专享券，快去使用吧！', 0),
(3, 'system', '系统维护', '系统将于今晚22:00-24:00进行维护，请提前安排观影时间', 1);

-- =====================================================
-- 17. 数据统计表 (statistics)
-- =====================================================
DROP TABLE IF EXISTS `statistics`;
CREATE TABLE `statistics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `stat_date` date NOT NULL,
  `stat_type` varchar(50) NOT NULL,
  `stat_value` bigint(20) NOT NULL DEFAULT 0,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_date_type` (`stat_date`, `stat_type`),
  KEY `idx_stat_date` (`stat_date`),
  KEY `idx_stat_type` (`stat_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入测试统计数据
INSERT INTO `statistics` (`stat_date`, `stat_type`, `stat_value`) VALUES
('2025-08-15', 'total_orders', 156),
('2025-08-15', 'total_revenue', 12580),
('2025-08-15', 'total_users', 89),
('2025-08-16', 'total_orders', 142),
('2025-08-16', 'total_revenue', 11890),
('2025-08-16', 'total_users', 67);

-- =====================================================
-- 18. 创建索引和约束
-- =====================================================

-- 为show表添加外键约束
ALTER TABLE `show` ADD CONSTRAINT `fk_show_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE CASCADE;

-- 为user_order表添加外键约束
ALTER TABLE `user_order` ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_order` ADD CONSTRAINT `fk_order_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_order` ADD CONSTRAINT `fk_order_show` FOREIGN KEY (`show_id`) REFERENCES `show` (`id`) ON DELETE CASCADE;

-- 为favorite表添加外键约束
ALTER TABLE `favorite` ADD CONSTRAINT `fk_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
ALTER TABLE `favorite` ADD CONSTRAINT `fk_favorite_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE CASCADE;

-- 为review表添加外键约束
ALTER TABLE `review` ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
ALTER TABLE `review` ADD CONSTRAINT `fk_review_movie` FOREIGN KEY (`movie_id`) REFERENCES `movie` (`id`) ON DELETE CASCADE;

-- 为payment表添加外键约束
ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_id`) REFERENCES `user_order` (`id`) ON DELETE CASCADE;

-- 为user_coupon表添加外键约束
ALTER TABLE `user_coupon` ADD CONSTRAINT `fk_user_coupon_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
ALTER TABLE `user_coupon` ADD CONSTRAINT `fk_user_coupon_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`id`) ON DELETE CASCADE;

-- 为hall表添加外键约束
ALTER TABLE `hall` ADD CONSTRAINT `fk_hall_theater` FOREIGN KEY (`theater_id`) REFERENCES `theater` (`id`) ON DELETE CASCADE;

-- 为seat表添加外键约束
ALTER TABLE `seat` ADD CONSTRAINT `fk_seat_hall` FOREIGN KEY (`hall_id`) REFERENCES `hall` (`id`) ON DELETE CASCADE;

-- =====================================================
-- 19. 创建视图
-- =====================================================

-- 电影统计视图
CREATE OR REPLACE VIEW `movie_statistics` AS
SELECT 
    m.id,
    m.name,
    m.rating_score,
    m.rating_count,
    COUNT(DISTINCT s.id) as show_count,
    COUNT(DISTINCT uo.id) as order_count,
    COUNT(DISTINCT f.user_id) as favorite_count,
    AVG(r.rating) as avg_user_rating,
    COUNT(r.id) as review_count
FROM movie m
LEFT JOIN `show` s ON m.id = s.movie_id
LEFT JOIN user_order uo ON m.id = uo.movie_id
LEFT JOIN favorite f ON m.id = f.movie_id
LEFT JOIN review r ON m.id = r.movie_id
GROUP BY m.id, m.name, m.rating_score, m.rating_count;

-- 用户订单统计视图
CREATE OR REPLACE VIEW `user_order_statistics` AS
SELECT 
    u.id as user_id,
    u.username,
    u.email,
    COUNT(uo.id) as total_orders,
    SUM(uo.total_price) as total_spent,
    AVG(uo.total_price) as avg_order_amount,
    MAX(uo.order_time) as last_order_time
FROM user u
LEFT JOIN user_order uo ON u.id = uo.user_id
GROUP BY u.id, u.username, u.email;

-- 影院场次统计视图
CREATE OR REPLACE VIEW `theater_show_statistics` AS
SELECT 
    t.id as theater_id,
    t.code,
    t.name,
    COUNT(s.id) as total_shows,
    COUNT(DISTINCT s.movie_id) as movie_count,
    AVG(s.price) as avg_price,
    MIN(s.price) as min_price,
    MAX(s.price) as max_price
FROM theater t
LEFT JOIN `show` s ON t.code = s.theater_name
GROUP BY t.id, t.code, t.name;

-- =====================================================
-- 20. 创建存储过程
-- =====================================================

-- 获取电影场次信息的存储过程
DELIMITER //
CREATE PROCEDURE `GetMovieShows`(IN movie_id_param BIGINT)
BEGIN
    SELECT 
        s.id,
        s.theater_name,
        t.name as theater_display_name,
        s.time,
        s.price,
        s.seat_map,
        m.name as movie_name,
        m.poster_path
    FROM `show` s
    JOIN movie m ON s.movie_id = m.id
    LEFT JOIN theater t ON s.theater_name = t.code
    WHERE s.movie_id = movie_id_param
    ORDER BY s.time;
END //
DELIMITER ;

-- 创建订单的存储过程
DELIMITER //
CREATE PROCEDURE `CreateOrder`(
    IN user_id_param BIGINT,
    IN movie_id_param BIGINT,
    IN show_id_param BIGINT,
    IN seats_param TEXT,
    IN total_price_param DECIMAL(10,2),
    OUT order_id_param BIGINT
)
BEGIN
    DECLARE movie_name_val VARCHAR(255);
    DECLARE movie_poster_val VARCHAR(255);
    DECLARE cinema_name_val VARCHAR(255);
    DECLARE show_time_val VARCHAR(255);
    
    -- 获取电影信息
    SELECT name, poster_path INTO movie_name_val, movie_poster_val
    FROM movie WHERE id = movie_id_param;
    
    -- 获取场次信息
    SELECT time INTO show_time_val
    FROM `show` WHERE id = show_id_param;
    
    -- 获取影院显示名称
    SELECT 
        CASE theater_name
            WHEN 'UKnow' THEN 'UKnow影院'
            WHEN 'BigFeel' THEN 'BigFeel影院'
            WHEN 'EyeBrand' THEN '万达影城'
            WHEN 'Happy' THEN '金逸影城'
            WHEN 'ABC' THEN 'CGV影城'
            ELSE CONCAT(theater_name, '影院')
        END INTO cinema_name_val
    FROM `show` WHERE id = show_id_param;
    
    -- 创建订单
    INSERT INTO user_order (user_id, movie_id, show_id, movie_name, movie_poster, cinema_name, show_time, total_price, seats)
    VALUES (user_id_param, movie_id_param, show_id_param, movie_name_val, movie_poster_val, cinema_name_val, show_time_val, total_price_param, seats_param);
    
    -- 返回订单ID
    SET order_id_param = LAST_INSERT_ID();
END //
DELIMITER ;

-- =====================================================
-- 21. 创建触发器
-- =====================================================

-- 订单创建后自动创建支付记录
DELIMITER //
CREATE TRIGGER `tr_order_after_insert` 
AFTER INSERT ON `user_order`
FOR EACH ROW
BEGIN
    INSERT INTO payment (order_id, payment_method, amount, status)
    VALUES (NEW.id, 'pending', NEW.total_price, 'pending');
END //
DELIMITER ;

-- 支付成功后更新订单状态
DELIMITER //
CREATE TRIGGER `tr_payment_after_update`
AFTER UPDATE ON `payment`
FOR EACH ROW
BEGIN
    IF NEW.status = 'completed' AND OLD.status != 'completed' THEN
        UPDATE user_order SET status = 'paid' WHERE id = NEW.order_id;
    END IF;
END //
DELIMITER ;

-- 用户注册后自动发送欢迎通知
DELIMITER //
CREATE TRIGGER `tr_user_after_insert`
AFTER INSERT ON `user`
FOR EACH ROW
BEGIN
    INSERT INTO notification (user_id, type, title, content)
    VALUES (NEW.id, 'welcome', '欢迎加入PopcornMovie', '感谢您注册PopcornMovie电影订票系统，祝您观影愉快！');
END //
DELIMITER ;

-- =====================================================
-- 22. 恢复外键检查
-- =====================================================
SET FOREIGN_KEY_CHECKS=1;

-- =====================================================
-- 脚本执行完成
-- =====================================================