DELIMITER //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "CreateContact"(

    IN p_Con1_Id int,
    IN p_Con2_Id int,
    IN p_Contact_Date date,
    OUT p_ContactId int,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    IF NOT EXISTS(SELECT UserId FROM Users WHERE UserId = p_Con1_Id) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Con1_id  does not exists');
    end if;
    
    IF NOT EXISTS(SELECT UserId FROM Users WHERE UserId = p_Con2_Id) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Con2_id  does not exists');
    end if;
    
     IF p_Contact_Date IS NULL THEN
     SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Contact date can not be null or empty');
    end if;
    
    
    if json_length(@ErrorTable) > 0 then
    set p_Errors = json_unquote(@ErrorTable);
    set p_ContactId = null;
    
    ELSE
    INSERT INTO Contact(Con1_Id, Con2_Id, Contact_Date)
    VALUES(p_Con1_Id, p_Con2_Id, p_Contact_Date);
    
    SET p_Errors = '[]';
    SET p_ContactId = last_insert_id();
    SET p_Errors = 'User Contact created Successfully';
    end if;

END //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "DeleteContact"(

	IN p_ContactId int,
    OUT p_Errors VARCHAR(255)
)
BEGIN
	SET @ErrorTable = '[]';
    
    IF(SELECT COUNT(*) FROM Contact WHERE ContactId = p_ContactId) = 0 THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' ,'Contact id doest not exists');
    END IF;
    
     if json_length(@ErrorTable) > 0 then
    set p_Errors = json_unquote(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE FROM Contact WHERE ContactId = p_ContactId ;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contact id not found';
    end if;
    
    SET p_Errors = ' User Contact deleted succcessfully';
END //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "UpdateContact"(

	IN p_ContactId int,
    IN p_Con1_Id int,
    IN p_Con2_Id int,
    IN p_Contact_Date date,
    OUT p_Errors VARCHAR(255)
    )
BEGIN

	SET @ErrorTable = '[]';
    IF NOT EXISTS(SELECT UserId FROM Users WHERE UserId = p_Con1_Id) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Con1_id  does not exists');
    end if;
    
    IF NOT EXISTS(SELECT UserId FROM Users WHERE UserId = p_Con2_Id) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Con2_id  does not exists');
    end if;
    
     IF p_Contact_Date IS NULL THEN
     SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Contact date can not be null or empty');
     end if;
    
    
    if json_length(@ErrorTable) > 0 then
    set p_Errors = json_unquote(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    UPDATE Contact
    SET 
    
    Con1_Id = p_Con1_Id,
    Con2_Id = p_Con2_Id ,
	Contact_Date = p_Contact_Date
    WHERE ContactId = p_ContactId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contact id not found';
    end if;
    
    SET p_Errors = ' User Contact Updated succcessfully';
END //
DELIMITER;