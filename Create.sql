IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments
IF OBJECT_ID('Buildings', 'U') IS NOT NULL DROP TABLE Buildings
IF OBJECT_ID('DepartmentBuildings', 'U') IS NOT NULL DROP TABLE DepartmentBuildings
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees
IF OBJECT_ID('SalaryHistory', 'U') IS NOT NULL DROP TABLE SalaryHistory
IF OBJECT_ID('EmployeeHolidays', 'U') IS NOT NULL DROP TABLE EmployeeHolidays
IF OBJECT_ID('EmployeeFamilyMembers', 'U') IS NOT NULL DROP TABLE EmployeeFamilyMembers
IF OBJECT_ID('BusDrivers', 'U') IS NOT NULL DROP TABLE BusDrivers
IF OBJECT_ID('TramDrivers', 'U') IS NOT NULL DROP TABLE TramDrivers
IF OBJECT_ID('ServiceTechnicians', 'U') IS NOT NULL DROP TABLE ServiceTechnicians
IF OBJECT_ID('TicketInspectors', 'U') IS NOT NULL DROP TABLE TicketInspectors
IF OBJECT_ID('OfficeWorkers', 'U') IS NOT NULL DROP TABLE OfficeWorkers
IF OBJECT_ID('TramModels', 'U') IS NOT NULL DROP TABLE TramModels
IF OBJECT_ID('BusModels', 'U') IS NOT NULL DROP TABLE BusModels
IF OBJECT_ID('SpecialVehicleModels', 'U') IS NOT NULL DROP TABLE SpecialVehicleModels
IF OBJECT_ID('VehicleModels', 'U') IS NOT NULL DROP TABLE VehicleModels
IF OBJECT_ID('Depots', 'U') IS NOT NULL DROP TABLE Depots
IF OBJECT_ID('PeriodicTickets', 'U') IS NOT NULL DROP TABLE PeriodicTickets
IF OBJECT_ID('Passengers', 'U') IS NOT NULL DROP TABLE Passengers
IF OBJECT_ID('Discounts', 'U') IS NOT NULL DROP TABLE Discounts
IF OBJECT_ID('AirReadings', 'U') IS NOT NULL DROP TABLE AirReadings
IF OBJECT_ID('SoldSingleTickets ', 'U') IS NOT NULL DROP TABLE SoldSingleTickets
IF OBJECT_ID('TypesOfTickets', 'U') IS NOT NULL DROP TABLE TypesOfTickets


CREATE TABLE Departments (
	DepartmentID INT PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Buildings (
	BuildingID INT PRIMARY KEY,
	BuildingName VARCHAR(50) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	DepartmentID INT NOT NULL,

	FOREIGN KEY (DepartmentID) REFERENCES Departments (DepartmentID)
)

CREATE TABLE DepartmentBuildings (
	DepartmentID INT,
	BuildingID INT,

	PRIMARY KEY (DepartmentID, BuildingID),
	FOREIGN KEY (DepartmentID) REFERENCES Departments (DepartmentID),
	FOREIGN KEY (BuildingID) REFERENCES Buildings (BuildingID)
	ON UPDATE CASCADE
	ON DELETE CASCADE
)



CREATE TABLE Employees (
	EmployeeID INT PRIMARY KEY IDENTITY(1,1),
	PESEL CHAR(11) UNIQUE NOT NULL, 
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Gender NVARCHAR (1) NOT NULL,
	BirthDate DATE,
	HireDate DATE NOT NULL,
	PhoneNumber CHAR(9),
	Address VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	DepartmentID INT NOT NULL,

	FOREIGN KEY (DepartmentID) REFERENCES Departments (DepartmentID),
	CONSTRAINT Employees_AltPK UNIQUE (EmployeeID, DepartmentID)
)

CREATE TABLE SalaryHistory (
	EmployeeID INT,
	DateFrom DATE,
	DateTo DATE,
	Salary MONEY NOT NULL,
	
	PRIMARY KEY (EmployeeID, DateFrom),
	FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE EmployeeHolidays (
	EmployeeID INT,
	DateFrom DATE,
	DateTo DATE NOT NULL,

	PRIMARY KEY (EmployeeID, DateFrom),
	FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID) --on cascade ??
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE EmployeeFamilyMembers (
	EmployeeID INT,
	MemberID INT,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	Gender NVARCHAR (1) NOT NULL,
	BirthDate DATE,
	Relationship VARCHAR(30) NOT NULL,

	PRIMARY KEY (EmployeeID, MemberID),
	FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE BusDrivers (
	EmployeeID INT PRIMARY KEY,
	DepartmentID AS 1 PERSISTED,
	DriverLicenceID CHAR(13) UNIQUE NOT NULL,
	SightDefect BIT NOT NULL,
	MedicalExpiryDate DATE NOT NULL,

	FOREIGN KEY (EmployeeID, DepartmentID) REFERENCES Employees (EmployeeID, DepartmentID)
)

CREATE TABLE TramDrivers (
	EmployeeID INT PRIMARY KEY,
	DepartmentID AS 2 PERSISTED,
	LicenceID CHAR(10) NOT NULL,
	SightDefect BIT NOT NULL,
	MedicalExpiryDate DATE NOT NULL,
	
	FOREIGN KEY (EmployeeID, DepartmentID) REFERENCES Employees (EmployeeID, DepartmentID)
)

CREATE TABLE ServiceTechnicians (
	EmployeeID INT PRIMARY KEY,
	DepartmentID AS 3 PERSISTED,
	BusPermission BIT NOT NULL,
	TramPermission BIT NOT NULL,

	FOREIGN KEY (EmployeeID, DepartmentID) REFERENCES Employees (EmployeeID, DepartmentID)
)

CREATE TABLE TicketInspectors (
	EmployeeID INT PRIMARY KEY,
	DepartmentID AS 3 PERSISTED,
	LicenceID CHAR(10) NOT NULL,

	FOREIGN KEY (EmployeeID, DepartmentID) REFERENCES Employees (EmployeeID, DepartmentID)
)

CREATE TABLE OfficeWorkers (
	EmployeeID INT PRIMARY KEY,
	DepartmentID AS 4 PERSISTED,
	BuildingID INT NOT NULL,

	FOREIGN KEY (BuildingID) REFERENCES Buildings(BuildingID),
	FOREIGN KEY (EmployeeID, DepartmentID) REFERENCES Employees (EmployeeID, DepartmentID)
)

CREATE TABLE VehicleModels (
ModelID INT PRIMARY KEY,
ProductionStartDate DATE,
ProductionEndDate DATE,
Seats INT NOT NULL,
StandingPlaces INT NOT NULL,
ModelLength INT NOT NULL --, 
--FOREIGN KEY (ModelID) REFERENCES Vehicles(ModelID)
--ON DELETE CASCADE
--ON UPDATE CASCADE
)

CREATE TABLE TramModels (
ModelID INT PRIMARY KEY,
LowFloor BIT NOT NULL,
NumberOfCarriages INT NOT NULL,
Bidirectional BIT NOT NULL,

FOREIGN KEY (ModelID) REFERENCES VehicleModels(ModelID)
ON DELETE CASCADE
ON UPDATE CASCADE
)

CREATE TABLE BusModels (
ModelID INT PRIMARY KEY,
Drive VARCHAR(50) NOT NULL,
LowFloor BIT NOT NULL,
Articulated BIT NOT NULL,

FOREIGN KEY (ModelID) REFERENCES VehicleModels(ModelID)
ON DELETE CASCADE
ON UPDATE CASCADE
)

CREATE TABLE SpecialVehicleModels (
ModelID INT PRIMARY KEY,
Remarks VARCHAR(50),

FOREIGN KEY (ModelID) REFERENCES VehicleModels(ModelID)
ON DELETE CASCADE
ON UPDATE CASCADE
)

CREATE TABLE Depots (
DepotID INT PRIMARY KEY,
BuildingID INT NOT NULL,
TramDepot BIT NOT NULL,
BusDepot BIT NOT NULL,

FOREIGN KEY (BuildingID) REFERENCES Buildings(BuildingID)
ON DELETE CASCADE
ON UPDATE CASCADE
)

CREATE TABLE TypesOfTickets (
TicketID INT PRIMARY KEY,
Name VARCHAR(50) NOT NULL,
Price MONEY NOT NULL,
Periodic BIT NOT NULL
)

CREATE TABLE Passengers (
PassengerID INT PRIMARY KEY,
PESEL CHAR(11) UNIQUE NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
BirthDate DATE NOT NULL,
PlaceOfResidence VARCHAR(50) NOT NULL,
Student BIT NOT NULL,
Pupil BIT NOT NULL,
HonoraryBloodDonor BIT NOT NULL,
Pensioner BIT NOT NULL
)

CREATE TABLE PeriodicTickets (
TicketID INT PRIMARY KEY,
TicketNumber INT NOT NULL,
OwnerID INT NOT NULL,
DateFrom DATE NOT NULL,

FOREIGN KEY (TicketID) REFERENCES TypesOfTickets(TicketID)
ON DELETE CASCADE
ON UPDATE CASCADE,

FOREIGN KEY (OwnerID) REFERENCES Passengers(PassengerID)
ON DELETE CASCADE
ON UPDATE CASCADE
)

CREATE TABLE Discounts (
DiscountID INT PRIMARY KEY,
TicketID INT NOT NULL,
DateFrom DATE,
DateTo DATE

FOREIGN KEY (TicketID) REFERENCES TypesOfTickets(TicketID)
ON DELETE CASCADE
ON UPDATE CASCADE
)

CREATE TABLE AirReadings (
AirReadingDate Date PRIMARY KEY,
PM10 FLOAT NOT NULL,
PM25 FLOAT NOT NULL,
SO2 FLOAT NOT NULL,
NO2 FLOAT NOT NULL,
O3 FLOAT NOT NULL
)

CREATE TABLE SoldSingleTickets (
TicketID INT PRIMARY KEY,
TicketNumber INT NOT NULL,
DateOfPurchase Date NOT NULL

FOREIGN KEY (TicketID) REFERENCES TypesOfTickets(TicketID)
ON DELETE CASCADE
ON UPDATE CASCADE
)


ALTER TABLE Employees
ADD CONSTRAINT is_phone_valid CHECK(ISNUMERIC(PhoneNumber) = 1 AND LEN(PhoneNumber) = 9)

ALTER TABLE Employees
ADD CONSTRAINT is_employee_pesel_valid CHECK(ISNUMERIC(PESEL) = 1 AND LEN(PESEL) = 11)

ALTER TABLE EmployeeHolidays 
ADD CONSTRAINT are_holiday_dates_valid CHECK(DateTo >= DateFrom)

ALTER TABLE SalaryHistory
ADD CONSTRAINT are_salary_dates_valid CHECK(DateTo >= DateFrom)

ALTER TABLE BusDrivers
ADD CONSTRAINT is_driver_licence_valid CHECK(LEN(DriverLicenceID) = 13)

ALTER TABLE TramDrivers
ADD CONSTRAINT is_tram_licence_valid CHECK(LEN(LicenceID) = 10)

ALTER TABLE TicketInspectors
ADD CONSTRAINT is_ispector_licence_valid CHECK(LEN(LicenceID) = 10)

ALTER TABLE VehicleModels
ADD CONSTRAINT is_production_date_valid CHECK(ProductionStartDate >= ProductionEndDate)

ALTER TABLE Passengers
ADD CONSTRAINT is_passenger_pesel_valid CHECK(ISNUMERIC(PESEL) = 1 AND LEN(PESEL) = 11)

ALTER TABLE Discounts
ADD CONSTRAINT is_discount_date_valid CHECK(DateFrom >= DateTo)
