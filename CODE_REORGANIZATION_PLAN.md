# 代码重新组织方案

## 📁 项目结构规划

```
MovieTime-master/
├── backend/                    # 后端项目
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/
│   │   │   │   └── com/movietime/
│   │   │   │       ├── controller/
│   │   │   │       │   ├── HomePageController.java     # 保留原控制器
│   │   │   │       │   ├── LoginPageController.java
│   │   │   │       │   ├── RegisterPageController.java
│   │   │   │       │   ├── SelectSeatPageController.java
│   │   │   │       │   ├── SelectShowPageController.java
│   │   │   │       │   ├── PaymentPageController.java
│   │   │   │       │   └── api/                        # 新增API控制器
│   │   │   │       │       ├── MovieApiController.java
│   │   │   │       │       ├── AuthApiController.java
│   │   │   │       │       ├── ShowApiController.java
│   │   │   │       │       ├── SeatApiController.java
│   │   │   │       │       └── PaymentApiController.java
│   │   │   │       ├── service/                        # 保持不变
│   │   │   │       ├── dao/                            # 保持不变
│   │   │   │       ├── entity/                         # 保持不变
│   │   │   │       ├── vo/                             # 保持不变
│   │   │   │       └── util/                           # 保持不变
│   │   │   └── resources/
│   │   │       ├── mapper/                             # MyBatis映射文件
│   │   │       ├── jdbc.properties                     # 数据库配置
│   │   │       ├── spring-dao.xml                      # Spring配置
│   │   │       ├── spring-web.xml                      # Spring配置
│   │   │       ├── mybatis-config.xml                  # MyBatis配置
│   │   │       └── ehcache-config.xml                  # 缓存配置
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── web.xml                             # Web配置
│   ├── sql/
│   │   └── movietime.sql                               # 数据库脚本
│   ├── pom.xml                                         # Maven配置
│   └── README.md                                       # 后端说明
├── frontend/                    # 前端项目（您已创建）
│   ├── src/
│   │   ├── components/                                 # Vue组件
│   │   ├── views/                                      # 页面组件
│   │   ├── router/                                     # 路由配置
│   │   ├── store/                                      # 状态管理
│   │   ├── api/                                        # API调用
│   │   ├── utils/                                      # 工具函数
│   │   ├── App.vue                                     # 主应用
│   │   └── main.js                                     # 入口文件
│   ├── public/
│   ├── package.json                                     # 前端依赖
│   └── README.md                                       # 前端说明
├── shared/                      # 共享资源
│   ├── images/                                          # 图片资源
│   └── docs/                                            # 文档
└── README.md                     # 项目总说明
```

## 🔄 迁移步骤

### 第一步：后端代码迁移

1. **复制Java源代码**
```bash
# 复制Java源代码到backend
cp -r src/main/java backend/src/main/java/

# 复制资源文件
cp -r src/main/resources backend/src/main/resources/

# 复制Web配置
cp -r src/main/webapp backend/src/main/webapp/

# 复制SQL脚本
cp -r sql backend/

# 复制Maven配置
cp pom.xml backend/
```

2. **创建新的API控制器**
在 `backend/src/main/java/com/movietime/controller/api/` 下创建REST API控制器

3. **修改Spring配置**
- 添加跨域支持
- 移除Thymeleaf相关配置
- 保留MyBatis和数据库配置

### 第二步：前端代码开发

1. **安装依赖**
```bash
cd frontend
npm install axios element-plus vuex@next
```

2. **创建API调用模块**
- `src/api/movie.js` - 电影相关API
- `src/api/auth.js` - 用户认证API
- `src/api/booking.js` - 预订相关API

3. **创建Vue组件**
- `src/views/Home.vue` - 首页
- `src/views/Login.vue` - 登录页
- `src/views/Register.vue` - 注册页
- `src/components/SeatMap.vue` - 座位选择组件

### 第三步：共享资源处理

1. **图片资源**
- 将 `src/main/webapp/WEB-INF/templates/images/` 移动到 `shared/images/`
- 前端通过HTTP请求访问图片

2. **静态资源**
- CSS和JS文件可以保留在后端，通过API提供
- 或者移动到前端项目中

## 📋 具体操作命令

### 1. 创建目录结构
```bash
# 创建后端目录结构
mkdir -p backend/src/main/java/com/movietime/controller/api
mkdir -p backend/src/main/resources/mapper
mkdir -p backend/src/main/webapp/WEB-INF

# 创建前端目录结构
mkdir -p frontend/src/api
mkdir -p frontend/src/components
mkdir -p frontend/src/views
mkdir -p frontend/src/utils

# 创建共享目录
mkdir -p shared/images
mkdir -p shared/docs
```

### 2. 复制文件
```bash
# 复制Java源代码
cp -r src/main/java/* backend/src/main/java/

# 复制资源文件
cp -r src/main/resources/* backend/src/main/resources/

# 复制Web配置
cp -r src/main/webapp/* backend/src/main/webapp/

# 复制SQL脚本
cp -r sql/* backend/sql/

# 复制Maven配置
cp pom.xml backend/

# 复制图片资源
cp -r src/main/webapp/WEB-INF/templates/images/* shared/images/
```

### 3. 修改配置文件

#### 后端配置修改
1. **修改pom.xml** - 移除Thymeleaf依赖
2. **添加跨域配置** - 在Spring配置中添加CORS
3. **创建API控制器** - 新的REST API控制器

#### 前端配置
1. **配置API地址** - 在 `src/utils/request.js` 中设置baseURL
2. **配置路由** - 在 `src/router/index.js` 中设置路由
3. **配置状态管理** - 在 `src/store/index.js` 中配置Vuex

## 🎯 实施优先级

### 高优先级（必须完成）
1. ✅ 后端代码迁移
2. ✅ 创建API控制器
3. ✅ 前端API调用模块
4. ✅ 基础页面组件

### 中优先级（重要功能）
1. 🔄 用户认证系统
2. 🔄 座位选择功能
3. 🔄 支付流程

### 低优先级（优化功能）
1. 📝 错误处理优化
2. 📝 性能优化
3. 📝 UI/UX改进

## 💡 注意事项

1. **数据库连接** - 确保后端能正常连接数据库
2. **跨域问题** - 后端必须配置CORS支持
3. **API测试** - 使用Postman测试API接口
4. **前后端联调** - 确保前端能正确调用后端API
5. **图片资源** - 确保图片路径正确

## 🚀 下一步行动

1. **立即开始** - 复制后端代码到backend文件夹
2. **创建API** - 实现REST API控制器
3. **前端开发** - 实现Vue组件和API调用
4. **测试联调** - 前后端功能测试

这样重新组织后，您的项目将具有清晰的前后端分离架构！ 