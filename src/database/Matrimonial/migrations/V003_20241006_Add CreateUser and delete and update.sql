DELIMITER //
CREATE PROCEDURE CreateUsers(
	IN p_FirstName VARCHAR(255),
    IN p_LastName VARCHAR(255),
    IN p_DOB DATE,
    IN p_Gender VARCHAR(255),
    IN p_Email VARCHAR(255),
    IN p_Phone VARCHAR(255),
    IN p_Address VARCHAR(255),
    OUT p_Errors VARCHAR(255)
)
BEGIN

	-- add error table 
	SET @p_ErrorTable = '[]';
        
	-- add validation
	IF p_FirstName IS NULL OR p_FirstName = '' THEN 
	SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'FirstName can not be null or empty');
	END IF; 
        
	IF p_LastName IS NULL OR p_LastName = '' THEN 
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'LastName can not be null or empty');
    END IF;
    
    IF p_DOB IS NULL THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'DOB can not be null');
    END IF;
    
    IF p_Gender != 'Male' AND p_Gender != 'Female' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Gender acn only be male or female');
    END IF;
    
	IF p_Email IS NULL OR p_Email = '' OR NOT p_Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Invalid Email Format');
	END IF;
	
    IF p_Phone IS NULL OR p_Phone = '' THEN 
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Phone can not be null or empty');
    END IF;
    
    IF p_Address IS NULL OR p_Address = '' THEN 
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Address can not be null or empty');
    END IF;
    
    SELECT @p_ErrorTable;
    
    IF JSON_LENGTH(@p_ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@p_ErrorTable);
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    INSERT INTO Users (FirstName, LastName, DOB, Gender, Email, Phone, Address)
    VALUES(p_FirstName, p_LastName, p_DOB, p_Gender, p_Email, p_Phone, p_Address);
    
    SELECT last_insert_id() INTO p_Errors;
    

END //

CREATE  PROCEDURE Update_Users(
	
    IN p_UserId INT,
    IN p_FirstName VARCHAR(255),
    IN p_LastName varchar(255),
    IN p_DOB DATE,
    IN p_Gender VARCHAR(255),
    IN p_Email VARCHAR(255),
    IN p_Phone VARCHAR(255),
    IN p_Address VARCHAR(255),
    OUT p_Errors VARCHAR(255)
    
)
BEGIN

	-- initiaize error table
    SET @p_ErrorTable = '[]';
    
    -- add validation
    IF p_FirstName IS NULL OR p_FirstName = '' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'First name cant be null or empty');
    END IF;
    
    IF p_LastName IS NULL OR p_LastName = '' THEN 
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'last name cant be null or empty');
    END IF;
    
    IF p_DOB IS NULL THEN 
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'DOB cant be null or empty');
    END IF;
    
    IF  p_Gender!= 'Male' AND  p_Gender != 'Female' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Gender cant be null or empty');
    END IF;
    
    IF p_Email IS NULL OR p_Email = '' OR NOT p_Email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Invalid Email ');
    END IF;
    
    IF p_Phone IS NULL OR p_Phone = '' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'Phone can not be null or empty');
    END IF;
    
    IF p_Address IS NULL OR p_Address = '' THEN
    SET @p_ErrorTable = JSON_ARRAY_APPEND(@p_ErrorTable, '$', 'ADDRESS can not be null or empty');
    END IF;
    -- return errors
    IF JSON_LENGTH(@p_ErrorTable)> 0 THEN
    SET p_Errors = JSON_UNQUOTE(@p_ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    -- update errors
    UPDATE Users 
    SET 
    FirstName = p_FirstName,
    LastName =p_LastName,
    DOB =p_DOB,
    Gender = p_Gender,
    Email = p_Email,
    Phone = p_Phone,
    Address = p_Address
    WHERE UserId = p_UserId;
    
    -- check ANY ROWS AFFECTED
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NO CHANGES MADE OR USER NOT FOUND';
	END IF;
    
    -- return successfull message
    SET p_Errors = ' User uppdated sucessfully';
  
END //


CREATE PROCEDURE Delete_User(
	
    IN p_UserId INT,
    OUT p_Errors VARCHAR(255)
)
BEGIN
	-- ADD ERROR TABLE
    SET @ErrorTable = '[]';
	IF(SELECT COUNT(*) FROM Users WHERE UserId = p_UserId) = 0 THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'user id not found');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE FROM Users WHERE UserId = p_UserId;
    
	IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to delete user';
    END IF;
    SET p_Errors = 'User deleted successfully';
END //

DELIMITER ;