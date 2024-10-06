USE `YH_Matrimony`;
DROP procedure IF EXISTS `CreateUser`;

USE `YH_Matrimony`;
DROP procedure IF EXISTS `YH_Matrimony`.`CreateUser`;
;

DELIMITER $$
USE `YH_Matrimony`$$
CREATE  PROCEDURE "CreateUser"(
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_DOB DATE,
    IN p_Gender VARCHAR(255),
    IN p_Email NVARCHAR(255),
    IN p_Phone BIGINT,
    IN p_Address NVARCHAR(255),
    OUT p_UserId INT
)
BEGIN
    ## add validation
    IF p_FirstName IS NULL OR p_FirstName = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'First name cannot be null or empty';
    END IF;

    IF p_LastName IS NULL OR p_LastName = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Last name cannot be null or empty';
    END IF;

    IF p_DOB IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Date of birth cannot be null';
    END IF;

    IF p_Gender != 'Male' AND p_Gender != 'Female' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Gender can only be male or female';
    END IF;

    IF p_Email IS NULL OR p_Email = '' OR NOT p_Email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid e-mail format';
    END IF;

    INSERT INTO Users (FirstName, LastName, DOB, Gender, Email, Phone, Address)
    VALUES (p_FirstName, p_LastName, p_DOB, p_Gender, p_Email, p_Phone, p_Address);
    
    SET p_UserId = LAST_INSERT_ID();
END$$

DELIMITER ;
;