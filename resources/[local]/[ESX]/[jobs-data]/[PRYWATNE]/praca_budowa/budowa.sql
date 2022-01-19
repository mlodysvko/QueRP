INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('budowa', 'Budowlaniec', 0);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('budowa', 0, 'Budowlaniec', 'Pracownik', 30, '{}', '{}');

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('contrat', 'Faktura', 100, 0, 1);
