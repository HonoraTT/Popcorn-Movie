@echo off
echo 正在修复Maven依赖问题...

REM 设置IDEA内置Maven路径
set MAVEN_HOME=D:\IDEA\IntelliJ IDEA 2024.2.1\plugins\maven\lib\maven3
set PATH=%MAVEN_HOME%\bin;%PATH%

echo 清理Maven缓存...
call mvn dependency:purge-local-repository

echo 强制重新下载依赖...
call mvn dependency:resolve -U

echo 编译项目...
call mvn compile

echo 完成！现在请在IDEA中重新加载项目。
pause 