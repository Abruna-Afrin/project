 DELIMITER //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "CreateUser_Preference"(

    IN p_UserId int,
    IN p_Nationality varchar(255),
    IN p_Religion varchar(255),
	IN p_Height varchar(255),
    IN p_Education VARCHAR(255),
    IN p_Occupation varchar(255),
    IN p_Location varchar(255),
    OUT p_UserPreId INT,
    OUT p_Errors VARCHAR(255)
    
)
BEGIN

	SET @ErrorTable = '[]';
    
	IF NOT EXISTS (SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId not exists');
    END IF ;
    
    IF p_Nationality IS NULL OR p_Nationality = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Nationality can not be null or empty');
    END IF ;
    
     IF p_Religion IS NULL OR p_Religion = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Religion can not be null or empty');
    END IF ;
    
	IF p_Height IS NULL OR p_Height = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Height can not be null or empty');
    END IF ;
    
    IF p_Education IS NULL OR p_Education = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Education can not be null or empty');
    END IF ;
    
    IF p_Occupation IS NULL OR p_Occupation = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation can not be null or empty');
    END IF ;
    
    IF p_Location IS NULL OR p_Location = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Location can not be null or empty');
    END IF ;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SET p_UserPreId = NULL;
    
    ELSE 
    INSERT INTO User_Preference( UserId, Nationality, Religion, Height, Education, Occupation, Location)
    VALUES(p_UserId, p_Nationality, p_Religion, p_Height, p_Education, p_Occupation, p_Location);
    
    SET p_Errors = '[]';
    SET p_UserPreId = LAST_INSERT_ID();
    SET p_Errors = 'User Preference inserted successfully';
    END IF;

END //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "UpdateUserPreference"(

	IN p_UserPreId INT,
    IN p_UserId int,
    IN p_Nationality varchar(255),
    IN p_Religion varchar(255),
	IN p_Height varchar(255),
    IN p_Education VARCHAR(255),
    IN p_Occupation varchar(255),
    IN p_Location varchar(255),
    OUT p_Errors VARCHAR(255)

)
BEGIN

	SET @ErrorTable = '[]';
    
	IF NOT EXISTS (SELECT PreId FROM User_Preference WHERE PreId = p_UserPreId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'User PreId not exists');
    END IF ;
    
    IF NOT EXISTS (SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId not exists');
    END IF ;
    
    IF p_Nationality IS NULL OR p_Nationality = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Nationality can not be null or empty');
    END IF ;
    
     IF p_Religion IS NULL OR p_Religion = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Religion can not be null or empty');
    END IF ;
    
	IF p_Height IS NULL OR p_Height = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Height can not be null or empty');
    END IF ;
    
    IF p_Education IS NULL OR p_Education = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Education can not be null or empty');
    END IF ;
    
    IF p_Occupation IS NULL OR p_Occupation = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation can not be null or empty');
    END IF ;
    
    IF p_Location IS NULL OR p_Location = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Location can not be null or empty');
    END IF ;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF ;
    
    UPDATE User_Preference
    set 
	PreId =  p_UserPreId,
    UserId = p_UserId,
	Nationality = p_Nationality,
    Religion = p_Religion,
	Height = p_Height,
    Education = p_Education,
    Occupation = p_Occupation,
    Location = p_Location
    where 
    PreId =  p_UserPreId;
    
    if row_count() = 0 then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to update user preference';
    END IF;
    
    SET p_Errors = 'UPDATED USER Preference successfully';
   
     
END //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "DeleteUserPreference"(

	IN p_UserPreId INT,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF (SELECT COUNT(*) FROM User_Preference WHERE PreId = p_UserPreId) = 0 THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Preid not found');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE
    FROM User_Preference WHERE PreId =  p_UserPreId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'No changes made';
    END IF;
    
    SET p_Errors = 'Deleted usser preference successfully';

END //
 DELIMITER ;