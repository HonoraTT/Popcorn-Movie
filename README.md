# Popcorn-Movie 电影购票系统

一个基于Spring Boot + Vue.js的前后端分离电影购票系统。

## 🎬 项目简介

PopcornMovie是一个现代化的电影购票系统，提供完整的电影浏览、场次选择、座位预订和支付功能。系统采用前后端分离架构，后端使用Spring Boot框架，前端使用Vue.js构建。

## ✨ 主要功能

### 🎭 电影管理
- 电影信息展示
- 电影分类和标签
- 电影详情页面
- 热门电影推荐

### 🎫 场次管理
- 电影场次查询
- 时间选择
- 价格显示

### 🪑 座位预订
- 可视化座位图
- 实时座位状态
- 多座位选择
- 座位冲突检测

### 💳 支付系统
- 多种支付方式
- 订单管理
- 支付状态跟踪

### 👤 用户系统
- 用户注册/登录
- 个人信息管理
- 订单历史
- 收藏功能

## 🏗️ 技术架构

### 后端技术栈
- **框架**: Spring Boot 2.x
- **数据库**: MySQL 8.0
- **ORM**: MyBatis
- **连接池**: Druid
- **缓存**: EhCache
- **构建工具**: Maven

### 前端技术栈
- **框架**: Vue 3
- **构建工具**: Vite
- **UI组件**: Element Plus
- **状态管理**: Vuex 4
- **路由**: Vue Router 4
- **HTTP客户端**: Axios

## 🚀 快速开始

### 环境要求
- JDK 8+
- Node.js 16+
- MySQL 8.0+
- Maven 3.6+

### 后端启动
```bash
cd backend
mvn spring-boot:run
```

### 前端启动
```bash
cd frontend
npm install
npm run dev
```

### 数据库配置
1. 创建数据库 `movietime`
2. 导入 `sql/movietime.sql` 文件
3. 修改 `backend/src/main/resources/application.yml` 中的数据库连接信息

## 📁 项目结构

```
MovieTime-master/
├── backend/                 # 后端项目
│   ├── src/main/java/      # Java源代码
│   ├── src/main/resources/ # 配置文件
│   └── pom.xml            # Maven配置
├── frontend/               # 前端项目
│   ├── src/               # Vue源代码
│   ├── public/            # 静态资源
│   └── package.json       # 依赖配置
├── sql/                   # 数据库脚本
└── README.md              # 项目说明
```

## 🔧 配置说明

### 后端配置
- 数据库连接配置在 `application.yml`
- MyBatis映射文件在 `mapper/` 目录
- 静态资源在 `webapp/` 目录

### 前端配置
- API接口配置在 `src/api/` 目录
- 路由配置在 `src/router/` 目录
- 状态管理在 `src/store/` 目录

## 🌟 特色功能

1. **响应式设计**: 支持PC和移动端
2. **实时更新**: 座位状态实时同步
3. **用户体验**: 直观的界面设计和交互
4. **性能优化**: 缓存机制和懒加载
5. **安全性**: 输入验证和SQL注入防护

## 📝 开发说明

### 代码规范
- 遵循阿里巴巴Java开发手册
- 使用ESLint进行前端代码规范检查
- 统一的命名规范和注释风格

### 提交规范
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式调整
- refactor: 代码重构
- test: 测试相关
- chore: 构建过程或辅助工具的变动

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

如有问题或建议，请通过以下方式联系：
- 提交 Issue
- 发送邮件
- 参与讨论

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和用户！

---

**PopcornMovie** - 让电影购票更简单！🎬✨
