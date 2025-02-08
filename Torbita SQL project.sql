use testdb;

-- Distinct values 
select distinct Victim_Race from crime_data;

select * from crime_data;

 -- Create a function
 DELIMITER $$

CREATE FUNCTION age_difference (Offender_Age INT, Victim_Age INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN Offender_Age - Victim_Age;
END$$

DELIMITER ;

SELECT age_difference(30, 20);


alter table crime_data
add column age_diff int
after Victim_Age;

-- Create Triggers
create trigger age_update
before update on crime_data
for each row
set new.age_diff = abs(Offender_Age - Victim_Age);

insert into crime_data(age_diff)
values(abs(Offender_Age - Victim_Age));

update crime_data
set age_diff = abs(Offender_Age - Victim_Age);

CREATE TABLE crime_archive (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Offender_Race VARCHAR(60),
    Offender_Age INT,
    Victim_Race VARCHAR(60),
    Victim_Age INT
);



DELIMITER $$

CREATE TRIGGER Remove_record
AFTER DELETE
ON crime_data
FOR EACH ROW
BEGIN
    INSERT INTO crime_archive (Offender_Race, Offender_Age, Victim_Race, Victim_Age)
    VALUES (OLD.Offender_Race, OLD.Offender_Age, OLD.Victim_Race, OLD.Victim_Age);
END$$

DELIMITER ;

CREATE TABLE crime_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_message VARCHAR(255),
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

DELIMITER $$

CREATE TRIGGER Log_Insert
AFTER INSERT ON crime_data
FOR EACH ROW
BEGIN
    INSERT INTO crime_log (log_message)
    VALUES (CONCAT('New crime record added: Offender Race - ', NEW.Offender_Race, 
                   ', Victim Race - ', NEW.Victim_Race));
END$$

DELIMITER ;


-- Create stored procedures
DELIMITER //

CREATE PROCEDURE GetOffendersByAge(IN min_Age INT)
BEGIN
    SELECT * FROM crime_data
    WHERE Offender_Age > min_age;
END; //

DELIMITER ;

CALL GetOffendersByAge(25);

-- Add a new field
ALTER TABLE crime_data
ADD crime_type VARCHAR(80) DEFAULT 'Unknown'
AFTER Category;

-- change the name of field
ALTER TABLE crime_data
RENAME COLUMN age_diff TO Age_Diff;

-- Create user
create user 'Olowogoke'@'localhost'
identified by 'abcd';

-- Grant privileges
grant select, insert, alter on *.*
to 'Olowogoke'@'localhost';

-- Revoke privileges
revoke select, insert, alter on *.*
from 'Olowogoke'@'localhost';

create database Libary2;
use Libary2;

CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Bio TEXT
);

CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description TEXT
);

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    AuthorID INT,
    CategoryID INT,
    ISBN VARCHAR(13),
    PublishedYear INT,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255),
    JoinDate DATE
);

CREATE TABLE Loans (
    LoanID INT AUTO_INCREMENT PRIMARY KEY,
    MemberID INT,
    BookID INT,
    LoanDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

CREATE TABLE Staff (
    StaffID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Position VARCHAR(255),
    Email VARCHAR(255)
);

