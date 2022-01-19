INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('spawacz', 'Spawacz podwodny', 0);

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('spawacz', 0, 'Spawacz podwodny', 'Pracownik', 30, '{}', '{}');

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('zdjecie', 'Zdjecie spawu', 100, 0, 1);
