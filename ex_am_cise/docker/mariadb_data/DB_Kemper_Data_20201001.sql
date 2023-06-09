-- MySQL dump 10.13  Distrib 5.6.24, for osx10.8 (x86_64)
--
-- Host: 127.0.0.1    Database: KEMPER_DATA
-- ------------------------------------------------------
-- Server version	5.6.20

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
-- Table structure for table `Assistenten`
--

DROP TABLE IF EXISTS `Assistenten`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Assistenten` (
  `PersNr` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Fachgebiet` varchar(30) DEFAULT NULL,
  `Boss` int(11) NOT NULL,
  PRIMARY KEY (`PersNr`),
  KEY `Boss` (`Boss`),
  CONSTRAINT `assistenten_ibfk_1` FOREIGN KEY (`Boss`) REFERENCES `Professoren` (`PersNr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Assistenten`
--

LOCK TABLES `Assistenten` WRITE;
/*!40000 ALTER TABLE `Assistenten` DISABLE KEYS */;
INSERT INTO `Assistenten` VALUES (3002,'Platon','Ideenlehre',2125),(3003,'Aristoteles','Syllogistik',2125),(3004,'Wittgenstein','Sprachtheorie',2126),(3005,'Rhetikus','Planetenbewegung',2127),(3006,'Newton','Keplersche Gesetze',2127),(3007,'Spinoza','Gott und Natur',2134);
/*!40000 ALTER TABLE `Assistenten` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Professoren`
--

DROP TABLE IF EXISTS `Professoren`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Professoren` (
  `PersNr` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Rang` varchar(10) DEFAULT NULL,
  `Standort` varchar(20) DEFAULT NULL,
  `Raum` int(11) DEFAULT NULL,
  PRIMARY KEY (`PersNr`),
  UNIQUE KEY `Raum` (`Raum`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Professoren`
--

LOCK TABLES `Professoren` WRITE;
/*!40000 ALTER TABLE `Professoren` DISABLE KEYS */;
INSERT INTO `Professoren` VALUES (2125,'Sokrates','C4','Jülich',226),(2126,'Russel','C4','Jülich',232),(2127,'Kopernikus','C3','Aachen',310),(2133,'Popper','C3','Aachen',52),(2134,'Augustinus','C3','Aachen',309),(2136,'Curie','C4','Jülich',36),(2137,'Kant','C4','Jülich',7);
/*!40000 ALTER TABLE `Professoren` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Vorlesungen`
--

DROP TABLE IF EXISTS `Vorlesungen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Vorlesungen` (
  `VorlNr` int(11) NOT NULL,
  `Titel` varchar(30) DEFAULT NULL,
  `SWS` int(11) DEFAULT NULL,
  `gelesenVon` int(11) NOT NULL,
  PRIMARY KEY (`VorlNr`),
  KEY `fk_Vorlesungen_Professoren1_idx` (`gelesenVon`),
  CONSTRAINT `fk_Vorlesungen_Professoren1` FOREIGN KEY (`gelesenVon`) REFERENCES `Professoren` (`PersNr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Vorlesungen`
--

LOCK TABLES `Vorlesungen` WRITE;
/*!40000 ALTER TABLE `Vorlesungen` DISABLE KEYS */;
INSERT INTO `Vorlesungen` VALUES (4052,'Logik',4,2125),(4630,'Die 3 Kritiken',4,2137),(5001,'Grundzuege',4,2125),(5022,'Glaube und Wissen',2,2134),(5041,'Ethik',4,2125),(5043,'Erkenntnistheorie',3,2126),(5049,'Maeeutik',2,2125),(5052,'Wissenschaftstheorie',3,2126),(5216,'Bioethik',2,2126),(5259,'Der Wiener Kreis',2,2133);
/*!40000 ALTER TABLE `Vorlesungen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hoeren`
--

DROP TABLE IF EXISTS `hoeren`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hoeren` (
  `MatrNr` int(11) NOT NULL DEFAULT '0',
  `VorlNr` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MatrNr`,`VorlNr`),
  KEY `fk_hoeren_Vorlesungen1_idx` (`VorlNr`),
  CONSTRAINT `fk_hoeren_Studenten1` FOREIGN KEY (`MatrNr`) REFERENCES `Studenten` (`MatrNr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_hoeren_Vorlesungen1` FOREIGN KEY (`VorlNr`) REFERENCES `Vorlesungen` (`VorlNr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hoeren`
--

LOCK TABLES `hoeren` WRITE;
/*!40000 ALTER TABLE `hoeren` DISABLE KEYS */;
INSERT INTO `hoeren` VALUES (27550,4052),(29120,4052),(29120,4630),(26120,5001),(27550,5001),(29120,5001),(29555,5001),(25403,5022),(29555,5022),(28106,5041),(29120,5041),(29120,5049),(28106,5052),(28106,5216),(28106,5259);
/*!40000 ALTER TABLE `hoeren` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pruefen`
--

DROP TABLE IF EXISTS `pruefen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pruefen` (
  `MatrNr` int(11) NOT NULL,
  `VorlNr` int(11) NOT NULL,
  `PersNr` int(11) NOT NULL,
  `Note` decimal(2,1) DEFAULT NULL,
  PRIMARY KEY (`MatrNr`,`VorlNr`,`PersNr`),
  KEY `fk_pruefen_Vorlesungen1_idx` (`VorlNr`),
  KEY `fk_pruefen_Professoren1_idx` (`PersNr`),
  CONSTRAINT `fk_pruefen_Professoren1` FOREIGN KEY (`PersNr`) REFERENCES `Professoren` (`PersNr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pruefen_Studenten1` FOREIGN KEY (`MatrNr`) REFERENCES `Studenten` (`MatrNr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_pruefen_Vorlesungen1` FOREIGN KEY (`VorlNr`) REFERENCES `Vorlesungen` (`VorlNr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pruefen`
--

LOCK TABLES `pruefen` WRITE;
/*!40000 ALTER TABLE `pruefen` DISABLE KEYS */;
INSERT INTO `pruefen` VALUES (24002,5041,2125,3.0),(25403,5041,2125,2.0),(27550,4630,2137,2.0),(28106,5001,2126,1.0),(29555,5041,2125,4.0);
/*!40000 ALTER TABLE `pruefen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `studenten`
--

DROP TABLE IF EXISTS `studenten`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `studenten` (
  `MatrNr` int(11) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `Semester` int(11) DEFAULT NULL,
  PRIMARY KEY (`MatrNr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `studenten`
--

LOCK TABLES `studenten` WRITE;
/*!40000 ALTER TABLE `studenten` DISABLE KEYS */;
INSERT INTO `studenten` VALUES (24002,'Xenokrates',18),(25403,'Jonas',12),(26120,'Fichte',10),(26830,'Aristoxenos',8),(27550,'Schopenhauer',6),(28106,'Carnap',3),(29120,'Theophrastos',2),(29555,'Feuerbach',2);
/*!40000 ALTER TABLE `studenten` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voraussetzen`
--

DROP TABLE IF EXISTS `voraussetzen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voraussetzen` (
  `Vorgaenger` int(11) NOT NULL DEFAULT '0',
  `Nachfolger` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Vorgaenger`,`Nachfolger`),
  KEY `fk_voraussetzen_Vorlesungen2_idx` (`Nachfolger`),
  CONSTRAINT `fk_voraussetzen_Vorlesungen1` FOREIGN KEY (`Vorgaenger`) REFERENCES `Vorlesungen` (`VorlNr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_voraussetzen_Vorlesungen2` FOREIGN KEY (`Nachfolger`) REFERENCES `Vorlesungen` (`VorlNr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voraussetzen`
--

LOCK TABLES `voraussetzen` WRITE;
/*!40000 ALTER TABLE `voraussetzen` DISABLE KEYS */;
INSERT INTO `voraussetzen` VALUES (5001,5041),(5001,5043),(5001,5049),(5041,5052),(5043,5052),(5041,5216),(5052,5259);
/*!40000 ALTER TABLE `voraussetzen` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-10-18 20:02:00
