IF OBJECT_ID('New_Discounts', 'TR') IS NOT NULL
DROP TRIGGER New_Discounts

IF OBJECT_ID('Air_Readings_Update', 'TR') IS NOT NULL
DROP TRIGGER Air_Readings_Update

GO
CREATE TRIGGER InsertBuilding 
ON Buildings 
AFTER INSERT
AS
	INSERT INTO DepartmentBuildings
		SELECT BuildingID, DepartmentID FROM INSERTED
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
