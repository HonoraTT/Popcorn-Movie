@echo off
echo 正在下载Maven依赖...

REM 设置Maven环境变量（如果IDEA有内置Maven）
set MAVEN_HOME=D:\IDEA\IntelliJ IDEA 2024.2.1\plugins\maven\lib\maven3
set PATH=%MAVEN_HOME%\bin;%PATH%

REM 清理并下载依赖
echo 清理项目...
call mvn clean

echo 编译项目...
call mvn compile

echo 下载依赖...
call mvn dependency:resolve

echo 完成！
pause 