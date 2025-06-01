

--5. Triggers – Real-Time Business Logic


--trg_UpdateBookAvailability After new loan ? set book to unavailable

CREATE TRIGGER trg_UpdateBookAvailability
ON Loan
AFTER INSERT
AS
BEGIN
    UPDATE b
    SET b.AvailabilityStatus = 0
    FROM Book b
    JOIN inserted i ON b.BookID = i.BookID;
END;



---trg_CalculateLibraryRevenue After new payment ? update library revenue

CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payment
AFTER INSERT
AS
BEGIN
    UPDATE lr
    SET lr.TotalRevenue = lr.TotalRevenue + i.AmountPaid
    FROM LibraryRevenue lr
    JOIN inserted i ON i.MemberID = i.MemberID
    JOIN Loan l ON l.LoanID = i.LoanID
    JOIN Book b ON l.BookID = b.BookID
    WHERE lr.LibraryID = b.LibraryID;
END;



--trg_LoanDateValidation Prevents invalid return dates on insert

CREATE TRIGGER trg_LoanDateValidation
ON Loan
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ReturnDate IS NOT NULL AND ReturnDate < LoanDate
    )
    BEGIN
        RAISERROR('Return date cannot be before loan date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;



