DELIMITER //

DROP PROCEDURE IF EXISTS CreateFeedback //
CREATE PROCEDURE CreateFeedback(
 
    IN p_UserId int,
    IN p_Message text,
    IN p_Feedback_Date date,
    OUT p_FeedbackId int,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    IF NOT EXISTS(SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId  does not exists');
    end if;

 IF p_Message IS NULL OR p_Message = '' THEN
     SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Message can not be null or empty');
    end if;
    
     IF  p_Feedback_Date IS NULL THEN
     SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Feedback date can not be null or empty');
    end if;
    
    
    if json_length(@ErrorTable) > 0 then
    set p_Errors = json_unquote(@ErrorTable);
    set p_FeedbackId = null;
    
    ELSE
    INSERT INTO Feedback(UserId, Message, Feedback_Date)
    VALUES(p_UserId, p_Message, p_Feedback_Date);
    
    SET p_Errors = '[]';
    SET p_FeedbackId= last_insert_id();
    SET p_Errors = 'User Feedback created Successfully';
    end if;

END //

DROP PROCEDURE IF EXISTS UpdateFeedback //
CREATE  PROCEDURE UpdateFeedback(
 
    IN p_FeedbackId int,
    IN p_UserId int,
    IN p_Message text,
    IN p_Feedback_Date date,
    OUT p_Errors VARCHAR(255)
)
BEGIN

	SET @ErrorTable = '[]';
    
    IF NOT EXISTS (SELECT FeedbackId FROM Feedback WHERE FeedbackId = p_FeedbackId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Feedback id NOT EXISTS');
    END IF;
    
    IF NOT EXISTS(SELECT UserId FROM Users WHERE UserId = p_UserId) THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'UserId  does not exists');
    end if;

     IF p_Message IS NULL OR p_Message = '' THEN
     SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Message can not be null or empty');
     END IF;
    
     IF  p_Feedback_Date IS NULL THEN
     SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$', 'Feedback date can not be null or empty');
     END IF;
    
    
    if json_length(@ErrorTable) > 0 then
    set p_Errors = json_unquote(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    end if;
    
    UPDATE Feedback
    SET 
    UserId = p_UserId, 
    Message = p_Message,
    Feedback_Date = p_Feedback_Date
    WHERE 
    FeedbackId = p_FeedbackId;
    
    IF ROW_COUNT() = 0 THEN 
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    end if;
	SET p_Errors = 'User Feedback Updated Successfully';

END //

DROP PROCEDURE IF EXISTS DeleteFeedback //
CREATE PROCEDURE DeleteFeedback(

	IN p_FeedbackId int,
    OUT p_Errors VARCHAR(255)
)
BEGIN
	SET @ErrorTable = '[]';
    
    IF(SELECT COUNT(*) FROM Feedback WHERE FeedbackId = p_FeedbackId) = 0 THEN
    SET @ErrorTable = JSON_ARRAY_APPEND(@ErrorTable, '$' ,'Feedback id doest not exists');
    END IF;
    
     if json_length(@ErrorTable) > 0 then
    set p_Errors = json_unquote(@ErrorTable);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_Errors;
    END IF;
    
    DELETE FROM Feedback WHERE FeedbackId = p_FeedbackId;
    
    IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Feedback id not found';
    end if;
    
    SET p_Errors = ' User Feedback deleted succcessfully';
END //

DELIMITER;
