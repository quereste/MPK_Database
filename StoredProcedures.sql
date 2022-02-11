IF OBJECT_ID('Passenger_Ticket_Info', 'P') IS NOT NULL
DROP PROCEDURE Passenger_Ticket_Info

GO

CREATE PROCEDURE Passenger_Ticket_Info (@id INT) AS
BEGIN
	IF NOT EXISTS(SELECT * FROM Passengers P WHERE P.PassengerID = @id)
		BEGIN
			;THROW 51000, 'Passenger does not exist.', 1
		END

	DECLARE @pesel CHAR(11)
	DECLARE @passengerID INT
	DECLARE @birthDate DATE
	DECLARE @firstName VARCHAR(50)
	DECLARE @lastName VARCHAR(50)
	DECLARE @placeOfResidence VARCHAR(50)
	DECLARE @city VARCHAR(50)
	DECLARE @student BIT
	DECLARE @pupil BIT
	DECLARE @honoraryBloodDonor BIT
	DECLARE @pensioner BIT

	DECLARE cur CURSOR FOR (SELECT * FROM Passengers P WHERE P.PassengerID = @id)
	OPEN cur
	FETCH NEXT FROM cur INTO @passengerID, @pesel, @birthDate, @firstName, @lastName, @placeOfResidence, @city, @student, @pupil,
	@honoraryBloodDonor, @pensioner
	SELECT FORMATMESSAGE('Passenger info: PESEL: %s; ID: %d; Date of birth: %s; first name: %s; last name: %s; address: %s; city: %s; student: %d; pupil: %d; honorary blood donor: %d; pensioner: %d',  @pesel, @passengerID, CONVERT(varchar(50), @birthDate), @firstName,
	@lastName, @placeOfResidence, @city, CONVERT(INT, @student), CONVERT(INT, @pupil), CONVERT(INT, @honoraryBloodDonor), CONVERT(INT, @pensioner))
	CLOSE cur
	DEALLOCATE cur

	IF (@student = 1 OR @pupil = 1 OR @honoraryBloodDonor = 1 OR @pensioner = 1)
		SELECT FORMATMESSAGE('%s %s with passenger id %d can buy tickets with reduced prices.', @firstName, @lastName, @id)
	ELSE
		SELECT FORMATMESSAGE('%s %s with passenger id %d cannot buy tickets with reduced prices.', @firstName, @lastName, @id)
END

GO
