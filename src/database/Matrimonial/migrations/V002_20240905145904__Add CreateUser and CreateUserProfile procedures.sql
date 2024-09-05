DELIMITER //

CREATE PROCEDURE CreateUserProfile(
    IN p_UserId INT,
    IN p_Nationality VARCHAR(255),
    IN p_Religion VARCHAR(255),
    IN p_Height VARCHAR(255),
    IN p_Marital_Status VARCHAR(255),
    IN p_Bio VARCHAR(255)
)
BEGIN
    INSERT INTO User_Profile (UserId, Nationality, Religion, Height, Marital_Status, Bio)
    VALUES (p_UserId, p_Nationality, p_Religion, p_Height, p_Marital_Status, p_Bio);
END //

CREATE PROCEDURE CreateUser(
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
    INSERT INTO users (FirstName, LastName, DOB, Gender, Email, Phone, Address)
    VALUES (p_FirstName, p_LastName, p_DOB, p_Gender, p_Email, p_Phone, p_Address);
    
    SET p_UserId = LAST_INSERT_ID();
END //

DELIMITER ;