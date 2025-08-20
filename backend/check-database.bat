@echo off
echo 正在检查数据库状态...

REM 请根据您的数据库配置修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=movietime
set DB_USER=root
set DB_PASSWORD=123456

echo 检查数据库连接...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT 1;" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 数据库连接失败！请检查数据库是否启动。
    pause
    exit /b 1
)

echo 数据库连接成功！

echo.
echo 检查user_order表是否存在...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SHOW TABLES LIKE 'user_order';"

echo.
echo 检查user_order表结构...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "DESCRIBE user_order;"

echo.
echo 检查user_order表中的数据...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT COUNT(*) as total_orders FROM user_order;"

echo.
echo 显示最近的订单数据...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT id, user_id, movie_name, status, order_time FROM user_order ORDER BY order_time DESC LIMIT 5;"

echo.
echo 数据库检查完成！
pause
