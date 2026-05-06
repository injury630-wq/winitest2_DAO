-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: winitest
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `board_no` int NOT NULL COMMENT '게시글 PK (BOARD_SEQ 채번)',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '제목',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '내용',
  `writer_pw` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '비밀번호 (비회원 작성용)',
  `ref` int DEFAULT '0' COMMENT '원글 그룹 번호 (답글 묶음)',
  `re_lev` int DEFAULT '0' COMMENT '답글 깊이 (depth)',
  `sort_ord` int DEFAULT '0' COMMENT '정렬 순서 (같은 ref 그룹 내)',
  `hit` int DEFAULT '0' COMMENT '조회수',
  `use_yn` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'Y' COMMENT '사용여부 (Y:사용, N:미사용)',
  `user_no` int NOT NULL COMMENT 'FK) users.user_no 작성자',
  `parent_no` int DEFAULT NULL COMMENT '부모 게시글 번호 (답글인 경우)',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `mod_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  `mod_user` int DEFAULT NULL COMMENT 'FK) users.user_no 수정자',
  PRIMARY KEY (`board_no`),
  KEY `idx_board_ref` (`ref`),
  KEY `fk_board_user` (`user_no`),
  KEY `fk_board_parent` (`parent_no`),
  CONSTRAINT `fk_board_parent` FOREIGN KEY (`parent_no`) REFERENCES `board` (`board_no`) ON DELETE CASCADE,
  CONSTRAINT `fk_board_user` FOREIGN KEY (`user_no`) REFERENCES `users` (`user_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='일반 게시판 (BOARD_SEQ, file_master 연결)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (3,'fdgsdf','hjjghjghjgjhgㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁ','1234',3,0,NULL,15,'Y',5,NULL,'2026-04-26 12:55:42','2026-04-26 13:32:48',NULL),(4,'ㅁㄴㅇ','ㅁㄴㅇ','1234',4,0,NULL,6,'Y',5,NULL,'2026-04-26 13:32:46','2026-04-27 21:35:55',NULL);
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `code`
--

DROP TABLE IF EXISTS `code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `code` (
  `code_key` int NOT NULL AUTO_INCREMENT COMMENT '코드 PK (AUTO)',
  `code_name` varchar(50) DEFAULT NULL COMMENT '코드 표시명 (예: 관리자)',
  `sort_ord` int DEFAULT NULL COMMENT '정렬 순서 (콤보박스 출력 시)',
  `code_no` varchar(255) NOT NULL COMMENT 'UK 의미코드번호 (예: 70010 / Y / Q_RADIO)',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  PRIMARY KEY (`code_key`),
  UNIQUE KEY `uk_code_no` (`code_no`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='공통 코드 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `code`
--

LOCK TABLES `code` WRITE;
/*!40000 ALTER TABLE `code` DISABLE KEYS */;
INSERT INTO `code` VALUES (1,'일반사용자',0,'70010',NULL,'2026-05-05 06:33:37',NULL,NULL),(2,'관리자',1,'70020',NULL,'2026-05-05 06:33:37',NULL,NULL),(3,'시스템관리자',2,'70030',NULL,'2026-05-05 06:33:37',NULL,NULL),(4,'Y',0,'Y',NULL,'2026-05-05 06:33:38',NULL,NULL),(5,'N',1,'N',NULL,'2026-05-05 06:33:38',NULL,NULL),(6,'단답형',0,'text',NULL,'2026-05-05 06:33:38',NULL,NULL),(7,'장문형',1,'textarea',NULL,'2026-05-05 06:33:38',NULL,NULL),(8,'라디오박스',2,'radio',NULL,'2026-05-05 06:33:38',NULL,NULL),(9,'셀렉트박스',3,'select',NULL,'2026-05-05 06:33:38',NULL,NULL),(10,'체크박스',4,'checkbox',NULL,'2026-05-05 06:33:38',NULL,NULL);
/*!40000 ALTER TABLE `code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `code_group`
--

DROP TABLE IF EXISTS `code_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `code_group` (
  `group_no` int NOT NULL AUTO_INCREMENT COMMENT '코드그룹 PK (AUTO)',
  `group_code` varchar(50) NOT NULL COMMENT '코드 분류 키 (예: USER_TYPE)',
  `group_name` varchar(100) DEFAULT NULL COMMENT '코드 분류 한글명',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  PRIMARY KEY (`group_no`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='공통 코드 그룹 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `code_group`
--

LOCK TABLES `code_group` WRITE;
/*!40000 ALTER TABLE `code_group` DISABLE KEYS */;
INSERT INTO `code_group` VALUES (1,'USER_TYPE','사용자 종류',NULL,'2026-05-05 06:32:57',NULL,NULL),(2,'USE_YN','사용여부',NULL,'2026-05-05 06:32:57',NULL,NULL),(3,'ADMIN_YN','관리자여부',NULL,'2026-05-05 06:32:57',NULL,NULL),(4,'Q_TYPE','질문유형',NULL,'2026-05-05 06:32:57',NULL,NULL);
/*!40000 ALTER TABLE `code_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `code_group_mid`
--

DROP TABLE IF EXISTS `code_group_mid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `code_group_mid` (
  `group_no` int NOT NULL COMMENT 'FK) code_group.group_no',
  `code_key` int NOT NULL COMMENT 'FK) code.code_key',
  PRIMARY KEY (`group_no`,`code_key`),
  KEY `fk_cgm_code` (`code_key`),
  CONSTRAINT `fk_cgm_code` FOREIGN KEY (`code_key`) REFERENCES `code` (`code_key`),
  CONSTRAINT `fk_cgm_group` FOREIGN KEY (`group_no`) REFERENCES `code_group` (`group_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='코드-코드그룹 중간 테이블 (1코드 다그룹 허용)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `code_group_mid`
--

LOCK TABLES `code_group_mid` WRITE;
/*!40000 ALTER TABLE `code_group_mid` DISABLE KEYS */;
INSERT INTO `code_group_mid` VALUES (1,1),(1,2),(1,3),(2,4),(3,4),(2,5),(3,5),(4,6),(4,7),(4,8),(4,9),(4,10);
/*!40000 ALTER TABLE `code_group_mid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_master`
--

DROP TABLE IF EXISTS `file_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `file_master` (
  `file_no` int NOT NULL AUTO_INCREMENT COMMENT '파일 PK (AUTO)',
  `file_path` varchar(300) DEFAULT NULL COMMENT '파일 저장 경로 (디렉토리 포함)',
  `file_name` varchar(200) DEFAULT NULL COMMENT '서버 저장 파일명 (UUID 기반)',
  `org_name` varchar(200) DEFAULT NULL COMMENT '원본 파일명 (사용자 업로드명)',
  `file_ext` varchar(20) DEFAULT NULL COMMENT '파일 확장자 (jpg, png 등)',
  `file_size` bigint DEFAULT '0' COMMENT '파일 크기 (byte)',
  `sort_ord` int DEFAULT '0' COMMENT '정렬 순서',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `board_no` int DEFAULT NULL COMMENT 'image_board, board (논리 FK/물리 적용 x)',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '파일 논리 삭제 (Y/N)',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  PRIMARY KEY (`file_no`),
  KEY `fk_file_reg_user` (`reg_user`),
  CONSTRAINT `fk_file_reg_user` FOREIGN KEY (`reg_user`) REFERENCES `users` (`user_no`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='통합 파일 테이블 (board/image_board 공용, group_id로 묶음)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_master`
--

LOCK TABLES `file_master` WRITE;
/*!40000 ALTER TABLE `file_master` DISABLE KEYS */;
INSERT INTO `file_master` VALUES (8,'C:/upload/board/','181d571b-c1a1-4334-8007-4f2c23656707.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-26 13:28:42',3,'Y',NULL,NULL),(9,'C:/upload/board/','7ad38180-256b-4f64-9491-2a53d617e690.png','img.png','png',3154554,0,5,'2026-04-26 13:29:27',3,'Y',NULL,NULL),(10,'C:/upload/board/','c493981c-c28b-4375-98bd-59a484227c70.txt','새 텍스트 문서.txt','txt',235,0,5,'2026-04-26 13:32:10',3,'Y',NULL,NULL),(11,'C:/upload/board/','c47cf601-8d0d-4933-88cd-2853f2271bf4.jpg','실비아눈치.jpg','jpg',64957,1,5,'2026-04-26 13:32:10',3,'Y',NULL,NULL),(12,'C:/upload/board/','dadb9d47-f664-4d6d-891f-21019440d907.txt','새 텍스트 문서.txt','txt',235,0,5,'2026-04-26 13:32:24',3,'Y',NULL,NULL),(13,'C:/upload/board/','937bdac5-4916-4862-ab94-f34036865d29.png','img.png','png',3154554,0,5,'2026-04-26 13:32:46',4,'Y',NULL,NULL),(14,'C:/upload/board/','7562f8be-4202-4488-bde8-1914fbc47ae2.jpg','실비아눈치.jpg','jpg',64957,1,5,'2026-04-26 13:32:46',4,'Y',NULL,NULL),(15,'C:/upload/gallery/','611c90a1-14c6-4a96-bcc9-bfc119b73d18.png','img.png','png',3154554,0,5,'2026-04-26 18:05:15',5,'N',NULL,NULL),(16,'C:/upload/gallery/','18cfe994-0d7d-43fb-9f7d-9421a941cd2c.jpg','실비아눈치.jpg','jpg',64957,1,5,'2026-04-26 18:05:15',5,'N',NULL,NULL),(17,'C:/upload/gallery/','9674d0d1-2dbb-4f63-8bfa-c0014f59abdf.png','img.png','png',3154554,0,5,'2026-04-26 18:06:42',6,'Y',NULL,NULL),(18,'C:/upload/gallery/','c7278d27-ef38-4746-8b32-5318c71b76e3.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-26 18:06:56',6,'Y',NULL,NULL),(19,'C:/upload/gallery/','132337ba-85f3-4e90-a576-14f61c69301b.png','별의소리.png','png',130994,0,5,'2026-04-26 18:19:44',7,'Y',NULL,NULL),(20,'C:/upload/gallery/','7b13bf7d-a45d-4820-adad-03ba0dfe0fc9.png','프로필.png','png',439993,1,5,'2026-04-26 18:19:44',7,'Y',NULL,NULL),(21,'C:/upload/gallery/','e01702b4-b800-4bb1-8d63-f3565bedce8f.png','화면 캡처 2026-01-15 105722.png','png',808243,2,5,'2026-04-26 18:19:44',7,'Y',NULL,NULL),(22,'C:/upload/gallery/','6c58e1cf-35c3-4b8b-b66f-c6690908ab17.png','별의소리.png','png',130994,0,8,'2026-04-26 18:28:29',9,'Y',NULL,NULL),(23,'C:/upload/gallery/','0d6f1787-1581-4f55-98fb-1a9f5769356d.png','프로필.png','png',439993,1,8,'2026-04-26 18:28:29',9,'Y',NULL,NULL),(24,'C:/upload/gallery/','a2f6d19a-5f3a-4815-9822-df3654ef3dc8.png','화면 캡처 2026-01-15 105722.png','png',808243,2,8,'2026-04-26 18:28:29',9,'Y',NULL,NULL),(25,'C:/upload/gallery/','504eff0a-8874-4aa7-87d4-3c1d832306df.png','별의소리.png','png',130994,0,8,'2026-04-26 18:29:58',11,'Y',NULL,NULL),(26,'C:/upload/gallery/','555dde9f-8f15-4048-8c36-e2c15194926b.png','프로필.png','png',439993,1,8,'2026-04-26 18:29:58',11,'Y',NULL,NULL),(27,'C:/upload/gallery/','90ed623e-2c78-41e1-bd20-d22139ceb72f.png','화면 캡처 2026-01-15 105722.png','png',808243,2,8,'2026-04-26 18:29:58',11,'Y',NULL,NULL),(28,'C:/upload/gallery/','deaa88aa-283c-4d0f-aea1-5a6c658b1b24.png','img.png','png',3154554,0,8,'2026-04-26 18:30:27',11,'Y',NULL,NULL),(29,'C:/upload/gallery/','7bba8e80-659c-486a-8990-77ede1797ce8.jpg','실비아눈치.jpg','jpg',64957,0,8,'2026-04-26 18:30:50',12,'N',NULL,NULL),(30,'C:/upload/gallery/','380c6748-ce08-4db3-8a45-bf503c35de90.png','img.png','png',3154554,0,6,'2026-04-26 18:50:52',13,'N',NULL,NULL),(31,'C:/upload/gallery/','39830152-e709-441f-ac66-b4d20926146a.jpg','실비아눈치.jpg','jpg',64957,0,6,'2026-04-26 18:51:09',13,'N',NULL,NULL),(32,'C:/upload/gallery/','b297d24c-cd49-4646-9b88-ad0a18752a60.jpg','실비아눈치.jpg','jpg',64957,0,8,'2026-04-26 22:12:28',14,'N',NULL,NULL),(33,'C:/upload/gallery/','c4bc19b2-91ba-4dd5-b957-8f79ace82f4f.jpg','실비아눈치.jpg','jpg',64957,1,8,'2026-04-26 22:12:28',14,'N',NULL,NULL),(34,'C:/upload/gallery/','bdfdb40c-8aa6-4d9f-962c-1eb12d200afb.jpg','실비아눈치.jpg','jpg',64957,2,8,'2026-04-26 22:12:28',14,'N',NULL,NULL),(35,'C:/upload/gallery/','3165cdb8-6806-4c5d-b110-51c80a33e6d6.jpg','실비아눈치.jpg','jpg',64957,3,8,'2026-04-26 22:12:28',14,'N',NULL,NULL),(36,'C:/upload/gallery/','dcdac3f7-8476-4f37-acd2-51b8f29ac7eb.png','img.png','png',3154554,4,8,'2026-04-26 22:12:28',14,'N',NULL,NULL),(37,'C:/upload/gallery/','5e11cd0d-9ae0-40a7-bdb3-835e5905f6e0.jpg','실비아눈치.jpg','jpg',64957,0,8,'2026-04-26 22:12:59',14,'N',NULL,NULL),(38,'C:/upload/gallery/','391a225e-d952-41f5-b84f-8dbc0ff25538.png','img.png','png',3154554,1,8,'2026-04-26 22:12:59',14,'N',NULL,NULL),(39,'C:/upload/gallery/','8a593f32-8075-4591-8105-ee4068751e26.jpg','실비아눈치.jpg','jpg',64957,2,8,'2026-04-26 22:12:59',14,'N',NULL,NULL),(40,'C:/upload/gallery/','2bc4c365-80e2-40d7-8fcd-47b97b991576.png','img.png','png',3154554,3,8,'2026-04-26 22:12:59',14,'N',NULL,NULL),(41,'C:/upload/gallery/','c77c37de-4994-455c-8650-13256a38ea90.jpg','실비아눈치.jpg','jpg',64957,4,8,'2026-04-26 22:12:59',14,'N',NULL,NULL),(42,'C:/upload/gallery/','8c1aa0b1-68f6-4f2a-ae71-cc5fcda82bb5.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-27 02:24:01',14,'N',NULL,NULL),(43,'C:/upload/gallery/','8fc78f47-5d12-4458-a753-5aad255461d5.png','img.png','png',3154554,0,5,'2026-04-27 02:24:11',14,'N',NULL,NULL),(44,'C:/upload/gallery/','e549ab55-0d10-4450-8a4a-c3147dfb7a71.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-27 02:38:05',12,'N',NULL,NULL),(45,'C:/upload/gallery/','38c645a6-68eb-4bdf-bf45-d0fb2ab0f27d.png','img.png','png',3154554,1,5,'2026-04-27 02:38:05',12,'N',NULL,NULL),(46,'C:/upload/gallery/','f1672f69-d424-4684-9db5-f611954f5602.png','img.png','png',3154554,2,5,'2026-04-27 02:38:05',12,'N',NULL,NULL),(47,'C:/upload/gallery/','01f86f95-ba03-4faa-a2f3-9a08eae36a9c.jpg','실비아눈치.jpg','jpg',64957,3,5,'2026-04-27 02:38:05',12,'N',NULL,NULL),(48,'C:/upload/gallery/','25b04cac-a906-4417-931c-fd27753b4ec1.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-27 05:11:23',14,'N',NULL,NULL),(49,'C:/upload/gallery/','1a371aa1-a972-4067-9ce6-daae16453918.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-27 05:20:17',14,'N',NULL,NULL),(50,'C:/upload/gallery/','d456c049-a1cd-4279-a5f1-8dcd64bedae4.png','img.png','png',3154554,0,5,'2026-04-27 05:20:52',15,'N',NULL,NULL),(51,'C:/upload/gallery/','1affba2f-649c-424a-a07e-ceb10024bf21.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-27 05:21:03',16,'N',NULL,NULL),(52,'C:/upload/gallery/','a672705e-eb46-42b4-82f8-a2f3cffbebdb.png','img.png','png',3154554,0,5,'2026-04-27 05:29:43',16,'N',NULL,NULL),(53,'C:/upload/gallery/','a8728321-e274-4bdc-bb83-409f2313e63b.jpg','실비아눈치.jpg','jpg',64957,0,5,'2026-04-27 05:39:44',17,'Y',NULL,NULL),(54,'C:/upload/gallery/','9be92fd3-0c06-4b4b-b264-a5577062b055.png','img.png','png',3154554,0,5,'2026-04-27 05:39:52',18,'Y',NULL,NULL),(55,'C:/upload/gallery/','55d3a906-da90-4ae7-987a-0b9f7f95e9be.jpg','실비아눈치.jpg','jpg',64957,0,7,'2026-04-27 06:05:26',18,'Y',NULL,NULL),(56,'C:/upload/gallery/','17b9a295-8c6e-4592-91dd-2cc675d40c4a.jpg','실비아눈치.jpg','jpg',64957,0,7,'2026-04-27 06:05:32',18,'Y',NULL,NULL),(57,'C:/upload/gallery/','bf96b140-8a70-4f2d-ac05-61cc1c006a3c.png','img.png','png',3154554,0,7,'2026-04-27 06:05:41',18,'Y',NULL,NULL),(58,'C:/upload/gallery/','1706f228-b828-4467-bad7-9064355985bc.jpg','실비아눈치.jpg','jpg',64957,0,7,'2026-04-27 06:06:01',0,'N',NULL,NULL),(59,'C:/upload/gallery/','bf34d54e-19bf-454a-a606-d17bef4025cc.jpg','실비아눈치.jpg','jpg',64957,0,7,'2026-04-27 06:06:09',0,'N',NULL,NULL),(60,'C:/upload/gallery/','3029cedf-6dfc-4fcc-b9fc-b0430d7eeaad.png','img.png','png',3154554,0,7,'2026-04-27 06:06:36',0,'N',NULL,NULL),(61,'C:/upload/gallery/','4bbee88f-ab42-409d-9055-7f006013d99f.png','img.png','png',3154554,0,5,'2026-04-27 06:10:38',19,'Y',NULL,NULL),(62,'C:/upload/gallery/','690415ae-a016-4582-839d-0250439e7958.png','7d7d7d (1).png','png',4269,0,5,'2026-04-27 20:24:59',20,'Y',NULL,NULL),(63,'C:/upload/gallery/','c4915259-ba6b-4a7f-b610-724e03e05b14.png','7d7d7d.png','png',4269,1,5,'2026-04-27 20:24:59',20,'Y',NULL,NULL),(64,'C:/upload/gallery/','8dbb7a10-d31d-49c2-bb63-bf643bd8e726.png','0011ff.png','png',5630,2,5,'2026-04-27 20:24:59',20,'Y',NULL,NULL),(65,'C:/upload/gallery/','c0aa7bfe-0578-4d30-9a9c-e4982e2cc93c.png','fff.png','png',5630,3,5,'2026-04-27 20:24:59',20,'N',NULL,NULL),(66,'C:/upload/gallery/','a79c8c87-d9b4-44f9-9837-1ec6d1d034b4.png','ffffff.png','png',1824,4,5,'2026-04-27 20:24:59',0,'N',NULL,NULL),(67,'C:/upload/gallery/','3621d2eb-72a4-449a-86c5-0061e7e8be81.png','ffffff.png','png',1824,0,5,'2026-04-27 20:25:06',20,'Y',NULL,NULL),(68,'C:/upload/gallery/','1fbbed40-58d8-4c34-a3b6-03734bd53b52.png','fff.png','png',5630,0,5,'2026-04-27 20:57:59',21,'Y',NULL,NULL),(69,'C:/upload/gallery/','c341af24-dc5f-4a1f-ad17-1f116899b946.png','7d7d7d (1).png','png',4269,0,5,'2026-04-27 20:59:14',0,'N',NULL,NULL),(70,'C:/upload/gallery/','7a712f71-416b-4869-a366-c9a0895fe9f0.png','7d7d7d (1).png','png',4269,0,5,'2026-04-27 21:36:04',0,'N',NULL,NULL),(71,'C:/upload/gallery/','434314f2-9478-446f-b054-4837b7d9b15d.png','7d7d7d.png','png',4269,1,5,'2026-04-27 21:36:04',0,'N',NULL,NULL),(72,'C:/upload/gallery/','05408fe7-56cf-4bb2-883a-3de240318dfa.png','0011ff.png','png',5630,2,5,'2026-04-27 21:36:04',0,'N',NULL,NULL),(73,'C:/upload/gallery/','710b7b69-d62f-4ffd-bb85-e2f3b1aa37bc.png','fff.png','png',5630,3,5,'2026-04-27 21:36:04',0,'N',NULL,NULL),(74,'C:/upload/gallery/','ab2ab7bc-3508-47bb-a645-a8f5afbe089f.png','ffffff.png','png',1824,4,5,'2026-04-27 21:36:04',0,'N',NULL,NULL),(75,'C:/upload/gallery/','47efba22-10ec-473d-9ac5-2adae5396c2b.png','fff.png','png',5630,0,5,'2026-04-27 21:45:23',0,'N',NULL,NULL),(76,'C:/upload/gallery/','969f0690-57ef-4445-9658-232a96e81a79.png','ffffff.png','png',1824,0,5,'2026-04-27 21:45:25',0,'N',NULL,NULL),(77,'C:/upload/gallery/','d1fca860-78d0-4210-bd6d-7a1a48311058.png','7d7d7d.png','png',4269,0,5,'2026-04-27 21:45:30',0,'N',NULL,NULL),(78,'C:/upload/gallery/','4eb9fea9-f20b-4d5b-acc3-2819ed816e6d.png','fff.png','png',5630,0,5,'2026-04-27 21:53:27',22,'Y',NULL,NULL),(96,'C:/upload/gallery/','25830c56-dfd5-4cec-954a-b10e05a23583.png','ffffff.png','png',1824,0,5,'2026-04-27 22:42:21',17,'Y',NULL,NULL),(97,'C:/upload/gallery/','7da533c1-891e-4570-b0d9-cd949ea1f69a.png','7d7d7d.png','png',4269,0,5,'2026-04-27 22:44:58',23,'Y',NULL,NULL),(98,'C:/upload/gallery/','f7229bf0-105b-4afd-adfb-9b3448935052.png','0011ff.png','png',5630,1,5,'2026-04-27 22:44:58',23,'Y',NULL,NULL),(99,'C:/upload/gallery/','db29c4af-78d7-458a-b914-8b1ccc958657.png','fff.png','png',5630,2,5,'2026-04-27 22:44:58',23,'N',NULL,NULL),(100,'C:/upload/gallery/','2d55c7e4-a8a9-4ccf-8bbf-a1bc814f9fe3.png','ffffff.png','png',1824,3,5,'2026-04-27 22:44:58',23,'N',NULL,NULL),(101,'C:/upload/gallery/','be5a429f-cf37-47f5-8903-411cc7bd2865.png','ffffff.png','png',1824,0,5,'2026-04-28 00:36:20',23,'Y',NULL,NULL),(102,'C:/upload/gallery/','210748c8-3411-4949-9a7c-17ca197e0432.png','ffffff.png','png',1824,0,5,'2026-04-28 07:07:04',13,'Y',NULL,NULL),(103,'C:/upload/gallery/','f84be80c-1dd6-4c71-83f2-72140cc97637.png','fff.png','png',5630,0,8,'2026-04-28 07:09:34',24,'N',NULL,NULL),(104,'C:/upload/gallery/','49a3a783-9964-4b1a-ac5e-56cd38eb4541.png','7d7d7d.png','png',4269,0,8,'2026-04-28 07:09:36',0,'N',NULL,NULL),(105,'C:/upload/gallery/','e70321b2-fb6e-4a37-ba09-5778da1bde86.png','ffffff.png','png',1824,0,8,'2026-04-28 07:09:46',24,'N',NULL,NULL),(106,'C:/upload/gallery/','88e3878e-5189-4af9-a877-4da5dd111f1e.png','7d7d7d.png','png',4269,0,8,'2026-04-28 07:09:48',24,'N',NULL,NULL),(107,'C:/upload/gallery/','8c26b605-a398-417e-b707-d04d3e2f0f20.png','ffffff.png','png',1824,0,8,'2026-04-28 07:10:08',24,'Y',NULL,NULL);
/*!40000 ALTER TABLE `file_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_board`
--

DROP TABLE IF EXISTS `image_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_board` (
  `board_no` int NOT NULL COMMENT '게시글 PK (BOARD_SEQ 채번, board 공유)',
  `title` varchar(200) NOT NULL COMMENT '제목',
  `content` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '내용',
  `thumb_file_no` int DEFAULT NULL COMMENT '썸네일 FK) file_master.file_no',
  `hit` int DEFAULT '0' COMMENT '조회수',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부 (Y:사용, N:미사용)',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `mod_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  PRIMARY KEY (`board_no`),
  KEY `fk_img_reg_user` (`reg_user`),
  KEY `fk_img_mod_user` (`mod_user`),
  KEY `fk_img_thumb` (`thumb_file_no`),
  CONSTRAINT `fk_img_mod_user` FOREIGN KEY (`mod_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_img_reg_user` FOREIGN KEY (`reg_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_img_thumb` FOREIGN KEY (`thumb_file_no`) REFERENCES `file_master` (`file_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='이미지 게시판 (BOARD_SEQ  board 와 PK 공유)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_board`
--

LOCK TABLES `image_board` WRITE;
/*!40000 ALTER TABLE `image_board` DISABLE KEYS */;
INSERT INTO `image_board` VALUES (5,'12','<br><img src=\"gallery/imgView.do?fileNo=15\" class=\"\"><img src=\"gallery/imgView.do?fileNo=16\" class=\"\">',16,5,'N','2026-04-26 18:04:31',5,'2026-04-26 18:06:34',5),(6,'ㅁㄴㅇ','<img src=\"gallery/imgView.do?fileNo=17\" class=\"\"><img src=\"gallery/imgView.do?fileNo=18\">ㅁㅇㄴㅁㄴㅇㄴㅁㅇㅁㄴㅇㅓㅘㅗㅓㅏㅗㅓ<div><br></div>',17,35,'Y','2026-04-26 18:06:42',5,'2026-04-26 18:28:15',5),(7,'ㅁㄴㅇ123','ㅁㄴㅇㅁㄴㅇㅁㄴㅇ<div><br><div><img src=\"gallery/imgView.do?fileNo=19\" class=\"\"></div><div><img src=\"gallery/imgView.do?fileNo=20\" class=\"\"></div><div><img src=\"gallery/imgView.do?fileNo=21\" class=\"\"></div></div>',21,2,'Y','2026-04-26 18:19:44',5,'2026-04-26 18:26:26',NULL),(8,'1234','ㅁㄴㅇㅁㄴ',NULL,8,'Y','2026-04-26 18:19:56',5,'2026-04-27 06:06:29',NULL),(9,'ㅁㄴㅇ','<img src=\"gallery/imgView.do?fileNo=22\" class=\"\"><img src=\"gallery/imgView.do?fileNo=23\" class=\"\"><img src=\"gallery/imgView.do?fileNo=24\">',23,8,'Y','2026-04-26 18:28:29',8,'2026-04-27 05:30:17',8),(10,'ㅁㄴㅇ','ㅁㄴㅇ',NULL,1,'Y','2026-04-26 18:28:43',8,'2026-04-26 18:28:43',NULL),(11,'ㄴㅇㄹ','ㅁㄴㅇㅁㄴㅇㅁ<div>&nbsp; &nbsp; &nbsp;ㅇㄹㅇㄹㅇㄹㅇㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹ</div><img src=\"gallery/imgView.do?fileNo=28\">',27,20,'Y','2026-04-26 18:29:58',8,'2026-04-27 02:24:23',8),(12,'1231','123<img src=\"gallery/imgView.do?fileNo=29\" class=\"\">',45,10,'N','2026-04-26 18:30:50',8,'2026-04-27 05:34:07',7),(13,'asd123','dgdgd<img src=\"gallery/imgView.do?fileNo=102\" data-fileno=\"102\" data-filesize=\"1824\">',102,12,'Y','2026-04-26 18:50:52',6,'2026-04-28 07:07:12',5),(14,'test','<img src=\"gallery/imgView.do?fileNo=48\">ㅁㄴㅇㅁㄴㅇㅁㅇㄴㅁㅁㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ<div>ㅓㅘㅗㅓ하ㅗㅓ하</div><img src=\"gallery/imgView.do?fileNo=49\">',49,17,'N','2026-04-26 22:12:28',8,'2026-04-27 05:31:38',7),(15,'ㅗㅓ하ㅗㅓㅎ','ㅓ<img src=\"gallery/imgView.do?fileNo=50\"><img src=\"gallery/imgView.do?fileNo=50\">',50,4,'N','2026-04-27 05:20:42',5,'2026-04-27 05:31:35',7),(16,'ㅓㅗ하','ㅗㅓ하<img src=\"gallery/imgView.do?fileNo=51\"><img src=\"gallery/imgView.do?fileNo=52\">',51,5,'N','2026-04-27 05:21:03',5,'2026-04-27 05:31:33',7),(17,'aaaa','aa<img src=\"gallery/imgView.do?fileNo=96\" data-fileno=\"96\" data-filesize=\"1824\">',53,7,'Y','2026-04-27 05:39:44',5,'2026-04-27 22:44:51',5),(18,'aa','aaa<img src=\"gallery/imgView.do?fileNo=54\"><img src=\"gallery/imgView.do?fileNo=55\" data-fileno=\"55\"><img src=\"gallery/imgView.do?fileNo=56\" data-fileno=\"56\"><img src=\"gallery/imgView.do?fileNo=57\" data-fileno=\"57\">',54,6,'Y','2026-04-27 05:39:52',5,'2026-04-28 07:09:27',7),(19,'ㅁㄴㅇ','123<img src=\"gallery/imgView.do?fileNo=61\" data-fileno=\"61\">',61,1,'Y','2026-04-27 06:10:39',5,'2026-04-27 06:10:39',NULL),(20,'nmn','hgjghjgh===jjjjjjjjjjj&nbsp;&nbsp;<div><br></div><img src=\"gallery/imgView.do?fileNo=62\" data-fileno=\"62\"><img src=\"gallery/imgView.do?fileNo=63\" data-fileno=\"63\"><img src=\"gallery/imgView.do?fileNo=64\" data-fileno=\"64\"><img src=\"gallery/imgView.do?fileNo=67\" data-fileno=\"67\">',67,5,'Y','2026-04-27 20:25:29',5,'2026-04-27 20:47:55',5),(21,'ㅁㄴㅇ','ㅁㄴㅇ<img src=\"gallery/imgView.do?fileNo=68\" data-fileno=\"68\">',68,4,'Y','2026-04-27 20:58:00',5,'2026-04-27 22:36:21',NULL),(22,'ㅁㄴㅇㅁㄴㅇ','<img src=\"gallery/imgView.do?fileNo=80\" data-fileno=\"80\" data-filesize=\"1824\"><img src=\"gallery/imgView.do?fileNo=83\" data-fileno=\"83\" data-filesize=\"1824\">',78,4,'Y','2026-04-27 21:53:32',5,'2026-04-27 22:36:17',5),(23,'ㅁㄴㅇㅁㄴ','<br><img src=\"gallery/imgView.do?fileNo=97\" data-fileno=\"97\" data-filesize=\"4269\"><img src=\"gallery/imgView.do?fileNo=98\" data-fileno=\"98\" data-filesize=\"5630\"><img src=\"gallery/imgView.do?fileNo=101\" data-fileno=\"101\" data-filesize=\"1824\">',101,18,'Y','2026-04-27 22:45:00',5,'2026-04-28 07:09:25',5),(24,'ㅁㅇ','ㅇㄴㅁ<img src=\"gallery/imgView.do?fileNo=107\" data-fileno=\"107\" data-filesize=\"1824\">',107,3,'Y','2026-04-28 07:09:39',8,'2026-04-28 07:10:20',8);
/*!40000 ALTER TABLE `image_board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu` (
  `menu_no` int NOT NULL AUTO_INCREMENT COMMENT '메뉴 PK (AUTO)',
  `menu_name` varchar(100) NOT NULL COMMENT '메뉴명',
  `parent_no` int DEFAULT NULL COMMENT '부모 메뉴 번호 (최상위는 NULL)',
  `menu_lev` int DEFAULT '0' COMMENT '메뉴 깊이 (depth)',
  `sort_ord` int DEFAULT '0' COMMENT '정렬 순서 (같은 레벨 내)',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부 (Y:사용, N:미사용)',
  `pro_no` int DEFAULT NULL COMMENT 'FK) program.pro_no',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `mod_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  PRIMARY KEY (`menu_no`),
  KEY `fk_menu_program` (`pro_no`),
  CONSTRAINT `fk_menu_program` FOREIGN KEY (`pro_no`) REFERENCES `program` (`pro_no`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='메뉴 관리 테이블 (계층 구조 + 프로그램 연결)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'게시판',NULL,0,0,'Y',NULL,'2026-04-24 00:50:56',0,'2026-04-24 00:50:56',0),(2,'시스템',NULL,0,0,'Y',NULL,'2026-04-24 00:50:56',0,'2026-04-24 00:50:56',0),(3,'일반게시판',1,1,0,'Y',1,'2026-04-24 00:50:56',0,'2026-04-24 01:00:12',0),(4,'이미지게시판',1,1,1,'Y',2,'2026-04-24 00:50:56',0,'2026-04-24 01:00:12',0),(5,'사용자관리',2,1,0,'Y',3,'2026-04-24 00:50:56',0,'2026-04-24 01:00:12',0),(6,'설문',NULL,0,1,'Y',NULL,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(7,'권한관리',NULL,0,2,'Y',NULL,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(8,'설문관리',6,1,0,'Y',4,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(10,'설문참여',6,1,2,'Y',6,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(11,'권한그룹관리',7,1,0,'Y',7,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(12,'메뉴별권한관리',7,1,1,'Y',8,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(13,'권한별사용자관리',7,1,2,'Y',9,'2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_role_perm`
--

DROP TABLE IF EXISTS `menu_role_perm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_role_perm` (
  `perm_no` int NOT NULL AUTO_INCREMENT COMMENT '권한 PK (AUTO)',
  `menu_no` int NOT NULL COMMENT 'FK) menu.menu_no',
  `role_no` int NOT NULL COMMENT 'FK) user_role.role_no',
  `disp_yn` char(1) DEFAULT 'N' COMMENT '메뉴 표시 권한 (사이드바 노출여부)',
  `view_yn` char(1) DEFAULT 'N' COMMENT '프로그램 조회 권한 (URL 직접 접근)',
  `ins_yn` char(1) DEFAULT 'N' COMMENT '등록 권한',
  `upd_yn` char(1) DEFAULT 'N' COMMENT '수정 권한',
  `del_yn` char(1) DEFAULT 'N' COMMENT '삭제 권한',
  PRIMARY KEY (`perm_no`),
  UNIQUE KEY `uq_menu_role` (`menu_no`,`role_no`),
  KEY `fk_perm_role` (`role_no`),
  CONSTRAINT `fk_perm_menu` FOREIGN KEY (`menu_no`) REFERENCES `menu` (`menu_no`),
  CONSTRAINT `fk_perm_role` FOREIGN KEY (`role_no`) REFERENCES `user_role` (`role_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='메뉴별 롤 권한 관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_role_perm`
--

LOCK TABLES `menu_role_perm` WRITE;
/*!40000 ALTER TABLE `menu_role_perm` DISABLE KEYS */;
/*!40000 ALTER TABLE `menu_role_perm` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program`
--

DROP TABLE IF EXISTS `program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program` (
  `pro_no` int NOT NULL AUTO_INCREMENT COMMENT '프로그램 PK (AUTO)',
  `pro_name` varchar(100) NOT NULL COMMENT '프로그램명',
  `pro_path` varchar(200) NOT NULL COMMENT '요청 URL 경로 (예: /user/list.do)',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부 (Y:사용, N:미사용)',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `mod_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  PRIMARY KEY (`pro_no`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='프로그램 관리 테이블 (URL 및 기능 단위)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program`
--

LOCK TABLES `program` WRITE;
/*!40000 ALTER TABLE `program` DISABLE KEYS */;
INSERT INTO `program` VALUES (1,'일반게시판','/board/list.do','Y','2026-04-24 00:59:54',0,'2026-04-24 00:59:54',0),(2,'이미지게시판','/gallery/list.do','Y','2026-04-24 00:59:54',0,'2026-04-24 00:59:54',0),(3,'사용자관리','/user/userManage.do','Y','2026-04-24 00:59:54',0,'2026-04-24 01:00:01',0),(4,'설문관리','/survey/surveyManage.do','Y','2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(5,'설문통계','/survey/surveyStat.do','Y','2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(6,'설문참여목록','/survey/surveyList.do','Y','2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(7,'권한그룹관리','/role/roleManage.do','Y','2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(8,'메뉴별권한관리','/role/menuPerm.do','Y','2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL),(9,'권한별사용자관리','/role/userRole.do','Y','2026-05-05 06:32:57',NULL,'2026-05-05 06:32:57',NULL);
/*!40000 ALTER TABLE `program` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `q_option`
--

DROP TABLE IF EXISTS `q_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `q_option` (
  `option_no` int NOT NULL AUTO_INCREMENT COMMENT '보기 PK (AUTO)',
  `q_no` int NOT NULL COMMENT 'FK) question.board_no',
  `content` text NOT NULL COMMENT '보기 내용',
  `sort_ord` int DEFAULT NULL COMMENT '보기 정렬 순서',
  `reg_user` int DEFAULT NULL COMMENT 'FK) users.user_no 등록자',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `mod_user` int DEFAULT NULL COMMENT 'FK) users.user_no 수정자',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부 (논리삭제용)',
  PRIMARY KEY (`option_no`),
  KEY `fk_qoption_reg` (`reg_user`),
  KEY `fk_qoption_mod` (`mod_user`),
  KEY `q_option_question_FK` (`q_no`),
  CONSTRAINT `fk_qoption_mod` FOREIGN KEY (`mod_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_qoption_reg` FOREIGN KEY (`reg_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `q_option_question_FK` FOREIGN KEY (`q_no`) REFERENCES `question` (`board_no`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='질문 보기(선택지) 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `q_option`
--

LOCK TABLES `q_option` WRITE;
/*!40000 ALTER TABLE `q_option` DISABLE KEYS */;
INSERT INTO `q_option` VALUES (18,34,'r1',0,NULL,'2026-05-06 00:23:27',NULL,NULL,'Y'),(19,34,'r2',1,NULL,'2026-05-06 00:23:27',NULL,NULL,'Y'),(20,34,'r3',2,NULL,'2026-05-06 00:23:27',NULL,NULL,'Y'),(21,37,'ㅅ1',0,NULL,'2026-05-06 00:26:49',NULL,NULL,'Y'),(22,37,'ㅅ2',1,NULL,'2026-05-06 00:26:49',NULL,NULL,'Y'),(23,37,'ㅅ3',2,NULL,'2026-05-06 00:26:49',NULL,NULL,'Y'),(24,38,'ㄱㄱㄱㄱ',0,NULL,'2026-05-06 07:54:12',NULL,NULL,'Y'),(25,38,'ㄷㄷㄷㄷㄷ',1,NULL,'2026-05-06 07:54:12',NULL,NULL,'Y'),(26,38,'ㄴㄴㄴㄴㄴ',2,NULL,'2026-05-06 07:54:12',NULL,NULL,'Y');
/*!40000 ALTER TABLE `q_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question` (
  `board_no` int NOT NULL COMMENT '질문 PK (AUTO, file_master.board_no 공용)',
  `survey_no` int NOT NULL COMMENT 'FK) survey.survey_no',
  `content` text NOT NULL COMMENT '질문 내용',
  `type` varchar(255) NOT NULL COMMENT 'FK) code.code_no 문항 타입 (80010~80050)',
  `sort_ord` int DEFAULT NULL COMMENT '질문 정렬 순서',
  `is_multiple` char(1) DEFAULT NULL COMMENT '복수 선택 허용 여부 Y/N',
  `reg_user` int DEFAULT NULL COMMENT 'FK) users.user_no 등록자',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `mod_user` int DEFAULT NULL COMMENT 'FK) users.user_no 수정자',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부 (논리삭제용)',
  PRIMARY KEY (`board_no`),
  KEY `fk_question_survey` (`survey_no`),
  KEY `fk_question_reg` (`reg_user`),
  KEY `fk_question_mod` (`mod_user`),
  CONSTRAINT `fk_question_mod` FOREIGN KEY (`mod_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_question_reg` FOREIGN KEY (`reg_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_question_survey` FOREIGN KEY (`survey_no`) REFERENCES `survey` (`survey_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='설문 질문 테이블 (board_no = file_master.board_no 공용)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (34,5,'radio q','radio',0,NULL,5,'2026-05-06 00:23:27',5,'2026-05-06 00:42:50','Y'),(35,5,'aaaaa','textarea',1,NULL,5,'2026-05-06 00:23:27',5,'2026-05-06 00:42:50','Y'),(36,6,'단답질문','text',0,NULL,5,'2026-05-06 00:26:49',NULL,NULL,'Y'),(37,6,'셀렉트질문','select',1,NULL,5,'2026-05-06 00:26:49',NULL,NULL,'Y'),(38,7,'ㅓㅗㅓㅗㅓㅗ','radio',0,NULL,5,'2026-05-06 07:54:12',NULL,NULL,'Y'),(39,7,'ㅎㅎㅎㅎ','textarea',1,NULL,5,'2026-05-06 07:54:12',NULL,NULL,'Y');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `response`
--

DROP TABLE IF EXISTS `response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `response` (
  `res_no` int NOT NULL AUTO_INCREMENT COMMENT '응답 PK (AUTO)',
  `survey_no` int NOT NULL COMMENT 'FK) survey.survey_no (reg_user 복합UK)',
  `reg_user` int NOT NULL COMMENT 'FK) users.user_no 응답자',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '응답 등록일시',
  `mod_user` int DEFAULT NULL COMMENT '(예비, 응답 수정 불가)',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시 (응답 수정 불가)',
  `use_yn` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Y' COMMENT '사용여부 (응답 수정 불가)',
  PRIMARY KEY (`res_no`),
  UNIQUE KEY `uq_response_survey_user` (`survey_no`,`reg_user`),
  KEY `fk_response_reg` (`reg_user`),
  KEY `fk_response_mod` (`mod_user`),
  CONSTRAINT `fk_response_mod` FOREIGN KEY (`mod_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_response_reg` FOREIGN KEY (`reg_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_response_survey` FOREIGN KEY (`survey_no`) REFERENCES `survey` (`survey_no`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='설문 응답 헤더 (중복참여 방지 UNIQUE)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `response`
--

LOCK TABLES `response` WRITE;
/*!40000 ALTER TABLE `response` DISABLE KEYS */;
INSERT INTO `response` VALUES (2,6,5,'2026-05-06 00:41:34',NULL,NULL,'Y'),(3,6,6,'2026-05-06 02:33:37',NULL,NULL,'Y'),(4,5,6,'2026-05-06 02:33:47',NULL,NULL,'Y');
/*!40000 ALTER TABLE `response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `response_detail`
--

DROP TABLE IF EXISTS `response_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `response_detail` (
  `res_detail_no` int NOT NULL AUTO_INCREMENT COMMENT '응답 상세 PK (AUTO)',
  `res_no` int NOT NULL COMMENT 'FK) response.res_no',
  `q_no` int NOT NULL COMMENT 'FK) question.board_no 소속질문',
  `answer_content` text COMMENT '주관식 답변 텍스트 (단답형/장문형)',
  `option_no` int DEFAULT NULL COMMENT 'FK) q_option.option_no (선택형, 체크박스 복수시 행 복수)',
  PRIMARY KEY (`res_detail_no`),
  KEY `fk_resdetail_response` (`res_no`),
  KEY `fk_resdetail_option` (`option_no`),
  KEY `response_detail_question_FK` (`q_no`),
  CONSTRAINT `fk_resdetail_option` FOREIGN KEY (`option_no`) REFERENCES `q_option` (`option_no`),
  CONSTRAINT `fk_resdetail_response` FOREIGN KEY (`res_no`) REFERENCES `response` (`res_no`),
  CONSTRAINT `response_detail_question_FK` FOREIGN KEY (`q_no`) REFERENCES `question` (`board_no`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='설문 응답 상세 (문항별 답변, 체크박스 복수선택시 행 여러개)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `response_detail`
--

LOCK TABLES `response_detail` WRITE;
/*!40000 ALTER TABLE `response_detail` DISABLE KEYS */;
INSERT INTO `response_detail` VALUES (1,2,36,'안녕하세요',NULL),(2,2,37,NULL,21),(3,3,36,'tttt',NULL),(4,3,37,NULL,23),(5,4,34,NULL,18),(6,4,35,'hgjghjg',NULL);
/*!40000 ALTER TABLE `response_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sequences`
--

DROP TABLE IF EXISTS `sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sequences` (
  `name` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currval` bigint unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='시퀀스용 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sequences`
--

LOCK TABLES `sequences` WRITE;
/*!40000 ALTER TABLE `sequences` DISABLE KEYS */;
INSERT INTO `sequences` VALUES ('BOARD_COMMON_SEQ',39);
/*!40000 ALTER TABLE `sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `survey`
--

DROP TABLE IF EXISTS `survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `survey` (
  `survey_no` int NOT NULL AUTO_INCREMENT COMMENT '설문지 PK (AUTO)',
  `title` varchar(200) NOT NULL COMMENT '설문지 제목',
  `content` text COMMENT '설문지 설명/개요',
  `start_date` datetime DEFAULT NULL COMMENT '설문 참여 시작일시',
  `end_date` datetime DEFAULT NULL COMMENT '설문 마감일시',
  `use_yn` char(1) DEFAULT 'Y' COMMENT '사용여부 (관리자 직접 설정)',
  `reg_user` int DEFAULT NULL COMMENT 'FK) users.user_no 등록자',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `mod_user` int DEFAULT NULL COMMENT 'FK) users.user_no 수정자',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  PRIMARY KEY (`survey_no`),
  KEY `fk_survey_reg` (`reg_user`),
  KEY `fk_survey_mod` (`mod_user`),
  CONSTRAINT `fk_survey_mod` FOREIGN KEY (`mod_user`) REFERENCES `users` (`user_no`),
  CONSTRAINT `fk_survey_reg` FOREIGN KEY (`reg_user`) REFERENCES `users` (`user_no`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='설문지 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `survey`
--

LOCK TABLES `survey` WRITE;
/*!40000 ALTER TABLE `survey` DISABLE KEYS */;
INSERT INTO `survey` VALUES (5,'adasdsa','','2026-05-06 00:00:00','2026-05-07 00:00:00','Y',5,'2026-05-06 00:23:27',5,'2026-05-06 00:42:50'),(6,'qqqqqq3','','2026-05-06 00:00:00','2026-05-07 00:00:00','Y',5,'2026-05-06 00:26:49',NULL,NULL),(7,'ㅋㅌㅊ','ㅂㅈㄷ','2026-05-08 00:00:00','2026-05-09 00:00:00','Y',5,'2026-05-06 07:54:12',NULL,NULL);
/*!40000 ALTER TABLE `survey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `role_no` int NOT NULL AUTO_INCREMENT COMMENT '역할 PK (AUTO)',
  `role_rank` varchar(200) NOT NULL COMMENT 'FK) code.code_no 권한 레벨 (숫자형식 문자열)',
  `role_name` varchar(50) DEFAULT NULL COMMENT '역할명 (예: 관리자)',
  `role_id` varchar(100) DEFAULT NULL COMMENT '역할 식별자 (예: D70001)',
  `admin_yn` char(1) DEFAULT NULL COMMENT '관리자 여부 (Y:관리자, N:일반)',
  `use_yn` char(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부 (Y:사용, N:미사용)',
  `sort_ord` int DEFAULT NULL COMMENT '정렬 순서',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `mod_date` datetime DEFAULT NULL COMMENT '수정일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  PRIMARY KEY (`role_no`),
  KEY `fk_user_role_code` (`role_rank`),
  CONSTRAINT `fk_user_role_code` FOREIGN KEY (`role_rank`) REFERENCES `code` (`code_no`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='사용자 역할 테이블 (code 테이블과 연결)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (1,'70010','일반사용자','U70010','N','Y',1,'2026-05-05 06:32:57',NULL,NULL,NULL),(2,'70020','관리자','U70020','Y','Y',2,'2026-05-05 06:32:57',NULL,NULL,NULL),(3,'70030','시스템관리자','U70030','Y','Y',3,'2026-05-05 06:32:57',NULL,NULL,NULL),(4,'70010','테스트','U70040','N','Y',4,'2026-05-05 06:32:57',NULL,NULL,NULL);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_no` int NOT NULL AUTO_INCREMENT COMMENT '사용자 PK (AUTO)',
  `user_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '로그인 아이디',
  `user_pw` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '비밀번호 (암호화)',
  `user_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '사용자명',
  `use_yn` char(1) COLLATE utf8mb4_unicode_ci DEFAULT 'Y' COMMENT '사용여부 (Y:사용, N:미사용)',
  `role_no` int DEFAULT NULL COMMENT 'FK) user_role.role_no 사용자 역할',
  `reg_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
  `reg_user` int DEFAULT NULL COMMENT '등록자 (users.user_no)',
  `mod_date` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
  `mod_user` int DEFAULT NULL COMMENT '수정자 (users.user_no)',
  PRIMARY KEY (`user_no`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  KEY `fk_users_role` (`role_no`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_no`) REFERENCES `user_role` (`role_no`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='사용자 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (5,'root','1234','ROOT33335612312','Y',2,'2026-04-24 00:53:38',0,'2026-04-27 21:58:44',5),(6,'testuser','1234','테스트유저1111111111111111111111111','Y',1,'2026-04-26 08:39:12',5,'2026-04-26 18:50:33',5),(7,'testadmin','zxc123123!','adasd','Y',2,'2026-04-26 08:44:30',5,'2026-04-27 05:31:21',5),(8,'testadmin1','asd123123!','hhgfhgfsd','Y',1,'2026-04-26 08:48:19',5,'2026-04-26 13:06:29',8),(9,'test1231','ASD123123!','TEST123','Y',1,'2026-04-28 22:35:11',5,'2026-04-28 23:15:15',5);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'winitest'
--
/*!50003 DROP FUNCTION IF EXISTS `nextval` */;
ALTER DATABASE `winitest` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `nextval`(the_name VARCHAR(32)) RETURNS bigint unsigned
    MODIFIES SQL DATA
    DETERMINISTIC
begin

        declare ret BIGINT unsigned;

        update SEQUENCES set currval = currval +1 where name = the_name;

        select currval into ret from SEQUENCES where name = the_name limit 1;

        return ret;

    end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `winitest` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `create_sequence` */;
ALTER DATABASE `winitest` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_sequence`(IN the_name text)
    MODIFIES SQL DATA
    DETERMINISTIC
begin

        delete from SEQUENCES where name = the_name;

        insert into SEQUENCES values(the_name, 0);

    end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `winitest` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
/*!50003 DROP PROCEDURE IF EXISTS `users` */;
ALTER DATABASE `winitest` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `users`(IN count INT)
BEGIN

    DECLARE i INT DEFAULT 1;

    WHILE i <= 100 DO

        INSERT INTO users

        (

            user_id

            , user_pw

            , user_name

            , reg_date

            , reg_user

            , mod_date

            , mod_user

            , `role`

            , status

        )

        VALUES(

            CONCAT('dummyuser', i)

            , '1234'

            , CONCAT('더미유저', i)

            , CURRENT_TIMESTAMP

            , NULL

            , CURRENT_TIMESTAMP

            , NULL

            , 'USER'

            , 'ACTIVE'

        );

        SET i = i + 1;

    END WHILE;

    

	-- // 한 번에 업데이트 (핵심)

    UPDATE users

    SET reg_user = user_no

    WHERE reg_user IS NULL;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
ALTER DATABASE `winitest` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-06  8:43:42
