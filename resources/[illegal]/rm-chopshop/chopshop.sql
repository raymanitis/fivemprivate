CREATE TABLE IF NOT EXISTS `rm_chopshop_xp` (
  `citizenid` VARCHAR(64) NOT NULL,
  `xp` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;