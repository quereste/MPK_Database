IF OBJECT_ID('Interval_Air_Readings', 'TF') IS NOT NULL DROP FUNCTION Interval_Air_Readings
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
