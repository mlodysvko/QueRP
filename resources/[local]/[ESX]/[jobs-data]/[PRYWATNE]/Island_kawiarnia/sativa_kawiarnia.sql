INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('kawiarnia', 'Kawiarnia', 0)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('kawiarnia',0,'recrue','Nowicjusz', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',1,'recrue','Pracownik', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',2,'recrue','Fachowiec', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',3,'recrue','Zawodowiec', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',4,'recrue','Specjalista', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',5,'boss','Manager', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',6,'boss','Zastepca Szefa', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}'),
	('kawiarnia',7,'boss','Szef', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":17,"torso_2":5,"shoes_1":5,"shoes_2":0,"pants_1":6, "pants_2":0, "arms":67}', '{"tshirt_1":177,"tshirt_2":0,"torso_1":16,"torso_2":4,"shoes_1":5,"shoes_2":0,"pants_1":10, "pants_2":1, "arms":76}')
;


INSERT INTO `items` (`name`, `label`) VALUES
	('ziarnakawy123', 'Ziarna Kawy'),
	('zmielonakawa123', 'Zmielona Kawa'),
	('kawa123123', 'Zapakowana Kawa'),
	('paragonkawiarnia', 'Faktura Bean Machine Coffe')
;

INSERT INTO addon_account (name, label, shared) VALUES
    ('society_kawiarnia', 'kawiarnia', 1);

INSERT INTO addon_inventory (name, label, shared) VALUES
    ('society_kawiarnia', 'kawiarnia', 1);

INSERT INTO datastore (name, label, shared) VALUES
    ('society_kawiarnia', 'kawiarnia', 1);
