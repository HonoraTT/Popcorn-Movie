@echo off
echo 正在创建用户订单表...

REM 请根据您的数据库配置修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=movietime
set DB_USER=root
set DB_PASSWORD=123456

REM 执行SQL脚本
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% < sql/create_user_order_table.sql

if %ERRORLEVEL% EQU 0 (
    echo 用户订单表创建成功！
) else (
    echo 用户订单表创建失败，请检查数据库连接和配置。
)

pause
