-- MySQL dump 10.13  Distrib 5.7.19, for Linux (x86_64)
--
-- Host: 172.22.247.7    Database: gni
-- ------------------------------------------------------
-- Server version	5.6.28-0ubuntu0.14.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `canonical_forms`
--

DROP TABLE IF EXISTS `canonical_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `canonical_forms` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_letter` char(1) NOT NULL,
  `length` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_canonical_forms_1` (`name`),
  KEY `idx_canonical_forms_2` (`first_letter`,`length`)
) ENGINE=InnoDB AUTO_INCREMENT=230489066 DEFAULT CHARSET=ascii;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_source_contributors`
--

DROP TABLE IF EXISTS `data_source_contributors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_source_contributors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_source_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `data_source_admin` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_data_source_contributors1` (`data_source_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `data_sources`
--

DROP TABLE IF EXISTS `data_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `data_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `logo_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `web_site_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `refresh_period_days` int(11) DEFAULT '14',
  `name_strings_count` int(11) DEFAULT '0',
  `data_hash` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unique_names_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_data_sources_1` (`data_url`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dwca_importers`
--

DROP TABLE IF EXISTS `dwca_importers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dwca_importers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_source_id` int(11) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dwca_importers_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_logs`
--

DROP TABLE IF EXISTS `job_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `job_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `job_id` int(11) DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_job_logs_on_type_and_job_id` (`type`,`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=216524 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lexical_group_name_strings`
--

DROP TABLE IF EXISTS `lexical_group_name_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lexical_group_name_strings` (
  `name_string_id` int(11) unsigned NOT NULL,
  `lexical_group_id` int(11) unsigned NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`name_string_id`,`lexical_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lexical_groups`
--

DROP TABLE IF EXISTS `lexical_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lexical_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `supercedure_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lexical_groups_1` (`supercedure_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lexical_match_candidates`
--

DROP TABLE IF EXISTS `lexical_match_candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lexical_match_candidates` (
  `canonical_form_id` int(11) unsigned NOT NULL,
  `candidate_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `processed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`canonical_form_id`,`candidate_name`),
  KEY `idx_lexical_match_candidates2` (`processed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lexical_matches`
--

DROP TABLE IF EXISTS `lexical_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lexical_matches` (
  `canonical_form_id` int(11) unsigned NOT NULL,
  `matched_canonical_form_id` int(11) unsigned NOT NULL,
  `edit_distance` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`canonical_form_id`,`matched_canonical_form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `name_resolvers`
--

DROP TABLE IF EXISTS `name_resolvers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `name_resolvers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `options` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `progress_status_id` int(11) DEFAULT NULL,
  `progress_message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_name_resolvers_on_token` (`token`),
  KEY `index_external_list_reconcilers_on_progress_status_id` (`progress_status_id`)
) ENGINE=InnoDB AUTO_INCREMENT=28661747 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `name_string_indices`
--

DROP TABLE IF EXISTS `name_string_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `name_string_indices` (
  `data_source_id` int(11) NOT NULL,
  `name_string_id` int(11) unsigned NOT NULL,
  `taxon_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `global_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accepted_taxon_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `synonym` set('synonym','lexical','homotypic','heterotypic') COLLATE utf8_unicode_ci DEFAULT NULL,
  `classification_path` text COLLATE utf8_unicode_ci,
  `classification_path_ids` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `nomenclatural_code_id` int(11) DEFAULT NULL,
  `local_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `classification_path_ranks` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`data_source_id`,`name_string_id`,`taxon_id`),
  KEY `idx_name_index_records_1` (`name_string_id`),
  KEY `idx_name_index_records_3` (`synonym`),
  KEY `index_name_string_indices_on_taxon_id` (`taxon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `name_strings`
--

DROP TABLE IF EXISTS `name_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `name_strings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `normalized` varchar(255) CHARACTER SET ascii DEFAULT NULL,
  `canonical_form_id` int(11) DEFAULT NULL,
  `has_words` tinyint(1) DEFAULT NULL,
  `uuid` decimal(39,0) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parser_version` int(11) DEFAULT '10000',
  `has_groups` tinyint(1) DEFAULT '0',
  `surrogate` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `idx_name_strings_1` (`name`),
  KEY `idx_name_strings_2` (`canonical_form_id`),
  KEY `idx_name_strings_3` (`normalized`),
  KEY `idx_name_strings_4` (`parser_version`),
  KEY `idx_name_strings_5` (`has_words`),
  KEY `idx_name_strings_6` (`has_groups`)
) ENGINE=InnoDB AUTO_INCREMENT=202618586 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `name_word_semantic_meanings`
--

DROP TABLE IF EXISTS `name_word_semantic_meanings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `name_word_semantic_meanings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name_word_id` int(11) unsigned NOT NULL,
  `name_string_id` int(11) unsigned NOT NULL,
  `semantic_meaning_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `length` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name_words_semantics_1` (`name_word_id`,`name_string_id`,`position`),
  KEY `idx_name_words_semantics_2` (`name_string_id`)
) ENGINE=InnoDB AUTO_INCREMENT=898142973 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `name_words`
--

DROP TABLE IF EXISTS `name_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `name_words` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `word` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_letter` char(1) CHARACTER SET ascii NOT NULL,
  `length` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name_words_1` (`word`),
  KEY `idx_name_words_2` (`first_letter`,`length`)
) ENGINE=InnoDB AUTO_INCREMENT=828116318 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nomenclatural_codes`
--

DROP TABLE IF EXISTS `nomenclatural_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `nomenclatural_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parsed_name_strings`
--

DROP TABLE IF EXISTS `parsed_name_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parsed_name_strings` (
  `id` int(11) unsigned NOT NULL,
  `canonical_form` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parser_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parsed` tinyint(1) DEFAULT NULL,
  `pass_num` int(11) DEFAULT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parsed_name_strings_1` (`parser_version`),
  KEY `idx_parsed_name_strings_2` (`pass_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `progress_statuses`
--

DROP TABLE IF EXISTS `progress_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progress_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reconciler_batches`
--

DROP TABLE IF EXISTS `reconciler_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reconciler_batches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reconciler_id` int(11) DEFAULT NULL,
  `offset` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reconciler_batches_on_reconciler_id` (`reconciler_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14231 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reconciler_data_sources`
--

DROP TABLE IF EXISTS `reconciler_data_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reconciler_data_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reconciler_id` int(11) DEFAULT NULL,
  `data_source_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_reconciler_data_sources_on_reconciler_id` (`reconciler_id`),
  KEY `index_reconciler_data_sources_on_data_source_id` (`data_source_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reconcilers`
--

DROP TABLE IF EXISTS `reconcilers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reconcilers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `batch_size` int(11) DEFAULT '10000',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `semantic_meanings`
--

DROP TABLE IF EXISTS `semantic_meanings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `semantic_meanings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vernacular_string_indices`
--

DROP TABLE IF EXISTS `vernacular_string_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vernacular_string_indices` (
  `data_source_id` int(11) NOT NULL,
  `vernacular_string_id` int(11) unsigned NOT NULL,
  `taxon_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locality` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`data_source_id`,`vernacular_string_id`,`taxon_id`),
  KEY `idx_vernacular_string_index_records_1` (`vernacular_string_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vernacular_strings`
--

DROP TABLE IF EXISTS `vernacular_strings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vernacular_strings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `uuid` decimal(39,0) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid` (`uuid`),
  UNIQUE KEY `idx_vernacular_strings_1` (`name`),
  KEY `idx_vernacular_strings_2` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=6804690 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-08-14 11:47:23
