GO
CREATE VIEW Bus_Drivers
AS
	SELECT E.FirstName AS [First Name], E.LastName AS [Last Name], D.DriverLicenceID AS [Licence ID] 
	FROM Employees AS E JOIN BusDrivers AS D
	ON E.EmployeeID = D.EmployeeID
	WHERE E.DepartmentID = 1
	ORDER BY [Last Name], [First Name]
	OFFSET 0 ROWS

GO
CREATE VIEW Tram_Drivers
AS
	SELECT E.FirstName AS [First Name], E.LastName AS [Last Name], D.LicenceID AS [Licence ID] 
	FROM Employees AS E JOIN TramDrivers AS D
	ON E.EmployeeID = D.EmployeeID
	WHERE E.DepartmentID = 2
	ORDER BY [Last Name], [First Name]
	OFFSET 0 ROWS

GO
CREATE VIEW Ticket_Types
AS
	SELECT Name AS [Ticket Name], Price FROM TypesOfTickets

GO 
CREATE VIEW Vehicle_Models
AS 
	SELECT M.ModelName, COUNT(*) AS Quantity, 
	CASE 
		WHEN M.ModelID IN (SELECT ModelID FROM TramModels) THEN 'Tram'
		WHEN M.ModelID IN (SELECT ModelID FROM BusModels) THEN 'Bus'
		ELSE 'Other'
	END AS Vechicle_Type
	FROM Vehicles AS V JOIN VehicleModels AS M
	ON V.ModelID = M.ModelID
	GROUP BY M.ModelName, M.ModelID
	ORDER BY M.ModelID
	OFFSET 0 ROWS
	
GO
CREATE VIEW Passengers_With_Periodic_Tickets
AS
	SELECT * FROM Passengers P JOIN PeriodicTickets PT ON P.PassengerID = PT.OwnerID
GO

CREATE VIEW Single_Tickets_Sold_Each_Day
AS
	SELECT DateOfPurchase, COUNT(*) AS TicketsSold FROM SoldSingleTickets
	GROUP BY DateOfPurchase
GO

CREATE VIEW Days_With_Discounts
AS
	SELECT AirReadingDate FROM AirReadings WHERE PM10 >= 150 OR PM25 >= 150 OR NO2 >= 150 OR SO2 >= 150 OR O3 >= 150
GO

CREATE VIEW Vehicles_in_depots
AS
	SELECT B.Address, B.BuildingName AS Depot, VM.ModelName, COUNT(VM.ModelName) AS Count
	FROM Depots AS D JOIN Vehicles AS V
	ON D.DepotID = V.DepotID
	JOIN Buildings AS B
	ON D.BuildingID = B.BuildingID
	JOIN VehicleModels AS VM 
	ON VM.ModelID = V.ModelID
	GROUP BY B.BuildingName, B.Address, VM.ModelName
	ORDER BY Address, Depot, Count DESC
	OFFSET 0 ROWS
GO
