-- Create user order table
CREATE TABLE IF NOT EXISTS `user_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `movie_id` bigint(20) NOT NULL,
  `show_id` bigint(20) NOT NULL,
  `movie_name` varchar(255) NOT NULL,
  `movie_poster` varchar(255) DEFAULT NULL,
  `cinema_name` varchar(255) NOT NULL,
  `show_time` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'upcoming', -- completed, upcoming, cancelled
  `order_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `seats` text, -- JSON format for seat information
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_movie_id` (`movie_id`),
  KEY `idx_show_id` (`show_id`),
  KEY `idx_status` (`status`),
  KEY `idx_order_time` (`order_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert test order data
INSERT INTO `user_order` (`user_id`, `movie_id`, `show_id`, `movie_name`, `movie_poster`, `cinema_name`, `show_time`, `status`, `order_time`, `total_price`, `seats`) VALUES
(1, 1, 1, 'The Matrix', '/templates/images/The Matrix.jpg', 'UKnow影院', '2024-01-15 19:30', 'completed', '2024-01-10 14:30:00', 45.00, '[{"row": 3, "col": 5}, {"row": 3, "col": 6}]'),
(1, 3, 5, 'The Lord of the Rings', '/templates/images/Lord of the rings.jpg', 'BigFeel影院', '2024-01-20 20:00', 'upcoming', '2024-01-12 16:45:00', 50.00, '[{"row": 4, "col": 3}]'),
(1, 4, 8, 'Pirates of the Caribbean', '/templates/images/Pirates of the Caribbean.jpg', '万达影城', '2024-01-25 15:00', 'upcoming', '2024-01-15 10:20:00', 40.00, '[{"row": 2, "col": 7}]'),
(1, 2, 3, 'The Hobbit', '/templates/images/The Hobbit.jpg', '金逸影城', '2024-01-18 14:30', 'completed', '2024-01-08 09:15:00', 55.00, '[{"row": 5, "col": 4}, {"row": 5, "col": 5}]'),
(1, 6, 12, 'Interstellar', '/templates/images/Interstellar.jpg', 'CGV影城', '2024-01-30 21:00', 'upcoming', '2024-01-16 11:30:00', 60.00, '[{"row": 6, "col": 2}]');
