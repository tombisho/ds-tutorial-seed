CREATE DATABASE IF NOT EXISTS sqlrealm;

USE `sqlrealm`;

DROP TABLE IF EXISTS `user`;


CREATE TABLE `user` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `username` varchar(45) NOT NULL,
 `first_name` varchar(128) DEFAULT NULL,
 `last_name` varchar(128) DEFAULT NULL,
 `email` varchar(128) NOT NULL,
 `password` varchar(128) NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

INSERT INTO `user` (`username`, `first_name`, `last_name`, `email`, `password`) values ('jbrown', 'James', 'Brown', 'jbrown@example.com','yoyo1234');
INSERT INTO `user` (`username`, `first_name`, `last_name`, `email`, `password`) values ('tmarconi', 'Toto', 'Marconi', 'tmarconi@example.com','toto1234');