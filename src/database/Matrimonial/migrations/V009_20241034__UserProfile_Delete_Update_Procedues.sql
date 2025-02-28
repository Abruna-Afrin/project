DELIMITER //

DROP PROCEDURE IF EXISTS CreateUserProfile //
CREATE PROCEDURE CreateUserProfile(
	
    IN p_UserId INT,
    IN p_Nationality VARCHAR(255),
    IN p_Religion VARCHAR(255),
    IN p_Height VARCHAR(255),
    IN p_Marital_Status VARCHAR(255),
    IN p_Bio VARCHAR(255),
    OUT p_UserProfileId INT,
    OUT p_Errors VARCHAR(255)
	
)
BEGIN
	-- Error table
	SET @ErrorList = '[]';
    
    -- add validation
    
    IF NOT EXISTS ( SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'User Id does not exist.');
    END IF;
    
    IF p_Nationality IS NULL OR p_Nationality = '' THEN
    SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Nationality can not be null or empty');
    END IF;
    
    IF p_Religion IS NULL OR p_Religion = '' THEN
    SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Religion can not be null or empty');
    END IF;
    
    IF p_Height IS NULL OR p_Height = '' THEN
    SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Height can not be null or empty');
    END IF;
	
    
    IF p_Marital_Status IS NULL OR  (p_Marital_Status != 'Single' AND p_Marital_Status != 'Married' AND p_Marital_Status != 'Divorced') THEN
        SET @ErrorList =  JSON_ARRAY_APPEND(@ErrorList, '$','Marital_Status can only be Single or Married or Divorced');
    END IF;
    
	IF p_Bio IS NULL OR p_Bio = '' THEN
    SET @ErrorList = JSON_ARRAY_APPEND(@ErrorList, '$', 'Bio can not be null or empty');
    END IF; 
    
    IF JSON_LENGTH(@ErrorList)>0 THEN 
    SET p_Errors = @ErrorList;
    SET p_UserProfileId = NULL;
	ELSE
        INSERT INTO User_Profile (UserId, Nationality, Religion, Height, Marital_Status, Bio)
        VALUES (p_UserId, p_Nationality, p_Religion, p_Height, p_Marital_Status, p_Bio);
        SET p_UserProfileId = LAST_INSERT_ID();
    END IF;

END //

DROP PROCEDURE IF EXISTS Update_UserProfile //
CREATE PROCEDURE Update_UserProfile(

	IN p_ProfileId INT,
    IN p_UserId INT,
    IN p_Nationality VARCHAR(255),
    IN p_Religion VARCHAR(255),
    IN p_Height VARCHAR(255),
    IN p_Marital_Status VARCHAR(255),
    IN p_Bio VARCHAR(255),
    OUT p_Errors VARCHAR(255)
)
BEGIN
	-- eRROR TABLE
    SET @ErrorTable = '[]';
    
	IF NOT EXISTS (SELECT ProfileId FROM User_Profile WHERE ProfileId = p_ProfileId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Profile Id not found');
    END IF;
    
    IF NOT EXISTS (SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Userid not found');
    END IF; 
    
    IF p_Religion IS NULL OR p_Religion = '' THEN
		SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'Religion can not be null or empty');
    END IF;
    
     IF p_Nationality IS NULL OR p_Nationality = '' THEN
		SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'Nationality can not be null or empty');
    END IF;
    
   IF p_Height IS NULL OR p_Height = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Height can not be null or empty');
    END IF;
    
   IF p_Marital_Status IS NULL OR  (p_Marital_Status != 'Single' AND p_Marital_Status != 'Married' AND p_Marital_Status != 'Divorced') THEN
        SET @ErrorTable =  JSON_ARRAY_APPEND(@ErrorTable, '$','Marital_Status can only be Single or Married or Divorced');
    END IF;
    

    
    IF p_Bio IS NULL OR p_Bio = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Bio can not be null or empty');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
	UPDATE User_Profile
	
	SET
        UserId = p_UserId,
		Nationality = p_Nationality,
		Religion = p_Religion,
		Height = p_Height,
		Marital_Status = p_Marital_Status,
		Bio = p_Bio
        Where ProfileId = p_ProfileId;
        
        IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'  SET MESSAGE_TEXT = 'NO CHAGES MADE OR USERID NOT FOUND';
        END IF;
        
        SET p_Errors = ' Updated Successfully';
	
END//

DROP PROCEDURE IF EXISTS Delete_UserProfile //
CREATE PROCEDURE Delete_UserProfile(

	IN p_ProfileId INT,
    OUT p_Errors VARCHAR(255)
)
BEGIN
	SET @ErrorTable = '[]';
    
    IF (select COUNT(*) FROM User_Profile WHERE ProfileId = p_ProfileId) = 0 THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'User profile not found');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE FROM User_Profile WHERE ProfileId = p_ProfileId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to delete user profile';
    End if;
    
    SET p_Errors = 'Deleted Successfully';

END //