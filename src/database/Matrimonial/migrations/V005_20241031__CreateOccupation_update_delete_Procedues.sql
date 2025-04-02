DELIMITER //

DROP PROCEDURE IF EXISTS CreateOccupation //
CREATE PROCEDURE CreateOccupation(

	IN p_UserId INT,
    IN p_Occupation_Title varchar(255),       
    IN p_Occupation_Description text,                           
    IN p_AverageSalary decimal(12, 2),                 
    IN p_DateAdded date,
	OUT p_UserOccupationId int, 
    OUT p_Errors varchar(255)
    )
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS(SELECT UserId from Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId DOES NOT EXISTS');
    END IF;
    
    IF p_Occupation_Title IS NULL OR p_Occupation_Title = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation Title can not be null or empty');
    END IF;
    
    IF p_Occupation_Description IS NULL OR p_Occupation_Description = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation Description can not be null or empty');
    END IF;
    
    IF  p_AverageSalary IS NULL OR  p_AverageSalary = '' THEN
    SET  @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'AverageSalary can not be null or empty');
    END IF;
    
    IF p_DateAdded IS NULL THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'DateAdded can not be null or empty');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SET p_UserOccupationId = NULL;
    
    ELSE
    INSERT INTO Occupation(UserId, Occupation_Title, Occupation_Description, AverageSalary, DateAdded)
    VALUES(p_UserId, p_Occupation_Title, p_Occupation_Description, p_AverageSalary, p_DateAdded);
    SET p_Errors = '[]';
    SET p_UserOccupationId = LAST_INSERT_ID();
    SET p_Errors = 'User Occupation Added successfully';
    END IF;

END //

DROP PROCEDURE IF EXISTS UpdateOccupation //
CREATE PROCEDURE UpdateOccupation(

	IN p_UserOccupationId  INT,
    IN p_UserId INT,
     IN p_Occupation_Title varchar(255),       
    IN p_Occupation_Description text,                           
    IN p_AverageSalary decimal(12, 2),                 
    IN p_DateAdded date,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS(SELECT COUNT(*) FROM occupation WHERE OccupationId = p_UserOccupationId ) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'OccupationId does not exists');
    END IF;
    
    IF NOT EXISTS (SELECT COUNT(*) FROM Users WHERE UserId = p_UserId) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId does not exists');
    END IF;
    
    IF p_Occupation_Title IS NULL OR p_Occupation_Title = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation_Title can not be null or empty');
    End if ;
    
    IF p_Occupation_Description IS NULL OR p_Occupation_Description = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation_Description can not be null or empty');
    END IF ;
    
   
	IF p_DateAdded IS NULL OR p_DateAdded = '' THEN 
    SET  @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'Date can not be null or empty');
    END IF;
    
    IF p_AverageSalary IS NULL THEN
    SET  @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'AverageSalary can not be null');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable)>0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    UPDATE Occupation
    SET 
    OccupationId = p_UserOccupationId,
	UserId = p_UserId,
    OccupationTitle = p_Occupation_Title,
	OccupationDescription =p_Occupation_Description,
    AverageSalary = p_AverageSalary ,
    DateAdded = p_DateAdded,
    Where OccupationId = p_UserOccupationId;
    
    if row_count() = 0 then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' No changes made';
    End if;
    
    set p_Errors = 'Updated User occpation Successfully';
    
END //

DROP PROCEDURE IF EXISTS DeleteOccupation //
CREATE PROCEDURE DeleteOccupation(
	
    IN p_OccupationId INT,
    OUT p_Errors VARCHAR(255)

)
BEGIN
    SET @ErrorTable = '[]';
	IF NOT EXISTS( SELECT COUNT(*) FROM Occupation WHERE OccupationId = p_OccupationId) = 0 THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Occupation Id does not exist');
    end if;
    
    
    IF JSON_LENGTH(@ErrorTable) = 0 THEN 
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET message_text = p_Errors;
    END IF;
    
    DELETE FROM Occupation WHERE OccupationId = p_OccupationId;
    
    IF row_count() = 0 THEN
    SIGNAL SQLSTATE '45000' SET message_text = 'Failed to delete';
    end if;
    set p_Errors = ' User Occupation Deleted successfully';
    
    END //

 DELIMITER ;