# 🎬 MovieTime 前后端分离改造完成

## ✅ 改造完成状态

### **后端 Spring Boot 改造**
- ✅ 更新 `pom.xml` 为 Spring Boot 依赖
- ✅ 创建 `MovieTimeApplication.java` 主启动类
- ✅ 配置 `application.yml` Spring Boot 配置
- ✅ 创建 REST API 控制器：
  - `MovieApiController.java` - 电影相关API
  - `AuthApiController.java` - 用户认证API
  - `TagApiController.java` - 标签相关API
  - `ShowApiController.java` - 场次相关API
  - `SeatApiController.java` - 座位相关API
- ✅ 配置 CORS 跨域支持
- ✅ 移动静态资源到 `src/main/resources/static/`
- ✅ 删除旧的 Spring MVC 配置文件

### **前端 Vue 3 完善**
- ✅ 创建 API 调用模块：
  - `movie.js` - 电影相关API
  - `auth.js` - 用户认证API
  - `booking.js` - 预订相关API
- ✅ 配置 Vuex 状态管理
- ✅ 配置 Vue Router 路由
- ✅ 创建页面组件：
  - `Home.vue` - 首页
  - `Login.vue` - 登录页
  - `NavBar.vue` - 导航栏
- ✅ 集成 Element Plus UI 组件库

## 🚀 如何运行项目

### **1. 启动后端服务**

```bash
# 进入后端目录
cd backend

# 编译项目
mvn clean compile

# 启动Spring Boot应用
mvn spring-boot:run
```

或者直接在IDEA中运行 `MovieTimeApplication.java` 的 `main` 方法！

### **2. 启动前端服务**

```bash
# 进入前端目录
cd frontend

# 安装依赖
npm install

# 启动开发服务器
npm run dev
```

### **3. 访问应用**

- **前端**: http://localhost:3000
- **后端API**: http://localhost:8080
- **API文档**: http://localhost:8080/api/movies

## 📋 API 接口列表

### **电影相关**
- `GET /api/movies` - 获取所有电影
- `GET /api/movies/{id}` - 获取指定电影
- `GET /api/movies/tag/{tagName}` - 根据标签获取电影
- `GET /api/movies/banners` - 获取横幅电影

### **标签相关**
- `GET /api/tags` - 获取所有标签

### **用户认证**
- `POST /api/auth/login` - 用户登录
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/logout` - 用户退出

### **场次相关**
- `GET /api/shows/movie/{movieId}` - 获取电影的场次
- `GET /api/shows/{showId}` - 获取场次详情

### **座位相关**
- `GET /api/seats/show/{showId}` - 获取座位图
- `POST /api/seats/book` - 预订座位

## 🎯 项目优势

### **后端优势**
1. **Spring Boot 自动配置** - 简化配置，快速启动
2. **内嵌 Tomcat** - 无需外部服务器
3. **热重载** - 开发时自动重启
4. **健康检查** - 内置监控端点
5. **统一配置** - YAML 配置文件

### **前端优势**
1. **Vue 3 Composition API** - 更好的代码组织
2. **Element Plus** - 丰富的UI组件
3. **Vuex 状态管理** - 集中状态管理
4. **Vue Router** - 单页应用路由
5. **Axios** - HTTP 请求库

### **前后端分离优势**
1. **独立开发** - 前后端可以并行开发
2. **技术栈灵活** - 可以独立选择技术栈
3. **部署灵活** - 可以独立部署
4. **团队协作** - 前后端团队可以独立工作
5. **扩展性好** - 可以轻松添加移动端、小程序等

## 🔧 开发指南

### **后端开发**
1. 在 `controller/api/` 下添加新的API控制器
2. 在 `service/` 下添加业务逻辑
3. 在 `mapper/` 下添加MyBatis映射文件
4. 修改 `application.yml` 进行配置

### **前端开发**
1. 在 `src/api/` 下添加新的API调用
2. 在 `src/views/` 下添加新的页面组件
3. 在 `src/components/` 下添加可复用组件
4. 在 `src/store/` 下管理状态

## 🐛 常见问题

### **1. 后端启动失败**
- 检查数据库连接配置
- 确保MySQL服务正在运行
- 检查端口8080是否被占用

### **2. 前端启动失败**
- 检查Node.js版本（建议16+）
- 删除 `node_modules` 重新安装
- 检查端口3000是否被占用

### **3. 跨域问题**
- 后端已配置CORS，支持所有来源
- 前端API地址配置为 `http://localhost:8080`

### **4. 数据库问题**
- 确保数据库 `movietime` 已创建
- 确保数据已导入（执行 `sql/movietime.sql`）

## 🎉 恭喜！

您的MovieTime项目已成功改造为前后端分离架构！

- **后端**: Spring Boot + MyBatis + MySQL
- **前端**: Vue 3 + Element Plus + Vite

现在您可以在IDEA中直接运行 `MovieTimeApplication.java` 来启动后端服务了！ 