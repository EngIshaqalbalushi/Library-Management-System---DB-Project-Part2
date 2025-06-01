

--4. Stored Procedures – Backend Automation







--sp_MarkBookUnavailable(BookID) Updates availability after issuing

CREATE PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Book
    SET AvailabilityStatus = 0
    WHERE BookID = @BookID;
END;


--sp_UpdateLoanStatus() Checks dates and updates loan statuses
CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    -- Set availability = 1 for returned books
    UPDATE b
    SET b.AvailabilityStatus = 1
    FROM Book b
    JOIN Loan l ON b.BookID = l.BookID
    WHERE l.ReturnDate IS NOT NULL;

    -- Set availability = 0 for active loans
    UPDATE b
    SET b.AvailabilityStatus = 0
    FROM Book b
    JOIN Loan l ON b.BookID = l.BookID
    WHERE l.ReturnDate IS NULL;
END;



--sp_RankMembersByFines() Ranks members by total fines paid

CREATE PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SELECT 
        m.MemberID,
        m.FullName,
        SUM(p.Amount) AS TotalFines,
        RANK() OVER (ORDER BY SUM(p.Amount) DESC) AS FineRank
    FROM 
        Member m
    JOIN Payment p ON m.MemberID = p.PaymentID
    GROUP BY 
        m.MemberID, m.FullName
    ORDER BY 
        TotalFines DESC;
END;

