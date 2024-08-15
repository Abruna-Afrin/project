DELIMITER $$
CREATE DEFINER="avnadmin"@"%" PROCEDURE "AddUserGroup"(
    IN p_Name NVARCHAR(255),
    IN p_ParentUserGroupId BIGINT,
    IN p_LastModifiedBy VARCHAR(255),
    IN p_CreatedBy VARCHAR(255),
    OUT p_Result VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback any changes in case of an error
        ROLLBACK;
        SET p_Result = 'Error occurred while adding the UserGroup';
    END;
     proc: BEGIN
 
    -- Start a transaction
    START TRANSACTION;
 
    -- Validation logic
    IF p_Name IS NULL OR p_Name = '' THEN
        SET p_Result = 'Name cannot be NULL or empty';
        ROLLBACK;
        LEAVE proc;
    END IF;
 
   
 
    -- Insert into UserGroups table
    INSERT INTO UserGroups (
        Name,
        ParentUserGroupId,
        LastModifiedUTCDateTime,
        LastModifiedBy,
        CreatedUTCDateTime,
        CreatedBy,
        IsDelete
    ) VALUES (
        p_Name,
        p_ParentUserGroupId,
        UTC_TIMESTAMP(),
        p_LastModifiedBy,
        UTC_TIMESTAMP(),
        p_CreatedBy,
        0
    );
 
    -- Commit the transaction
    COMMIT;
 
    SET p_Result = 'UserGroup added successfully';
 
    END proc;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER="avnadmin"@"%" PROCEDURE "CreateUserGroup"(
    IN p_Name NVARCHAR(255),
    IN p_ParentUserGroupId BIGINT
)
BEGIN
    DECLARE v_UserGroupId BIGINT;
    
    -- Validate input parameters
    IF p_Name IS NULL OR p_Name = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Name cannot be empty.';
    END IF;

    -- Check if ParentUserGroupId exists
    SELECT UserGroupId INTO v_UserGroupId
    FROM yh_UserGroups
    WHERE UserGroupId = p_ParentUserGroupId;

    IF v_UserGroupId IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ParentUserGroupId does not exist.';
    END IF;

    -- Insert the new user group
    INSERT INTO yh_UserGroups (Name, ParentUserGroupId, LastModifiedUTCDateTime, CreatedUTCDateTime, CreatedBy)
    VALUES (p_Name, p_ParentUserGroupId, UTC_TIMESTAMP(), UTC_TIMESTAMP(), USER());

    SET v_UserGroupId = LAST_INSERT_ID();

    -- Handle any exceptions
    IF v_UserGroupId IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error creating user group.';
    ELSE
        SELECT CONCAT('User group created with ID: ', v_UserGroupId) AS Result;
    END IF;
END$$
DELIMITER ;



DELIMITER $$
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

    IF p_EMail IS NULL OR p_EMail = '' OR NOT p_EMail REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid e-mail format.';
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


DELIMITER $$
CREATE DEFINER="avnadmin"@"%" PROCEDURE "yh_CreateUserGroup"(
    IN p_Name NVARCHAR(255),
    IN p_ParentUserGroupId BIGINT
)
BEGIN
    DECLARE v_UserGroupId BIGINT;
    
    SELECT p_ParentUserGroupId;
    
    -- Validate input parameters
    IF p_Name IS NULL OR p_Name = '' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Name cannot be empty.';
    END IF;

	-- Check if ParentUserGroupId exists (if not NULL)
	IF p_ParentUserGroupId IS NOT NULL THEN
		SELECT UserGroupId INTO v_UserGroupId
		FROM yh_UserGroups
		WHERE UserGroupId = p_ParentUserGroupId;

		IF v_UserGroupId IS NULL THEN
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'ParentUserGroupId does not exist.';
		END IF;
	END IF;
 
    -- Insert the new user group
    INSERT INTO yh_UserGroups (GroupName, ParentUserGroupId, LastModifiedUTCDateTime, CreatedUTCDateTime, CreatedBy)
    VALUES (p_Name, p_ParentUserGroupId, UTC_TIMESTAMP(), UTC_TIMESTAMP(), USER());

    SET v_UserGroupId = LAST_INSERT_ID();

    -- Handle any exceptions
    IF v_UserGroupId IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error creating user group.';
    ELSE
        SELECT CONCAT('User group created with ID: ', v_UserGroupId) AS Result;
    END IF;
END$$
DELIMITER ;
