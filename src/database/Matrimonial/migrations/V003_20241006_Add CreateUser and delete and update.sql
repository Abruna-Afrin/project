DELIMITER //
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
   IF p_FirstName IS NULL OR LENGTH(p_FirstName) < 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name cannot be null and must be at least 2 characters long';
    END IF;

    -- Validate last name
    IF p_LastName IS NULL OR LENGTH(p_LastName) < 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Last name cannot be null and must be at least 2 characters long';
    END IF;

    -- Validate email format
    IF p_Email IS NULL OR NOT p_Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid email format';
    END IF;

    -- Validate phone number is 10 digits
    IF LENGTH(p_Phone) != 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone number must be 10 digits';
    END IF;

    -- Validate date of birth is not in the future
    IF p_DOB IS NULL OR p_DOB > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date of birth cannot be in the future and Null';
    END IF;

    -- Validate gender is one of 'Male', 'Female', 'Other'
    IF p_Gender NOT IN ('Male', 'Female', 'Other') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid gender value';
    END IF;

    -- Insert valid data into Users table
    INSERT INTO Users (FirstName, LastName, DOB, Gender, Email, Phone, Address)
    VALUES (p_FirstName, p_LastName, p_DOB, p_Gender, p_Email, p_Phone, p_Address);

    -- Return new user ID
    SET p_UserId = LAST_INSERT_ID();
END //

CREATE PROCEDURE UpdateUser(
    IN p_UserId INT,
    IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_DOB DATE,
    IN p_Gender VARCHAR(255),
    IN p_Email NVARCHAR(255),
    IN p_Phone BIGINT,
    IN p_Address NVARCHAR(255)
)
BEGIN
    -- Ensure user exists
    DECLARE user_exists INT;
    SELECT COUNT(*) INTO user_exists FROM Users WHERE UserId = p_UserId;

    IF user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    ELSE
        -- Update user information
        UPDATE Users
        SET
            FirstName = p_FirstName,
            LastName = p_LastName,
            DOB = p_DOB,
            Gender = p_Gender,
            Email = p_Email,
            Phone = p_Phone,
            Address = p_Address
        WHERE UserId = p_UserId;

        -- Check if any rows were affected
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No changes made';
        END IF;
    END IF;
END //


CREATE PROCEDURE DeleteUsers(
	IN p_UserId INT
)
BEGIN
-- Ensure user exists
    IF (SELECT COUNT(*) FROM Users WHERE UserId = p_UserId) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User not found';
    END IF;
	DELETE from Users
    WHERE UserId = p_UserId;
    
     IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to delete';
     END IF;
END //

DELIMITER ;