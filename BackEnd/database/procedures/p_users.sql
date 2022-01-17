USE M2L_DB;

DELIMITER //

-- get users
CREATE OR REPLACE PROCEDURE getAllAccount()
BEGIN
	SELECT id, nom, prenom, email, tel, ddn, adresse FROM users;
END //

-- get user
CREATE OR REPLACE PROCEDURE getOneAccount(IN p_user_id int)
BEGIN
    SELECT id, nom, prenom, email, tel, ddn, adresse FROM users WHERE id = p_user_id;
END //

    -- check user password (authentification)
    -- get user payments services (historique)

    -- get user payments salles (historique)
    CREATE OR REPLACE PROCEDURE getAccountResaToPay()
    BEGIN
	SELECT u.id, u.nom, u.prenom, u.email, u.tel, u.ddn, u.adresse, r.id, r.date_resa, s.nom, s.prix
	FROM users u
	INNER JOIN reservations r
	ON u.id = r.id
	INNER JOIN salles s
	ON r.id_salle = s.id
	WHERE r.is_paid = 0;
    END //

    -- voir les comptes qui ont une reservation à venir (admin)
    CREATE OR REPLACE PROCEDURE getAccountResa(IN p_date_resa int)
    BEGIN
	SELECT u.id, u.nom, u.prenom, u.email, u.tel, u.ddn, u.adresse 
	FROM users u
	INNER JOIN reservations r
	ON u.id = r.id
	WHERE date_resa > p_date_resa;
    END //

-- create user
CREATE OR REPLACE PROCEDURE createAccount(IN p_nom VARCHAR(255), IN p_prenom VARCHAR(255), IN p_email VARCHAR(255), IN p_tel VARCHAR(50), IN p_password VARCHAR(255), IN p_ddn VARCHAR(255), IN p_adresse VARCHAR(255))
BEGIN
	INSERT INTO Users(nom, prenom, email, tel, password, ddn, adresse)
	VALUES (p_nom, p_prenom, p_email, p_tel, SHA1(p_password), p_ddn, p_adresse);
END //

-- update user
CREATE OR REPLACE PROCEDURE updateAccount(IN p_id int, IN p_nom VARCHAR(255), IN p_prenom VARCHAR(255), IN p_email VARCHAR(255), IN p_tel VARCHAR(50), IN p_password VARCHAR(255), IN p_ddn VARCHAR(255), IN p_adresse VARCHAR(255))
BEGIN
	UPDATE USERS
	SET
		nom = p_nom, prenom = p_prenom, email = p_email, tel = p_tel, password = SHA1(p_password), ddn = p_ddn, adresse = p_adresse
	WHERE
		id = p_id;
END //

-- delete user
CREATE OR REPLACE PROCEDURE deleteAccount(IN p_user_id int)
BEGIN
	DELETE FROM users
	WHERE id = p_user_id;
END //

-- create user paiement

-- get user reservations (participants: (nom/prénom))

    -- reservations avant date du jour (exclus) 
    CREATE OR REPLACE PROCEDURE getBeforeReservation (IN p_user_id int)
    BEGIN
	SELECT s.nom, s.description, r.date_resa, s.prix, is_paid  FROM reservations r
	INNER JOIN salles s
	ON r.id_salle = s.id
	WHERE r.id_user = p_user_id AND date_resa < DATE(NOW());
    END //

    -- reservations après date du jour (inclus)
    CREATE OR REPLACE PROCEDURE getFutureReservation (IN p_user_id int)
    BEGIN
	SELECT s.nom, s.description, r.date_resa, s.prix, is_paid  FROM reservations r
	INNER JOIN salles s
	ON r.id_salle = s.id
	WHERE r.id_user = p_user_id AND date_resa >= DATE(NOW());
    END //

-- create user reservation
CREATE OR REPLACE PROCEDURE createReservation (IN p_date VARCHAR(255), IN p_user_id int, IN p_salle_id int, IN p_is_paid BOOLEAN)
BEGIN
	INSERT INTO reservations (date_resa, id_user, id_salle, is_paid) VALUES (p_date, p_user_id, p_salle_id, p_is_paid);
END //

-- update user reservation (set is_paid via create paiement)
CREATE OR REPLACE PROCEDURE updateReservation (IN p_date VARCHAR(255), IN p_user_id int, IN p_salle_id int)
BEGIN
UPDATE reservations 
SET date_resa = p_date, id_salle = p_salle_id
WHERE id_user = p_user_id;
END //

-- delete user reservation (bloqué post date du jour)
CREATE OR REPLACE PROCEDURE deleteReservation (IN p_date VARCHAR(255), IN p_user_id int, IN p_salle VARCHAR(255))
BEGIN
DELETE r FROM reservations r
INNER JOIN salles s
ON s.nom = p_salle
WHERE id_user = p_user_id AND date_resa = p_date;
END //

-- get user participations (réservation: (nom_salle, date, admin_resa(nom/prenom)))
    -- participations avant date du jour (exclus)
        -- get réservation covid_state (renvois liste booleen etat covid participants, si 1 covid_state = 1 backend)
    -- participations après date du jour (inclus)

-- create user participation
-- update user participation (set covid state)
-- delete user participation (bloqué post date du jour)

-- get userTickets (historique)

-- get userTicket
    -- create
    -- update
    -- delete

-- cas covid positif
CREATE OR REPLACE PROCEDURE isCovid (IN p_user_id int, IN p_resa_id int)
BEGIN
	UPDATE participants
	SET covid_positive = 1
    WHERE id_user = p_user_id AND id_reservation = p_resa_id;
END //

