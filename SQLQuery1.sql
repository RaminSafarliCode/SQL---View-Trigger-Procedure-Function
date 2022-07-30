CREATE DATABASE	SocialMedia

USE SocialMedia

--CREATE TABLE
CREATE TABLE People
(
	Id int primary key identity,
	Name nvarchar(30) not null,
	Surname nvarchar(35) not null,
	Age int,
	UserId int references Users(Id)
)

CREATE TABLE Users
(
	Id int primary key identity,
	LoginName varchar(20) unique not null,
	Password varchar(15) not null,
	Mail varchar(100) unique not null
)

CREATE TABLE Posts
(
	Id int primary key identity,
	UserId int references Users(Id),
	Content nvarchar(255) not null,
	PostedTime datetime default(GETUTCDATE()),
	LikeCount int,
	IsDeleted bit default 0
)

CREATE TABLE Comments
(
	Id int primary key identity, 
	UserId int references Users(Id),
	PostId int references Posts(Id),
	LikeCount int,
	IsDeleted bit default 0
)

-- INSERTING VALUES TO TABLES
INSERT INTO Users
VALUES
('raminsafarli', 'ramin1234', 'ramin.seferli.kb@gmail.com'),
('farhadaghayev', 'farhad1234', 'farhad.1234@gmail.com'),
('azarzeynal', 'azar1234', 'zeynal.azar@gmail.com'),
('godzilla_Boy', 'godzillaKing', 'gamer.social@mail.ru')

INSERT INTO People
VALUES
('Ramin', 'Safarli', 20, 1),
('Farhad', 'Aghayev', 20, 2),
('Azar', 'Zeynalabdiyev', 19, 3),
('Seyfaddin', 'Nadjafli', 20, 4)

INSERT INTO Posts(UserId, Content, LikeCount)
VALUES
(1, 'Everything will be good, just hardwork is needed...', 2517)

INSERT INTO Posts(UserId, Content, LikeCount)
VALUES
(2, 'Another beautiful day))', 1453)

INSERT INTO Posts(UserId, Content, LikeCount)
VALUES
(3, 'Finance is mine!', 2419)

INSERT INTO Posts(UserId, Content, LikeCount)
VALUES
(4, 'Are there anybody who can play VALORANT like me:)', 5478)

INSERT INTO Comments(UserId, PostId, LikeCount)
VALUES
(1,4, 23),
(4,2,43),
(2,3,54),
(3,1,65)

INSERT INTO Comments(UserId, PostId, LikeCount)
VALUES
(4,1,39)

-- TASK-1
SELECT p.Content, COUNT(c.Id) as 'The number of comments' FROM Posts as p
INNER JOIN Comments as c
ON c.PostId = p.Id
GROUP BY p.Content


-- TASK-2 
CREATE VIEW ShowingAllData as
SELECT u.LoginName, u.Mail, u.Password, 
(p.Name + ' ' + p.Surname) as Fullname, p.Age,
pos.Content, pos.PostedTime, pos.LikeCount, pos.IsDeleted,
c.PostId as 'Commented to this post', c.LikeCount as'Comment likes', c.IsDeleted as DeletedOrNot
FROM Users as u
INNER JOIN People as p
ON p.UserId = u.Id
INNER JOIN Posts as pos
ON pos.UserId = u.Id
INNER JOIN Comments as c
ON c.UserId = u.Id

SELECT * FROM ShowingAllData


-- TASK-3
--(For Comments)
CREATE TRIGGER UpdateInsteadOfDeleteComment 
ON Comments
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @Id int
	SELECT @Id = Id FROM deleted
	UPDATE Comments SET IsDeleted = 1 Where Id = @Id	
END

DELETE Comments WHERE Id = 5

--(For Posts)
CREATE TRIGGER UpdateInsteadOfDeletePost
ON Posts
INSTEAD OF DELETE 
AS
BEGIN
	DECLARE @Id int
	SELECT @Id = Id FROM deleted
	UPDATE Posts SET IsDeleted = 1 Where Id = @Id	
END

DELETE Posts WHERE ID = 1

-- TASK-4
CREATE PROCEDURE usp_IncreasePostLikes(@Id int)
AS
UPDATE Posts SET LikeCount += 1
WHERE Posts.Id = @Id

EXEC usp_IncreasePostLikes 1
EXEC usp_IncreasePostLikes 4

-- TASK-5
CREATE PROCEDURE usp_ResetPassword (@Mail varchar(100), @NewPassword varchar(15))
AS 
UPDATE Users SET Password = @NewPassword
WHERE Users.Mail = @Mail

EXEC usp_ResetPassword @Mail = 'ramin.seferli.kb@gmail.com', @NewPassword = 'raminseferli23'
