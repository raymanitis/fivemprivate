CREATE TABLE IF NOT EXISTS `racing_racers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` text NOT NULL,
  `name` text NOT NULL,
  `avatar_url` text DEFAULT NULL,
  `crew` int(11) NOT NULL DEFAULT 0,
  `mmr` int(11) NOT NULL DEFAULT 0,
  `completed` int(11) DEFAULT 0,
  `wins` int(11) DEFAULT 0,
  `pastRaces` longtext DEFAULT NULL,
  `averagePosition` int(11) NOT NULL DEFAULT 0,
  `pastPositions` longtext DEFAULT NULL,
  `averageVehicle` text NOT NULL,
  `pastVehicles` longtext DEFAULT NULL,
  `timeSpentRacing` int(11) NOT NULL DEFAULT 0,
  `MMRChart` longtext DEFAULT NULL,

  KEY `id` (`id`)
);

CREATE TABLE IF NOT EXISTS `racing_races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` int(11) NOT NULL DEFAULT 0,
  `trackStartingTimestamp` int(11) NOT NULL DEFAULT 0,
  `trackName` text NOT NULL,
  `trackAuthorId` int(11) NOT NULL DEFAULT 0,
  `trackId` int(11) NOT NULL DEFAULT 0,
  `totalTime` int(11) DEFAULT 0,
  `fastestTime` int(11) DEFAULT 0,
  `fastestTimeHolder` int(11) DEFAULT 0,
  `raceClass` text DEFAULT NULL,
  `players` longtext DEFAULT NULL,
  `laps` int(11) NOT NULL DEFAULT 0,
  `phasingOn` int(11) NOT NULL DEFAULT 0,
  `phasingTime` int(11) NOT NULL DEFAULT 0,
  `buyIn` int(11) NOT NULL DEFAULT 0,
  `camera` text NOT NULL,
  `moneyPrize` int(11) NOT NULL DEFAULT 0,
  `raceType` text NOT NULL,
  KEY `id` (`id`)
);

CREATE TABLE IF NOT EXISTS `racing_trackResults` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trackId` int(11) DEFAULT 0,
  `raceId` int(11) DEFAULT 0,
  `racer` int(11) DEFAULT 0,
  `time` int(11) DEFAULT 0,
  `class` text DEFAULT NULL,
  `vehicle` text DEFAULT NULL,
  `pos` int(11) DEFAULT 0,
  `timestamp` int(11) DEFAULT NULL,
  KEY `id` (`id`)
);

CREATE TABLE IF NOT EXISTS `racing_tracks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `type` text NOT NULL,
  `checkpointCount` int(11) NOT NULL DEFAULT 0,
  `author` int(11) DEFAULT 0,
  `data` longtext DEFAULT NULL,
  `racesCompleted` int(11) DEFAULT 0,
  `totalTime` int(11) DEFAULT 0,
  `fastestTime` int(11) DEFAULT 0,
  `fastestTimeHolder` int(11) DEFAULT 0,
  `timesPlayedChart` longtext DEFAULT NULL,
  `timesPlayedChartSaved` longtext DEFAULT NULL,
  `verified` int(11) NOT NULL DEFAULT 0,
  KEY `id` (`id`)
);