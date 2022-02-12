CREATE TRIGGER InsertBuilding 
ON Buildings 
AFTER INSERT
AS
	INSERT INTO DepartmentBuildings
		SELECT BuildingID, DepartmentID FROM INSERTED
