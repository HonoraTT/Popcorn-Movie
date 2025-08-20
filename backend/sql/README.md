# PopcornMovie 数据库文件说明

## 文件结构

### 主要文件
- **`PopcornMovie.sql`** - 完整的数据库初始化脚本
  - 包含所有表结构（movie, show, user_order等）
  - 包含所有初始数据
  - 包含存储过程和触发器
  - 支持一键创建完整数据库

### 导出文件（运行脚本后生成）
- **`popcornmovie_complete.sql`** - 完整数据库导出（结构+数据）
- **`popcornmovie_structure.sql`** - 仅数据库结构
- **`popcornmovie_data.sql`** - 仅数据

## 使用方法

### 1. 新环境初始化
```bash
# 使用快速设置脚本
./setup_database.bat

# 或手动执行
mysql -u root -p < backend/sql/PopcornMovie.sql
```

### 2. 数据库同步
```bash
# 导出当前数据库
./export_database.bat

# 导入最新数据库
./import_database.bat
```

## 表结构说明

### movie 表
- 电影基本信息
- 包含海报、评分、票房等字段

### show 表
- 电影场次信息
- 包含影院、时间、价格、座位图

### user_order 表
- 用户订单信息
- 包含订单状态、座位信息等

## 注意事项

1. **字符编码**：所有文件使用UTF-8编码
2. **外键约束**：导入时会自动处理外键约束
3. **数据完整性**：脚本包含完整的数据验证
4. **版本控制**：建议将 `popcornmovie_complete.sql` 提交到Git

## 历史记录

- **v2.1** (2024-01-20) - 更新项目名称为PopcornMovie，统一命名规范
- **v2.0** (2024-01-20) - 整合所有SQL文件，创建统一初始化脚本
- **v1.0** (2024-01-15) - 初始版本，分散的SQL文件
