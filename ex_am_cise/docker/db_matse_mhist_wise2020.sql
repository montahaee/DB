-- MariaDB dump 10.17  Distrib 10.5.5-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: matse_mhist
-- ------------------------------------------------------
-- Server version	10.5.5-MariaDB-1:10.5.5+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `abteilung`
--

DROP TABLE IF EXISTS `abteilung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `abteilung` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abteilung`
--

LOCK TABLES `abteilung` WRITE;
/*!40000 ALTER TABLE `abteilung` DISABLE KEYS */;
INSERT INTO `abteilung` VALUES (1,'Vorstand'),(2,'HR/Buchhaltung'),(3,'Vertrieb'),(4,'Marketing'),(5,'Einkauf'),(6,'F&E'),(7,'AR');
/*!40000 ALTER TABLE `abteilung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `arbeitet_in_als`
--

DROP TABLE IF EXISTS `arbeitet_in_als`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arbeitet_in_als` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mitarbeiter_id` int(11) NOT NULL,
  `abteilung_id` int(11) NOT NULL,
  `rolle_id` int(11) NOT NULL,
  `wochenstunden` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_arbeitet_in_als_mitarbeiter_idx` (`mitarbeiter_id`),
  KEY `fk_arbeitet_in_als_abteilung_idx` (`abteilung_id`),
  KEY `fk_arbeitet_in_als_rolle_idx` (`rolle_id`),
  CONSTRAINT `fk_arbeitet_in_als_abteilung` FOREIGN KEY (`abteilung_id`) REFERENCES `abteilung` (`id`),
  CONSTRAINT `fk_arbeitet_in_als_mitarbeiter` FOREIGN KEY (`mitarbeiter_id`) REFERENCES `mitarbeiter` (`id`),
  CONSTRAINT `fk_arbeitet_in_als_rolle` FOREIGN KEY (`rolle_id`) REFERENCES `rolle` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arbeitet_in_als`
--

LOCK TABLES `arbeitet_in_als` WRITE;
/*!40000 ALTER TABLE `arbeitet_in_als` DISABLE KEYS */;
INSERT INTO `arbeitet_in_als` VALUES (1,1,1,3,10.00),(2,1,1,4,5.00),(3,1,2,3,10.00),(4,1,2,4,15.00),(5,2,1,4,5.00),(6,2,3,3,10.00),(7,2,3,4,25.00),(12,3,1,4,5.00),(13,3,4,4,35.00),(14,4,7,3,10.00),(15,4,7,4,5.00),(16,5,7,4,5.00),(17,6,7,4,5.00),(18,7,2,4,20.00),(19,8,2,4,40.00),(20,9,3,4,40.00),(21,10,3,4,30.00),(22,11,3,4,40.00),(23,12,4,3,10.00),(24,12,4,4,30.00),(25,13,4,4,30.00),(26,23,4,8,20.00),(27,14,5,3,10.00),(28,14,5,4,30.00),(29,15,5,4,40.00),(30,16,6,3,10.00),(31,16,6,4,30.00),(32,17,6,4,40.00),(33,18,6,7,0.00),(34,18,6,8,20.00),(35,20,6,4,40.00),(36,18,6,4,20.00),(37,21,6,4,20.00),(38,22,6,7,0.00),(39,22,6,8,20.00),(40,22,6,4,20.00),(41,23,4,4,20.00);
/*!40000 ALTER TABLE `arbeitet_in_als` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `besteht_aus`
--

DROP TABLE IF EXISTS `besteht_aus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `besteht_aus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bestellung_id` int(11) NOT NULL,
  `produkt_id` int(11) NOT NULL,
  `einheiten` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_besteht_aus_bestellung_idx` (`bestellung_id`),
  KEY `fk_besteht_aus_produkt_idx` (`produkt_id`),
  CONSTRAINT `fk_besteht_aus_bestellung` FOREIGN KEY (`bestellung_id`) REFERENCES `bestellung` (`id`),
  CONSTRAINT `fk_besteht_aus_produkt` FOREIGN KEY (`produkt_id`) REFERENCES `produkt` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `besteht_aus`
--

LOCK TABLES `besteht_aus` WRITE;
/*!40000 ALTER TABLE `besteht_aus` DISABLE KEYS */;
INSERT INTO `besteht_aus` VALUES (1,1,15,12.00),(2,1,16,6.00),(3,1,18,24.00),(4,2,22,10.00),(5,2,23,5.00),(6,2,24,5.00),(7,2,11,20.00),(8,3,15,6.00),(9,3,17,12.00),(10,3,18,12.00);
/*!40000 ALTER TABLE `besteht_aus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bestellung`
--

DROP TABLE IF EXISTS `bestellung`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bestellung` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kunde_id` int(11) NOT NULL,
  `vermittler_mitarbeiter_id` int(11) NOT NULL,
  `vom` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_bestellung_kunde_idx` (`kunde_id`),
  KEY `fk_bestellung_mitarbeiter_idx` (`vermittler_mitarbeiter_id`),
  CONSTRAINT `fk_bestellung_kunde` FOREIGN KEY (`kunde_id`) REFERENCES `kunde` (`id`),
  CONSTRAINT `fk_bestellung_mitarbeiter` FOREIGN KEY (`vermittler_mitarbeiter_id`) REFERENCES `mitarbeiter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bestellung`
--

LOCK TABLES `bestellung` WRITE;
/*!40000 ALTER TABLE `bestellung` DISABLE KEYS */;
INSERT INTO `bestellung` VALUES (1,30,9,'2014-09-12 00:00:00'),(2,30,10,'2014-08-30 00:00:00'),(3,32,9,'2014-09-11 00:00:00');
/*!40000 ALTER TABLE `bestellung` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kennt`
--

DROP TABLE IF EXISTS `kennt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kennt` (
  `id` int(11) NOT NULL,
  `kunde_a_id` int(11) NOT NULL,
  `kunde_b_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_kennt_kunde_a_idx` (`kunde_a_id`),
  KEY `fk_kennt_kunde_b_idx` (`kunde_b_id`),
  CONSTRAINT `fk_kennt_kunde_a` FOREIGN KEY (`kunde_a_id`) REFERENCES `kunde` (`id`),
  CONSTRAINT `fk_kennt_kunde_b` FOREIGN KEY (`kunde_b_id`) REFERENCES `kunde` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kennt`
--

LOCK TABLES `kennt` WRITE;
/*!40000 ALTER TABLE `kennt` DISABLE KEYS */;
INSERT INTO `kennt` VALUES (1001,2,31),(1002,34,31),(1003,30,31),(1004,29,30),(1005,27,29),(1006,27,30),(1007,28,30),(1008,26,28),(1009,32,35),(1010,35,36),(1011,32,36),(1012,36,33);
/*!40000 ALTER TABLE `kennt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kunde`
--

DROP TABLE IF EXISTS `kunde`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kunde` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `rabatt_prozent` decimal(6,2) DEFAULT NULL,
  `ausfallrisiko_prozent` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kunde`
--

LOCK TABLES `kunde` WRITE;
/*!40000 ALTER TABLE `kunde` DISABLE KEYS */;
INSERT INTO `kunde` VALUES (2,'Bayer',1.00,NULL),(26,'BMW',1.00,NULL),(27,'Commerzbank',0.00,NULL),(28,'Daimler',1.00,NULL),(29,'Deutsche Bank',0.00,NULL),(30,'Sparkasse',10.00,NULL),(31,'Börse',0.00,NULL),(32,'E.ON',1.00,NULL),(33,'Infinion',2.00,NULL),(34,'Lufthansa',2.00,NULL),(35,'RWE',1.00,2.00),(36,'SAP',2.00,NULL);
/*!40000 ALTER TABLE `kunde` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mitarbeiter`
--

DROP TABLE IF EXISTS `mitarbeiter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mitarbeiter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `jahresgehalt` decimal(12,2) DEFAULT NULL,
  `vorgesetzter_mitarbeiter_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_mitarbeiter_mitarbeiter_idx` (`vorgesetzter_mitarbeiter_id`),
  CONSTRAINT `fk_mitarbeiter_mitarbeiter` FOREIGN KEY (`vorgesetzter_mitarbeiter_id`) REFERENCES `mitarbeiter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mitarbeiter`
--

LOCK TABLES `mitarbeiter` WRITE;
/*!40000 ALTER TABLE `mitarbeiter` DISABLE KEYS */;
INSERT INTO `mitarbeiter` VALUES (1,'Mia',110000.00,26),(2,'Ben',90000.00,26),(3,'Emma',70000.00,12),(4,'Paul',5000.00,27),(5,'Hannah',5000.00,27),(6,'Luka',5000.00,27),(7,'Sofia',50000.00,1),(8,'Jonas',50000.00,1),(9,'Anna',50000.00,2),(10,'Finn',50000.00,2),(11,'Lea',50000.00,2),(12,'Leon',70000.00,1),(13,'Emilia',50000.00,12),(14,'Luis',70000.00,1),(15,'Marie',50000.00,14),(16,'Lukas',70000.00,1),(17,'Lena',50000.00,16),(18,'Max',12000.00,16),(20,'Leonie',70000.00,1),(21,'Felix',14000.00,20),(22,'Lilly',12000.00,20),(23,'Tim',10000.00,12),(26,'GF',0.00,27),(27,'AR',0.00,26);
/*!40000 ALTER TABLE `mitarbeiter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produkt`
--

DROP TABLE IF EXISTS `produkt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produkt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(100) DEFAULT NULL,
  `warengruppe_id` int(11) NOT NULL,
  `einheit` varchar(20) DEFAULT NULL,
  `stueckpreis` decimal(12,2) DEFAULT NULL,
  `umsatzsteuer` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_produkt_warengruppe_idx` (`warengruppe_id`),
  CONSTRAINT `fk_produkt_warengruppe` FOREIGN KEY (`warengruppe_id`) REFERENCES `warengruppe` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produkt`
--

LOCK TABLES `produkt` WRITE;
/*!40000 ALTER TABLE `produkt` DISABLE KEYS */;
INSERT INTO `produkt` VALUES (1,'Spinat',1,'PK',1.99,0.07),(2,'Vier Käse Pizza',1,'ST',2.39,0.07),(3,'Spinatpizza',1,'ST',2.29,0.07),(4,'Fischstäbchen',1,'PK',1.99,0.07),(5,'Nudelpfanne',1,'PK',3.29,0.07),(6,'Möhren',2,'KG',0.39,0.07),(7,'Zwiebeln',2,'KG',0.29,0.07),(8,'Bananen',2,'KG',1.29,0.07),(9,'Knoblauch',2,'KG',0.98,0.07),(10,'Fleischwurst',3,'ST',1.99,0.07),(11,'Frikadellen',3,'PK',2.35,0.07),(12,'Milch',4,'ST',0.79,0.07),(13,'Quark',4,'ST',0.99,0.07),(14,'Joghurt',4,'ST',0.98,0.07),(15,'Cola light',5,'ST',1.50,0.19),(16,'Nerd Bull',5,'ST',1.50,0.19),(17,'Eistee',5,'ST',1.80,0.19),(18,'Wasser',5,'ST',0.99,0.19),(19,'Grillwürstchen',6,'PK',3.55,0.07),(20,'Leberkäse',6,'PK',2.79,0.07),(21,'Frikandeln',6,'PK',3.49,0.07),(22,'Chips',7,'PK',1.99,0.07),(23,'Salzstangen',7,'PK',1.79,0.07),(24,'Gummibärchen',7,'PK',1.59,0.07),(25,'Tee',8,'ST',2.50,0.19),(26,'Kaffee',8,'ST',3.20,0.19),(27,'Nudeln in Soße',9,'PK',1.99,0.07),(28,'Ravioli',9,'PK',1.89,0.07),(29,'Nudeln gebraten',9,'PK',2.39,0.07),(30,'Reis süß/sauer',9,'PK',2.19,0.07),(31,'Reisfladen',10,'ST',2.00,0.07),(32,'Gedeckter Apflekuchen',10,'ST',2.20,0.07),(33,'Belegtes Brötchen',10,'ST',2.80,0.07),(34,'Graubrot',10,'ST',1.90,0.07),(35,'Bild',11,'ST',0.90,0.07),(36,'Kicker',11,'ST',2.00,0.07),(37,'c\'t',11,'ST',3.70,0.07),(38,'Computerbild',11,'ST',2.20,0.07),(39,'Zeit',11,'ST',4.20,0.07),(43,'GameStar',11,'ST',6.50,0.07),(101,'Hochzeit',12,'1x',128.00,0.19),(102,'Scheidung',12,'nx',512.00,0.19);
/*!40000 ALTER TABLE `produkt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ressource`
--

DROP TABLE IF EXISTS `ressource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ressource` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inventar_code` varchar(100) DEFAULT NULL,
  `preis` decimal(12,2) DEFAULT NULL,
  `katalog_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ressource_inventar_code_uindex` (`inventar_code`),
  KEY `ressource_ressource_katalog_id_fk` (`katalog_id`),
  CONSTRAINT `ressource_ressource_katalog_id_fk` FOREIGN KEY (`katalog_id`) REFERENCES `ressource_katalog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ressource`
--

LOCK TABLES `ressource` WRITE;
/*!40000 ALTER TABLE `ressource` DISABLE KEYS */;
INSERT INTO `ressource` VALUES (1,'S-001',193.00,1),(2,'S-002',39.00,3),(3,'T-001',262.00,6),(4,'T-002',263.44,5),(5,'M-001',1120.00,7),(6,'M-002',1120.00,7),(7,'M-003',551.00,9);
/*!40000 ALTER TABLE `ressource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ressource_katalog`
--

DROP TABLE IF EXISTS `ressource_katalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ressource_katalog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `beschreibung` varchar(100) DEFAULT NULL,
  `artikelnr` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ressource_katalog`
--

LOCK TABLES `ressource_katalog` WRITE;
/*!40000 ALTER TABLE `ressource_katalog` DISABLE KEYS */;
INSERT INTO `ressource_katalog` VALUES (1,'Stuhl JÄRVFJÄLLET','892.756.23'),(2,'Stuhl HATTEFJÄLL','892.521.36'),(3,'Stuhl RENBERGET','203.394.20'),(4,'Tisch SKARSTA','593.248.18'),(5,'Tisch BEKANT','490.064.06'),(6,'Tisch IDÅSEN','992.810.39'),(7,'Mobile iPhone 11 Pro','MWC22ZD/A'),(8,'Mobile iPhone 11 Max','MWHQ2ZD/A'),(9,'Mobile Pixel 4','GA01188-DE');
/*!40000 ALTER TABLE `ressource_katalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ressource_mobile`
--

DROP TABLE IF EXISTS `ressource_mobile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ressource_mobile` (
  `id` int(11) NOT NULL,
  `beschreibung` varchar(100) DEFAULT NULL,
  `OS` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ressource_mobile_ressource_id_fk` FOREIGN KEY (`id`) REFERENCES `ressource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ressource_mobile`
--

LOCK TABLES `ressource_mobile` WRITE;
/*!40000 ALTER TABLE `ressource_mobile` DISABLE KEYS */;
INSERT INTO `ressource_mobile` VALUES (5,'iPhone 11 Pro, 5.8\" Display, Space Grau','iOS 14'),(6,'iPhone 11 Pro, 5.8\" Display, Nachtgrün','iOS 13'),(7,'Google Pixel 4 64GB Handy, weiß, Clearly White','Android 10');
/*!40000 ALTER TABLE `ressource_mobile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ressource_moebel`
--

DROP TABLE IF EXISTS `ressource_moebel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ressource_moebel` (
  `id` int(11) NOT NULL,
  `beschreibung` varchar(100) DEFAULT NULL,
  `raum` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `ressource_moebel_ressource_id_fk` FOREIGN KEY (`id`) REFERENCES `ressource` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ressource_moebel`
--

LOCK TABLES `ressource_moebel` WRITE;
/*!40000 ALTER TABLE `ressource_moebel` DISABLE KEYS */;
INSERT INTO `ressource_moebel` VALUES (1,'Drehstuhl mit Armlehnen, Gunnared dunkelgrau/schwarz','102.1'),(2,'Drehstuhl, Bomstad schwarz','103.1'),(3,'Schreibtisch, braun/dunkelgrau160x80 cm','103.1'),(4,'Schreibtisch sitz/steh, weiß160x80 cm','102.1');
/*!40000 ALTER TABLE `ressource_moebel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolle`
--

DROP TABLE IF EXISTS `rolle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rolle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `beschreibung` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolle`
--

LOCK TABLES `rolle` WRITE;
/*!40000 ALTER TABLE `rolle` DISABLE KEYS */;
INSERT INTO `rolle` VALUES (3,'Leitung'),(4,'Mitarbeiter'),(7,'Student'),(8,'Auszubildender'),(9,'Schüler');
/*!40000 ALTER TABLE `rolle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sitzt_am`
--

DROP TABLE IF EXISTS `sitzt_am`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sitzt_am` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `abteilung_id` int(11) NOT NULL,
  `standort_id` int(11) NOT NULL,
  `ist_hauptsitz` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sitzt_am_standort_idx` (`standort_id`),
  KEY `fk_sitzt_am_abteilung_idx` (`abteilung_id`),
  CONSTRAINT `fk_sitzt_am_abteilung` FOREIGN KEY (`abteilung_id`) REFERENCES `abteilung` (`id`),
  CONSTRAINT `fk_sitzt_am_standort` FOREIGN KEY (`standort_id`) REFERENCES `standort` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sitzt_am`
--

LOCK TABLES `sitzt_am` WRITE;
/*!40000 ALTER TABLE `sitzt_am` DISABLE KEYS */;
INSERT INTO `sitzt_am` VALUES (1,1,1,1),(2,2,1,1),(3,3,2,1),(4,3,1,0),(5,3,3,0),(6,3,4,0),(7,5,3,1),(8,4,3,1),(9,6,1,1),(10,6,2,0);
/*!40000 ALTER TABLE `sitzt_am` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `standort`
--

DROP TABLE IF EXISTS `standort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `standort` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ort` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `standort`
--

LOCK TABLES `standort` WRITE;
/*!40000 ALTER TABLE `standort` DISABLE KEYS */;
INSERT INTO `standort` VALUES (1,'Aachen'),(2,'Jülich'),(3,'Köln'),(4,'Berlin');
/*!40000 ALTER TABLE `standort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tier`
--

DROP TABLE IF EXISTS `tier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(30) NOT NULL,
  `mitarbeiter_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tier_mitarbeiter_id_fk` (`mitarbeiter_id`),
  CONSTRAINT `tier_mitarbeiter_id_fk` FOREIGN KEY (`mitarbeiter_id`) REFERENCES `mitarbeiter` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tier`
--

LOCK TABLES `tier` WRITE;
/*!40000 ALTER TABLE `tier` DISABLE KEYS */;
INSERT INTO `tier` VALUES (1,'Petra',4),(2,'Mini',18),(3,'Rosa',NULL);
/*!40000 ALTER TABLE `tier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `verantwortlich_fuer`
--

DROP TABLE IF EXISTS `verantwortlich_fuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `verantwortlich_fuer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mitarbeiter_id` int(11) NOT NULL,
  `ressource_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_verantwortlich_fuer_mitarbeiter_idx` (`mitarbeiter_id`),
  KEY `fk_verantwortlich_fuer_ressource_idx` (`ressource_id`),
  CONSTRAINT `fk_verantwortlich_fuer_mitarbeiter` FOREIGN KEY (`mitarbeiter_id`) REFERENCES `mitarbeiter` (`id`),
  CONSTRAINT `verantwortlich_fuer_ressource_id_fk` FOREIGN KEY (`ressource_id`) REFERENCES `ressource` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verantwortlich_fuer`
--

LOCK TABLES `verantwortlich_fuer` WRITE;
/*!40000 ALTER TABLE `verantwortlich_fuer` DISABLE KEYS */;
INSERT INTO `verantwortlich_fuer` VALUES (1,1,1),(2,1,3),(3,1,5),(4,1,7),(5,2,2),(6,2,4),(7,2,6),(8,2,7);
/*!40000 ALTER TABLE `verantwortlich_fuer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warengruppe`
--

DROP TABLE IF EXISTS `warengruppe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warengruppe` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warengruppe`
--

LOCK TABLES `warengruppe` WRITE;
/*!40000 ALTER TABLE `warengruppe` DISABLE KEYS */;
INSERT INTO `warengruppe` VALUES (1,'TK'),(2,'Obst, Gemüse'),(3,'Wurst, Aufschnitt'),(4,'Milchprodukte'),(5,'Kaltgetränke'),(6,'Grillgut'),(7,'Snacks, Süsswaren'),(8,'Heissgetränke'),(9,'Fertiggerichte'),(10,'Brot, Backwaren'),(11,'Zeitschriften'),(12,'Dienstleistung');
/*!40000 ALTER TABLE `warengruppe` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-12 21:33:37
