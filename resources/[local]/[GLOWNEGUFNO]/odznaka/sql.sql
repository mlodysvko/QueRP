CREATE TABLE `pixel_odznaka` (
  `id` int(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `callsign` varchar(255) NOT NULL,
  `odznaka` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `pixel_odznaka`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `pixel_odznaka`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;