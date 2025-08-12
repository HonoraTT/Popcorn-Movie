# MovieTime 项目问题诊断和解决方案

## 项目运行缓慢或无法启动的原因分析

### 1. 数据库配置问题（主要问题）

**问题描述：**
- 数据库名不匹配：配置文件中是 `movie`，SQL文件中是 `movietime`
- 密码不匹配：配置文件中是 `1233`，README中说明是 `123456`
- 驱动版本不兼容：使用了MySQL 8.0.33驱动但配置了旧版驱动类名

**解决方案：**
已修复 `src/main/resources/jdbc.properties` 文件：
```properties
jdbc.driver=com.mysql.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/movietime?useUnicode=true&characterEncoding=utf-8&useSSL=false
jdbc.username=root
jdbc.password=123456
```

### 2. 依赖版本问题

**问题描述：**
- Spring版本较老（4.3.3.RELEASE）
- MySQL驱动版本较新（8.0.33）
- 可能存在版本兼容性问题

**解决方案：**
已将MySQL驱动版本降级到5.1.38，与Spring 4.3.3兼容。

### 3. Maven环境问题

**问题描述：**
- Maven未安装或未配置到PATH环境变量
- 依赖下载失败

**解决方案：**
1. 安装Maven并配置环境变量
2. 使用国内镜像源加速依赖下载

### 4. 数据库未初始化

**问题描述：**
- 数据库未创建
- 数据表未导入

**解决方案：**
运行 `init-database.bat` 脚本初始化数据库。

## 快速启动步骤

### 步骤1：环境检查
确保已安装：
- JDK 8或更高版本
- Maven 3.6或更高版本
- MySQL 5.7或更高版本

### 步骤2：数据库初始化
```bash
# 双击运行
init-database.bat
```

### 步骤3：启动项目
```bash
# 双击运行
start.bat
```

### 步骤4：访问项目
打开浏览器访问：http://localhost:8080

## 常见错误及解决方案

### 错误1：数据库连接失败
**错误信息：** `Communications link failure`
**解决方案：**
1. 检查MySQL服务是否启动
2. 检查数据库密码是否正确（默认：123456）
3. 检查数据库名是否正确（movietime）

### 错误2：端口被占用
**错误信息：** `Address already in use`
**解决方案：**
1. 查找占用8080端口的进程：`netstat -ano | findstr 8080`
2. 结束进程：`taskkill /PID <进程ID> /F`
3. 或修改 `pom.xml` 中的端口号

### 错误3：依赖下载失败
**错误信息：** `Could not transfer artifact`
**解决方案：**
1. 检查网络连接
2. 配置Maven镜像源
3. 清理Maven缓存：`mvn clean`

### 错误4：编译失败
**错误信息：** `Compilation failure`
**解决方案：**
1. 检查JDK版本（建议使用JDK 8）
2. 清理项目：`mvn clean`
3. 重新编译：`mvn compile`

## 性能优化建议

### 1. 数据库优化
- 确保MySQL服务正常运行
- 检查数据库连接池配置
- 优化SQL查询

### 2. JVM优化
在IDEA中配置JVM参数：
```
-Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=256m
```

### 3. 缓存配置
项目已配置EhCache缓存，确保缓存配置正确。

## 项目结构说明

```
MovieTime-master/
├── src/main/java/com/movietime/
│   ├── controller/     # 控制器层
│   ├── service/        # 服务层
│   ├── dao/           # 数据访问层
│   ├── entity/        # 实体类
│   └── util/          # 工具类
├── src/main/resources/
│   ├── mapper/        # MyBatis映射文件
│   ├── *.xml          # Spring配置文件
│   └── jdbc.properties # 数据库配置
├── src/main/webapp/
│   └── WEB-INF/templates/ # 前端模板
└── sql/
    └── movietime.sql  # 数据库初始化脚本
```

## 联系支持

如果问题仍然存在，请检查：
1. 控制台错误日志
2. IDEA的Event Log
3. 数据库连接状态
4. 网络连接状态 