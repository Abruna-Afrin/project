CREATE TABLE "UserGroups" (
  "UserGroupId" bigint NOT NULL AUTO_INCREMENT,
  "GroupName" varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  "ParentUserGroupId" bigint DEFAULT NULL,
  "LastModifiedUTCDateTime" datetime DEFAULT NULL,
  "LastModifiedBy" varchar(50) DEFAULT NULL,
  "CreatedUTCDateTime" datetime DEFAULT NULL,
  "CreatedBy" varchar(50) DEFAULT NULL,
  "IsDelete" bit(1) DEFAULT NULL,
  PRIMARY KEY ("UserGroupId")
);


CREATE TABLE "Users" (
  "UserId" bigint NOT NULL AUTO_INCREMENT,
  "UserUUId" varchar(255) NOT NULL,
  "UserGroupId" bigint NOT NULL,
  "FirstName" varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  "LastName" varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  "EMail" varchar(255) DEFAULT NULL,
  "LastModifiedUTCDateTime" datetime DEFAULT CURRENT_TIMESTAMP,
  "LastModifiedBy" varchar(255) DEFAULT NULL,
  "CreatedUTCDateTime" datetime DEFAULT CURRENT_TIMESTAMP,
  "CreatedBy" varchar(255) DEFAULT NULL,
  "IsDelete" bit(1) DEFAULT b'1',
  PRIMARY KEY ("UserId"),
  KEY "fk_UserGroupId" ("UserGroupId"),
  CONSTRAINT "fk_UserGroupId" FOREIGN KEY ("UserGroupId") REFERENCES "UserGroups" ("UserGroupId") ON DELETE CASCADE ON UPDATE CASCADE
);
