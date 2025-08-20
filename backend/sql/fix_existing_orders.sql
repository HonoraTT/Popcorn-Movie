-- 修复现有订单的影院名称
-- 根据show_id关联show表获取真实的影院名称

UPDATE user_order uo 
JOIN `show` s ON uo.show_id = s.id 
SET uo.cinema_name = 
  CASE s.theater_name
    WHEN 'UKnow' THEN 'UKnow影院'
    WHEN 'BigFeel' THEN 'BigFeel影院'
    WHEN 'EyeBrand' THEN '万达影城'
    WHEN 'Happy' THEN '金逸影城'
    WHEN 'ABC' THEN 'CGV影城'
    ELSE CONCAT(s.theater_name, '影院')
  END
WHERE uo.cinema_name = 'PopcornMovie影院';

-- 查看修復結果
SELECT 
  uo.id,
  uo.movie_name,
  uo.cinema_name,
  uo.show_time,
  uo.status,
  s.theater_name as original_theater_name
FROM user_order uo
LEFT JOIN `show` s ON uo.show_id = s.id
WHERE uo.user_id = 2
ORDER BY uo.id DESC;
