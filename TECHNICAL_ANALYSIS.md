# MovieTime 电影售票系统技术架构分析

## 🏗️ 整体架构

这是一个基于 **Spring MVC + MyBatis** 的传统Java Web应用，采用经典的三层架构设计。

```
┌─────────────────────────────────────────────────────────────┐
│                    表现层 (Presentation Layer)                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Thymeleaf │  │   Bootstrap │  │   jQuery    │         │
│  │   模板引擎   │  │   前端框架   │  │   JavaScript │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    控制层 (Controller Layer)                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │HomePageCtrl │  │LoginPageCtrl│  │SelectSeatCtrl│         │
│  │RegisterCtrl │  │PaymentCtrl  │  │SelectShowCtrl│         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    业务层 (Service Layer)                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │MovieService │  │UserService  │  │ShowService  │         │
│  │SeatService  │  │TagService   │  │             │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    数据访问层 (DAO Layer)                     │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  MovieDao   │  │   UserDao   │  │  ShowDao    │         │
│  │  SeatDao    │  │   TagDao    │  │             │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    数据层 (Data Layer)                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │    MySQL    │  │   Druid     │  │  EhCache    │         │
│  │   数据库     │  │  连接池     │  │   缓存      │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ 核心技术栈

### 1. 后端框架
- **Spring Framework 4.3.3** - 核心框架
  - Spring Core - 依赖注入容器
  - Spring WebMVC - Web框架
  - Spring JDBC - 数据库访问
  - Spring AOP - 面向切面编程
  - Spring Context Support - 缓存支持

### 2. 数据持久化
- **MyBatis 3.4.1** - ORM框架
  - XML映射文件配置
  - 动态SQL支持
  - 结果映射
- **MySQL 8.0.33** - 关系型数据库
- **Druid 1.0.26** - 数据库连接池

### 3. 前端技术
- **Thymeleaf 3.0.2** - 服务器端模板引擎
- **Bootstrap** - 响应式CSS框架
- **jQuery 2.1.4** - JavaScript库
- **自定义CSS/JS** - 项目特定样式和交互
- **jQuery Seat Charts** - 座位选择插件
- **Nice Scroll** - 自定义滚动条插件

### 4. 安全框架
- **Apache Shiro 1.2.3** - 安全框架（已注释，未启用）

### 5. 缓存
- **EhCache 2.7.2** - 本地缓存

### 6. 服务器
- **Jetty 9.3.9** - 嵌入式Web服务器

## 📊 数据库设计

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

#### 3. 座位表 (seat)
```sql
CREATE TABLE `seat` (
  `show_id` int(11) NOT NULL,                 -- 场次ID
  `row` int(11) NOT NULL,                     -- 行号
  `col` int(11) NOT NULL,                     -- 列号
  `is_booked` tinyint(4) DEFAULT NULL,        -- 是否已预订
  PRIMARY KEY (`show_id`,`row`,`col`)
);
```

#### 4. 用户表 (user)
```sql
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,       -- 用户名
  `email` varchar(255) DEFAULT NULL,          -- 邮箱
  `password` varchar(255) DEFAULT NULL,       -- 密码（MD5加密）
  `icon_path` varchar(255) DEFAULT NULL,      -- 头像路径
  `is_admin` tinyint(1) DEFAULT NULL,         -- 是否管理员
  PRIMARY KEY (`id`)
);
```

#### 5. 标签系统 (tag, tag_movie)
```sql
-- 标签表
CREATE TABLE `tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,           -- 标签名称
  PRIMARY KEY (`id`)
);

-- 电影标签关联表
CREATE TABLE `tag_movie` (
  `tag_id` bigint(11) NOT NULL,               -- 标签ID
  `movie_id` bigint(11) NOT NULL,             -- 电影ID
  PRIMARY KEY (`tag_id`,`movie_id`)
);
```

## 🔧 核心功能模块

### 1. 用户管理模块
- **注册功能** - 用户注册，密码MD5加密
- **登录功能** - 基于Session的用户认证
- **用户信息管理** - 头像、个人信息

### 2. 电影展示模块
- **首页轮播** - 展示热门电影横幅
- **分类展示** - 按标签分类显示电影
- **电影详情** - 电影信息展示

### 3. 选座系统
- **场次选择** - 选择电影放映场次
- **座位图显示** - 可视化座位布局
- **座位预订** - 实时座位状态更新

### 4. 支付系统
- **订单生成** - 创建购票订单
- **支付处理** - 模拟支付流程
- **订单确认** - 支付成功确认

## 🎨 前端设计特点

### 1. 前端架构
- **服务器端渲染 (SSR)** - 使用Thymeleaf模板引擎
- **传统MVC模式** - 页面由服务器渲染后返回
- **模块化设计** - 每个功能模块独立的前端文件

### 2. 页面结构
```
前端页面结构：
├── homepage.html      # 首页 - 电影展示和轮播
├── login.html         # 登录页面
├── register.html      # 注册页面  
├── selectShow.html    # 场次选择页面
├── selectSeat.html    # 座位选择页面（核心功能）
└── payment.html       # 支付页面
```

### 3. 响应式设计
- 使用Bootstrap框架实现响应式布局
- 支持不同屏幕尺寸的设备
- 移动端适配良好

### 4. 交互体验
- **轮播图展示** - 首页热门电影横幅
- **标签页切换** - 不同分类电影展示
- **动态座位选择** - 可视化座位布局和选择
- **实时状态更新** - AJAX异步请求
- **表单验证** - 客户端和服务器端双重验证

### 5. 核心技术实现
- **座位选择系统** - 使用jQuery Seat Charts插件
- **AJAX通信** - 异步数据交互
- **自定义滚动条** - Nice Scroll插件
- **模态框交互** - Bootstrap模态框组件

### 6. 视觉设计
- 现代化UI设计风格
- 丰富的图片资源（电影海报、横幅等）
- 统一的色彩搭配和布局
- 专业的电影售票系统界面

## 🔄 业务流程

### 1. 用户购票流程
```
用户注册/登录 → 浏览电影 → 选择电影 → 选择场次 → 选择座位 → 支付 → 完成购票
```

### 2. 数据流转
```
Controller → Service → DAO → Database
    ↓
Thymeleaf模板 ← Model数据 ← Controller
```

## ⚡ 性能优化

### 1. 数据库优化
- 使用Druid连接池管理数据库连接
- 合理的索引设计
- 查询优化

### 2. 缓存策略
- EhCache本地缓存
- 减少数据库访问频率

### 3. 前端优化
- 静态资源压缩
- 图片优化
- 减少HTTP请求

## 🔒 安全考虑

### 1. 数据安全
- 密码MD5加密存储
- SQL注入防护（MyBatis参数化查询）
- XSS防护

### 2. 会话管理
- 基于Session的用户认证
- 会话超时处理

## 📈 项目亮点

### 1. 架构设计
- 清晰的分层架构
- 良好的代码组织
- 模块化设计

### 2. 前端技术亮点
- **座位选择系统** - 使用专业的jQuery Seat Charts插件，实现可视化座位选择
- **响应式设计** - 完美适配PC、平板、手机等不同设备
- **AJAX异步交互** - 提升用户体验，减少页面刷新
- **服务器端渲染** - 使用Thymeleaf模板引擎，SEO友好

### 3. 用户体验
- 直观的座位选择界面
- 流畅的购票流程
- 美观的界面设计
- 实时状态反馈

### 4. 技术选型
- 成熟稳定的技术栈
- 良好的扩展性
- 易于维护
- 前后端分离思想（虽然使用SSR）

## 🚀 部署架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   用户浏览器     │    │   Jetty服务器   │    │   MySQL数据库   │
│                 │◄──►│                 │◄──►│                 │
│  - Chrome       │    │  - Spring MVC   │    │  - 数据存储     │
│  - Firefox      │    │  - MyBatis      │    │  - 事务管理     │
│  - Safari       │    │  - Thymeleaf    │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📝 总结

这是一个设计良好的电影售票系统，采用了经典的Java Web开发技术栈，具有以下特点：

1. **技术成熟** - 使用经过验证的框架和工具
2. **架构清晰** - 分层明确，职责分离
3. **功能完整** - 覆盖电影售票的核心业务流程
4. **用户体验好** - 界面美观，操作流畅
5. **易于维护** - 代码结构清晰，注释完整

适合作为学习Spring MVC + MyBatis技术栈的实践项目。 