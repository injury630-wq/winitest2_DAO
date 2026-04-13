-- winitest.users definition

CREATE TABLE `users` (
  `user_no` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_pw` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_no`),
  UNIQUE KEY `uk_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- winitest.board definition

CREATE TABLE `board` (
  `board_no` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `writer_pw` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ref` int DEFAULT '0',
  `re_lev` int DEFAULT '0',
  `hit` int DEFAULT '0',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `re_seq` int DEFAULT '0',
  `modi_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `parent_no` int DEFAULT NULL,
  `user_no` int DEFAULT NULL,
  PRIMARY KEY (`board_no`),
  KEY `fk_board_parent` (`parent_no`),
  KEY `fk_board_user` (`user_no`),
  CONSTRAINT `fk_board_parent` FOREIGN KEY (`parent_no`) REFERENCES `board` (`board_no`) ON DELETE CASCADE,
  CONSTRAINT `fk_board_user` FOREIGN KEY (`user_no`) REFERENCES `users` (`user_no`)
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- winitest.board_file definition

CREATE TABLE `board_file` (
  `file_no` int NOT NULL AUTO_INCREMENT,
  `board_no` int NOT NULL,
  `file_name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` bigint DEFAULT '0',
  PRIMARY KEY (`file_no`),
  KEY `board_no` (`board_no`),
  CONSTRAINT `board_file_ibfk_1` FOREIGN KEY (`board_no`) REFERENCES `board` (`board_no`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;