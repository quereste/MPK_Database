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
