# 数据库升级指南

## 概述
本次升级为 `movie` 表添加了新的字段，用于存储电影的评分、票房、简介和获奖信息，消除了前端硬编码的问题。

## 新增字段
- `rating_score` (DECIMAL(3,1)): 电影评分
- `rating_count` (INT): 评分人数
- `box_office` (VARCHAR(100)): 票房信息
- `synopsis` (TEXT): 电影简介
- `awards` (TEXT): 获奖情况

## 升级步骤

### 方法一：使用更新脚本（推荐）
1. 连接到你的MySQL数据库
2. 执行更新脚本：
```bash
mysql -u your_username -p your_database_name < backend/sql/update_movie_table.sql
```

### 方法二：手动执行SQL
1. 连接到数据库
2. 执行以下SQL语句：

```sql
-- 添加新字段
ALTER TABLE movie ADD COLUMN rating_score DECIMAL(3,1) DEFAULT NULL;
ALTER TABLE movie ADD COLUMN rating_count INT DEFAULT NULL;
ALTER TABLE movie ADD COLUMN box_office VARCHAR(100) DEFAULT NULL;
ALTER TABLE movie ADD COLUMN synopsis TEXT DEFAULT NULL;
ALTER TABLE movie ADD COLUMN awards TEXT DEFAULT NULL;

-- 更新现有电影数据（示例）
UPDATE movie SET 
    rating_score = 9.8,
    rating_count = 125430,
    box_office = '4.63亿',
    synopsis = '在未来的世界里，人类被机器统治，生活在一个虚拟的矩阵中。尼奥（基努·里维斯饰）发现自己可能是救世主，能够拯救人类。',
    awards = '奥斯卡最佳视觉效果奖、最佳音效剪辑奖'
WHERE name = 'The Matrix';
```

### 方法三：重新创建数据库
1. 删除现有数据库
2. 使用新的 `movietime.sql` 脚本重新创建数据库

## 添加新电影

现在添加新电影变得非常简单，只需要：

1. **准备图片文件**：将电影海报放在 `frontend/public/templates/images/` 目录下
2. **插入数据库记录**：
```sql
INSERT INTO movie (
    name, poster_path, banner_path, release_date, duration, 
    director, language, genre, cast_and_crew,
    rating_score, rating_count, box_office, synopsis, awards
) VALUES (
    '电影名称', '/images/电影海报.jpg', '/images/电影横幅.jpg', 
    '2024-01-01', '2小时', '导演名', '中文', '动作', '主演阵容',
    9.5, 50000, '1.2亿', '电影简介内容', '获奖情况'
);
```

## 验证升级

升级完成后，可以通过以下方式验证：

1. **检查数据库结构**：
```sql
DESCRIBE movie;
```

2. **查看电影数据**：
```sql
SELECT name, rating_score, rating_count, box_office FROM movie LIMIT 5;
```

3. **测试前端显示**：访问电影详情页面，确认评分、票房、简介等信息正确显示

## 注意事项

1. **备份数据**：升级前请备份现有数据库
2. **图片路径**：确保图片文件名与数据库中的 `poster_path` 完全匹配
3. **字符编码**：确保数据库使用 UTF-8 编码以正确显示中文
4. **重启服务**：升级后重启后端服务以确保新字段生效

## 故障排除

### 问题1：字段已存在
如果遇到 "Duplicate column name" 错误，说明字段已存在，可以跳过 ALTER TABLE 语句。

### 问题2：中文显示乱码
确保数据库连接使用 UTF-8 编码：
```sql
SET NAMES utf8mb4;
```

### 问题3：图片不显示
检查图片文件是否存在，路径是否正确。

## 技术优势

升级后的系统具有以下优势：

1. **数据驱动**：所有电影信息都存储在数据库中，便于管理
2. **易于维护**：添加新电影只需插入数据库记录
3. **动态更新**：可以随时更新电影信息而无需修改代码
4. **扩展性强**：可以轻松添加更多电影相关字段
5. **专业规范**：符合企业级应用的数据管理标准
