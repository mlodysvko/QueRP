INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('schowek', 'Schowek', 0),
('schowek_black_money', 'Schowek', 0);

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('schowek', 'Schowek', 0);

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('schowek', 'Schowek', 0);

CREATE TABLE `owned_schowek` (
  `id` int(11) NOT NULL,
  `owner` text NOT NULL,
  `posiadanie` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
