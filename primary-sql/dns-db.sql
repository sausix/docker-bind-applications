SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE `records` (
  `id` int(11) NOT NULL,
  `zoneid` int(11) NOT NULL,
  `host` varchar(64) DEFAULT NULL,
  `ttl` int(11) DEFAULT NULL,
  `typeid` int(11) NOT NULL,
  `mx_priority` int(11) DEFAULT NULL,
  `data` text NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `recordtypes` (
  `id` int(11) NOT NULL,
  `recordtype` varchar(12) NOT NULL,
  `quote` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `recordtypes` (`id`, `recordtype`, `quote`) VALUES
(1, 'A', 0),
(2, 'AAAA', 0),
(3, 'NS', 0),
(4, 'MX', 0),
(5, 'CNAME', 0),
(6, 'TXT', 1),
(7, 'PTR', 0),
(8, 'SPF', 0),
(9, 'SRV', 0);

CREATE TABLE `xfr` (
  `id` int(11) NOT NULL,
  `client` varchar(64) NOT NULL,
  `zoneid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `zones` (
  `id` int(11) NOT NULL,
  `zone` varchar(64) NOT NULL,
  `ttl` int(11) DEFAULT NULL,
  `data` text NOT NULL DEFAULT '',
  `resp_person` varchar(64) DEFAULT NULL,
  `serial` bigint(20) DEFAULT NULL,
  `refresh` int(11) DEFAULT NULL COMMENT 'SOA: Seconds after secondary DNS servers check the serial number',
  `retry` int(11) DEFAULT NULL COMMENT 'SOA: Seconds to retry after an error',
  `expire` int(11) DEFAULT NULL COMMENT 'SOA: Seconds without contact to the primary server make secondaries drop their validity',
  `negcache` int(11) DEFAULT NULL COMMENT 'SOA: Seconds during not to check for NXDOMAIN again. Max: 300=5min',
  `query_count` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `host` (`host`),
  ADD KEY `zoneid` (`zoneid`),
  ADD KEY `typeid` (`typeid`);

ALTER TABLE `recordtypes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `recordtype` (`recordtype`);

ALTER TABLE `xfr`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `client` (`client`,`zoneid`),
  ADD KEY `zoneid2` (`zoneid`);

ALTER TABLE `zones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `zone` (`zone`);


ALTER TABLE `records`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `recordtypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

ALTER TABLE `xfr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `zones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


ALTER TABLE `records`
  ADD CONSTRAINT `typeid` FOREIGN KEY (`typeid`) REFERENCES `recordtypes` (`id`),
  ADD CONSTRAINT `zoneid` FOREIGN KEY (`zoneid`) REFERENCES `zones` (`id`);

ALTER TABLE `xfr`
  ADD CONSTRAINT `zoneid2` FOREIGN KEY (`zoneid`) REFERENCES `zones` (`id`);
