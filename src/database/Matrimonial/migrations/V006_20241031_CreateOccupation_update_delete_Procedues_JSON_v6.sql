DELIMITER //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "CreateOccupation"(

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
CREATE DEFINER="avnadmin"@"%" PROCEDURE "UpdateEducation"(

	IN p_UserEducationId INT,
    IN p_UserId INT,
    IN p_Degree VARCHAR(255),
    IN p_Institution VARCHAR(255),
    IN p_FieldOfStudy VARCHAR(255),
    IN p_StartDate date,
    IN p_EndDate DATE,
    IN p_GPA DECIMAL(3,2),
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS(SELECT COUNT(*) FROM Education WHERE EducationId = p_UserEducationId) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'EducationId does not exists');
    END IF;
    
    IF NOT EXISTS (SELECT COUNT(*) FROM Users WHERE UserId = p_UserId) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId does not exists');
    END IF;
    
    IF p_Degree IS NULL OR p_Degree = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Degree can not be null or empty');
    End if ;
    
    IF p_Institution IS NULL OR p_Institution = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Institution can not be null or empty');
    END IF ;
    
     IF p_FieldOfStudy IS NULL OR p_FieldOfStudy = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'FieldOfStudy can not be null or empty');
    END IF;
    
    IF p_StartDate IS NULL OR p_StartDate = '' THEN 
    SET  @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'StartDate can not be null or empty');
    END IF;
    
	IF p_EndDate IS NULL OR p_EndDate = '' THEN 
    SET  @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'EndDate can not be null or empty');
    END IF;
    
    IF p_GPA IS NULL OR p_GPA < 0 OR p_GPA > 4 THEN
    SET  @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'GPA must be between 0.00 and 4.00');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable)>0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    UPDATE Education
    SET 
    EducationId = p_UserEducationId,
	UserId = p_UserId,
    Degree = p_Degree,
	Institution = p_Institution,
    FieldOfStudy = p_FieldOfStudy ,
    StartDate = p_StartDate,
    EndDate = p_EndDate,
    GPA = p_GPA
    Where EducationId = p_UserEducationId;
    
    if row_count() = 0 then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = ' No changes made';
    End if;
    
    set p_Errors = 'Updated User Education Successfully';
    
END //
CREATE DEFINER="avnadmin"@"%" PROCEDURE "DeleteOccupation"(
	
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