

--Transactions – Ensuring Consistency Real-world transactional flows:





-- Start the transaction

DECLARE @LoanID INT = 1001;  

BEGIN TRANSACTION;

BEGIN TRY
DECLARE @MemberID INT = 1;  -- Replace with a valid ID from your database
DECLARE @BookID INT = 101; 
    -- Insert new loan
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate)
    VALUES (@MemberID, @BookID, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

    -- Update book availability
    UPDATE Book
    SET AvailabilityStatus = 0
    WHERE BookID = @BookID;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    RAISERROR('Borrowing failed. Transaction rolled back.', 16, 1);
END CATCH;






--Returning a book (update status, return date, availability)

DECLARE @LoanID INT = 1;  

BEGIN TRANSACTION;

BEGIN TRY
    -- Update return date
    UPDATE Loan
    SET ReturnDate = GETDATE()
    WHERE LoanID = @LoanID;

    -- Set book as available
    UPDATE Book
    SET AvailabilityStatus = 1
    WHERE BookID = (SELECT BookID FROM Loan WHERE LoanID = @LoanID);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    RAISERROR('Return operation failed.', 16, 1);
END CATCH;







-- Registering a payment (with validation)

DECLARE @LoanID INT = 1;         
DECLARE @AmountPaid INT = -1;       

BEGIN TRANSACTION;

BEGIN TRY
    -- Validate payment amount is positive
    IF @AmountPaid <= 0
    BEGIN
        RAISERROR('Invalid payment amount.', 16, 1);
        ROLLBACK;
        RETURN;
    END

    -- Insert payment
    INSERT INTO Payment (LoanID, Amount, PaymentDate)
    VALUES (@LoanID, @AmountPaid, GETDATE());

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    RAISERROR('Payment failed.', 16, 1);
END CATCH;



-- Batch loan insert with rollback on failure

DECLARE @Member1 INT = 1;   
DECLARE @Book1   INT = 101; 
DECLARE @Member2 INT = 2;  
DECLARE @Book2   INT = 102; 


BEGIN TRANSACTION;

BEGIN TRY
    -- First loan
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate)
    VALUES (@Member1, @Book1, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

    UPDATE Book 
    SET AvailabilityStatus = 0 
    WHERE BookID = @Book1;

    -- Second loan
    INSERT INTO Loan (MemberID, BookID, LoanDate, DueDate, ReturnDate)
    VALUES (@Member2, @Book2, GETDATE(), DATEADD(DAY, 14, GETDATE()), NULL);

    UPDATE Book 
    SET AvailabilityStatus = 0 
    WHERE BookID = @Book2;

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    RAISERROR('Batch loan insert failed. All changes rolled back.', 16, 1);
END CATCH;




