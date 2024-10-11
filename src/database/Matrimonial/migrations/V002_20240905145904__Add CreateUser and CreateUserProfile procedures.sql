DELIMITER //

CREATE PROCEDURE CreateUserProfile(
    IN p_UserId INT,
    IN p_Nationality VARCHAR(255),
    IN p_Religion VARCHAR(255),
    IN p_Height VARCHAR(255),
    IN p_Marital_Status VARCHAR(255),
    IN p_Bio VARCHAR(255),
    OUT p_ErrorListAsJsonString VARCHAR(max),
    OUT p_UserProfileId INT
)
BEGIN

    SET @ErrorList = '[]';
    
    --add validation
    --UserId must exist
    IF NOT EXISTS (SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
        SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'UserId does not exist');
    END IF;

    -- nationality cannot be empty or null
    IF p_Nationality IS NULL OR p_Nationality = '' THEN
        SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Nationality cannot be empty or null');
    END IF;

    -- religion cannot be empty or null
    IF p_Religion IS NULL OR p_Religion = '' THEN
        SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Religion cannot be empty or null');
    END IF;

    -- height cannot be empty or null
    IF p_Height IS NULL OR p_Height = '' THEN
        SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Height cannot be empty or null');
    END IF;

    -- marital status cannot be empty or null
    IF p_Marital_Status IS NULL OR p_Marital_Status = '' THEN
        SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Marital Status cannot be empty or null');
    END IF;

    -- bio cannot be empty or null
    IF p_Bio IS NULL OR p_Bio = '' THEN
        SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Bio cannot be empty or null');
    END IF;

    -- if error list is not empty, return error list
    IF JSON_LENGTH(@ErrorList) > 0 THEN
        SET p_ErrorListAsJsonString = @ErrorList;
        RETURN;
    END IF;

    INSERT INTO UserProfile (UserId, Nationality, Religion, Height, Marital_Status, Bio)
    VALUES (p_UserId, p_Nationality, p_Religion, p_Height, p_Marital_Status, p_Bio);

    SET p_UserProfileId = LAST_INSERT_ID();
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
    INSERT INTO Users (FirstName, LastName, DOB, Gender, Email, Phone, Address)
    VALUES (p_FirstName, p_LastName, p_DOB, p_Gender, p_Email, p_Phone, p_Address);
    
    SET p_UserId = LAST_INSERT_ID();
END //

DELIMITER ;