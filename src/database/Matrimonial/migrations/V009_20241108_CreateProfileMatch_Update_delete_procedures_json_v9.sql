DELIMITER //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "CreateProfile_Match"(

    IN p_Profile1_Id INT,
    IN p_Profile2_Id INT,
    IN p_Match_Date DATE,
    IN p_Match_status VARCHAR(255),
    OUT p_MatchId INT,
    OUT p_Errors VARCHAR(255)
    )
BEGIN

	SET @ErrorTable = '[]';
	if not exists (SELECT ProfileId FROM User_Profile WHERE ProfileId = p_Profile1_Id) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'Profile1_ID does NOT Exists');
	END IF;
    
    if not exists (SELECT ProfileId FROM User_Profile WHERE ProfileId = p_Profile2_Id) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'Profile2_ID does NOT Exists');
	END IF;
    
    IF p_Profile1_Id = p_Profile2_Id THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Profiles cannot match with themselves');
    END IF;
    
    IF p_Match_Date IS NULL THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Match_Date cannot be null');
    END IF; 
    
    IF p_Match_status IS NULL OR p_Match_status = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Match_status cannot be null or empty'); 
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SET p_MatchId = NULL;
   
   ELSE 
    INSERT INTO Profile_Match( Profile1_Id, Profile2_Id, Match_Date, Match_status)
    VALUES(p_Profile1_Id, p_Profile2_Id, p_Match_Date, p_Match_status);
    
    SET p_Errors = '[]';
    SET p_MatchId = last_insert_id();
    SET p_Errors = 'Profile Match created Successfully';
    end if;
END //
CREATE DEFINER="avnadmin"@"%" PROCEDURE "UpdteProfile_Match"(

	IN p_MatchId INT,
    IN p_Profile1_Id INT,
    IN p_Profile2_Id INT,
    IN p_Match_Date DATE,
    IN p_Match_status VARCHAR(255),
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
	IF NOT EXISTS(SELECT ProfileId FROM User_Profile WHERE ProfileId = p_Profile1_Id) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'Profile1_ID does NOT Exists');
	END IF;
    
    IF NOT EXISTS(SELECT ProfileId FROM User_Profile WHERE ProfileId = p_Profile2_Id) then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'Profile2_ID does NOT Exists');
	END IF;
    
    IF p_Profile1_Id = p_Profile2_Id THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Profiles cannot match with themselves');
    END IF;
    
    IF p_Match_Date IS NULL THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Match_Date cannot be null');
    END IF; 
    
    IF p_Match_status IS NULL OR p_Match_status = '' THEN 
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Match_status cannot be null or empty'); 
    END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0 THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET message_text = p_Errors;
    END IF;
    
    UPDATE Profile_Match
    SET 
    MatchId = p_MatchId,
    Profile1_Id = p_Profile1_Id,
    Profile2_Id = p_Profile2_Id,
    Match_Date = p_Match_Date,
    Match_status = p_Match_status
    WHERE 
    MatchId = p_MatchId;
    
    IF row_count() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Match id not found';
    end if;
    set p_Errors = 'Profile Match updated successfully';
    
END //

CREATE DEFINER="avnadmin"@"%" PROCEDURE "DeleteProfile_Match"(

	IN  p_MatchId INT,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
	IF(SELECT COUNT(*) FROM Profile_Match WHERE MatchId = p_MatchId) = 0 then
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' , 'MatchId does NOT Exists');
	END IF;
    
    IF JSON_LENGTH(@ErrorTable) > 0  THEN
    SET p_Errors = JSON_UNQUOTE(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE FROM Profile_Match WHERE MatchId = p_MatchId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET message_text = 'MatchId NOT FOUND';
    END IF;
    
    set p_Errors = ' User Match Deleted successfully';
END //
DELIMITER;