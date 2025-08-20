@echo off
echo ========================================
echo PopcornMovie 数据库初始化脚本
echo ========================================
echo.

echo 正在初始化数据库...
echo.

REM 检查MySQL是否安装
mysql --version >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到MySQL，请先安装MySQL
    pause
    exit /b 1
)

echo MySQL已安装，开始初始化数据库...
echo.

REM 执行SQL脚本
echo 正在执行PopcornMovie.sql...
mysql -u root -p < PopcornMovie.sql

if errorlevel 1 (
    echo.
    echo 错误: 数据库初始化失败！
    echo 请检查：
    echo 1. MySQL服务是否启动
    echo 2. 用户名和密码是否正确
    echo 3. 是否有足够的权限
    pause
    exit /b 1
)

echo.
echo ========================================
echo 数据库初始化成功！
echo ========================================
echo.
echo 数据库信息：
echo - 数据库名: popcornmovie
echo - 字符集: utf8
echo - 包含: 10部电影，70+个场次，测试用户等
echo.
echo 测试账户：
echo - 用户名: admin, 密码: admin123
echo - 用户名: user1, 密码: password123
echo.
echo 现在可以启动应用程序了！
pause
