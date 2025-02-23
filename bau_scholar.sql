-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: bauscholar
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Current Database: `bauscholar`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bauscholar` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `bauscholar`;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_customuser'),(22,'Can change user',6,'change_customuser'),(23,'Can delete user',6,'delete_customuser'),(24,'Can view user',6,'view_customuser'),(25,'Can add publication',7,'add_publication'),(26,'Can change publication',7,'change_publication'),(27,'Can delete publication',7,'delete_publication'),(28,'Can view publication',7,'view_publication'),(29,'Can add followers',8,'add_followers'),(30,'Can change followers',8,'change_followers'),(31,'Can delete followers',8,'delete_followers'),(32,'Can view followers',8,'view_followers'),(33,'Can add conversation',9,'add_conversation'),(34,'Can change conversation',9,'change_conversation'),(35,'Can delete conversation',9,'delete_conversation'),(36,'Can view conversation',9,'view_conversation'),(37,'Can add message',10,'add_message'),(38,'Can change message',10,'change_message'),(39,'Can delete message',10,'delete_message'),(40,'Can view message',10,'view_message'),(41,'Can add profile',11,'add_profile'),(42,'Can change profile',11,'change_profile'),(43,'Can delete profile',11,'delete_profile'),(44,'Can view profile',11,'view_profile'),(45,'Can add event',12,'add_event'),(46,'Can change event',12,'change_event'),(47,'Can delete event',12,'delete_event'),(48,'Can view event',12,'view_event'),(49,'Can add online user activity',13,'add_onlineuseractivity'),(50,'Can change online user activity',13,'change_onlineuseractivity'),(51,'Can delete online user activity',13,'delete_onlineuseractivity'),(52,'Can view online user activity',13,'view_onlineuseractivity'),(53,'Can add completed task',14,'add_completedtask'),(54,'Can change completed task',14,'change_completedtask'),(55,'Can delete completed task',14,'delete_completedtask'),(56,'Can view completed task',14,'view_completedtask'),(57,'Can add task',15,'add_task'),(58,'Can change task',15,'change_task'),(59,'Can delete task',15,'delete_task'),(60,'Can view task',15,'view_task');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `background_task`
--

DROP TABLE IF EXISTS `background_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `background_task` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_name` varchar(190) NOT NULL,
  `task_params` longtext NOT NULL,
  `task_hash` varchar(40) NOT NULL,
  `verbose_name` varchar(255) DEFAULT NULL,
  `priority` int NOT NULL,
  `run_at` datetime(6) NOT NULL,
  `repeat` bigint NOT NULL,
  `repeat_until` datetime(6) DEFAULT NULL,
  `queue` varchar(190) DEFAULT NULL,
  `attempts` int NOT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `last_error` longtext NOT NULL,
  `locked_by` varchar(64) DEFAULT NULL,
  `locked_at` datetime(6) DEFAULT NULL,
  `creator_object_id` int unsigned DEFAULT NULL,
  `creator_content_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `background_task_creator_content_type_61cc9af3_fk_django_co` (`creator_content_type_id`),
  KEY `background_task_task_name_4562d56a` (`task_name`),
  KEY `background_task_task_hash_d8f233bd` (`task_hash`),
  KEY `background_task_priority_88bdbce9` (`priority`),
  KEY `background_task_run_at_7baca3aa` (`run_at`),
  KEY `background_task_queue_1d5f3a40` (`queue`),
  KEY `background_task_attempts_a9ade23d` (`attempts`),
  KEY `background_task_failed_at_b81bba14` (`failed_at`),
  KEY `background_task_locked_by_db7779e3` (`locked_by`),
  KEY `background_task_locked_at_0fb0f225` (`locked_at`),
  CONSTRAINT `background_task_creator_content_type_61cc9af3_fk_django_co` FOREIGN KEY (`creator_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `background_task_chk_1` CHECK ((`creator_object_id` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `background_task`
--

LOCK TABLES `background_task` WRITE;
/*!40000 ALTER TABLE `background_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `background_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `background_task_completedtask`
--

DROP TABLE IF EXISTS `background_task_completedtask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `background_task_completedtask` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `task_name` varchar(190) NOT NULL,
  `task_params` longtext NOT NULL,
  `task_hash` varchar(40) NOT NULL,
  `verbose_name` varchar(255) DEFAULT NULL,
  `priority` int NOT NULL,
  `run_at` datetime(6) NOT NULL,
  `repeat` bigint NOT NULL,
  `repeat_until` datetime(6) DEFAULT NULL,
  `queue` varchar(190) DEFAULT NULL,
  `attempts` int NOT NULL,
  `failed_at` datetime(6) DEFAULT NULL,
  `last_error` longtext NOT NULL,
  `locked_by` varchar(64) DEFAULT NULL,
  `locked_at` datetime(6) DEFAULT NULL,
  `creator_object_id` int unsigned DEFAULT NULL,
  `creator_content_type_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `background_task_comp_creator_content_type_21d6a741_fk_django_co` (`creator_content_type_id`),
  KEY `background_task_completedtask_task_name_388dabc2` (`task_name`),
  KEY `background_task_completedtask_task_hash_91187576` (`task_hash`),
  KEY `background_task_completedtask_priority_9080692e` (`priority`),
  KEY `background_task_completedtask_run_at_77c80f34` (`run_at`),
  KEY `background_task_completedtask_queue_61fb0415` (`queue`),
  KEY `background_task_completedtask_attempts_772a6783` (`attempts`),
  KEY `background_task_completedtask_failed_at_3de56618` (`failed_at`),
  KEY `background_task_completedtask_locked_by_edc8a213` (`locked_by`),
  KEY `background_task_completedtask_locked_at_29c62708` (`locked_at`),
  CONSTRAINT `background_task_comp_creator_content_type_21d6a741_fk_django_co` FOREIGN KEY (`creator_content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `background_task_completedtask_chk_1` CHECK ((`creator_object_id` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `background_task_completedtask`
--

LOCK TABLES `background_task_completedtask` WRITE;
/*!40000 ALTER TABLE `background_task_completedtask` DISABLE KEYS */;
INSERT INTO `background_task_completedtask` VALUES (1,'scholarapp.utils.common.send_email_notification','[[\"Imane Haidar\", \"Mohammad Ayache\", \"Hello\", \"DDOS LLM Group\"], {}]','982e9cfaa61891a68d15abd5b60244635b87f549',NULL,0,'2025-01-11 17:33:34.978965',0,NULL,NULL,1,NULL,'','32318','2025-01-11 17:33:30.254125',NULL,NULL),(2,'scholarapp.utils.common.send_email_notification','[[\"Imane Haidar\", \"Ziad Doughan\", \"Hello\", \"DDOS LLM Group\"], {}]','f6924ee7ef6f6ae1e89f4de831b1d0c183a0ed81',NULL,0,'2025-01-11 17:33:38.759580',0,NULL,NULL,1,NULL,'','32318','2025-01-11 17:33:35.024100',NULL,NULL),(3,'scholarapp.utils.common.send_email_notification','[[\"Imane Haidar\", \"Mohammad Ayache\", \"Hi\", \"DDOS LLM Group\"], {}]','b7494ca50f5d499076413d771bcd19e62f710c86',NULL,0,'2025-01-11 17:33:51.974627',0,NULL,NULL,1,NULL,'','32318','2025-01-11 17:33:48.884260',NULL,NULL),(4,'scholarapp.utils.common.send_email_notification','[[\"Imane Haidar\", \"Ziad Doughan\", \"Hi\", \"DDOS LLM Group\"], {}]','bdbcd775f1c3cfec75a935aef33887a06b03accc',NULL,0,'2025-01-11 17:34:05.646123',0,NULL,NULL,1,NULL,'','32318','2025-01-11 17:33:52.088883',NULL,NULL);
/*!40000 ALTER TABLE `background_task_completedtask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_scholarapp_customuser_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_scholarapp_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `scholarapp_customuser` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(14,'background_task','completedtask'),(15,'background_task','task'),(4,'contenttypes','contenttype'),(13,'online_users','onlineuseractivity'),(9,'scholarapp','conversation'),(6,'scholarapp','customuser'),(12,'scholarapp','event'),(8,'scholarapp','followers'),(10,'scholarapp','message'),(11,'scholarapp','profile'),(7,'scholarapp','publication'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-08-12 07:28:27.546983'),(2,'contenttypes','0002_remove_content_type_name','2024-08-12 07:28:27.737090'),(3,'auth','0001_initial','2024-08-12 07:28:28.765400'),(4,'auth','0002_alter_permission_name_max_length','2024-08-12 07:28:29.019471'),(5,'auth','0003_alter_user_email_max_length','2024-08-12 07:28:29.030685'),(6,'auth','0004_alter_user_username_opts','2024-08-12 07:28:29.045313'),(7,'auth','0005_alter_user_last_login_null','2024-08-12 07:28:29.062909'),(8,'auth','0006_require_contenttypes_0002','2024-08-12 07:28:29.074661'),(9,'auth','0007_alter_validators_add_error_messages','2024-08-12 07:28:29.100279'),(10,'auth','0008_alter_user_username_max_length','2024-08-12 07:28:29.118308'),(11,'auth','0009_alter_user_last_name_max_length','2024-08-12 07:28:29.135525'),(12,'auth','0010_alter_group_name_max_length','2024-08-12 07:28:29.170637'),(13,'auth','0011_update_proxy_permissions','2024-08-12 07:28:29.184542'),(14,'auth','0012_alter_user_first_name_max_length','2024-08-12 07:28:29.195730'),(15,'scholarapp','0001_initial','2024-08-12 07:28:30.700432'),(16,'admin','0001_initial','2024-08-12 07:28:31.128175'),(17,'admin','0002_logentry_remove_auto_add','2024-08-12 07:28:31.142940'),(18,'admin','0003_logentry_add_action_flag_choices','2024-08-12 07:28:31.159348'),(19,'scholarapp','0002_following_customuser_following','2024-08-12 07:28:31.615810'),(20,'scholarapp','0003_remove_customuser_following_followers_and_more','2024-08-12 07:28:32.089908'),(21,'scholarapp','0004_alter_publication_author_str_alter_publication_title','2024-08-12 07:28:32.150782'),(22,'scholarapp','0005_conversation_message','2024-08-12 07:28:33.389703'),(23,'scholarapp','0006_message_message','2024-08-12 07:28:33.453588'),(24,'sessions','0001_initial','2024-08-12 07:28:33.571456'),(25,'scholarapp','0007_publication_external_link','2024-08-27 19:48:03.052675'),(26,'scholarapp','0008_customuser_profile_info','2024-09-03 16:48:55.606371'),(27,'scholarapp','0009_remove_customuser_profile_info_profile','2024-09-03 18:16:05.051146'),(28,'scholarapp','0010_alter_profile_user','2024-09-03 19:32:30.196734'),(29,'scholarapp','0011_profile_department_profile_development_activities_and_more','2024-09-03 20:12:39.966244'),(30,'scholarapp','0012_remove_customuser_skills_remove_customuser_tags_and_more','2024-09-08 17:03:10.497675'),(31,'scholarapp','0013_alter_profile_staff_member_achievements','2024-09-11 16:04:56.941566'),(32,'scholarapp','0014_event_delete_publication','2024-09-11 19:35:49.972154'),(33,'scholarapp','0015_alter_event_date_created_alter_event_event_type','2024-09-11 20:42:11.024382'),(34,'scholarapp','0016_alter_event_event_type','2024-09-11 21:20:24.799919'),(35,'scholarapp','0017_alter_event_event_type','2024-09-11 21:24:13.796547'),(36,'scholarapp','0018_event_attendees','2024-09-16 11:35:34.817719'),(37,'scholarapp','0019_conversation_description_conversation_title','2024-10-19 17:21:12.118799'),(38,'scholarapp','0020_event_tags','2024-10-20 18:33:51.889326'),(39,'scholarapp','0021_conversation_group_icon','2024-10-25 20:49:00.436817'),(40,'scholarapp','0022_alter_conversation_group_icon','2024-10-25 21:07:49.988988'),(41,'scholarapp','0023_alter_conversation_group_icon','2024-10-25 21:14:10.966294'),(42,'scholarapp','0024_alter_conversation_group_icon','2024-10-25 21:15:58.177572'),(43,'scholarapp','0025_alter_conversation_group_icon','2024-10-25 21:26:28.040790'),(44,'scholarapp','0026_alter_conversation_group_icon','2024-10-25 21:27:25.298641'),(45,'scholarapp','0027_alter_conversation_group_icon','2024-10-25 21:55:31.699142'),(46,'scholarapp','0028_alter_conversation_group_icon','2024-10-25 21:56:10.402075'),(47,'scholarapp','0029_alter_conversation_group_icon','2024-10-26 15:15:34.287164'),(48,'scholarapp','0030_remove_message_user_to','2024-10-26 15:21:43.360512'),(49,'scholarapp','0031_alter_conversation_description_and_more','2024-10-27 17:10:01.936050'),(50,'scholarapp','0032_alter_conversation_group_icon','2024-10-27 20:55:24.214550'),(51,'online_users','0001_initial','2024-10-30 23:29:41.888343'),(52,'background_task','0001_initial','2025-01-11 13:37:23.333908'),(53,'background_task','0002_auto_20170927_1109','2025-01-11 13:37:23.363701'),(54,'background_task','0003_alter_completedtask_id_alter_task_id','2025-01-23 18:39:41.019656'),(55,'scholarapp','0033_alter_customuser_avatar_alter_event_author_str','2025-01-23 18:39:41.282024'),(56,'scholarapp','0034_remove_customuser_profile_url','2025-01-23 18:40:19.161703');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0oacyc4phsflknazk8s9lwd168pzxs07','.eJxVzMEOwiAQBNB_4WwIhaVuPXr3Gwgsi1QNJKU9Gf9dmvSg15k38xbOb2t2W-PFzVFcBIjTbxY8PbnsRXz4cq-SalmXOcidyKNt8lYjv66H_TvIvuW-VpbSxBFMNAHYKjyjJkJGjWiN12DVqKcuUKlhYCDSqWuIyZCG0YjPF9XHN0o:1t6IAO:Lmk2ToxzVmFoVAOWZZrfgP4MnKELvqEWuSfHqAbnkkU','2024-11-13 23:31:56.852573'),('11c74czopv1p2dazhzwpcdfe47902ixn','eyJuZXh0IjoiLyJ9:1tb2GY:ld6wJDmFH4ROH9qNhDtc9XmxmEnQ-oS_zXtcCbe7rhU','2025-02-06 18:49:22.580150'),('1cyq0p5w10ulmm75pfb97fferkbksl1c','eyJuZXh0IjoiLyJ9:1tcXRp:XIuyW8HWoCsIi44YMq4Qsu32-pgMdiJAvB4JpIHGjWs','2025-02-10 22:19:13.015781'),('1it7vnr5sl8wcm0mod2jwpjlblkw8sya','.eJxVjMEOwiAQBf-Fs8GlQEGP3v0GssAiVQNJoYmJ8d9tk156nZn3vqzQp7MrO7MTc7j07JZGs5viysSReQwvKpuITyyPykMtfZ483xK-28bvNdL7treHg4wtr2ukpMHKC0U7oEWwYIXQWtMANBIMScoxyCQ0gQYTlVQok_JkwJtkybDfH884Okg:1sjaX7:MymUDJHnvCDcJnoXYMnY9u_-tsBpII5DQXCgJvvYOK0','2024-09-12 08:29:33.640631'),('1n9eafucrx9ngp29z5fh2eyvjrgvc0zc','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1t4Rok:EUpreXz3KMjnmLgnUzCv230F2w_JHoDWVLcRN_EWe7g','2024-11-08 21:25:58.988729'),('1sev21dhhds6ql3i02styltslhs95g9w','eyJuZXh0IjoiLyJ9:1tcXJo:QPf6-5KWXeZ7xlw2zgw1HigoWOssek7kiMe-_RwIalg','2025-02-10 22:10:56.175851'),('2tc5p63q8u0lj9gqn2f8615wvk7hah2z','.eJxVjMsOwiAQRf-FtSHhJeDSvd9AhmFGqgaS0q6M_26bdKHbc869b5FgXWpaB81pKuIilDj9sgz4pLaL8oB27xJ7W-Ypyz2Rhx3y1gu9rkf7d1Bh1G1tgnY2RustFkCiwvpsOSi0wE5lp9Czi2CQA7kNWB194WA0EGJ0JD5f7EY4ew:1ti983:nOEUWfhSf_0aNxge1q6-dbm7TqIQrkyYpm4IpQXw2A8','2025-02-26 09:33:59.020563'),('5366hd243s6an0nuud5x5sywouq90o2q','.eJxVjMEOwiAQBf-Fs8GlQEGP3v0GssAiVQNJoYmJ8d9tk156nZn3vqzQp7MrO7MTc7j07JZGs5viysSReQwvKpuITyyPykMtfZ483xK-28bvNdL7treHg4wtr2ukpMHKC0U7oEWwYIXQWtMANBIMScoxyCQ0gQYTlVQok_JkwJtkybDfH884Okg:1sroc9:Jf09V3Aj0uWcMzWm5NvrvYvWDjLROiPYhzZOHoiqWTI','2024-10-05 01:08:45.838410'),('631e4rakbjq0vl97nsnhx4vw8z0cqxv6','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1t4NOi:GqDOgKYLY4ZziGnnkYgMTwVHnCBQ0VRWPjXlWd8CaBc','2024-11-08 16:42:48.943999'),('6dniuw2trwuyd7wp1ds1sryurvj0lsti','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1tM0lF:mc2qeLQtI-2hWiLH7_O-WamGIGW38g2bJZu0eJTgTDE','2024-12-27 08:10:57.317575'),('6rurh9ct6vj5hi00w3bpht5c4dwst9l8','eyJuZXh0IjoiLyJ9:1tcXEs:UWGlt41aQv_4FHy1wLBcR_1dpKdiUtsslbrF0FibSJU','2025-02-10 22:05:50.874507'),('7ks5pg07srb6g5761fctte0kgdfbefm0','.eJxVjEEOwiAQRe_C2pBhoIVx6d4zNMCAVA0kpV0Z765NutDtf-_9l5j8tpZp62mZZhZngeL0uwUfH6nugO--3pqMra7LHOSuyIN2eW2cnpfD_TsovpdvDREDJcCBjXHJWlQIaHJkHCgA5gBaGxgS5RGdVn7MQFYTE2W2Lirx_gC-qDbo:1t59F5:uwl13hP2ktnfPdcPkPZfK49AIyPqSa4Jrv8cZCdGaOw','2024-11-10 19:48:03.016717'),('7okvqyulheik5nmup63zpg7xuyu7jyn8','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1sizaw:FwUvXN2s5J2W9TLCFQfOioeJmHLb4_FsbFSEBlJ_rnA','2024-09-10 17:03:02.199869'),('97expjr52nswa32slz5gx9lwz6nu8pj0','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snKLD:_TuO8MkNXHegIPIcAPwU_CZKcN1IfQ1-MjzcmnX0uFM','2024-09-22 16:00:43.919405'),('98gq796gp36kb2kjf22u7j8xmjlkwaju','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1sjDUY:y9SAzhMQNDPk6My_uDhIpAHzkM5xdp2DsB_USP_6p_Y','2024-09-11 07:53:22.022206'),('a0bcuf8f8kd1uanrsp9097714xswwuur','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t4RpQ:laqmYReOS2k6QWz03Ycsgfli1W3VzaPKO2bn_H74cI8','2024-11-08 21:26:40.551154'),('a3neptwhtzjkt24f91qr4b0dleeapqnk','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1spshb:Y698qSzH6pjFll0oPkYnxw4zU3OKaI2EjHTw-wGKzFA','2024-09-29 17:06:23.040190'),('apb5eia6efy0gvs0j84cjwauy0qnlp2d','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t6IaM:-KB_5tD9EytIOcLV4wK4QlKRSx6R1JxS0NyKGEROrkU','2024-11-13 23:58:46.228167'),('b4df3irli1l2k7w9xjn31pn0jm5dfjrq','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1stpq1:yjAIxrDRy1vFhMuuVWzmp-4mBLwpo5me_Ai5MuBUxjg','2024-10-10 14:51:25.934111'),('bjmj9h3ekj8me8yy0cf9wpj9h7fztxrm','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1swQFI:0Xt-tHYTFJQ8KFneOcV3TsqbiCpA--l_m1w2mwOR21M','2024-10-17 18:08:12.166278'),('bjunky3uvg72cvdiq407e0fsmf6mqj44','eyJuZXh0IjoiLyJ9:1tKKHH:8HN1oZnEcN9L-qMMf2AAnhxWCj2ZdPCblLhfCA35DLY','2024-12-22 16:37:03.218938'),('bv3e5xxq31orld3yy1rrmxvfhkb53qvm','eyJfcGFzc3dvcmRfcmVzZXRfdG9rZW4iOiJjazczZXotMGViYjZiY2UwZGI0MzIxNTY5OTdkZTM2YWFiZTQ0NWQifQ:1tbja3:HiTTF7jtMe-EDsiHIqtZJ7pAeNeFgEGJa5LQydeGTSw','2025-02-08 17:04:23.158751'),('bxxqxz1lxizh1rzlaeh6od95qtmu5hhv','eyJuZXh0IjoiLyJ9:1tbinU:-21XToC0_iOZGi6SsHGeM1Rsv7rR7zOLme4niTfYLR0','2025-02-08 16:14:12.302686'),('d03js1wml5jcyp0vo8zjjolvl9noofkm','.eJxVjEEOwiAQRe_C2hAoMwVcuvcMZBhAqqYkpV0Z765NutDtf-_9lwi0rTVsPS9hSuIsjDj9bpH4kecdpDvNtya5zesyRbkr8qBdXlvKz8vh_h1U6vVbA9pcCAnBAgDrVJjMEAciw94X9ONotSYFDlGVQeeYwBvlFGtU0bF4fwDeIDdk:1tdqAM:Wu_NlUH_FvQlnOsFvnjPOIDE6hDHq7wd4zw4Cy-jb0E','2025-02-14 12:30:34.974978'),('dhak0ui5ofvbf50wrcl4vtp5si1twi0j','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1st8P1:IrKWyVS5ldDLWK369HWpbe8cZBcA_9bKj8VkiXedvcI','2024-10-08 16:28:39.214649'),('dhyq5vd79fawrxim09n06j3dsbn8lauw','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1slZD7:ixyt-I4aEoNUTS1CSdJB_pa5wvEXlaYVxLG3gk0DNjs','2024-09-17 19:29:05.906149'),('dmz5jr8uj9si11yw8pxlaqff5f8s2ony','.eJxVjMsOwiAUBf-FtUHgtjxcdu83EB4XqRpICk1MjP9um3TT7cyc8yUFP53cyJVciHVrz3ZtuNg5bgzOzLvwwrKL-HTlUWmopS-zp3tCD9vovUZ8T0d7Osiu5W0tB2WiShANDEYHGBCMdqggcS8QgpCMjwmFFtwrKZMSAT1nI4rE0LFIfn_OqDqI:1sgU0w:03aPYOzaUzFzXhXav0XztpEdZr8-MyHx6jEhkWflvc4','2024-09-03 18:55:30.056345'),('ebwizjhr4iltp6j8sxmjgmhwxxs45sj6','eyJuZXh0IjoiLyJ9:1tKKMt:1wz5bD6CgHgxkKNOz5kqxal7XBIzVe61su7sKfuOqdo','2024-12-22 16:42:51.480586'),('egf7z5h42ifuv2giuek5vipdztiznev7','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t4Rp1:a3yJWPEYRlMBAxfwXx_-i-T0d87Ze_gF-2TcRFAMa7o','2024-11-08 21:26:15.828124'),('em5aau3tdrepoes9eib58yl7x2npd1ce','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snvpU:rUDMRw3vWY9Ex9sZlllgHg9InkdEU-005focRioLaag','2024-09-24 08:02:28.122545'),('eoxp0e45p33v4ocv6bl5dqrsfki2rme8','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snPgk:gxLnO7ijFWq28xaF8z8yZstkl3-rPO2kGBX31NY-oYI','2024-09-22 21:43:18.774119'),('er3ay6degpb86gh7mfyo1ircfhcd4ves','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1t6PXm:Hyhttp8DH_EufOuONZJ9nyiqxd_vReSrJnOIzMKJaEk','2024-11-14 07:24:34.081090'),('fm9t5idb0n6dz7qx2caxbfxopomn7ink','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1shbon:RIsnftRrwl-Y7fVL0xrk9euXCQ0UmWj94rlaThSpGmw','2024-09-06 21:27:37.753993'),('fn1z46l2qfeuuzvrh7dc23gchm1aqcod','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1srK2D:xMeqheTgg6nfvZwkP7cZaE4LMBJJWn7M4-HHA4jNp9E','2024-10-03 16:29:37.316088'),('fy72vmeqc5evh0ocihcqzz7vkwauk2kt','eyJuZXh0IjoiLyJ9:1tYXDa:cGMZRu0RySNyAvJPSIy4fdOfs7kmo9XWR6LVIy8nXsQ','2025-01-30 21:15:58.117304'),('gh0dwh4x2ri3bfk61p6idnr8bmliw1c9','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1spCgz:f3Gq1sZiR4irKlTrPS_XGIZDpeCTMvLeA5G9WoqOnLs','2024-09-27 20:14:57.987506'),('ghon6xu8442tsfnqfpexb3dn8i1u1qkh','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t6NpJ:DIlNAjFrnSBrl2fOOIhTeZaGIwp7MRPgxLtrUMoYpkY','2024-11-14 05:34:33.205585'),('gvg5ykl07uzfysu9o7aq8jkxo1k8gsm8','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1sdPnd:eyqteLs0mAL8ZU0uiLLq7bPHz2HA70ImGlw56K0qt4E','2024-08-26 07:49:05.472478'),('hzgcpd41zj1k0zc029b5v2606l5rp3ke','eyJuZXh0IjoiLyJ9:1tbiy2:oyr97hRizlBUSCQMgZV2yYhtr-KQqF3OSb-iY0qXp80','2025-02-08 16:25:06.008011'),('i3e6xcupzoowm6n2itznlo4f4b05051b','eyJuZXh0IjoiLyJ9:1tLqPF:uUMJkqgaxuFLTI2K9Bhvfztfng7T5Dqa89hclUqCpFU','2024-12-26 21:07:33.467275'),('i82izqdrszkcydfmf9t4xua6a84jvd61','eyJuZXh0IjoiLyJ9:1tbioC:hN8bltPH7fKLzv5pE6Bw64W_Mlqv-XeeSIdlR0l4Eho','2025-02-08 16:14:56.205900'),('izv5i7wv1pg906de1yk0fe2t3yni0trl','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t05hR:63W46xxRhcImoNeEChlx3LFvVg7uw2Bt9eEg_EAQDwk','2024-10-27 21:00:25.860001'),('jec8vq21dgsnlhyelk3dgunh0qc6a2uh','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1srK5Y:teghBHtMz8EOedTnbeb00JkSgWk-KT8WOCAU2Ybm-98','2024-10-03 16:33:04.912739'),('kkbwzqedqv5jkwvec7sm16sm62kqjkju','.eJxVjMEOwiAQBf-Fs8GlQEGP3v0GssAiVQNJoYmJ8d9tk156nZn3vqzQp7MrO7MTc7j07JZGs5viysSReQwvKpuITyyPykMtfZ483xK-28bvNdL7treHg4wtr2ukpMHKC0U7oEWwYIXQWtMANBIMScoxyCQ0gQYTlVQok_JkwJtkybDfH884Okg:1snLcs:NBkyqdNRWXy1nQobio-fHgBWjsp4XooNwfQDrmKzHC0','2024-09-22 17:23:02.732598'),('l2r00e3qy9ep0258pu3p7iuhel64b5yq','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1slmA0:4XVwXGegYhmJNCQxYJ87lmv7CS_23x3fxKrXB3Um_Kk','2024-09-18 09:18:44.152879'),('l4wl52jzpfhb9sm4a5x8nz8ygzcx6hyb','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1sjDV5:7--7aLQaECwits-9JEmkVnTDaKWlYp7aRn3h9hWl7Z4','2024-09-11 07:53:55.330452'),('l97733cpkac5i7ygo0d8kutgp78a7mci','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2Ceo:qPuz91IvT0BFBqZqkc1LlsBSbN_kFZHTTaWwHVrr6XM','2024-11-02 16:50:26.359250'),('l9eadxe182jk6c8dnfu03qrcd82pvvpc','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1swR81:eHnfDYPo2aGCYh7ENT87pkQhQmao8RC13VolTMkDpw0','2024-10-17 19:04:45.771164'),('lmwgt2jca0d9o9kpw22gi047z6nnirrm','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t6IkD:WyQMZk9zfbu2UloAxt4FlYmaFR3_5O0yPp2t9xXn1oo','2024-11-14 00:08:57.027988'),('m8dypbfpjcy1s5unn0my2b72cfl77ymq','.eJxVjEEOwiAQRe_C2pBhoIVx6d4zNMCAVA0kpV0Z765NutDtf-_9l5j8tpZp62mZZhZngeL0uwUfH6nugO--3pqMra7LHOSuyIN2eW2cnpfD_TsovpdvDREDJcCBjXHJWlQIaHJkHCgA5gBaGxgS5RGdVn7MQFYTE2W2Lirx_gC-qDbo:1shbme:5n5DuSvKnYvCXf43tu-jC5gcYM4nMniFY_7dS2-JhuI','2024-09-06 21:25:24.960772'),('mi3pl5rxu15uq0n1mrx87fzb7mqrbgwc','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t57Mq:A_55jguEyYQtWAT1js5hJCjV_eDR7_PMc2Lb9_qkGRs','2024-11-10 17:47:56.153008'),('mpgbgheg71bnwr3brlx9sa0fayry7q5u','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2CkG:IPeIKZzpYJOZv3AOGlsPJOqEt9RAqxphLlo_yMfnn20','2024-11-02 16:56:04.160447'),('mspev0pdp56o9zswn61acw18hs8gh4ui','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snksf:FZOCEjzMedY_T5f4Yaf02fkvA8LPSjmKh7hQbeyrw54','2024-09-23 20:21:01.225093'),('n0d8zc0ph0p2zj9u9d98kndv5nx30a09','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1slmJk:GMB8FKwmhYiHbHSJ8D4OAIgs6219AqXKT9SD1ShbfFk','2024-09-18 09:28:48.649553'),('ndcoonqzhirlczp600p3ni4fxk1bgrx2','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t05hI:FY013MWVCNzEMZAkv5k1Qfi2491cH_GUA83GYA1_Fm0','2024-10-27 21:00:16.719530'),('njxzc4331jpqs5oaxxheupyc313zlhwm','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2ChY:TziiIEgOGglHKcdW9dt-jXrOaCYNes1enQhQH5z3AJE','2024-11-02 16:53:16.861243'),('oklrfweru7uijzvit8qr3auihabqziie','.eJxVjMsOwiAUBf-FtUHgtjxcdu83EB4XqRpICk1MjP9um3TT7cyc8yUFP53cyJVciHVrz3ZtuNg5bgzOzLvwwrKL-HTlUWmopS-zp3tCD9vovUZ8T0d7Osiu5W0tB2WiShANDEYHGBCMdqggcS8QgpCMjwmFFtwrKZMSAT1nI4rE0LFIfn_OqDqI:1tM0tv:HhtuEJO2-r8P04dEkBdlayQrp3JJuFzn2fmQm3Mf75E','2024-12-27 08:19:55.905014'),('omvmlhdpodfmnowd9cgqrktz4nykj3ug','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1slmDY:zfwaj30QZ-xQyz4x2GZqXzxr1SSHilI9wL2z6AHnMXc','2024-09-18 09:22:24.793662'),('ovf2enbassctyoa118zfntwg88yrzqqz','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2FC6:uyMG8mSDbuvaCa7Mx1jxrT9nYzNqoPdEPpQX1ppD6o8','2024-11-02 19:32:58.401616'),('p19iysgfh2cowwaaq6t3z3v073zf3ozn','eyJuZXh0IjoiLyJ9:1tLqO9:qYmwlyDM5Ie2N1Y2Idzpdiy1k7GrTEYKsKcehdY0oCk','2024-12-26 21:06:25.575353'),('p44kg1zj2lue0w5rymjkothp70ikdmsz','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1siHT8:mL6NkULJu9P1dRY971U77d73tYnblW4P9Tc8tD4qUCs','2024-09-08 17:56:02.364610'),('pcyi7xwye3ev1ahunwbiwtzxe14m9o6k','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t59Dh:ZtsFqpfLQGV8j-yzedbNNpxMAJY33TvldN603bbM8h8','2024-11-10 19:46:37.841837'),('pggcs3nrwf7zojlz4ypuv2vaku7ugibq','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2E0F:t-mg6J05IXIedbqz0zbTCc_b8R2vqLMYzgqGgsTUheE','2024-11-02 18:16:39.164044'),('pnvt7jwqwoz5hb2ux000fwqygh7xdsdq','.eJxVjEEOwiAQRe_C2pBhoIVx6d4zNMCAVA0kpV0Z765NutDtf-_9l5j8tpZp62mZZhZngeL0uwUfH6nugO--3pqMra7LHOSuyIN2eW2cnpfD_TsovpdvDREDJcCBjXHJWlQIaHJkHCgA5gBaGxgS5RGdVn7MQFYTE2W2Lirx_gC-qDbo:1tebi0:cNvQJyGaC-BD9CuPsB8zQL8_0oiiQMG8syVPZ4AuRbQ','2025-02-16 15:16:28.589197'),('q51w461wyv5buu2fpik5glwiy47ksfta','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2Cg9:RgB1U11PL76TbDlHHNEDRQ_H5ZxENNPFHiqHFJUl9eU','2024-11-02 16:51:49.922181'),('r96rpx6093sb291m3gkyi9ghhgq0vw7x','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snkai:V1X4vpfeRqHraVfPJxfz73y7R1fyhSlCagk_E4gkdvQ','2024-09-23 20:02:28.710571'),('t4lu46dmzygfdipf4d9zw0fzcsaftweo','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1sqTW9:mb8yM9rdkiTVDGVYhw8az3qUtzJTytTO_Rfiubc_RSA','2024-10-01 08:25:01.726691'),('tv62g8rs2bz2h9juygo1ok73ksu3ym4z','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t2ClE:j07gsYtnpF-e6DnImVTZDxPML3dfjw5r_KF9ZW49o5A','2024-11-02 16:57:04.667396'),('ufyrzpari1pjiq3hkl7ewq796ocpefz1','.eJxVjEEOwiAQRe_C2pBhoIVx6d4zNMCAVA0kpV0Z765NutDtf-_9l5j8tpZp62mZZhZngeL0uwUfH6nugO--3pqMra7LHOSuyIN2eW2cnpfD_TsovpdvDREDJcCBjXHJWlQIaHJkHCgA5gBaGxgS5RGdVn7MQFYTE2W2Lirx_gC-qDbo:1t4loG:v77qW5UlFcUdGqqxJaS2j6axXNJjF-FCuBJkHCkl118','2024-11-09 18:46:48.504206'),('upcf5g2gp6cjjxlsjjempi6108du4del','.eJxVjEEOwiAQRe_C2hAoMwVcuvcMZBhAqqYkpV0Z765NutDtf-_9lwi0rTVsPS9hSuIsjDj9bpH4kecdpDvNtya5zesyRbkr8qBdXlvKz8vh_h1U6vVbA9pcCAnBAgDrVJjMEAciw94X9ONotSYFDlGVQeeYwBvlFGtU0bF4fwDeIDdk:1tdYzS:pyDC3VZr3FnF6_rLbC8YwVCMZ7qWxKOP3w5kqrhW8pc','2025-02-13 18:10:10.125035'),('utj2w13qrrgbhttn49s55mrmo2v1hsi1','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1ssQeh:Q3aUdyhal2D6w66g8dEVd3cu4XqbQRwfydtIF01O858','2024-10-06 17:45:55.676559'),('v02fho4r3a665xm1umswsais6m4qw01u','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snkCh:is5AYLldm5im0KH98lmqwG6KCbFZfZf4HM6o81eMR9c','2024-09-23 19:37:39.400933'),('v39h88n91hbmzurh4asg0g0y0m6yqdys','eyJuZXh0IjoiLyJ9:1tbiqC:ThB7hO_vOt5eucEZPyct2Ws8ty8eX_WA62kQNWVTY6o','2025-02-08 16:17:00.000980'),('v81cirksx7k94npktslk630j5zppdy5m','eyJuZXh0IjoiLyJ9:1tLqO2:yt-ImO02iV4mSX_n47htmnJslnFWg7rXeZLbWjwaAIs','2024-12-26 21:06:18.769979'),('vof5v0rgwuumsjuooz7vc2yi8oel4o10','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t5ALu:7vq3nuLlT2To849eceBtZ6O0TshZcx82_35uMF5sp-8','2024-11-10 20:59:10.384149'),('vwlomdt2ymf564q4z4yuafogeviiftba','.eJxVjEEOwiAQRe_C2hAoMwVcuvcMZBhAqqYkpV0Z765NutDtf-_9lwi0rTVsPS9hSuIsjDj9bpH4kecdpDvNtya5zesyRbkr8qBdXlvKz8vh_h1U6vVbA9pcCAnBAgDrVJjMEAciw94X9ONotSYFDlGVQeeYwBvlFGtU0bF4fwDeIDdk:1tdcDs:nLuR3SoL-xoQD_eAF9Wk9vmtqjyYx3LG-GZU6HgxL1I','2025-02-13 21:37:16.518728'),('w8w5wopb7a085xhslb3r8awphlofzt83','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1t8xn4:nCax5Fn-oz0J-OTYHIclFjMp0E2ciheeT-ML4nk-PCA','2024-11-21 08:22:54.284405'),('wgah3snch36ruwtunvno3lpszyeqpmpa','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1ss8AV:BGl1-7U6ymW2zmNa6MB0bQWZqGXUvc5fX5ksKPHo_QQ','2024-10-05 22:01:31.049808'),('wne49zif44pltq08nbck197gitnp2vgy','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1str49:SIrTdsXHdj-ZivgPHQ4-tcSyKq-UOFS8SOuMA0q7GfY','2024-10-10 16:10:05.402067'),('wxkp5t17qh9emxd7tu6zohvqeb0yjf84','.eJxVjMsOwiAQRf-FtSHAUB4u3fsNBJhBqgaS0q6M_65NutDtPefcFwtxW2vYBi1hRnZmwE6_W4r5QW0HeI_t1nnubV3mxHeFH3Twa0d6Xg7376DGUb-10dajLYAetHcZNIF3kSwUmRRBVkbIqZBySiZrTLEqU5JiIlUERYHs_QHPcDes:1slnTB:0EJkRFxiaEo1_vVnW_2qptBZuO6qN3BcV5m9U75ca2s','2024-09-18 10:42:37.167393'),('xdp1d46orgbwrjsmoe9geh9gdcsd94gw','eyJuZXh0IjoiLyJ9:1tKKHQ:SW_qQLmSRSGtMu5W6BX4npCU5-RXZQHYo1fB2PTQHTU','2024-12-22 16:37:12.304570'),('xhy0505pq249tyj39stx0hd9xo6t5nx5','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1srK5D:MwNnZS8zEw4ALTPJyE5IBR1zj3BVRxc5F97r9pWAvmQ','2024-10-03 16:32:43.585307'),('xjue9nevpoxfvv8ilkl1c3amoa7yhk98','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1spCQd:t2sonbJOn_fErX_RHVtCFlQBP3sA0CxDNLfyGjyEGAQ','2024-09-27 19:58:03.293566'),('xkverq44vl7p7l03kmjs1k3i7uwzy25m','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1spBcu:u_zff8NEit8JYG_hm2Tgw6zdwyq8UuYrWLjrV6nIOks','2024-09-27 19:06:40.982946'),('xvojmonnoucg465ez9n7ayrchczfqy37','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1swPHv:bQ92dqRdejBQs4dFCbAxUGeTVjP0Y4Ph3xyv-7F1Sm0','2024-10-17 17:06:51.746737'),('ys6c1pa70wxh5fh5jjxrrcxxiwtwoyt8','.eJxVjMEOwiAQBf-Fs8GlQEGP3v0GssAiVQNJoYmJ8d9tk156nZn3vqzQp7MrO7MTc7j07JZGs5viysSReQwvKpuITyyPykMtfZ483xK-28bvNdL7treHg4wtr2ukpMHKC0U7oEWwYIXQWtMANBIMScoxyCQ0gQYTlVQok_JkwJtkybDfH884Okg:1sk65R:zpa7K2Ek2zU6ii5mhNHFj48fgJ0rCPup_t_izeX03pA','2024-09-13 18:11:05.750096'),('z9bb1uis5hzgdt9b3oklbaste412hwil','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1t4Plw:c7KaAEm7aqucyShumj21ojiLNqyeeE61MJdd3O-3JUg','2024-11-08 19:14:56.474806'),('zeu9tsehsrvkdrw0fz8huslayh0n7kye','.eJxVjMsOwiAQRf-FtSHDYwq6dN9vIAMMUjU0Ke3K-O_apAvd3nPOfYlA21rD1nkJUxYXocTpd4uUHtx2kO_UbrNMc1uXKcpdkQftcpwzP6-H-3dQqddvTVwQvDlz9po8gQevFCKyBh4YdDFmSKYoZEBw2RpLptjIDqIrnp14fwDQADds:1snJOq:2w268dZ2zfQCS2kNqUre3o010X-p4uZC9yE89mZMcO8','2024-09-22 15:00:24.779751'),('zra9ifd7h3bvhyrwa1szphnxapqiaqno','.eJxVjMEOwiAQBf-Fs8GlQEGP3v0GssAiVQNJoYmJ8d9tk156nZn3vqzQp7MrO7MTc7j07JZGs5viysSReQwvKpuITyyPykMtfZ483xK-28bvNdL7treHg4wtr2ukpMHKC0U7oEWwYIXQWtMANBIMScoxyCQ0gQYTlVQok_JkwJtkybDfH884Okg:1sogHT:w8Kqi0cS9JH3mpo6OpYGaOBqDeri3qWl5q7o_t2t-qs','2024-09-26 09:38:27.862157');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online_users_onlineuseractivity`
--

DROP TABLE IF EXISTS `online_users_onlineuseractivity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `online_users_onlineuseractivity` (
  `id` int NOT NULL AUTO_INCREMENT,
  `last_activity` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `online_users_onlineu_user_id_6def50a3_fk_scholarap` FOREIGN KEY (`user_id`) REFERENCES `scholarapp_customuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online_users_onlineuseractivity`
--

LOCK TABLES `online_users_onlineuseractivity` WRITE;
/*!40000 ALTER TABLE `online_users_onlineuseractivity` DISABLE KEYS */;
INSERT INTO `online_users_onlineuseractivity` VALUES (1,'2024-10-30 23:31:56.623472',1);
/*!40000 ALTER TABLE `online_users_onlineuseractivity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_conversation`
--

DROP TABLE IF EXISTS `scholarapp_conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_conversation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_slug` varchar(240) NOT NULL,
  `description` varchar(512) DEFAULT NULL,
  `title` varchar(120) DEFAULT NULL,
  `group_icon` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_slug` (`room_slug`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_conversation`
--

LOCK TABLES `scholarapp_conversation` WRITE;
/*!40000 ALTER TABLE `scholarapp_conversation` DISABLE KEYS */;
INSERT INTO `scholarapp_conversation` VALUES (29,'imane-haidar_mohammad-ayache',NULL,NULL,'data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' height=\'48px\' viewBox=\'0 -960 960 960\' width=\'48px\' fill=\'%23000000\'%3E%3Cpath d=\'M38-160v-94q0-35 18-63.5t50-42.5q73-32 131.5-46T358-420q62 0 120 14t131 46q32 14 50.5 42.5T678-254v94H38Zm700 0v-94q0-63-32-103.5T622-423q69 8 130 23.5t99 35.5q33 19 52 47t19 63v94H738ZM358-481q-66 0-108-42t-42-108q0-66 42-108t108-42q66 0 108 42t42 108q0 66-42 108t-108 42Zm360-150q0 66-42 108t-108 42q-11 0-24.5-1.5T519-488q24-25 36.5-61.5T568-631q0-45-12.5-79.5T519-774q11-3 24.5-5t24.5-2q66 0 108 42t42 108ZM98-220h520v-34q0-16-9.5-31T585-306q-72-32-121-43t-106-11q-57 0-106.5 11T130-306q-14 6-23 21t-9 31v34Zm260-321q39 0 64.5-25.5T448-631q0-39-25.5-64.5T358-721q-39 0-64.5 25.5T268-631q0 39 25.5 64.5T358-541Zm0 321Zm0-411Z\'/%3E%3C/svg%3E'),(30,'imane-haidar_ziad-doughan',NULL,NULL,'data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' height=\'48px\' viewBox=\'0 -960 960 960\' width=\'48px\' fill=\'%23000000\'%3E%3Cpath d=\'M38-160v-94q0-35 18-63.5t50-42.5q73-32 131.5-46T358-420q62 0 120 14t131 46q32 14 50.5 42.5T678-254v94H38Zm700 0v-94q0-63-32-103.5T622-423q69 8 130 23.5t99 35.5q33 19 52 47t19 63v94H738ZM358-481q-66 0-108-42t-42-108q0-66 42-108t108-42q66 0 108 42t42 108q0 66-42 108t-108 42Zm360-150q0 66-42 108t-108 42q-11 0-24.5-1.5T519-488q24-25 36.5-61.5T568-631q0-45-12.5-79.5T519-774q11-3 24.5-5t24.5-2q66 0 108 42t42 108ZM98-220h520v-34q0-16-9.5-31T585-306q-72-32-121-43t-106-11q-57 0-106.5 11T130-306q-14 6-23 21t-9 31v34Zm260-321q39 0 64.5-25.5T448-631q0-39-25.5-64.5T358-721q-39 0-64.5 25.5T268-631q0 39 25.5 64.5T358-541Zm0 321Zm0-411Z\'/%3E%3C/svg%3E'),(31,'imane-haidar_mohammad-ayache_ziad-doughan','Sample Text','DDOS LLM Group','data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' height=\'48px\' viewBox=\'0 -960 960 960\' width=\'48px\' fill=\'%23000000\'%3E%3Cpath d=\'M38-160v-94q0-35 18-63.5t50-42.5q73-32 131.5-46T358-420q62 0 120 14t131 46q32 14 50.5 42.5T678-254v94H38Zm700 0v-94q0-63-32-103.5T622-423q69 8 130 23.5t99 35.5q33 19 52 47t19 63v94H738ZM358-481q-66 0-108-42t-42-108q0-66 42-108t108-42q66 0 108 42t42 108q0 66-42 108t-108 42Zm360-150q0 66-42 108t-108 42q-11 0-24.5-1.5T519-488q24-25 36.5-61.5T568-631q0-45-12.5-79.5T519-774q11-3 24.5-5t24.5-2q66 0 108 42t42 108ZM98-220h520v-34q0-16-9.5-31T585-306q-72-32-121-43t-106-11q-57 0-106.5 11T130-306q-14 6-23 21t-9 31v34Zm260-321q39 0 64.5-25.5T448-631q0-39-25.5-64.5T358-721q-39 0-64.5 25.5T268-631q0 39 25.5 64.5T358-541Zm0 321Zm0-411Z\'/%3E%3C/svg%3E');
/*!40000 ALTER TABLE `scholarapp_conversation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_conversation_users`
--

DROP TABLE IF EXISTS `scholarapp_conversation_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_conversation_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint NOT NULL,
  `customuser_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scholarapp_conversation__conversation_id_customus_840955fe_uniq` (`conversation_id`,`customuser_id`),
  KEY `scholarapp_conversat_customuser_id_a419f304_fk_scholarap` (`customuser_id`),
  CONSTRAINT `scholarapp_conversat_conversation_id_c8ddeb71_fk_scholarap` FOREIGN KEY (`conversation_id`) REFERENCES `scholarapp_conversation` (`id`),
  CONSTRAINT `scholarapp_conversat_customuser_id_a419f304_fk_scholarap` FOREIGN KEY (`customuser_id`) REFERENCES `scholarapp_customuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_conversation_users`
--

LOCK TABLES `scholarapp_conversation_users` WRITE;
/*!40000 ALTER TABLE `scholarapp_conversation_users` DISABLE KEYS */;
INSERT INTO `scholarapp_conversation_users` VALUES (36,29,1),(37,29,2),(38,30,1),(39,30,3),(40,31,1),(42,31,2),(41,31,3);
/*!40000 ALTER TABLE `scholarapp_conversation_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_customuser`
--

DROP TABLE IF EXISTS `scholarapp_customuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_customuser` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `name` varchar(120) NOT NULL,
  `email` varchar(254) NOT NULL,
  `avatar` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_customuser`
--

LOCK TABLES `scholarapp_customuser` WRITE;
/*!40000 ALTER TABLE `scholarapp_customuser` DISABLE KEYS */;
INSERT INTO `scholarapp_customuser` VALUES (1,'pbkdf2_sha256$720000$5xXqZpKe9YLiSamSYZno5i$dvFJUn5Sk1+t1+XvcGDYr4Tht28QwuTHsIptxTPXZEk=','2025-02-12 09:33:59.007213',0,'','',0,1,'2024-08-12 07:45:46.779063','Imane Haidar','test@example.com','https://i1.rgstatic.net/ii/profile.image/11431281219016267-1705865296205_Q64/Imane-Haidar-2.jpg'),(2,'pbkdf2_sha256$720000$SfSKmFtOfEYgd9wBnGLP99$GZzTOo6H6RkFFuVo/0Z2F0wjfzP2XdcBTBzO8pOWikw=','2025-02-02 15:16:28.574340',0,'','',0,1,'2024-08-12 07:48:42.385929','Mohammad Ayache','test2@example.com','https://i1.rgstatic.net/ii/profile.image/11431281153613342-1682503661569_Q64/Mohammad-Ayache-3.jpg'),(3,'pbkdf2_sha256$720000$hjgmrFZlR6D2ksDhWKUJ3D$18Zv5sBSGayzjijMBq3uiwO9+Z4US6VIXBVaG7L87gU=','2025-01-31 12:30:34.963125',0,'','',0,1,'2024-08-20 18:55:26.515470','Ziad Doughan','test1@example.com','https://i1.rgstatic.net/ii/profile.image/677218942459904-1538472986249_Q64/Ziad-Doughan.jpg'),(24,'pbkdf2_sha256$720000$fDnpTaRFbw6kybfUspzjwM$Sx/4An7NNqBBBYGygw9blTSS78Zwyk+d0lY6W21o9m0=','2025-01-27 22:29:30.830267',0,'','',0,1,'2025-01-27 22:29:18.042792','Ziad Osman','test3@example.com','default_icon.png');
/*!40000 ALTER TABLE `scholarapp_customuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_customuser_groups`
--

DROP TABLE IF EXISTS `scholarapp_customuser_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_customuser_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scholarapp_customuser_gr_customuser_id_group_id_e38dd5bc_uniq` (`customuser_id`,`group_id`),
  KEY `scholarapp_customuser_groups_group_id_ee4a0b3a_fk_auth_group_id` (`group_id`),
  CONSTRAINT `scholarapp_customuse_customuser_id_0e647d41_fk_scholarap` FOREIGN KEY (`customuser_id`) REFERENCES `scholarapp_customuser` (`id`),
  CONSTRAINT `scholarapp_customuser_groups_group_id_ee4a0b3a_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_customuser_groups`
--

LOCK TABLES `scholarapp_customuser_groups` WRITE;
/*!40000 ALTER TABLE `scholarapp_customuser_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `scholarapp_customuser_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_customuser_user_permissions`
--

DROP TABLE IF EXISTS `scholarapp_customuser_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_customuser_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customuser_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scholarapp_customuser_us_customuser_id_permission_413a7e1e_uniq` (`customuser_id`,`permission_id`),
  KEY `scholarapp_customuse_permission_id_8a649945_fk_auth_perm` (`permission_id`),
  CONSTRAINT `scholarapp_customuse_customuser_id_f1776639_fk_scholarap` FOREIGN KEY (`customuser_id`) REFERENCES `scholarapp_customuser` (`id`),
  CONSTRAINT `scholarapp_customuse_permission_id_8a649945_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_customuser_user_permissions`
--

LOCK TABLES `scholarapp_customuser_user_permissions` WRITE;
/*!40000 ALTER TABLE `scholarapp_customuser_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `scholarapp_customuser_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_event`
--

DROP TABLE IF EXISTS `scholarapp_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_event` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(350) NOT NULL,
  `description` varchar(512) NOT NULL,
  `author_str` varchar(256) NOT NULL,
  `external_link` varchar(200) DEFAULT NULL,
  `date_created` datetime(6) NOT NULL,
  `event_type` varchar(3) NOT NULL,
  `tags` varchar(256) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_event`
--

LOCK TABLES `scholarapp_event` WRITE;
/*!40000 ALTER TABLE `scholarapp_event` DISABLE KEYS */;
INSERT INTO `scholarapp_event` VALUES (9,'Legacy Versus Algebraic Machine Learning: A Comparative Study','Over the last few decades, researchers have become increasingly interested in machine learning. The field has progressed from classical techniques to neural networks (NNs) and fuzzy neural networks. A novel approach that employs an algebraic model has recently emerged, which enables data conceptualization through generalization and formalization. T...','Imane Haidar,Layth Sliman,Issam Damaj,Ali Haidar',NULL,'2024-03-11 00:00:00.000000','CH',''),(10,'ResNet-Based Detection of SYN Flood DDoS Attacks','','Hiba S. Bazzi,Ali Nassar,Imane Haidar,Ziad Doughan',NULL,'2024-02-11 00:00:00.000000','CN','Artificial Intelligence '),(11,'High Performance and Lightweight Single Semi-Lattice Algebraic Machine Learning','Algebraic machine learning is a novel parameter-free model that has demonstrated impressive accuracy in challenging tasks such as the MNIST dataset and N-Queens completion. However, its utilization of two semi-lattices can lead to significant computational demands. To tackle this issue, a solution has been proposed that employs a single semi-lattic...','Imane Haidar,Layth Sliman,Issam Damaj,Ali Haidar',NULL,'2024-01-11 00:00:00.000000','AR',''),(12,'A NOVEL SPECIALIZED SEARCH ENGINE FOR AI-MODELS AND THEIR COMPARISON','','Imane Haidar,Ziad Doughan,Ali Haidar',NULL,'2023-05-11 00:00:00.000000','AR',''),(13,'Axes-Based Encryption Key','','Imane Haidar,Ali Haidar,Ramzi A. Haraty',NULL,'2018-10-11 00:00:00.000000','CN','Encryption'),(14,'Scrambled prime key encryption','Information security has become an important issue in the modern world as the popularity of internet commerce and communication technologies have emerged, making them a prospective medium to security threats. To surmount these threats, modern data communications uses cryptography - an effective, efficient and essential component for secure transmis...','Imane Haidar,Ali Haidar,Ramzi A. Haraty',NULL,'2018-09-11 00:00:00.000000','CN',''),(17,'Machine Unlearning, A Comparative Analysis','This paper investigates the effectiveness of machine unlearning techniques in removing sensitive data from pre-trained Resnet-18 models using the CIFAR-10 dataset. Specifically, it compares the performance of Fine-Tuning and Fisher Noise-based Impair-Repair methods in minimizing data leakage and preserving model performance. The study evaluates the...','Ziad Doughan,Sari Itani',NULL,'2024-06-11 00:00:00.000000','CH',''),(18,'A Novel Neural Network-Based Recommender System for Drug Recommendation','With the advancement of Machine Learning, recommender systems have emerged with the aim of improving the user experience in a world where data and available alternatives are tremendously growing. Employing Natural Language Processing with such systems can provide them with a sense of empowerment, given that most of the users’ opinions are reflected...','Hadi Al Mubasher,Ziad Doughan,Layth Sliman,Ali Haidar',NULL,'2023-06-11 00:00:00.000000','CH',''),(19,'Artificial neural network vision: Between myth and reality','Decades have passed since the world went crazy about the revolution of the machine. Through the years, pioneers in the field tried to imagine how such progress in artificial intelligence (AI) could influence our lives. Were we going to witness sentient machines among us? What would their capabilities, superpowers, and limitations be? Were there gho...','Ziad Doughan,Rola Kassem,Ahmad El Hajj,Ali Haidar',NULL,'2023-05-11 00:00:00.000000','AR',''),(20,'Early Diagnosis of Osteoporosis: An Artificial Intelligence-Based Framework','Osteoporosis is a common disease characterized by low bone density and structural deterioration of bone tissue. For a successful course of treatment and fracture avoidance, early diagnosis of this disease is essential. The aim was to provide a novel method for osteoporosis prediction using Artificial Intelligence (AI)-based framework. The purpose w...','Amira J. Zaylaa,Alaa Daher,Mohammad houssein Ayache,Bader Abou Hawili',NULL,'2023-10-11 00:00:00.000000','CN',''),(21,'Artificial Intelligence-Powered System for Detecting, Diagnosing, and Rehabilitating Strabismus Disorder','','Alaa Daher,Mohammad houssein Ayache,Amira J. Zaylaa,Hasan Hmadeh',NULL,'2023-10-11 00:00:00.000000','CN',''),(22,'Building a Brain Computer Interface (BCI) Using Electroencephalogram (EEG) Signals\' Classification','','Mohammad Nabil Younis,Sary Haj Sleiman,Salma Khadra,Mohammad houssein Ayache',NULL,'2023-10-11 00:00:00.000000','CN',''),(23,'Wireless Healthcare Monitoring System for Heart Diseases Classification using Efficient ECG-Based Wave Modeling and Machine Learning Techniques','','Alaa Daher,Mohammad houssein Ayache,Heba Halabi,Ongel Hajj',NULL,'2023-07-11 00:00:00.000000','CN',''),(24,'Engineering Education Program Enhancement Based on Modern Teaching Methodologies: System of Systems Approach','','Mohammad houssein Ayache,Alaa Daher',NULL,'2023-06-11 00:00:00.000000','CN',''),(25,'Issues and Innovation for Setting and Infrastructure Management in the Islamic University of Lebanon in the Time of Pandemic','The Islamic University of Lebanon (IUL) is committed to providing faith and knowledge as a source of inspiration for the Lebanese nation, citizen, state and society as a whole. IUL has paid special attention to the environment and to the green metrics when establishing the new campus in Wardanieh, the rules related to green buildings and the preser...','Jamal Haydar,Walid Fahs,Mohammad houssein Ayache',NULL,'2022-06-11 00:00:00.000000','AR',''),(26,'[1] Energy consumption clustering using machine learning: K-means approach','','Aghyad Al Skaif,Mohammad houssein Ayache,Hussein Mostafa Kanaan',NULL,'2021-12-11 00:00:00.000000','CN',''),(27,'HEART DISEASE PREDICTION SYSTEM USING MACHINE LEARNING ALGORITHM','Information decision support systems are becoming more in use as we are living in the era of digital data and rise of artificial intelligence. Heart disease as one of the most known and dangerous is getting very important attention, this attention is translated into digital and prediction system that detects the presence of disease according to the...','Israa Nadher,Mohammad houssein Ayache,Hussein Mostafa Kanaan',NULL,'2021-12-11 00:00:00.000000','AR',''),(28,'Digital deparaffinization of Raman spectral image acquired on FFPE human skin tissue','Raman spectral imaging is applied to human skin tissue fixed with formalin and embedded in paraffin. However, some restrictions may appear due to the high intensity of the paraffin signal. Extended Multiplicative Signal Correction (EMSC) is applied to correct the paraffin contribution of the Raman spectral image. For this purpose, the paraffin sign...','Abbas Rammal,Mohammad houssein Ayache,Zeinab Farhat',NULL,'2021-10-11 00:00:00.000000','CN',''),(29,'Lung Segmentation followed by Machine Learning & Deep Learning Techniques for COVID-19 Detection in lung CT Images','In the light of the rapidly growing COVID-19 pandemic, the need for an expeditious diagnosis of COVID-19 infection became essential. The immediate diagnosis will allow the initiation of the isolation process and adequate treatment as well. While the standard test used for the diagnosis of COVID-19 disease (RT-PCR) is usually time consuming (6 hours...','Hatem Tarhini,Abbas Rammal,Mohammad houssein Ayache,Rayan Mohamad',NULL,'2021-10-11 00:00:00.000000','CN',''),(30,'A Novel ECG Waves Detection Followed by a New Compression Technique Based on Fourier Series Modeling for up to 26 Days Holter Monitor','','Alaa Daher,Sally Yassin,Mohammad houssein Ayache',NULL,'2021-10-11 00:00:00.000000','CN',''),(31,'Fully Automatic Detection of Premature Ventricular Contractions: A New Approach Based On Unsupervised Learning','Premature Ventricular Contractions (PVCs), a common type of cardiac arrhythmia, can be identified by analyzing electrocardiogram (ECG) signals. If not treated on time, PVCs become life-threatening. In this paper, a high-performance approach is proposed for detecting PVCs in an unsupervised manner. The main objective is to perform an automatic PVCs...','Khouloud Lobnan Issa,Abbas Rammal,Ahmad Rammal,Mohammad houssein Ayache',NULL,'2021-10-11 00:00:00.000000','CN',''),(32,'Speech Command Recognition Using Deep Learning','Speech Recognition Software is a computer program that is trained to take the input of human speech, interpret it, and transcribe it into text. Most recently, the field has benefited from advances in deep learning and big data. The advances are evidenced not only by the surge of academic papers published in the field, but more importantly by the wo...','Mohammad houssein Ayache,Hussein Mostafa Kanaan,Kawthar Kassir,Yasser Kassir',NULL,'2021-09-11 00:00:00.000000','CN',''),(33,'Individual Palm Vein Identification: Machine Learning Approach','Biometric system has gained more importance in providing high security in individual identification as it uses a network of blood vessels underneath the palm skin. This paper proposes a new algorithm for palm vein identification using a histogram of gradient t(HOG). Raw images of palm hand vein are taken from a public dataset named VP base dataset....','Wafaa Fayad,Hussein Mostafa Kanaan,Mohammad houssein Ayache',NULL,'2021-09-11 00:00:00.000000','CN',''),(34,'Heart Disease Prediction System Using Machine Learning Algorithm','Information decision support systems are becoming more in use as we are living in the era of digital data and rise of artificial intelligence. Heart disease as one of the most known and dangerous is getting very important attention, this attention is translated into digital and prediction system that detects the presence of disease according to the...','Israa Nadheer,Mohammad houssein Ayache,Hussein Mostafa Kanaan',NULL,'2021-07-11 00:00:00.000000','CN',''),(35,'promising database for palm vein Identification','Palm vein authentication is one of the modern biometric techniques, which employs the vein pattern in the human palm to verify the person. The merits of palm vein on classical biometric (e.g. fingerprint, iris, face) are a low risk of falsification, difficulty of duplicated and stability. With the expanding application of palm–vein pattern recogni...','Hussein Mostafa Kanaan,Mohammad houssein Ayache,Maha Halla Abdul Sater',NULL,'2021-06-11 00:00:00.000000','AR',''),(36,'Diabetes Disease Prediction Using Artificial Intelligence','For a long time, the major problem area for researchers is disease diagnosis and the main interest of the medicine is an accurate diagnosis. Many engineering techniques have been developed in the past to help the medical staff with a diagnosis tool. There are many traditional methods of disease diagnosis, but the application of machine learning tec...','Muntather Ayad,Hussein Mostafa Kanaan,Mohammad houssein Ayache',NULL,'2020-11-11 00:00:00.000000','CN',''),(37,'Energy consumption clustering using Machine Learning','','Hussein Mostafa Kanaan,Mohammad houssein Ayache,• AGHYAD, AS, SKAIF',NULL,'2020-10-11 00:00:00.000000','PO',''),(38,'Identification of Ischemic Stroke by Marker Controlled Watershed Segmentation and Fearture Extraction','In this paper, we will describe a method that distinguishes the ischemic stroke from Computed Tomography (CT) brain images by extracting the statistical and textural features. First, preprocessing of the CT images is done followed by image enhancement. Segmentation of the CT images is performed by Marker Controlled Watershed. After the segmentation...','Mohammed Ajam,Hussein Mostafa Kanaan,Lina El Khansa,Mohammad houssein Ayache',NULL,'2020-07-11 00:00:00.000000','AR',''),(39,'Ischemic Stroke Identification by Using Watershed Segmentation and Textural and Statistical Features','The algorithm presented in this paper identifies the ischemic stroke from CT brain images by extracting the textural and statistical features. Our algorithm starts by preprocessing of our CT images, and then image enhancement is performed. The brain CT images are segmented by Marker Controlled watershed. We obtained the Grey Level Co-occurrence mat...','Mohammed Ajam,Hussein Mostafa Kanaan,Lina el Khansa,Mohammad houssein Ayache',NULL,'2019-12-11 00:00:00.000000','CN',''),(40,'Segmentation of CT Brain Stroke Image using Marker Controlled Watershed','In this paper, an algorithm is proposed to detect and segment ischemic stroke from CT brain images. Firstly, our proposed method starts by a preprocessing step contains skull bone striping and text removal from CT images, then the images are enhanced using median filter and histogram equalization. Next the watershed segmentation and Marker Controll...','Mohammed Ajam,Hussein Mostafa Kanaan,Mohammad houssein Ayache,Lina el Khansa',NULL,'2019-10-11 00:00:00.000000','CN',''),(41,'Identification of individuals using palm vein classification','In this paper, a new algorithm is introduced for palm identification using Gabor filter. First, our proposed method processes images using Gaussian filter and histogram equalization methods. The features are then extracted using bank of Gabor filters. We apply L2-max norm of superposition into output of Gabor filter to reduce the dimension of the f...','Maha Halla Abdul Sater,Hussein Mostafa Kanaan,Mohammad houssein Ayache',NULL,'2019-10-11 00:00:00.000000','CN',''),(42,'Liver Tumor Ablation Enhancement by Lean Concept','','Mouhamad Mourad,Mohammed Ajam,Mohammad houssein Ayache',NULL,'2018-11-11 00:00:00.000000','CN',''),(43,'Vaginal Power Doppler Parameters as New Predictors of Intra-Cytoplasmic Sperm Injection Outcome','','Zeinab Abbas,Chadi ibrahim Fakih,Ali Saad,Mohammad houssein Ayache',NULL,'2018-11-11 00:00:00.000000','CN',''),(44,'Detection of freezing of gait for Parkinson’s disease patients with multi-sensor device and Gaussian neural networks','Freezing of Gait (FoG) in Parkinson Disease (PD) is a sudden episode characterized by a brief failure to walk. The aim of this study is to detect FoG episodes using a multi-sensor device for data acquisition, and Gaussian neural networks as a classification tool. Thus we have built a multi sensor prototype that detects FoG using new indicators like...','Ali Saad,Iyad Zaarour,François Guerin,Dimitri Lefebvre',NULL,'2017-06-11 00:00:00.000000','AR',''),(45,'ECG classification for Sleep Apnea detection','','Amanda Hachem,Mohammad houssein Ayache,Lina El Khansa,Ali Jezzini',NULL,'2016-10-11 00:00:00.000000','CN',''),(46,'Methodologies for the Diagnosis of the Main Behavioral Syndromes for Parkinson\'s Disease with Bayesian Belief Networks','Parkinson\'s disease (PD) patients suffers from many disabling syndromes, such as freezing of gait (FoG), handwriting troubles, and speech difficulties. This study describes our methodologies for modeling those PD syndromes based on Bayesian belief network (BBN) formalism. The methodology of the FoG modeling approach is based on data acquired from a...','Iyad Zaarour,Ali Saad,Abbass Zein Eddine,D. Lefebvre',NULL,'2015-12-11 00:00:00.000000','AR',''),(47,'Detection of freezing of gait for Parkinson’s disease patients with multi-sensor device and Gaussian neural networks','','Ali Saad,Iyad Zaarour,Francois Guerin,D. Lefebvre',NULL,'2015-12-11 00:00:00.000000','AR',''),(48,'ECG Classification for Sleep Apnea Detection','Sleep apnea is a sleep-related breathing disorder that involves a decrease or complete halt in airflow despite an ongoing effort to breathe. The most common form of sleep apnea is well known as Obstructive sleep apnea (OSA) which is currently diagnosed using polysomnography (PSG) at sleeping labs. This diagnostic technique is both expensive and inc...','Ali Jezzini,Mohammad houssein Ayache,Zein Al Abidin Ibrahim,Lina Elkhansa',NULL,'2015-09-11 00:00:00.000000','CN',''),(49,'Volume variation of the parotid gland during adaptive radiotherapy','','Ali Raad,Mohammad houssein Ayache,Alaa Abboud,Eric Lartigau',NULL,'2015-09-11 00:00:00.000000','CN',''),(50,'Fault tolerance level assessment of a wireless communication link in a system of systems concept modeled using bond graph','','Ahmad Koubeissi,Mohammad houssein Ayache,Mahmoud Abbas,Blaise Conrard',NULL,'2015-09-11 00:00:00.000000','CN',''),(51,'Bond graph model-based for fault tolerance level assessment of a wireless communication link in a system of systems concept','The main focus of this paper is on graphical modeling of wireless link of a System of Systems (SoS) for the purpose of Fault Tolerance Level Assessment. Having used hypergraphs previously for modeling the structural organization of SoS, it\'s now important to introduce another graphical tool for modeling the wireless communication channel (WCL) betw...','Ahmad Koubeissi,Mohammad houssein Ayache,Rochdi Merzouki,Blaise Conrard',NULL,'2015-07-11 00:00:00.000000','AR',''),(52,'Multilevel graphical modeling for system of systems: Bondgraph model for a wireless communication link with redundancy','Graphical modeling for System of Systems (SoS) permits defining supervision strategies for fault detection and reconfiguration of component systems to achieve a common task. Hypergraphs are being used to model the structural organization of an SoS at macroscopic level without being able to relate the whole system organization to element failure wit...','Ahmad Koubeissi,Mohammad houssein Ayache,Rochdi Merzouki',NULL,'2015-04-11 00:00:00.000000','AR',''),(53,'Deformable image tracking of the parotid gland for adaptive radiotherapy application','Radiation therapy is a type of cancer treatment using radiation at different times defined as treatment sessions, distributed over different weeks. In each session, we have to determine and define the optimal treatment parameters for the patient. The aim of Adaptive Radiotherapy Treatment (ART) is to identify any change of initial parameters during...','Ali Raad,Mohammad houssein Ayache,Alaa Abboud,Eric Lartigau',NULL,'2014-08-11 00:00:00.000000','AR',''),(54,'Target evolution modeling for robotized adaptive radiotherapy','Adaptive Radiotherapy Treatment (ART) of cancerous organs is based on manipulating Autonomous Robotic System (ARS) used for radiation. After each treatment session, the biological organ is subject to deformation. Treatment efficiency depends highly on predicting successfully the shape of the deformable organ, being treated, prior to commencement of...','Ali Raad,Mohammad houssein Ayache,Alaa Abboud,Eric Lartigau',NULL,'2014-07-11 00:00:00.000000','CN',''),(55,'Bondgraph model for system of systems wireless communication link','Throughout this paper, we present a bondgraph model for a wireless communication link (WCL) between two component systems of a System of Systems (SoS). Our work contributes to enhancing the cooperative behavior of SoS by examining the benefit of integrating bondgraphs and hypergraphs in modeling SoS. We analyze basic channel effects and critical pa...','Ahmad Koubeissi,Mohammad houssein Ayache,Rochdi Merzouki',NULL,'2014-07-11 00:00:00.000000','CN',''),(56,'Sensoring and Features Extraction for the Detection of Freeze of Gait in Parkinson Disease','Freezing of Gait (FoG) in Parkinson disease (PD) is a sudden episode characterized by brief failure to walk. This study aims to build a preliminary prototype that is able to acquire signals from different sensors, and detect changes during FoG. This paper gives the basic concepts to build an algorithm. The different kinds of sensors used in this st...','Ali Saad,François Guerin,Mohammad houssein Ayache,Dimitri Lefebvre',NULL,'2014-02-11 00:00:00.000000','CN',''),(57,'About detection and diagnosis of Freezing of Gait','This paper is about the initiative of detecting Freezing of Gait (FoG) in Parkinson Disease (PD). Summarizing more than twelve years of accumulated data, presenting the techniques used, and evaluating their results would create a reference paper for future works. We traced the development of diverse researches and sensor-based systems (acceleration...','Ali Saad,Iyad Zaarour,Dimitri Lefebvre,Mohammad houssein Ayache',NULL,'2013-10-11 00:00:00.000000','CN',''),(58,'Effects of predictive maintenance(PdM), Proactive maintenace(PoM) & Preventive maintenance(PM) on minimizing the faults in medical instruments','Corrective maintenance (CM) is a big concern for both doctors and medical engineers; it has a direct influence on rising the unplanned downtime for the medical instruments. Our objective is to prove that by implementing a good scheduled maintenance program including Proactive, Predictive and Preventive maintenance will decrease the high cost in tim...','Ali Jezzini,Mohammad houssein Ayache,Lina Elkhansa,Maya Zein',NULL,'2013-09-11 00:00:00.000000','CN',''),(59,'A Preliminary Approach to Study the Causality of Freezing of Gait for Parkinson\'s: Bayesian Belief Network Approach','Parkinson disease patients suffer from a disabling phenomenon called freezing of gait, which can be described as if their feet are \" frozen \" or stuck, but that the top half of their body is still able to move. In this paper, we make a graphical probabilistic modeling study, \"Bayesian Belief Network (BBN) approach\" of a previously collected dataset...','Abbass Zein Eddine,A Zeineldine,Iyad Zaarour,P Bejjani',NULL,'2013-07-11 00:00:00.000000','CN',''),(60,'A Preliminary Study of the Causality of Freezing of Gait for Parkinson\'s Disease Patients: Bayesian Belief Network Approach','Parkinson Disease (PD) patients suffer from a disabling phenomenon called Freezing of Gait (FoG), which can be described as if their feet were \"frozen\" or stuck, but that the top half of their body was still able to move. In this paper, we make a graphical probabilistic modeling study, \"Bayesian Belief Network (BBN) approach\" of a previously collec...','Ali Saad,Iyad Zaarour,Abbass Zein Eddine,Dimitri Lefebvre',NULL,'2013-05-11 00:00:00.000000','AR',''),(61,'Handwriting and Speech Prototypes of Parkinson Patients: Belief Network Approach','Articulator phonetics and handwriting dysfunctions are frequent observations in Parkinson\'s disease (PD). In this paper we make an inductive study of speech and handwriting skills of PD patients by proposing ways for discovering prototypes of PD patients. Each discovered prototype consists of labeled cluster that combines a similar handwriting and...','Ali Saad,Iyad Zaarour,Paul Bejjani,Mohammad houssein Ayache',NULL,'2012-05-11 00:00:00.000000','AR',''),(62,'Artificial Neural Network for Transfer Function Placental Development: DCT and DWT Approach','The aim of our study is to propose an approach for transfer function placental development using ultrasound images. This approach is based to the selection of tissues, feature extraction by discrete cosine transform DCT, discrete wavelet transform DWT and classification of different grades of placenta by artificial neural network and especially the...','Mohammad houssein Ayache,Mohamad A Khalil,François Tranquart',NULL,'2011-09-11 00:00:00.000000','AR',''),(63,'A New Algorithm for Structure Optimization of Wavelet Neural Network','This paper presents a new algorithm for constructing and training wavelet neural network. This algorithm is based on the variation of the number of hidden neurons dynamically during the training process. The suggested method determines the optimal number of the hidden neurons and solves the optimization problem of wavelet neural network structure....','Youssef Harkouss,Walid Fahs,Mohammad houssein Ayache',NULL,'2011-03-11 00:00:00.000000','AR',''),(64,'Health Smart Home','We present in this paper a study and an experimental medical tele-surveillance system for maintaining patients at home. The aim of this paper is to demonstrate how combining many kinds of technologies starting with sensors connected to the patient then using wireless technology (ZigBee) to transmit information and finally analysis and detection of...','Ahmad Choukeir,Batoul Fneish,Nour Zaarour,Mohammad houssein Ayache',NULL,'2010-11-11 00:00:00.000000','AR',''),(65,'DWT to Classify Automatically the Placental Tissues Development: Neural Network Approach','Problem statement: This study proposed an approach for classification of placental tissues development using ultrasound images. Approach: This approach was based to the selection of tissues, feature extraction by discrete wavelet transform and classification by neural network and especially the Multi Layer Perceptron (MLP). Results: The proposed ap...','Mohammad houssein Ayache,Mohamad A Khalil,François Tranquart',NULL,'2010-06-11 00:00:00.000000','AR',''),(68,'Machine Unlearning, A Comparative Analysis','This paper investigates the effectiveness of machine unlearning techniques in removing sensitive data from pre-trained Resnet-18 models using the CIFAR-10 dataset. Specifically, it compares the performance of Fine-Tuning and Fisher Noise-based Impair-Repair methods in minimizing data leakage and preserving model performance. The study evaluates the...','Ziad Doughan,Sari Itani',NULL,'2024-06-16 00:00:00.000000','CH',''),(69,'ResNet-Based Detection of SYN Flood DDoS Attacks','','Hiba S. Bazzi,Ali Nassar,Imane Haidar,Ziad Doughan',NULL,'2024-02-16 00:00:00.000000','CN',''),(70,'A Novel Neural Network-Based Recommender System for Drug Recommendation','With the advancement of Machine Learning, recommender systems have emerged with the aim of improving the user experience in a world where data and available alternatives are tremendously growing. Employing Natural Language Processing with such systems can provide them with a sense of empowerment, given that most of the users’ opinions are reflected...','Hadi Al Mubasher,Ziad Doughan,Layth Sliman,Ali Haidar',NULL,'2023-06-16 00:00:00.000000','CH',''),(71,'A NOVEL SPECIALIZED SEARCH ENGINE FOR AI-MODELS AND THEIR COMPARISON','','Imane Haidar,Ziad Doughan,Ali Haidar',NULL,'2023-05-16 00:00:00.000000','AR',''),(72,'Artificial neural network vision: Between myth and reality','Decades have passed since the world went crazy about the revolution of the machine. Through the years, pioneers in the field tried to imagine how such progress in artificial intelligence (AI) could influence our lives. Were we going to witness sentient machines among us? What would their capabilities, superpowers, and limitations be? Were there gho...','Ziad Doughan,Rola Kassem,Ahmad El Hajj,Ali Haidar',NULL,'2023-05-16 00:00:00.000000','AR',''),(73,'A Multiple Criteria Decision Making-Based Recommender System for Neural Network Learning Rate Initialization','','Ziad Doughan,Hadi Al Mubasher,Layth Sliman,Ali Haidar',NULL,'2023-01-16 00:00:00.000000','PP',''),(74,'THE METAVERSE: A VIRTUAL WORLD IN THE PALM OF YOUR HAND','This paper explores the actual and future impact of the Metaverse as a virtual space. Thus, it focuses the probe on the technical challenges that face this everlasting emerging technology. Today, the Metaverse presents a digital environment to build collective architecture and historical heritage in a virtual space. In this digital world, the model...','Ziad Doughan,Hadi Al Mubasher,Mustafa El Bizri,Ali Haidar',NULL,'2022-12-16 00:00:00.000000','AR',''),(75,'Logic-Based Neural Network for Pattern Correction','','Ziad Doughan,Hadi Al Mubasher,Rola Kassem,Layth Sliman',NULL,'2022-11-16 00:00:00.000000','CN',''),(76,'Karnaugh Maps','A presentation explaining the Karnaugh Map process, for Boolean expression reduction.','Ziad Doughan',NULL,'2022-06-16 00:00:00.000000','PR',''),(77,'Novel Preprocessors for Convolution Neural Networks','Fooling neural networks is a main concern in the process of Artificial Intelligence optimization. Character perturbation make part of a text unnoticeable for some systems, even for human observers. This research focuses the probe on a novel input preprocessing technique, which applies with the Convolutional Neural Networks for character recognition...','Ziad Doughan,Rola Kassem,Ahmad El Hajj,Ali Haidar',NULL,'2022-03-16 00:00:00.000000','AR',''),(78,'Logic-Based Neural Network for Image Compression Applications','','Ziad Doughan,Rola Kassem,Ahmad El Hajj,Ali Haidar',NULL,'2021-12-16 00:00:00.000000','CN',''),(79,'Advanced Biomimetic Cells Architecture for Parallel Operations in Artificial Intelligence','This paper introduces a new architecture of Biomimetic Cells, which is very different in its nucleus from simple cells, and presents a multi combinational grid between inputs, weights and outputs. Designers are free to use hybrid combination of cells to model any required arrangement style. This leads to a massive reduction in complexity. The high...','Ziad Doughan,Wassim Itani,Ali Haidar',NULL,'2019-07-16 00:00:00.000000','CN',''),(80,'Automatic Radial Routing Protocol for Public Transport System','This paper introduces a new routing methodology for the public transportation system design using Big Data. The new radial routing procedure proposed provides a fast scheme manipulation of a public transport system on a geographic location, which relies directly on the history of daily trips of the citizens associated with their geographic location...','Ziad Doughan,Youssef Attallah,Hiba Koleilat',NULL,'2019-07-16 00:00:00.000000','CN',''),(81,'Blockchain, Cryptocurrency and the Energy Sector','This is a brief summary presentation about blockchain, cryptocurrency and their future impact in the energy sector.','Ziad Doughan',NULL,'2019-06-16 00:00:00.000000','PR',''),(82,'Biomimetic Cells: A New Frontier in Brain Informatics','This paper introduces a new imitation of neurons cells, based on the latest discoveries in neuroscience. After reobserving the latest revelations in the field of biological neurons, the conventional artificial models has proven strong potentials in image processing and pattern classification, but remains far from presenting a modern imitation of na...','Ziad Doughan,Wassim Itani,Ali Haidar',NULL,'2018-11-16 00:00:00.000000','CN',''),(83,'Bio-mimetic Approach in Digital Artificial Neuro-science','This paper presents a new field of artificial neuro-science, providing a group of mathematical relations and functional algorithms used to operate and improve Biomimetic Cells Network models. It introduces all the main properties and characteristics of the Biomimetic Cells by providing a modern platform of design and implementation of these intelli...','Ziad Doughan,Wassim Itani,Ali Haidar',NULL,'2016-07-16 00:00:00.000000','CN',''),(84,'Workshop','Sample Text','',NULL,'2024-09-16 18:46:42.529126','WR',''),(85,'Event Title','Sample Text','',NULL,'2024-09-22 18:21:56.352253','JN',''),(88,'Tagged Event','Sample Text','',NULL,'2024-10-23 15:04:08.334914','WR','Artificial Intelligence •Machine Learning Applications '),(89,'Cars Identification from partial images using norm angle of feature points.','Image processing is being widely used in various practical fields such as face recognition and medical diagnosis. Image recognition could be based on full shape or partial shape imaging depending on the area where image processing is applied. The application of interest in this paper is to use partial shape recognition to determine the brand and mo...','',NULL,'2023-10-27 00:00:00.000000','AR','Image Processing•Partial Shape Recognition•Brand Recognition\n'),(90,'Differential AGC with Offset Stability and Wide Range Frequency Synthesis','In modern electronic systems, signal stability is a crucial issue. Many methods have been developed to mitigate the deviation from an ideal signal. One of them is called Automatic Gain Control, which tracks variation in an input signal to settle output amplitude. This paper proposes a Differential Automatic Gain Controller with offset stability and...','',NULL,'2021-03-27 00:00:00.000000','AR','Automatic Gain Control•Signal Stability•Offset Stability\n'),(91,'Blind Image Quality Assessment for Face Pose Problem','','',NULL,'2020-06-27 00:00:00.000000','AR','Blind Image Quality Assessment•Face Pose\n'),(92,'Ensemble Models for Enhancement of an Arabic Speech Emotion Recognition System','Ensemble classification model has been widely used in the area of machine learning to enhance the performance of single classifiers. In this paper, we study the effect of employing five ensemble models, namely Bagging, Adaboost, Logitboost, Random Subspace and Random Committee, on a vocal emotion recognition system. The system recognizes happy, ang...','',NULL,'2020-01-27 00:00:00.000000','CH','Ensemble Classification•Vocal Emotion Recognition•Machine Learning\n'),(93,'A No-Reference Image Quality Assessment For Detecting Illumination Alteration','','',NULL,'2019-06-27 00:00:00.000000','CN','Image Quality Assessment•Illumination Alteration•No-Reference\n'),(94,'A Universal Method for Author Identification Using Statistical Properties of Text','Author identification is a major topic in Natural Language Processing whose applications go far beyond recognizing the original author of a text to detecting fraud. Each author has a unique writing style which is revealed by analyzing statistical features of his/her text. Traditionally, statistical features such as word frequencies and n-gram chara...','',NULL,'2018-08-27 00:00:00.000000','CN','Natural Language Processing•Author Identification•Fraud Detection\n'),(95,'Emotion recognition in Arabic speech','Automatic emotion recognition from speech signals without linguistic cues has been an important emerging research area. Integrating emotions in human–computer interaction is of great importance to effectively simulate real life scenarios. Research has been focusing on recognizing emotions from acted speech while little work was done on natural real...','',NULL,'2018-08-27 00:00:00.000000','AR','Emotion Recognition•Speech Processing•Human-Computer Interaction\n'),(96,'\'\'Using Statistical Properties for Author Identification','','',NULL,'2018-07-27 00:00:00.000000','AR','Author Identification•Statistical Properties\n'),(97,'Arabic Cultural Style Based Music Classification','','',NULL,'2017-10-27 00:00:00.000000','CN','Arabic Music•Cultural Style\n'),(98,'AGC with Signal Offset and Peak-to-Peak Amplitude Stabilization through Feedback Control','In modern electronic systems, signal stability is a crucial issue. Many methods have been developed to mitigate the deviation from an ideal signal. One of them is called Automatic Gain Control, which tracks variation in an input signal to settle output amplitude. This paper proposes a Differential Automatic Gain Controller with offset stability. It...','',NULL,'2017-09-27 00:00:00.000000','CN','Automatic Gain Control•Differential Amplifier•Offset Stability\n'),(99,'Emotion recognition in Arabic speech','','',NULL,'2017-09-27 00:00:00.000000','CN','Arabic•Speech•Emotion Recognition\n'),(100,'Classification of Arabic Text using Language Properties','Arabic language is highly redundant which makes text in Arabic highly compressible. This property was exploited in this paper in order to categorize Arabic text. The method developed starts by training the system using text that was already categorized. Distinct blocks in each category are determined. Thos blocks are then filtered to produce, for e...','',NULL,'2012-01-27 00:00:00.000000','AR','Arabic•Text Categorization•Compression\n'),(101,'Iris Recognition Using Phase Congruency','The techniques used in biometrics are diverse depending on which organ is of interest. When dealing with iris recognition some work was previously done. This paper describes a technique for iris recognition using phase congruency. Phase congruency is used to identify the different feature types that are present in the rich iris texture. It provides...','',NULL,'2011-05-27 00:00:00.000000','CN','Iris Recognition•Phase Congruency•Biometrics\n'),(102,'Computer Interfacing Electronic Boards for Building Management Systems','Modern personal computers are becoming highly capable and can support peripherals of various uses. Present software tools can efﬁciently work under personal computers and fully support the development of web-based, network-based, and/or ofﬂine software packages. This paper presents the design and implementation of a multipurpose hardware/software i...','',NULL,'2010-03-27 00:00:00.000000','CN','Hardware•Software•Design•Implementation\n'),(103,'Automatic processing of Arabic text','Automatic recognition of printed and handwritten documents remains an active area of research. Arabic is one of the languages that present special problems. Arabic is cursive and therefore necessitates a segmentation process to determine the boundaries of a character. Arabic characters consist of multiple disconnected parts. Dots and Diacritics are...','',NULL,'2010-01-27 00:00:00.000000','CN','Arabic•OCR•Handwriting recognition•Character segmentation\n'),(104,'Error Correction of Noisy Block Cipher Using Cipher and Plaintext Characteristics','Contemporary proven cryptographic algorithms, like the advanced encryption standard (AES), are used in many secure data storage systems. Cipher data when written or read might be subject to noise. Classical error detection and correction methods are not suitable for encrypted data. In this paper, error detection and correction is performed at the r...','',NULL,'2009-11-27 00:00:00.000000','CN','Cryptography•Data Security•Error Correction\n'),(105,'Cars Identification from partial images using norm angle of feature points.','','',NULL,'2023-01-27 00:00:00.000000','JN',''),(106,'An ultra high capacity polarization division multiplexed 128-QAM radio over fiber (RoF) system','','',NULL,'2023-01-27 00:00:00.000000','JN',''),(107,'Differential AGC with offset stability and wide range frequency synthesis','','',NULL,'2021-01-27 00:00:00.000000','JN',''),(108,'Comparison of Different Modulation Schemes in ROF Communication Systems.','','',NULL,'2021-01-27 00:00:00.000000','JN',''),(109,'A NOVEL ARABIC CORPUS FOR TEXT CLASSIFICATION USING DEEP LEARNING AND WORD EMBEDDING','','',NULL,'2021-01-27 00:00:00.000000','JN',''),(110,'BAU Journal-Science and Technolog y','','',NULL,'2020-01-27 00:00:00.000000','JN',''),(111,'Blind Image Quality Assessment for Face Pose Problem','','',NULL,'2020-01-27 00:00:00.000000','JN',''),(112,'Ensemble models for enhancement of an Arabic speech emotion recognition system','','',NULL,'2020-01-27 00:00:00.000000','JN',''),(113,'A no-reference image quality assessment for detecting illumination alteration','','',NULL,'2019-01-27 00:00:00.000000','JN',''),(114,'Ensemble Models for Enhancement of an Arabic Speech Emotion Recognition System','','',NULL,'2019-01-27 00:00:00.000000','JN','');
/*!40000 ALTER TABLE `scholarapp_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_event_attendees`
--

DROP TABLE IF EXISTS `scholarapp_event_attendees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_event_attendees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `event_id` bigint NOT NULL,
  `customuser_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scholarapp_event_attendees_event_id_customuser_id_8d82de30_uniq` (`event_id`,`customuser_id`),
  KEY `scholarapp_event_att_customuser_id_e39041bf_fk_scholarap` (`customuser_id`),
  CONSTRAINT `scholarapp_event_att_customuser_id_e39041bf_fk_scholarap` FOREIGN KEY (`customuser_id`) REFERENCES `scholarapp_customuser` (`id`),
  CONSTRAINT `scholarapp_event_att_event_id_3c94e1c2_fk_scholarap` FOREIGN KEY (`event_id`) REFERENCES `scholarapp_event` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_event_attendees`
--

LOCK TABLES `scholarapp_event_attendees` WRITE;
/*!40000 ALTER TABLE `scholarapp_event_attendees` DISABLE KEYS */;
INSERT INTO `scholarapp_event_attendees` VALUES (14,84,1),(13,84,3);
/*!40000 ALTER TABLE `scholarapp_event_attendees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_event_authors`
--

DROP TABLE IF EXISTS `scholarapp_event_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_event_authors` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `event_id` bigint NOT NULL,
  `customuser_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scholarapp_event_authors_event_id_customuser_id_cd89553a_uniq` (`event_id`,`customuser_id`),
  KEY `scholarapp_event_aut_customuser_id_48fcecbe_fk_scholarap` (`customuser_id`),
  CONSTRAINT `scholarapp_event_aut_customuser_id_48fcecbe_fk_scholarap` FOREIGN KEY (`customuser_id`) REFERENCES `scholarapp_customuser` (`id`),
  CONSTRAINT `scholarapp_event_aut_event_id_e18b006d_fk_scholarap` FOREIGN KEY (`event_id`) REFERENCES `scholarapp_event` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_event_authors`
--

LOCK TABLES `scholarapp_event_authors` WRITE;
/*!40000 ALTER TABLE `scholarapp_event_authors` DISABLE KEYS */;
INSERT INTO `scholarapp_event_authors` VALUES (7,9,1),(8,10,1),(110,10,3),(9,11,1),(10,12,1),(11,13,1),(12,14,1),(14,20,2),(15,21,2),(16,22,2),(17,23,2),(18,24,2),(19,25,2),(20,26,2),(21,27,2),(22,28,2),(23,29,2),(24,30,2),(25,31,2),(26,32,2),(27,33,2),(28,34,2),(29,35,2),(30,36,2),(31,37,2),(32,38,2),(33,39,2),(34,40,2),(35,41,2),(36,42,2),(37,43,2),(38,44,2),(39,45,2),(40,46,2),(41,47,2),(42,48,2),(43,49,2),(44,50,2),(45,51,2),(46,52,2),(47,53,2),(48,54,2),(49,55,2),(50,56,2),(51,57,2),(52,58,2),(53,59,2),(54,60,2),(55,61,2),(56,62,2),(57,63,2),(58,64,2),(59,65,2),(62,68,3),(63,69,3),(64,70,3),(65,71,3),(66,72,3),(67,73,3),(68,74,3),(69,75,3),(70,76,3),(71,77,3),(72,78,3),(73,79,3),(74,80,3),(75,81,3),(76,82,3),(77,83,3),(94,84,1),(96,85,1),(95,85,3),(99,88,1),(111,105,24),(112,106,24),(113,107,24),(114,108,24),(115,109,24),(116,110,24),(117,111,24),(118,112,24),(119,113,24),(120,114,24);
/*!40000 ALTER TABLE `scholarapp_event_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_followers`
--

DROP TABLE IF EXISTS `scholarapp_followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_followers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `follower_id` bigint NOT NULL,
  `following_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `scholarapp_followers_follower_id_02deb630_fk_scholarap` (`follower_id`),
  KEY `scholarapp_followers_following_id_095cee91_fk_scholarap` (`following_id`),
  CONSTRAINT `scholarapp_followers_follower_id_02deb630_fk_scholarap` FOREIGN KEY (`follower_id`) REFERENCES `scholarapp_customuser` (`id`),
  CONSTRAINT `scholarapp_followers_following_id_095cee91_fk_scholarap` FOREIGN KEY (`following_id`) REFERENCES `scholarapp_customuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_followers`
--

LOCK TABLES `scholarapp_followers` WRITE;
/*!40000 ALTER TABLE `scholarapp_followers` DISABLE KEYS */;
/*!40000 ALTER TABLE `scholarapp_followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_message`
--

DROP TABLE IF EXISTS `scholarapp_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `time_sent` datetime(6) NOT NULL,
  `parent_conversation_id` bigint NOT NULL,
  `user_from_id` bigint NOT NULL,
  `message` longtext,
  PRIMARY KEY (`id`),
  KEY `scholarapp_message_parent_conversation__116192a7_fk_scholarap` (`parent_conversation_id`),
  KEY `scholarapp_message_user_from_id_421f1e7f_fk_scholarap` (`user_from_id`),
  CONSTRAINT `scholarapp_message_parent_conversation__116192a7_fk_scholarap` FOREIGN KEY (`parent_conversation_id`) REFERENCES `scholarapp_conversation` (`id`),
  CONSTRAINT `scholarapp_message_user_from_id_421f1e7f_fk_scholarap` FOREIGN KEY (`user_from_id`) REFERENCES `scholarapp_customuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_message`
--

LOCK TABLES `scholarapp_message` WRITE;
/*!40000 ALTER TABLE `scholarapp_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `scholarapp_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scholarapp_profile`
--

DROP TABLE IF EXISTS `scholarapp_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scholarapp_profile` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rank` varchar(256) NOT NULL,
  `research_interests` varchar(256) NOT NULL,
  `rank_link` varchar(200) NOT NULL,
  `education` longtext NOT NULL,
  `academic_experience` longtext NOT NULL,
  `non_academic_experience` longtext NOT NULL,
  `certifications` longtext NOT NULL,
  `memberships` longtext NOT NULL,
  `honors` longtext NOT NULL,
  `service_activities` longtext NOT NULL,
  `courses` longtext NOT NULL,
  `references` longtext NOT NULL,
  `staff_member_achievements` longtext NOT NULL,
  `user_id` bigint NOT NULL,
  `department` varchar(256) NOT NULL,
  `development_activities` longtext NOT NULL DEFAULT (_utf8mb3''),
  `program` varchar(256) NOT NULL,
  `skills` varchar(256) NOT NULL,
  `tags` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `scholarapp_profile_user_id_1a24e2f3_uniq` (`user_id`),
  CONSTRAINT `scholarapp_profile_user_id_1a24e2f3_fk_scholarapp_customuser_id` FOREIGN KEY (`user_id`) REFERENCES `scholarapp_customuser` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scholarapp_profile`
--

LOCK TABLES `scholarapp_profile` WRITE;
/*!40000 ALTER TABLE `scholarapp_profile` DISABLE KEYS */;
INSERT INTO `scholarapp_profile` VALUES (29,'Full Time Senior Lecturer','Artificial Intelligence, Biomimetics','','','','','','','','','','','',3,'Engineering','','Electrical and Communications','OpenCV•Tensorflow•Huawei ICT','Artificial Intelligence '),(30,' Full-time Senior Lecturer','Cryptography and Artificial Intelligence','https://www.bau.edu.lb/Staff/Engineering/Academic','Ph.D., Computer Engineering, BAU, 2017 - Present•M.Sc., Computer Engineering, BAU, 2017•B.Sc., Computer Engineering, BAU, 2015','Beirut Arab University, 2022 – present, full time, Senior Lecturer•Beirut Arab University, 2015 – 2021, part time, Lab Instructor and Lecturer','Laptop Company – Lebanon - Internship, Hardware and software maintenance•Aynacorp, 2014, Internship, working with the hardware team to create a NOLLO phone for elderly and children.','Course Certifications: Fundamental of Robotics, Advanced Robotics, Computer Vision, Deep Learning, AI and Medicine','Member in Order of Engineering Lebanon','Jamal Abd-Nasser Award for education excellence (50% scholarship for master)','Member in the Quality Assurance committee•Member in the ERASMUS+ committee•Supervised many Senior projects (Domains: Blockchain, smart cities, Hospital Management, intelligent software development)•Advised Master Student for choosing research track•Participated in the project of Developing Curricula for Artificial Intelligence and Robotics (DeCAIR) where old courses were updated and new courses created.•Created a group for computer engineering students to share job opportunities and events•Cooperated with a hospital in France to do a customized software in CE.•Cooperated with a company in Emirates to co-supervise and sponsor 3 CE FYPs.•Attended 2 workshops related to IBDAA competition held in AUB•Building a Professional CV Workshop given by Dr Hassan Baalbaki – LAU•BAU Meeting with CERN representative, MENA Mr Martin Gastal•Assigned as the coordinator of COMP208 course•Assigned as the Council Secretary for Electrical and Computer Engineering department. This includes writing agendas, minutes and managing emails communication.•Participated in a project with Biomedical Engineering (Low-cost Prosthetic Arm)•Geek Express: Company job fair for teaching programming for kids•Attended two Scientific Days with supervision of many FYP projects•Experience Courses (Graduate and Undergraduate)•Introduction to Robotics (Lecture), Programming 1 (Lecture &Lab), Transmission and Processing of Digital Signals (Lecture & Lab), Object Oriented Programming (Lecture & Lab), Programming 2 (Lecture &Lab), Web Programming (Lab), Cryptography and Information Security (Lecture &Lab), Queuing and modeling (Lecture and Lab), Computer Networks (Lab), Artificial Intelligence (Lab), Software Development (Lab), Data Structures (Lecture and Lab), Microprocessor Fundamentals (Lab), Advanced Microprocessor (Lab)•CPU Design (Lab), Digital Systems (Lab), Computer Algorithms (Lab), Data Base Systems (Lab), Software Engineering (Lecture and Lab)','','Prof. Ali Haidar ari@bau.edu.lb (+9613676121)•Prof. Ziad Osman z.osman@bau.edu.lb (+9613836089)','',1,'Engineering','Attended “AI and Medicine” course given by the University of Genova (Italy)•DeCAIR Erasmus+: Attended “Deep Learning” course offered by University of Genoa•DeCAIR Erasmus+ :Attended “Computer Vision” course offered by University of Genoa•Attended the workshop “Advanced Robotics” offered by the university of Pisa (Italy)•Erasmus+, DECAIR, IEEE: Breaking the Laws of Robotics: Attacking Industrial Robots, by Dr. Stefano Zanero (Amman, Jordan) Attended Online•Erasmus+, DECAIR: Modern Higher Education Teaching and Learning Methodologies•Erasmus+, DECAIR: “Fundamental of Robotics” Training Course (20 hours)•Erasmus+, DECAIR: Advanced Robotics (Italy, Piza)•Erasmus+, ELEGANT: Enhancing Teaching, Learning and Graduate Employability through University- Enterprise Cooperation (BAU & MUBS) Attended Online (part1)•Erasmus+, ELEGANT: Enhancing Teaching, Learning and Graduate Employability through University- Enterprise Cooperation (part2 day1-2)•Erasmus+, ELEGANT: A Work-Ready Seminar Stand Out to Get Hired•IEEE online meeting: Techniques for Effective Searching in IEEE Xplore•ABET Meeting on Assessment with Dr Hadi Abou Chakra•Attended the talk titled: Cybersecurity and Blockchain held in A3 and given by Prof. Layth Sliman from EFREI University France•Huwaei Technologies Workshop•ELSEVIER Journal, Applied Soft Computing Journal, IEEE Conference, Other Conferences','Electrical and Communications','Python•OpenCV•Metasploit','Machine Learning Applications •Artificial Intelligence '),(31,'','','','','','','','','','','','','',2,'','','','',''),(52,'Senior Lecturer','','','','','','','','','','','','',24,'Engineering','','Electrical and Communications','','');
/*!40000 ALTER TABLE `scholarapp_profile` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-17 21:02:42
