@echo off
echo 正在检查最近的订单...

REM 请根据您的数据库配置修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=movietime
set DB_USER=root
set DB_PASSWORD=123456

echo.
echo 检查所有订单（按时间倒序）...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, user_id, movie_name, status, order_time, total_price FROM user_order ORDER BY order_time DESC LIMIT 10;"

echo.
echo 检查用户ID为2的订单...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, user_id, movie_name, status, order_time, total_price FROM user_order WHERE user_id = 2 ORDER BY order_time DESC;"

echo.
echo 检查今天的订单...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, user_id, movie_name, status, order_time, total_price FROM user_order WHERE DATE(order_time) = CURDATE() ORDER BY order_time DESC;"

echo.
echo 订单检查完成！
pause
