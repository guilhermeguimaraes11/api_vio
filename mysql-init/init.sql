CREATE DATABASE  IF NOT EXISTS `vio_guilherme` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vio_guilherme`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: vio_guilherme
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `compra`
--

LOCK TABLES `compra` WRITE;
/*!40000 ALTER TABLE `compra` DISABLE KEYS */;
INSERT INTO `compra` VALUES (1,'2024-11-14 19:04:00',1),(2,'2024-11-13 17:00:00',1),(3,'2024-11-12 15:30:00',2),(4,'2024-11-11 14:20:00',2),(5,'2025-05-12 10:51:10',3),(6,'2025-05-12 13:11:02',4),(7,'2025-05-12 13:18:27',7),(8,'2025-05-12 13:24:57',7),(9,'2025-05-12 13:51:11',1);
/*!40000 ALTER TABLE `compra` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `evento`
--

LOCK TABLES `evento` WRITE;
/*!40000 ALTER TABLE `evento` DISABLE KEYS */;
INSERT INTO `evento` VALUES (1,'Festival de Verão','Evento de Verão','2024-12-15 00:00:00','Praia Central',1),(2,'Congresso de Tecnologia','Evento de Tecnologia','2024-11-20 00:00:00','Novo Congresso',2),(3,'Show Internacional','Evento Internacional','2024-10-30 00:00:00','Arena Principal',3),(4,'Feira Cultural de Inverno','Evento Cultural com música e gastronomia.','2025-07-20 18:00:00','Teatro Central',1);
/*!40000 ALTER TABLE `evento` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alunods`@`%`*/ /*!50003 TRIGGER `impedir_alteracao_evento_passado` BEFORE UPDATE ON `evento` FOR EACH ROW begin
    if old.data_hora < curdate() then
        signal sqlstate '45000'
        set message_text = 'Não é permitido alterar eventos que já ocorreram.';
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping data for table `ingresso`
--

LOCK TABLES `ingresso` WRITE;
/*!40000 ALTER TABLE `ingresso` DISABLE KEYS */;
INSERT INTO `ingresso` VALUES (1,500.00,'VIP',1),(2,150.00,'PISTA',1),(3,200.00,'PISTA',2),(4,600.00,'VIP',3),(5,250.00,'PISTA',3),(6,120.00,'vip',4),(7,60.00,'pista',4);
/*!40000 ALTER TABLE `ingresso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `ingresso_compra`
--

LOCK TABLES `ingresso_compra` WRITE;
/*!40000 ALTER TABLE `ingresso_compra` DISABLE KEYS */;
INSERT INTO `ingresso_compra` VALUES (1,5,4,1),(2,2,5,1),(3,1,1,2),(4,2,2,2),(5,2,5,5),(6,10,7,8);
/*!40000 ALTER TABLE `ingresso_compra` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`alunods`@`%`*/ /*!50003 TRIGGER `verifica_data_evento` BEFORE INSERT ON `ingresso_compra` FOR EACH ROW begin 
    declare data_evento datetime;
    declare id_evento int;

    -- buscar data do evento    
    select e.data_hora 
    into data_evento
    from ingresso i
    join evento e on i.fk_id_evento = e.id_evento
    where i.id_ingresso = new.fk_id_ingresso;
    
    -- verificar se o evento já ocorreu
    if date(data_evento) < curdate() then 
        signal sqlstate '45000'
        set message_text = 'Não é possível comprar ingressos para eventos passados.';       
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping data for table `log_evento`
--

LOCK TABLES `log_evento` WRITE;
/*!40000 ALTER TABLE `log_evento` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `organizador`
--

LOCK TABLES `organizador` WRITE;
/*!40000 ALTER TABLE `organizador` DISABLE KEYS */;
INSERT INTO `organizador` VALUES (1,'Organização ABC','contato@abc.com','senha123','11111222333'),(2,'Eventos XYZ','info@xyz.com','senha123','11222333444'),(3,'Festivais BR','contato@festbr.com','senha123','11333444555'),(4,'Eventos GL','support@gl.com','senha123','11444555666'),(5,'Eventos JQ','contact@jq.com','senha123','11555666777');
/*!40000 ALTER TABLE `organizador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `presenca`
--

LOCK TABLES `presenca` WRITE;
/*!40000 ALTER TABLE `presenca` DISABLE KEYS */;
/*!40000 ALTER TABLE `presenca` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'João Silva','joao.silva@example.com','senha123','16123456789','1990-01-15'),(2,'Maria Oliveira','maria.oliveira@example.com','senha123','16987654321','1985-06-23'),(3,'Carlos Pereira','carlos.pereira@example.com','senha123','16123987456','1992-11-30'),(4,'Ana Souza','ana.souza@example.com','senha123','16456123789','1987-04-18'),(5,'Pedro Costa','pedro.costa@example.com','senha123','16789123456','1995-08-22'),(6,'Laura Lima','laura.lima@example.com','senha123','16321654987','1998-09-09'),(7,'Lucas Alves','lucas.alves@example.com','senha123','16654321987','1993-12-01'),(8,'Fernanda Rocha','fernanda.rocha@example.com','senha123','16741852963','1991-07-07'),(9,'Rafael Martins','rafael.martins@example.com','senha123','16369258147','1994-03-27'),(10,'Juliana Nunes','juliana.nunes@example.com','senha123','16258147369','1986-05-15'),(11,'Paulo Araujo','paulo.araujo@example.com','senha123','16159753486','1997-10-12'),(12,'Beatriz Melo','beatriz.melo@example.com','senha123','16486159753','1990-02-28'),(13,'Renato Dias','renato.dias@example.com','senha123','16753486159','1996-11-11'),(14,'Camila Ribeiro','camila.ribeiro@example.com','senha123','16963852741','1989-08-03'),(15,'Thiago Teixeira','thiago.teixeira@example.com','senha123','16852741963','1992-12-24'),(16,'Patrícia Fernandes','patricia.fernandes@example.com','senha123','16741963852','1991-01-10'),(17,'Rodrigo Gomes','rodrigo.gomes@example.com','senha123','16963741852','1987-06-30'),(18,'Mariana Batista','mariana.batista@example.com','senha123','16147258369','1998-09-22'),(19,'Fábio Freitas','fabio.freitas@example.com','senha123','16369147258','1994-04-16'),(20,'Isabela Cardoso','isabela.cardoso@example.com','senha123','16258369147','1985-11-08');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'vio_guilherme'
--

--
-- Dumping routines for database 'vio_guilherme'
--
/*!50003 DROP PROCEDURE IF EXISTS `registrar_compra` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`alunods`@`%` PROCEDURE `registrar_compra`(
    in p_id_usuario int,
    in p_id_ingresso int,
    in p_quantidade int
)
begin
    declare v_id_compra int;


-- Criar regisro na tabela 'compra'
insert into compra (data_compra, fk_id_usuario)
values (now(), p_id_usuario);

-- Obter o ID da compra recém-criada
set v_id_compra = last_insert_id();

-- Registrar os ingressos comprados
insert into ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
    values (v_id_compra, p_id_ingresso, p_quantidade);

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-12 14:13:22
