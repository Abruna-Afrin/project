USE `YH_University`;
DROP procedure IF EXISTS `yh_CreateUser`;

USE `YH_University`;
DROP procedure IF EXISTS `YH_University`.`yh_CreateUser`;
;

DELIMITER $$
USE `YH_University`$$
CREATE DEFINER="avnadmin"@"%" PROCEDURE "yh_CreateUser"(
    IN p_UserGroupId BIGINT,
    IN p_FirstName NVARCHAR(255),
    IN p_LastName NVARCHAR(255),
    IN p_EMail VARCHAR(255)
)
BEGIN
    DECLARE v_UserUUId VARCHAR(255);
    DECLARE v_UserGroupIdExists INT;

    -- Validate input parameters
    IF p_FirstName IS NULL OR p_FirstName = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'First name cannot be empty.';
    END IF;

    IF p_LastName IS NULL OR p_LastName = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Last name cannot be empty.';
    END IF;

    -- Check if UserGroupId exists
    SELECT COUNT(*) INTO v_UserGroupIdExists
    FROM yh_UserGroups
    WHERE UserGroupId = p_UserGroupId;

    IF v_UserGroupIdExists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'UserGroupId does not exist.';
    END IF;

    -- Generate UUID
    SET v_UserUUId = UUID();

    -- Insert the new user
    INSERT INTO yh_Users (UserUUId, UserGroupId, FirstName, LastName, EMail, LastModifiedUTCDateTime, CreatedUTCDateTime, CreatedBy)
    VALUES (v_UserUUId, p_UserGroupId, p_FirstName, p_LastName, p_EMail, UTC_TIMESTAMP(), UTC_TIMESTAMP(), USER());

    -- Handle any exceptions
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error creating user.';
    ELSE
        SELECT CONCAT('User created with UUID: ', v_UserUUId) AS Result;
    END IF;
END$$

DELIMITER ;
;

