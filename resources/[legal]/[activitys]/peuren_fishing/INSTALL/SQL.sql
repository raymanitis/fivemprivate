CREATE TABLE IF NOT EXISTS `fishing_players` (
  `identifier` varchar(128) NOT NULL,
  `skill` int(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
);