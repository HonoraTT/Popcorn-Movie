@echo off
echo 正在修复用户表结构...

REM 请根据您的数据库配置修改以下参数
set DB_HOST=localhost
set DB_PORT=3306
set DB_NAME=movietime
set DB_USER=root
set DB_PASSWORD=123456

echo 执行修复脚本...
mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% < fix-user-table.sql

if %ERRORLEVEL% EQU 0 (
    echo 用户表修复成功！
    echo.
    echo 验证修复结果...
    mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "DESCRIBE user;"
    echo.
    mysql -h%DB_HOST% -P%DB_PORT% -u%DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT * FROM user;"
) else (
    echo 用户表修复失败，请检查数据库连接和配置。
)

pause
