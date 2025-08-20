# PopcornMovie 数据库初始化指南

## 📋 概述

`PopcornMovie.sql` 是 PopcornMovie 电影订票系统的完整数据库初始化脚本，包含所有表结构、初始数据和高级功能。

## 🗄️ 数据库信息

- **数据库名**: `popcornmovie`
- **字符集**: `utf8`
- **排序规则**: `utf8_general_ci`

## 🚀 快速开始

### 方法一：使用命令行（推荐）

```bash
# 1. 登录MySQL
mysql -u root -p

# 2. 执行SQL脚本
source /path/to/PopcornMovie.sql;
```

### 方法二：使用MySQL Workbench

1. 打开 MySQL Workbench
2. 连接到您的MySQL服务器
3. 打开 `PopcornMovie.sql` 文件
4. 点击执行按钮

### 方法三：使用命令行直接执行

```bash
mysql -u root -p < PopcornMovie.sql
```

## 📊 包含的数据

### 电影数据 (10部)
- 黑客帝国
- 霍比特人：意外之旅
- 指环王：护戒使者
- 加勒比海盗：黑珍珠号诅咒
- 罗小黑战记2
- 星际穿越
- 南京照相馆
- 寻梦环游记
- 沙丘2
- 你想活出怎样的人生

### 场次数据 (70+个场次)
- 每个电影包含多个场次
- 不同影院和时间段
- 包含座位图信息

### 用户数据
- 测试用户账户
- 示例订单数据
- 收藏和评论数据

## ⚠️ 注意事项

1. **备份现有数据**: 如果数据库中已有数据，请先备份
2. **权限要求**: 确保MySQL用户有创建数据库和表的权限
3. **字符编码**: 脚本使用UTF-8编码，确保MySQL支持中文
4. **座位数据**: 目前只包含部分场次的座位数据，其他场次需要手动添加

## 🔧 配置要求

### MySQL版本
- MySQL 5.7+ 或 MySQL 8.0+

### 字符集设置
```sql
-- 确保MySQL支持UTF-8
SET NAMES utf8;
SET CHARACTER SET utf8;
```

## 📝 测试账户

脚本中包含以下测试账户：

| 用户名 | 邮箱 | 密码 |
|--------|------|------|
| admin | admin@popcornmovie.com | admin123 |
| user1 | user1@example.com | password123 |
| user2 | user2@example.com | password123 |
| user3 | user3@example.com | password123 |

## 🎯 验证安装

执行以下SQL验证数据库是否正确初始化：

```sql
USE popcornmovie;

-- 检查表数量
SHOW TABLES;

-- 检查电影数据
SELECT COUNT(*) as movie_count FROM movie;

-- 检查场次数据
SELECT COUNT(*) as show_count FROM `show`;

-- 检查用户数据
SELECT COUNT(*) as user_count FROM user;
```

## 🆘 常见问题

### Q: 执行时出现字符编码错误
A: 确保MySQL配置支持UTF-8，执行前运行：
```sql
SET NAMES utf8;
```

### Q: 外键约束错误
A: 脚本已设置 `SET FOREIGN_KEY_CHECKS=0;`，应该不会有此问题

### Q: 座位数据不完整
A: 目前只包含部分场次的座位数据，其他场次需要根据seat_map手动创建座位

## 📞 技术支持

如果遇到问题，请检查：
1. MySQL版本是否兼容
2. 字符集设置是否正确
3. 用户权限是否足够
4. 数据库连接是否正常

---

**版本**: v2.0  
**更新日期**: 2025-08-20  
**作者**: PopcornMovie Team
