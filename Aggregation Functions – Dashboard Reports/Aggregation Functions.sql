

-- Aggregation Functions – Dashboard Reports

--Tasks simulate admin dashboards:


--Total fines per member

SELECT 
    m.MemberID,
    m.FullName,
    SUM(p.Amount) AS TotalFines
FROM 
    Member m
JOIN 
    Payment p ON m.MemberID = p.PaymentID
GROUP BY 
    m.MemberID, m.FullName



--Most active libraries (by loan count)

SELECT 
    b.LibraryID,
    COUNT(l.LoanID) AS TotalLoans
FROM 
    Loan l
JOIN 
    Book b ON l.BookID = b.BookID
GROUP BY 
    b.LibraryID




-- Avg book price per genre
SELECT 
    Genre,
    AVG(Price) AS AvgPrice
FROM 
    Book
GROUP BY 
    Genre



-- Top 3 most reviewed books
SELECT TOP 3
    b.BookID,
    b.Title,
    COUNT(r.ReviewID) AS ReviewCount
FROM 
    Book b
JOIN 
    Review r ON b.BookID = r.BookID
GROUP BY 
    b.BookID, b.Title



--Library revenue report

SELECT 
    b.LibraryID,
    SUM(p.Amount) AS TotalRevenue
FROM 
    Payment p
JOIN 
    Loan l ON p.LoanID = l.LoanID
JOIN 
    Book b ON l.BookID = b.BookID
GROUP BY 
    b.LibraryID

--Member activity summary (loan + fines)

SELECT 
    m.MemberID,
    m.FullName,
    COUNT(DISTINCT l.LoanID) AS TotalLoans,
    SUM(p.Amount) AS TotalFines
FROM 
    Member m
LEFT JOIN 
    Loan l ON m.MemberID = l.MemberID
LEFT JOIN 
    Payment p ON m.MemberID = p.PaymentID
GROUP BY 
    m.MemberID, m.FullName

