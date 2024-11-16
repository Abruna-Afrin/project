DELIMITER //

CREATE PROCEDURE CreateProfile_Pictures(

    IN p_UserId int,
    IN p_ProfilePicture BLOB,
    IN p_PictureType VARCHAR(50),
    IN p_UploadDate date,
    OUT p_PictureId int,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS(SELECT UserId from Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId Does not exits');
    END IF;
    
    IF p_ProfilePicture IS NULL OR p_ProfilePicture = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'ProfilePicture can not be null or empty');
    END IF;
    
    IF p_PictureType IS NULL OR p_PictureType = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'PictureType Description can not be null or empty');
    END IF;
  
    IF p_UploadDate IS NULL THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UploadDate can not be null or empty');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SET p_PictureId= NULL;
    
    else
    INSERT INTO Profile_Pictures (UserId, ProfilePicture, PictureType, UploadDate)
    VALUES(p_UserId, p_ProfilePicture, p_PictureType, p_UploadDate);
    
    set p_Errors = '[]';
    set p_PictureId = last_insert_id();
    SET p_Errors = 'profile picture inserted successfully';
    end if;
    
END //

CREATE PROCEDURE UpdateProfile_Pictures(

	IN p_PictureId int,
	IN p_UserId int,
    IN p_ProfilePicture BLOB,
    IN p_PictureType VARCHAR(255),
    IN p_UploadDate date,
    OUT p_Errors VARCHAR(255)

)
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS(SELECT PictureId from Profile_Pictures WHERE PictureId = p_PictureId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'PictureId Does not exits');
    END IF;
    
    IF NOT EXISTS(SELECT UserId from Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId Does not exits');
    END IF;
    
    IF p_ProfilePicture IS NULL OR p_ProfilePicture = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'ProfilePicture can not be null or empty');
    END IF;
    
    IF p_PictureType IS NULL OR p_PictureType = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'PictureType Description can not be null or empty');
    END IF;
  
    IF p_UploadDate IS NULL THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UploadDate can not be null or empty');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    UPDATE Profile_Pictures
    SET 
    PictureId = p_PictureId,
	UserId = p_UserId,
    ProfilePicture = p_ProfilePicture,
    PictureType = p_PictureType,
    UploadDate = p_UploadDate
    WHERE PictureId = p_PictureId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No changes made';
    end if;
    
    set p_Errors = 'Updated Profile picture successfully';
END //

CREATE PROCEDURE DeleteProfile_Pictures(

	IN p_PictureId int,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF(SELECT COUNT(*) PictureId FROM Profile_Pictures WHERE PictureId = p_PictureId) = 0 THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Picture Id does not exists');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors ;
    END IF;
    
    DELETE FROM Profile_Pictures WHERE PictureId = p_PictureId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No changes made';
    END IF;
    
    SET p_Errors = 'Deleted Profile_Pictures successfully';
    
END //

DELIMITER;