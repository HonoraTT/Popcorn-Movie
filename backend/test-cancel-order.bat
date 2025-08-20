@echo off
echo 测试取消订单功能...

REM 请根据您的数据库配置修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=movietime
set DB_USER=root
set DB_PASSWORD=123456

echo.
echo 测试前检查订单状态...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, movie_name, cinema_name, status FROM user_order WHERE user_id = 2;"

echo.
echo 模拟取消订单ID为7的订单...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "UPDATE user_order SET status = '已取消' WHERE id = 7;"

echo.
echo 测试后检查订单状态...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, movie_name, cinema_name, status FROM user_order WHERE user_id = 2;"

echo.
echo 测试完成！
pause
