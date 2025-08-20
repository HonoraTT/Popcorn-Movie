-- PopcornMovie 数据库验证脚本
-- 用于验证数据库是否正确初始化

USE popcornmovie;

-- 显示所有表
SELECT '=== 数据库表列表 ===' as info;
SHOW TABLES;

-- 检查电影数据
SELECT '=== 电影数据统计 ===' as info;
SELECT COUNT(*) as movie_count FROM movie;
SELECT name, director, rating_score FROM movie ORDER BY id LIMIT 5;

-- 检查场次数据
SELECT '=== 场次数据统计 ===' as info;
SELECT COUNT(*) as show_count FROM `show`;
SELECT movie_id, COUNT(*) as show_count FROM `show` GROUP BY movie_id;

-- 检查用户数据
SELECT '=== 用户数据统计 ===' as info;
SELECT COUNT(*) as user_count FROM user;
SELECT username, email FROM user;

-- 检查订单数据
SELECT '=== 订单数据统计 ===' as info;
SELECT COUNT(*) as order_count FROM user_order;
SELECT movie_name, cinema_name, total_price FROM user_order LIMIT 5;

-- 检查座位数据
SELECT '=== 座位数据统计 ===' as info;
SELECT COUNT(*) as seat_count FROM seat;
SELECT show_id, COUNT(*) as seat_count FROM seat GROUP BY show_id LIMIT 5;

-- 检查标签数据
SELECT '=== 标签数据统计 ===' as info;
SELECT COUNT(*) as tag_count FROM tag;
SELECT name FROM tag;

-- 检查收藏数据
SELECT '=== 收藏数据统计 ===' as info;
SELECT COUNT(*) as favorite_count FROM favorite;

-- 检查评论数据
SELECT '=== 评论数据统计 ===' as info;
SELECT COUNT(*) as review_count FROM review;

-- 检查支付数据
SELECT '=== 支付数据统计 ===' as info;
SELECT COUNT(*) as payment_count FROM payment;

-- 检查优惠券数据
SELECT '=== 优惠券数据统计 ===' as info;
SELECT COUNT(*) as coupon_count FROM coupon;

-- 检查影院数据
SELECT '=== 影院数据统计 ===' as info;
SELECT COUNT(*) as theater_count FROM theater;
SELECT code, name FROM theater;

-- 检查影厅数据
SELECT '=== 影厅数据统计 ===' as info;
SELECT COUNT(*) as hall_count FROM hall;

-- 检查系统配置
SELECT '=== 系统配置统计 ===' as info;
SELECT COUNT(*) as config_count FROM system_config;

-- 检查操作日志
SELECT '=== 操作日志统计 ===' as info;
SELECT COUNT(*) as log_count FROM operation_log;

-- 检查通知数据
SELECT '=== 通知数据统计 ===' as info;
SELECT COUNT(*) as notification_count FROM notification;

-- 检查统计数据
SELECT '=== 统计数据统计 ===' as info;
SELECT COUNT(*) as statistics_count FROM statistics;

-- 检查视图
SELECT '=== 数据库视图 ===' as info;
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- 检查存储过程
SELECT '=== 存储过程 ===' as info;
SHOW PROCEDURE STATUS WHERE Db = 'popcornmovie';

-- 检查触发器
SELECT '=== 触发器 ===' as info;
SHOW TRIGGERS;

-- 最终验证
SELECT '=== 数据库初始化验证完成 ===' as info;
SELECT 
    (SELECT COUNT(*) FROM movie) as movies,
    (SELECT COUNT(*) FROM `show`) as shows,
    (SELECT COUNT(*) FROM user) as users,
    (SELECT COUNT(*) FROM user_order) as orders,
    (SELECT COUNT(*) FROM seat) as seats,
    (SELECT COUNT(*) FROM tag) as tags,
    (SELECT COUNT(*) FROM favorite) as favorites,
    (SELECT COUNT(*) FROM review) as reviews
FROM dual;
