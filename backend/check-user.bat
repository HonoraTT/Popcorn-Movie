@echo off
echo 正在检查用户信息...

REM 请根据您的数据库配置修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=movietime
set DB_USER=root
set DB_PASSWORD=123456

echo.
echo 检查用户表中的所有用户...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, username, email FROM user ORDER BY id;"

echo.
echo 检查最近的订单（按用户ID分组）...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT user_id, COUNT(*) as order_count, MAX(order_time) as latest_order FROM user_order GROUP BY user_id ORDER BY user_id;"

echo.
echo 检查今天创建的订单...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, user_id, movie_name, status, order_time FROM user_order WHERE DATE(order_time) = CURDATE() ORDER BY order_time DESC;"

echo.
echo 用户信息检查完成！
pause
