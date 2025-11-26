CREATE TABLE IF NOT EXISTS `mdt_incidents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` TEXT,
  `players` TEXT,
  `victims` TEXT,
  `cops` TEXT,
  `vehicles` TEXT,
  `evidences` TEXT,
  `charges` TEXT,
  `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_evidences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` TEXT,
  `players` TEXT,
  `cops` TEXT,
  `vehicles` TEXT,
  `weapons` TEXT,
  `images` TEXT,
  `archive` TEXT,
  `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reason` TEXT NOT NULL,
  `players` TEXT NOT NULL,
  `house` TEXT,
  `tag` varchar(64) DEFAULT NULL,
  `date` varchar(64) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_bolos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` TEXT,
  `player` varchar(255),
  `vehicle` varchar(255),
  `tag` varchar(64),
  `date` varchar(64) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_gallery` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(64) NOT NULL,
    `type` VARCHAR(10) NOT NULL,
    `value` TEXT NOT NULL,
    `description` TEXT,
    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_weapons` (
    `label` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL,
    `serial` VARCHAR(20) NOT NULL,
    `identifier` VARCHAR(64) DEFAULT NULL,
    `notes` TEXT,
    PRIMARY KEY (`serial`)
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS `mdt_charges` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `jail` int(11) DEFAULT 0,
    `fine` FLOAT DEFAULT 0,
    `tag` VARCHAR(64) DEFAULT NULL,
    `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_tags` (
    `identifier` VARCHAR(64) NOT NULL,
    `type` VARCHAR(64) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT,
    `color` VARCHAR(64) NOT NULL,
    PRIMARY KEY (`identifier`)
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS `mdt_activity` (
    `identifier` VARCHAR(64) NOT NULL,
    `amount` FLOAT NOT NULL,
    `clockIn` VARCHAR(128) NOT NULL,
    `clockOut` TIMESTAMP NOT NULL DEFAULT current_timestamp()
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS `mdt_announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `content` TEXT NOT NULL,
  `author` varchar(255) NOT NULL,
  `pinned` BOOLEAN DEFAULT FALSE,
  `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` TEXT,
  `code` varchar(32) NOT NULL UNIQUE,
  `createdAt` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 AUTO_INCREMENT=0;

CREATE TABLE IF NOT EXISTS `mdt_citizens` (
    `identifier` VARCHAR(64) NOT NULL UNIQUE,
    `firstname` VARCHAR(20) NOT NULL,
    `lastname` VARCHAR(20) NOT NULL,
    `gender` VARCHAR(10) NOT NULL,
    `birthdate` varchar(64) NOT NULL,
    `job` VARCHAR(128) DEFAULT '{}',
    `licenses` TEXT,
    `fingerprint` VARCHAR(64) DEFAULT NULL,
    `notes` TEXT,
    `image` TEXT,
    PRIMARY KEY (`identifier`)
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS `mdt_vehicles` (
    `plate` VARCHAR(32) NOT NULL UNIQUE,
    `model` VARCHAR(32) NOT NULL,
    `owner` VARCHAR(64) NOT NULL,
    `notes` TEXT,
    `image` TEXT,
    PRIMARY KEY (`plate`)
) CHARACTER SET utf8mb4;

CREATE TABLE IF NOT EXISTS `mdt_cameras` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prop` VARCHAR(64) NOT NULL,
  `label` VARCHAR(128) NOT NULL,
  `active` BOOLEAN DEFAULT TRUE,
  `rotation` LONGTEXT NOT NULL,
  `coords` LONGTEXT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci AUTO_INCREMENT=0;