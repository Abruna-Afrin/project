DELIMITER //

CREATE PROCEDURE CreateEducation(

	IN p_UserId INT,
    IN p_Degree VARCHAR(255),
    IN p_Institution VARCHAR(255),
    IN p_FieldOfStudy VARCHAR(255),
    IN p_StartDate DATE,
    IN p_EndDate DATE,
    IN p_GPA DECIMAL(3,2),
    OUT p_UserEducationId INT,
    OUT p_Errors VARCHAR(255)

)
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS (SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId does not exists');
    END IF;
    
    IF p_Degree IS NULL OR  p_Degree = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'Degree can not be null or empty');
    END IF;
    
    IF p_Institution IS NULL OR p_Institution = '' THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable,'$', 'Institution can not be null or empty');
    END IF;
    
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
    
    IF JSON_LENGTH(@ErrorTable)> 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
     SET p_UserEducationId = NULL;
     
     ELSE
     INSERT INTO Education(UserId, Degree, Institution, FieldOfStudy, StartDate, EndDate, GPA)
     VALUES(p_UserId, p_Degree, p_Institution, p_FieldOfStudy, p_StartDate, p_EndDate, p_GPA);
	 SET p_Errors = '[]';
    set p_UserEducationId = LAST_INSERT_ID();
     SET p_Errors = 'User education inserted successfully';
    END IF;
    

END //

CREATE PROCEDURE UpdateEducation(

	IN p_UserEducationId INT,
    IN p_UserId INT,
    IN p_Degree VARCHAR(255),
    IN p_Institution VARCHAR(255),
    IN p_FieldOfStudy VARCHAR(255),
    IN p_StartDate DATE,
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

CREATE PROCEDURE DeleteEducation(

	IN p_EducationId INT,
    OUT p_Errors varchar(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF (SELECT COUNT(*) FROM Education WHERE EducationId = p_EducationId) = 0 THEN 
    SET  @ErrorTable = JSON_ARRAY_APPEND( @ErrorTable, '$', 'Education id not found');
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE FROM Education WHERE EducationId = p_EducationId;
    
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to delete user Education';
    END IF;
    SET p_Errors = 'User Education deleted successfully';

END //
DELIMITER ;