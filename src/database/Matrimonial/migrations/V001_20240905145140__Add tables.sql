
create table Users
(
	UserId int auto_increment primary key,
    FirstName varchar(255),
    LastName varchar(255),
    DOB date,
    Gender varchar(255),
    Email nvarchar(255),
    Phone varchar(255),
    Address nvarchar(255)
);

/*profile table*/
create table UserProfile
(
	ProfileId int auto_increment primary key,
    UserId int,
    Nationality varchar(255),
    Religion varchar(255),
	Hight varchar(255),
    MaritalStatus varchar(255),
    Bio varchar(255),
    FOREIGN key (UserId)
    References Users (UserId)
);

create table Education (
    EducationId int auto_increment primary key,
    UserId int,
    Degree varchar(255),
    Institution varchar(255),
    FieldOfStudy varchar(100),
    StartDate date,
    EndDate date,
    GPA decimal(3, 2),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

/*occupation*/
CREATE TABLE Occupation (
    OccupationId int auto_increment primary key,  
    OccupationTitle varchar(100) NOT NULL,       
    OccupationDescription text,                           
    AverageSalary decimal(12, 2),                 
    DateAdded date  
);

/*preference table*/
create table UserPreference
(
	PreId int auto_increment primary key,
    UserId int,
    Nationality varchar(255),
    Religion varchar(255),
	Hight varchar(255),
    Education bigint,
    Occupation nvarchar(255),
    Location varchar(255),
    FOREIGN key (UserId)
    References Users (UserId)
);
/*picture table*/
create table ProfilePictures (
    PictureId int auto_increment primary key,
    UserId int,
    ProfilePicture BLOB,
    PictureType VARCHAR(50),
    UploadDate date,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

/* Match*/
create table ProfileMatch
(
	MatchId int auto_increment primary key,
    Profile1Id int,
    Profile2Id int,
    Match_Date date,
    Match_status varchar(255),
    FOREIGN key (Profile1Id) References UserProfile (ProfileId),
    FOREIGN key (Profile2Id) References UserProfile (ProfileId)
);

/* Contact*/
create table Contact
(
	ContactId int auto_increment primary key,
    Con1Id int,
    Con2Id int,
    Contact_Date date,
    FOREIGN key (Con1Id) References Users (UserId),
    FOREIGN key (Con2Id) References Users (UserId)
);

/*feedback*/
create table Feedback
(
	FeedbackId int auto_increment primary key,
    UserId int,
    Message text,
    FeedbackDate date,
    FOREIGN key (UserId) References Users (UserId)    
);


