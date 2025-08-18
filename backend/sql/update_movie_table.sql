-- 更新movie表结构，添加新字段
ALTER TABLE movie ADD COLUMN rating_score DECIMAL(3,1) DEFAULT NULL;
ALTER TABLE movie ADD COLUMN rating_count INT DEFAULT NULL;
ALTER TABLE movie ADD COLUMN box_office VARCHAR(100) DEFAULT NULL;
ALTER TABLE movie ADD COLUMN synopsis TEXT DEFAULT NULL;
ALTER TABLE movie ADD COLUMN awards TEXT DEFAULT NULL;

-- 更新现有电影数据
UPDATE movie SET 
    rating_score = 9.8,
    rating_count = 125430,
    box_office = '4.63亿',
    synopsis = '在未来的世界里，人类被机器统治，生活在一个虚拟的矩阵中。尼奥（基努·里维斯饰）发现自己可能是救世主，能够拯救人类。',
    awards = '奥斯卡最佳视觉效果奖、最佳音效剪辑奖'
WHERE name = 'The Matrix';

UPDATE movie SET 
    rating_score = 8.9,
    rating_count = 98765,
    box_office = '3.21亿',
    synopsis = '比尔博·巴金斯（马丁·弗里曼饰）被巫师甘道夫选中，加入矮人队伍前往孤山，夺回被恶龙史矛革占据的矮人王国。',
    awards = '奥斯卡最佳视觉效果奖提名'
WHERE name = 'The Hobbit';

UPDATE movie SET 
    rating_score = 9.2,
    rating_count = 156789,
    box_office = '5.12亿',
    synopsis = '佛罗多·巴金斯（伊利亚·伍德饰）继承了魔戒，必须前往魔多销毁它，拯救中土世界免于黑暗势力的统治。',
    awards = '奥斯卡最佳影片奖、最佳导演奖、最佳改编剧本奖'
WHERE name = 'Lord of the rings';

UPDATE movie SET 
    rating_score = 8.7,
    rating_count = 87654,
    box_office = '2.89亿',
    synopsis = '杰克·斯派洛船长（约翰尼·德普饰）与威尔·特纳（奥兰多·布鲁姆饰）和伊丽莎白·斯旺（凯拉·奈特莉饰）一起寻找被诅咒的阿兹特克金币。',
    awards = '奥斯卡最佳男主角提名'
WHERE name = 'Pirates of the Caribbean';

UPDATE movie SET 
    rating_score = 8.5,
    rating_count = 65432,
    box_office = '1.56亿',
    synopsis = '讲述了中国历史上著名的赤壁之战，曹操率领大军南下，刘备和孙权联合抗曹，最终在赤壁取得胜利。',
    awards = '金鸡奖最佳影片提名'
WHERE name = 'Chibi';

UPDATE movie SET 
    rating_score = 8.3,
    rating_count = 54321,
    box_office = '1.23亿',
    synopsis = '艾格西（塔伦·埃格顿饰）被招募加入秘密特工组织Kingsman，接受训练成为超级特工，阻止邪恶势力的阴谋。',
    awards = '英国电影学院奖最佳英国电影提名'
WHERE name = 'Kingsman';

UPDATE movie SET 
    rating_score = 7.8,
    rating_count = 43210,
    box_office = '0.89亿',
    synopsis = '特洛伊（扎克·埃夫隆饰）和加布里埃拉（瓦妮莎·哈金斯饰）在高中相遇，通过音乐剧发现了彼此的才华和爱情。',
    awards = '青少年选择奖最佳音乐电影'
WHERE name = 'High School Musical';

UPDATE movie SET 
    rating_score = 9.1,
    rating_count = 76543,
    box_office = '2.34亿',
    synopsis = '工藤新一（柯南）被神秘组织变小，以小学生身份继续破案，与毛利兰和小五郎一起解决各种悬疑案件。',
    awards = '日本电影学院奖最佳动画电影'
WHERE name = 'Conan';

UPDATE movie SET 
    rating_score = 8.6,
    rating_count = 34567,
    box_office = '1.78亿',
    synopsis = '李小龙饰演的武术大师在游戏中与各种对手较量，展现了中国功夫的精髓和武术哲学。',
    awards = '香港电影金像奖最佳动作设计'
WHERE name = 'Dead Game';

UPDATE movie SET 
    rating_score = 8.4,
    rating_count = 56789,
    box_office = '1.45亿',
    synopsis = '哆啦A梦从22世纪来到大雄身边，用各种神奇道具帮助大雄解决生活中的困难，成为他最好的朋友。',
    awards = '日本电影学院奖最佳动画电影提名'
WHERE name = 'Doraemon';
