

--2. Views – Frontend Integration Support


--ViewPopularBooks Books with average rating > 4.5 + total loans

CREATE VIEW ViewPopularBooks AS
SELECT 
    b.BookID,
    b.Title,

    COUNT(l.LoanID) AS TotalLoans,
    AVG(r.Rating) AS AverageRating
FROM 
    Book AS b
LEFT JOIN Loan AS l ON b.BookID = l.BookID
LEFT JOIN Review AS r ON b.BookID = r.BookID
GROUP BY 
    b.BookID, b.Title
HAVING 
    AVG(r.Rating) > 4.5;


--ViewMemberLoanSummary Member loan count + total fines paid

CREATE VIEW ViewMemberLoanSummary AS
SELECT 
    m.MemberID,
    m.FullName,
    COUNT(DISTINCT l.LoanID) AS TotalLoans,
    SUM(p.Amount) AS TotalFinesPaid
FROM 
    Member AS m
LEFT JOIN Loan AS l ON m.MemberID = l.MemberID
LEFT JOIN Payment AS p ON m.MemberID = p.PaymentID
GROUP BY 
    m.MemberID, m.FullName;


--ViewAvailableBooks Available books grouped by genre, ordered by price


CREATE VIEW ViewAvailableBooks AS
SELECT 
    Genre,
    Title,
    MAX(Price) AS Price
FROM 
    Book 
WHERE 
    AvailabilityStatus = 1
GROUP BY 
    Genre, Title;

SELECT * FROM ViewAvailableBooks ORDER BY Price;


--ViewLoanStatusSummary Loan stats (issued, returned, overdue) per library

CREATE VIEW ViewLoanStatusSummary AS
SELECT 
    b.LibraryID,
    SUM(CASE WHEN l.ReturnDate IS NULL AND l.DueDate < GETDATE() THEN 1 ELSE 0 END) AS OverdueLoans,
    SUM(CASE WHEN l.ReturnDate IS NULL AND l.DueDate >= GETDATE() THEN 1 ELSE 0 END) AS ActiveLoans,
    SUM(CASE WHEN l.ReturnDate IS NOT NULL THEN 1 ELSE 0 END) AS ReturnedLoans
FROM 
    Loan AS l
JOIN Book AS b ON l.BookID = b.BookID
GROUP BY 
    b.LibraryID;



--ViewPaymentOverview Payment info with member, book, and status

CREATE VIEW ViewPaymentOverview AS
SELECT 
    p.PaymentID,
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    p.Amount,
    p.PaymentDate
FROM 
    Payment AS p
JOIN Member AS m ON p.PaymentID = m.MemberID
JOIN Loan AS l ON p.LoanID = l.LoanID
JOIN Book AS b ON l.BookID = b.BookID;

