IF OBJECT_ID('New_Discounts', 'TR') IS NOT NULL
DROP TRIGGER New_Discounts

IF OBJECT_ID('Air_Readings_Update', 'TR') IS NOT NULL
DROP TRIGGER Air_Readings_Update

IF OBJECT_ID('Passenegers_Data_Check_Insert', 'TR') IS NOT NULL
DROP TRIGGER Passenegers_Data_Check_Insert

IF OBJECT_ID('Passenegers_Data_Check_Update', 'TR') IS NOT NULL
DROP TRIGGER Passenegers_Data_Check_Update

IF OBJECT_ID('Insert_TramConnections', 'TR') IS NOT NULL
DROP TRIGGER Insert_TramConnections

IF OBJECT_ID('Insert_BusConnections', 'TR') IS NOT NULL
DROP TRIGGER Insert_BusConnections

GO

CREATE TRIGGER New_Discounts ON AirReadings
AFTER INSERT
AS
	DECLARE cur CURSOR FOR SELECT * FROM inserted
	
	OPEN cur

	DECLARE @date DATE
	DECLARE @PM10 INT
	DECLARE @PM25 INT
	DECLARE @NO2 INT
	DECLARE @SO2 INT
	DECLARE @O3 INT
	FETCH cur INTO @date, @PM10, @PM25, @NO2, @SO2, @O3

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@PM10 >= 150 OR @PM25 >= 150 OR @NO2 >= 150 OR @SO2 >= 150 OR @O3 >= 150)
		BEGIN
			INSERT INTO Discounts VALUES
			(1, @date, @date, 100),
			(2, @date, @date, 100),
			(3, @date, @date, 100),
			(4, @date, @date, 100),
			(5, @date, @date, 100),
			(6, @date, @date, 100),
			(7, @date, @date, 100),
			(8, @date, @date, 100),
			(9, @date, @date, 100),
			(10, @date, @date, 100),
			(11, @date, @date, 100),
			(12, @date, @date, 100),
			(13, @date, @date, 100),
			(14, @date, @date, 100),
			(15, @date, @date, 100),
			(16, @date, @date, 100),
			(17, @date, @date, 100)
		END
		FETCH cur INTO @date, @PM10, @PM25, @NO2, @SO2, @O3
	END

	CLOSE cur
	DEALLOCATE cur
GO

GO
CREATE TRIGGER Air_Readings_Update ON AirReadings
AFTER UPDATE
AS
	DECLARE cur CURSOR FOR SELECT * FROM inserted

	OPEN cur

	DECLARE @date DATE
	DECLARE @PM10 INT
	DECLARE @PM25 INT
	DECLARE @NO2 INT
	DECLARE @SO2 INT
	DECLARE @O3 INT
	FETCH cur INTO @date, @PM10, @PM25, @NO2, @SO2, @O3

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@PM10 >= 150 OR @PM25 >= 150 OR @NO2 >= 150 OR @SO2 >= 150 OR @O3 >= 150)
		BEGIN
			INSERT INTO Discounts VALUES
			(1, @date, @date, 100),
			(2, @date, @date, 100),
			(3, @date, @date, 100),
			(4, @date, @date, 100),
			(5, @date, @date, 100),
			(6, @date, @date, 100),
			(7, @date, @date, 100),
			(8, @date, @date, 100),
			(9, @date, @date, 100),
			(10, @date, @date, 100),
			(11, @date, @date, 100),
			(12, @date, @date, 100),
			(13, @date, @date, 100),
			(14, @date, @date, 100),
			(15, @date, @date, 100),
			(16, @date, @date, 100),
			(17, @date, @date, 100)
		END
		FETCH cur INTO @date, @PM10, @PM25, @NO2, @SO2, @O3
	END

	CLOSE cur
	DEALLOCATE cur
GO

GO
CREATE TRIGGER Passenegers_Data_Check_Insert ON Passengers
INSTEAD OF INSERT
AS
	DECLARE @id INT
	DECLARE @pesel CHAR(11)
	DECLARE @firstName VARCHAR(50)
	DECLARE @lastName VARCHAR(50)
	DECLARE @address VARCHAR(50)
	DECLARE @city VARCHAR(50)
	DECLARE @birthDate DATE
	DECLARE @student BIT
	DECLARE @pupil BIT
	DECLARE @honoraryBloodDonor BIT
	DECLARE @pensioner BIT
	DECLARE @years INT
	DECLARE @gender VARCHAR(1)
	DECLARE @errorMsg VARCHAR(50)

	DECLARE cur CURSOR FOR SELECT PESEL, BirthDate, FirstName, LastName, PlaceOfResidence, City, Student, Pupil, HonoraryBloodDonor, Pensioner FROM inserted
	OPEN cur
	FETCH cur INTO @pesel, @birthDate, @firstName, @lastName, @address, @city, @student, @pupil, @honoraryBloodDonor, @pensioner
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @years = DATEDIFF(yy, @birthDate, GETDATE()) - CASE WHEN (MONTH(@birthDate) > MONTH(GETDATE())) OR (MONTH(@birthDate) = MONTH(GETDATE()) AND DAY(@birthDate) > DAY(GETDATE())) THEN 1 ELSE 0 END
		SET @gender = (SELECT LEFT(RIGHT(CONVERT(VARCHAR, @pesel), 2), 1))
		IF (@gender = '0' OR @gender = '2' OR @gender = '4' OR @gender = '6' OR @gender = '8')
		BEGIN
			IF (@years < 60 AND @pensioner = 1)
			BEGIN
				SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a pensioner.' 
				;THROW 51001, @errorMsg, 1
			END
		END
		ELSE
		BEGIN
			IF (@years < 65 AND @pensioner = 1)
			BEGIN
				SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a pensioner.' 
				;THROW 51001, @errorMsg, 1
			END
		END
		IF (@years > 26 AND @student = 1)
		BEGIN
			SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a student.' 
			;THROW 51001, @errorMsg, 1
		END
		IF (@years > 18 AND @pupil = 1)
		BEGIN
			SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a pupil.' 
			;THROW 51001, @errorMsg, 1
		END
		ELSE
		BEGIN
			INSERT INTO Passengers VALUES
			(@pesel, @birthDate, @firstName, @lastName, @address, @city, @student, @pupil, @honoraryBloodDonor, @pensioner)
		END

		FETCH cur INTO @pesel, @birthDate, @firstName, @lastName, @address, @city, @student, @pupil, @honoraryBloodDonor, @pensioner
	END

	CLOSE cur
	DEALLOCATE cur

GO

GO
CREATE TRIGGER Passenegers_Data_Check_Update ON Passengers
AFTER UPDATE
AS
	DECLARE @id INT
	DECLARE @pesel CHAR(11)
	DECLARE @firstName VARCHAR(50)
	DECLARE @lastName VARCHAR(50)
	DECLARE @address VARCHAR(50)
	DECLARE @city VARCHAR(50)
	DECLARE @birthDate DATE
	DECLARE @student BIT
	DECLARE @pupil BIT
	DECLARE @honoraryBloodDonor BIT
	DECLARE @pensioner BIT
	DECLARE @years INT
	DECLARE @gender VARCHAR(1)
	DECLARE @errorMsg VARCHAR(50)

	DECLARE cur CURSOR FOR SELECT PESEL, BirthDate, FirstName, LastName, PlaceOfResidence, City, Student, Pupil, HonoraryBloodDonor, Pensioner FROM inserted
	OPEN cur
	FETCH cur INTO @pesel, @birthDate, @firstName, @lastName, @address, @city, @student, @pupil, @honoraryBloodDonor, @pensioner
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @years = DATEDIFF(yy, @birthDate, GETDATE()) - CASE WHEN (MONTH(@birthDate) > MONTH(GETDATE())) OR (MONTH(@birthDate) = MONTH(GETDATE()) AND DAY(@birthDate) > DAY(GETDATE())) THEN 1 ELSE 0 END
		SET @gender = (SELECT LEFT(RIGHT(CONVERT(VARCHAR, @pesel), 2), 1))
		IF (@gender = '0' OR @gender = '2' OR @gender = '4' OR @gender = '6' OR @gender = '8')
		BEGIN
			IF (@years < 60 AND @pensioner = 1)
			BEGIN
				SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a pensioner.' 
				;THROW 51002, @errorMsg, 1
			END
		END
		ELSE
		BEGIN
			IF (@years < 65 AND @pensioner = 1)
			BEGIN
				SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a pensioner.' 
				;THROW 51002, @errorMsg, 1
			END
		END
		IF (@years > 26 AND @student = 1)
		BEGIN
			SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a student.' 
			;THROW 51002, @errorMsg, 1
		END
		IF (@years > 18 AND @pupil = 1)
		BEGIN
			SET @errorMsg = @firstName + ' ' + @lastName + ' cannot be a pupil.' 
			;THROW 51002, @errorMsg, 1
		END
		FETCH cur INTO @pesel, @birthDate, @firstName, @lastName, @address, @city, @student, @pupil, @honoraryBloodDonor, @pensioner
	END

	CLOSE cur
	DEALLOCATE cur

GO
CREATE TRIGGER Insert_TramConnections
ON TramConnections 
INSTEAD OF INSERT
AS 
BEGIN
	
	DECLARE @From INT
	DECLARE @To INT
	DECLARE @Time INT
	
	DECLARE Records CURSOR
		FOR SELECT FromStopID, ToStopID, Duration FROM Inserted
		FOR READ ONLY
	
	OPEN Records

	FETCH Records INTO @From, @To, @Time

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@To IN (SELECT StopID FROM Stops))
		BEGIN 
			IF (@Time > 0)
				INSERT INTO TramConnections VALUES (@From, @To, @Time)
			ELSE
				print CAST(@From AS VARCHAR) + ', ' + CAST(@To AS VARCHAR) + ', ' + CAST(@Time AS VARCHAR) + ' will not be added due to non-positive journey duration between the stops' 
		END
		ELSE
			print CAST(@From AS VARCHAR) + ', ' + CAST(@To AS VARCHAR) + ', ' + CAST(@Time AS VARCHAR) + ' will not be added due to non-existing stop'
		FETCH Records INTO @From, @To, @Time
	END
	
	CLOSE Records
	DEALLOCATE Records

END

GO

CREATE TRIGGER Insert_BusConnections
ON BusConnections 
INSTEAD OF INSERT
AS 
BEGIN
	
	DECLARE @From INT
	DECLARE @To INT
	DECLARE @Time INT

	DECLARE Records CURSOR
		FOR SELECT FromStopID, ToStopID, Duration FROM Inserted
		FOR READ ONLY
	
	OPEN Records

	FETCH Records INTO @From, @To, @Time

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@To IN (SELECT StopID FROM Stops))
		BEGIN 
			IF (@Time > 0)
				INSERT INTO TramConnections VALUES (@From, @To, @Time)
			ELSE
				print CAST(@From AS VARCHAR) + ', ' + CAST(@To AS VARCHAR) + ', ' + CAST(@Time AS VARCHAR) + ' will not be added due to non-positive journey duration between the stops' 
		END
		ELSE
			print CAST(@From AS VARCHAR) + ', ' + CAST(@To AS VARCHAR) + ', ' + CAST(@Time AS VARCHAR) + ' will not be added due to non-existing stop'
		FETCH Records INTO @From, @To, @Time
	END
	
	CLOSE Records
	DEALLOCATE Records

END

GO
