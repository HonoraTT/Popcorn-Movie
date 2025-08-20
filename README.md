# MovieTime 电影订票系统

## 项目概述

MovieTime 是一个基于 Spring Boot + Vue.js 的电影订票系统，提供电影浏览、选座购票、订单管理等功能。

## 主要功能

### 用户功能
- **用户注册/登录** - 支持邮箱注册和登录
- **电影浏览** - 查看电影列表、详情、评分等信息
- **选座购票** - 选择电影场次、座位，完成购票
- **订单管理** - 查看订单历史、订单详情
- **想看片单** - 收藏感兴趣的电影

### 订单详情功能（新增）
- **真实影院名称** - 订单中显示真实的影院名称，而不是硬编码的默认名称
- **订单详情页面** - 点击订单可查看完整的订单信息
- **订单状态管理** - 支持查看订单状态（已预订、已支付、已完成、已取消）
- **操作功能** - 支持支付、取消订单、申请退票等操作

## 技术架构

### 后端技术栈
- **Spring Boot 2.7.0** - 主框架
- **MyBatis** - ORM框架
- **MySQL** - 数据库
- **Maven** - 依赖管理

### 前端技术栈
- **Vue 3** - 前端框架
- **Vue Router** - 路由管理
- **Vuex** - 状态管理
- **Element Plus** - UI组件库
- **Vite** - 构建工具

## 数据库设计

### 核心表结构

#### 1. 电影表 (movie)
```sql
CREATE TABLE `movie` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,           -- 电影名称
  `poster_path` varchar(255) DEFAULT NULL,    -- 海报路径
  `banner_path` varchar(255) DEFAULT NULL,    -- 横幅路径
  `release_date` varchar(255) DEFAULT NULL,   -- 上映日期
  `duration` varchar(255) DEFAULT NULL,       -- 时长
  `director` varchar(255) DEFAULT NULL,       -- 导演
  `language` varchar(255) DEFAULT NULL,       -- 语言
  `genre` varchar(255) DEFAULT NULL,          -- 类型
  `cast_and_crew` varchar(255) DEFAULT NULL,  -- 演员阵容
  `rating_score` decimal(3,1) DEFAULT NULL,   -- 评分
  `rating_count` int(11) DEFAULT NULL,        -- 评分人数
  `box_office` varchar(100) DEFAULT NULL,     -- 票房
  `synopsis` text,                            -- 剧情简介
  `awards` text,                              -- 获奖情况
  PRIMARY KEY (`id`)
);
```

#### 2. 场次表 (show)
```sql
CREATE TABLE `show` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `theater_name` varchar(255) DEFAULT NULL,   -- 影院名称
  `time` varchar(255) DEFAULT NULL,           -- 放映时间
  `price` int(11) DEFAULT NULL,               -- 票价
  `movie_id` bigint(20) DEFAULT NULL,         -- 电影ID
  `seat_map` varchar(255) DEFAULT NULL,       -- 座位图（字符串表示）
  PRIMARY KEY (`id`)
);
```

#### 3. 用户订单表 (user_order)
```sql
CREATE TABLE `user_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,              -- 用户ID
  `movie_id` bigint(20) NOT NULL,             -- 电影ID
  `show_id` bigint(20) NOT NULL,              -- 场次ID
  `movie_name` varchar(255) NOT NULL,         -- 电影名称
  `movie_poster` varchar(255) DEFAULT NULL,   -- 电影海报
  `cinema_name` varchar(255) NOT NULL,        -- 影院名称
  `show_time` varchar(255) NOT NULL,          -- 放映时间
  `status` varchar(50) NOT NULL,              -- 订单状态
  `order_time` datetime NOT NULL,             -- 订单时间
  `total_price` decimal(10,2) NOT NULL,       -- 总价格
  `seats` text,                               -- 座位信息（JSON格式）
  PRIMARY KEY (`id`)
);
```

## 安装和运行

### 环境要求
- JDK 8+
- Node.js 16+
- MySQL 5.7+

### 后端启动
1. 配置数据库连接
```yaml
# application.yml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/movietime?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai
    username: root
    password: 123456
```

2. 执行SQL脚本

#### 方法一：使用快速设置脚本（推荐）
```bash
# Windows用户
./setup_database.bat

# 或手动执行
./import_database.bat
```

#### 方法二：手动执行SQL脚本
```bash
# 创建数据库和表
mysql -u root -p < backend/sql/movietime.sql

# 如果存在完整数据库导出文件，也可以使用
mysql -u root -p < backend/sql/movietime_complete.sql
```

3. 启动后端服务
```bash
cd backend
mvn spring-boot:run
```

### 前端启动
1. 安装依赖
```bash
cd frontend
npm install
```

2. 启动开发服务器
```bash
npm run dev
```

## API 接口

### 订单相关接口

#### 获取用户订单列表
```
GET /api/users/{userId}/orders
```

#### 获取订单详情
```
GET /api/orders/{orderId}
```

#### 创建订单
```
POST /api/seats/book
```

## 功能特色

### 1. 真实影院名称显示
- 系统会根据场次数据中的 `theater_name` 字段自动转换为对应的影院显示名称
- 支持的影院：
  - UKnow → UKnow影院
  - BigFeel → BigFeel影院
  - EyeBrand → 万达影城
  - Happy → 金逸影城
  - ABC → CGV影城

### 2. 订单详情页面
- 完整的订单信息展示
- 电影海报、影院信息、场次时间、座位信息
- 订单状态管理
- 支持支付、取消、退票等操作

### 3. 用户体验优化
- 响应式设计，支持移动端
- 加载状态提示
- 错误处理和用户友好提示
- 直观的订单状态显示

## 开发说明

### 代码结构
```
MovieTime-master/
├── backend/                 # 后端代码
│   ├── src/main/java/
│   │   └── com/movietime/
│   │       ├── controller/  # 控制器
│   │       ├── service/     # 服务层
│   │       ├── dao/         # 数据访问层
│   │       └── entity/      # 实体类
│   └── sql/                 # SQL脚本
├── frontend/                # 前端代码
│   ├── src/
│   │   ├── views/           # 页面组件
│   │   ├── components/      # 通用组件
│   │   ├── api/             # API接口
│   │   └── router/          # 路由配置
│   └── public/              # 静态资源
└── README.md               # 项目说明
```

### 新增功能说明

#### 1. 影院名称转换
在 `SelectSeatPageController` 和 `SeatApiController` 中添加了 `getCinemaDisplayName` 方法，用于将数据库中的影院代码转换为用户友好的显示名称。

#### 2. 订单详情页面
创建了 `OrderDetail.vue` 组件，提供完整的订单详情展示功能。

#### 3. API接口扩展
- 新增了获取订单详情的API接口
- 完善了错误处理和日志记录

## 注意事项

1. **数据库配置**：确保MySQL服务正在运行，并且数据库连接配置正确
2. **端口配置**：后端默认运行在8080端口，前端默认运行在3000端口
3. **跨域配置**：后端已配置CORS，支持前端跨域请求
4. **文件路径**：确保静态资源文件路径正确，特别是电影海报图片

## 更新日志

### v1.1.0 (2024-01-20)
- ✅ 修复订单中影院名称显示问题
- ✅ 新增订单详情页面功能
- ✅ 完善订单管理功能
- ✅ 优化用户体验

### v1.0.0 (2024-01-15)
- ✅ 基础电影浏览功能
- ✅ 用户注册登录
- ✅ 选座购票功能
- ✅ 订单管理基础功能

## 贡献指南

欢迎提交Issue和Pull Request来改进这个项目。

## 许可证

MIT License
