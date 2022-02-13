IF OBJECT_ID('Interval_Air_Readings', 'TF') IS NOT NULL DROP FUNCTION Interval_Air_Readings
IF OBJECT_ID('Get_Route', 'TF') IS NOT NULL DROP FUNCTION Get_Route
IF OBJECT_ID('Number_Of_Vehicles', 'TF') IS NOT NULL DROP FUNCTION Number_Of_Vehicles
IF OBJECT_ID('Number_Of_Types_Of_Drives', 'TF') IS NOT NULL DROP FUNCTION Number_Of_Types_Of_Drives

GO
CREATE FUNCTION Interval_Air_Readings (@date DATE)
RETURNS @table TABLE (
	Interval NVARCHAR(50),
	Average_PM10 DECIMAL(7,3),
	Standard_Deviation_PM10 DECIMAL(7,3),
	Average_PM25 DECIMAL(7,3),
	Standard_Deviation_PM25 DECIMAL(7,3),
	Average_SO2 DECIMAL(7,3),
	Standard_Deviation_SO2 DECIMAL(7,3),
	Average_NO2 DECIMAL(7,3),
	Standard_Deviation_NO2 DECIMAL(7,3),
	Average_O3 DECIMAL(7,3),
	Standard_Deviation_O3 DECIMAL(7,3)
)
AS
BEGIN
	INSERT INTO @table
		SELECT 'week', AVG(PM10), STDEV(PM10), AVG(PM25), STDEV(PM25), AVG(SO2), STDEV(SO2), AVG(NO2), STDEV(NO2), AVG(O3), STDEV(O3)
		FROM AirReadings
		WHERE DATEPART(week, AirReadingDate) = DATEPART(week, @date)
	
	INSERT INTO @table
		SELECT 'month', AVG(PM10), STDEV(PM10), AVG(PM25), STDEV(PM25), AVG(SO2), STDEV(SO2), AVG(NO2), STDEV(NO2), AVG(O3), STDEV(O3)
		FROM AirReadings
		WHERE MONTH(AirReadingDate) = MONTH(@date)
	
	INSERT INTO @table
		SELECT 'year', AVG(PM10), STDEV(PM10), AVG(PM25), STDEV(PM25), AVG(SO2), STDEV(SO2), AVG(NO2), STDEV(NO2), AVG(O3), STDEV(O3)
		FROM AirReadings
		WHERE YEAR(AirReadingDate) = YEAR(@date)

	RETURN
END

GO

SELECT *
FROM dbo.Interval_Air_Readings('2021-12-29')

GO
CREATE FUNCTION Get_Route (@line INT)
RETURNS @route TABLE
(	
	Ord INT,
	[Stop name] NVARCHAR(60)
)
AS
BEGIN	
	IF NOT EXISTS
		(
			SELECT LineID FROM Lines
			WHERE LineID = @line
		)
	BEGIN
		INSERT INTO @route VALUES
			(-1, CAST('Invalid line number.' AS INT))
	END
	ELSE
		IF EXISTS 
			( 
				SELECT LineID FROM TramLines
				WHERE LineID = @line
			)
		BEGIN
			INSERT INTO @route
				SELECT TL.StopNumber, S.StopName
				FROM Stops AS S JOIN TramLines AS TL
				ON TL.StopID = S.StopID
				WHERE TL.LineID = @line
				ORDER BY TL.StopNumber
		END

		ELSE
			BEGIN 
				INSERT INTO @route
					SELECT BL.StopNumber, S.StopName
					FROM Stops AS S JOIN BusLines AS BL
					ON BL.StopID = S.StopID
					WHERE BL.LineID = @line
					ORDER BY BL.StopNumber
			END
	RETURN
END

GO
SELECT * FROM dbo.Get_Route(52)
ORDER BY Ord

GO
CREATE FUNCTION Number_Of_Vehicles()
RETURNS @table TABLE
(
	Buses INT,
	Trams INT,
	SpecialVehicles INT
) 
AS
BEGIN

		DECLARE @noOfTrams INT
		DECLARE @noOfBuses INT
		DECLARE @noOfSpecialVehicles INT

		SET @noOfTrams = (SELECT COUNT(*) FROM (SELECT V.ModelID FROM VehicleModels V JOIN TramModels T ON V.ModelID = T.ModelID) AS subquery)
		SET @noOfBuses = (SELECT COUNT(*) FROM (SELECT V.ModelID FROM VehicleModels V JOIN BusModels B ON V.ModelID = B.ModelID) AS subquery1)
		SET @noOfSpecialVehicles = (SELECT COUNT(*) FROM (SELECT V.ModelID FROM VehicleModels V JOIN SpecialVehicleModels S ON V.ModelID = S.ModelID) AS subquery2)
		

		INSERT INTO @table 
			SELECT @noOfBuses, @noOfTrams, @noOfSpecialVehicles

		RETURN
END

GO

SELECT * FROM Number_Of_Vehicles()

GO

CREATE FUNCTION Number_Of_Types_Of_Drives()
RETURNS @table TABLE
(
	Combustion INT,
	Electric INT,
	Hybrid INT
) 
AS
BEGIN

		DECLARE @noOfCombustion INT
		DECLARE @noOfElectric INT
		DECLARE @noOfHybrid INT

		SET @noOfCombustion = (SELECT COUNT(*) FROM (SELECT * FROM BusModels WHERE Drive = 'Combustion') AS subquery)
		SET @noOfElectric = (SELECT COUNT(*) FROM (SELECT * FROM BusModels WHERE Drive = 'Electric') AS subquery1)
		SET @noOfHybrid = (SELECT COUNT(*) FROM (SELECT * FROM BusModels WHERE Drive = 'Hybrid') AS subquery2)
		

		INSERT INTO @table 
			SELECT @noOfCombustion, @noOfElectric, @noOfHybrid

		RETURN
END

GO

SELECT * FROM Number_Of_Types_Of_Drives()
