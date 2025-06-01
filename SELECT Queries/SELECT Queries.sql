



-- GET /loans/overdue ? List all overdue loans with member name, book title, due date
-- GET /loans/overdue ? List all overdue loans with member name, book title, due date
SELECT 
    l.LoanID, 
    m.FullName, 
    b.Title, 
    l.DueDate
FROM 
    Loan AS l
JOIN 
    Member AS m ON l.MemberID = m.MemberID
JOIN 
    Book AS b ON l.BookID = b.BookID
WHERE 
    l.ReturnDate IS NULL 
    AND l.DueDate < GETDATE();


--GET /books/unavailable ? List books not available 

SELECT 
    BookID,
    Title,
    Genre,
    Price,
    ShelfLocation,
    LibraryID
FROM 
    Book
WHERE 
    AvailabilityStatus = 0;

--GET /members/top-borrowers ? Members who borrowed >2 books

SELECT 
    m.MemberID,
    m.FullName,
    COUNT(l.LoanID) AS TotalLoans
FROM 
    Member AS m
JOIN 
    Loan AS l ON m.MemberID = l.MemberID
GROUP BY 
    m.MemberID, m.FullName
HAVING 
    COUNT(l.LoanID) > 2;


--GET /books/:id/ratings ? Show average rating per book 

SELECT 
    b.BookID,
    b.Title,
    AVG(r.Rating) AS AverageRating
FROM 
    Book AS b
JOIN 
    Review AS r ON b.BookID = r.BookID
WHERE 
    b.BookID = 1
GROUP BY 
    b.BookID, b.Title;

--GET /libraries/:id/genres ? Count books by genre 


SELECT 
    Genre,
    COUNT(*) AS BookCount
FROM 
    Book
WHERE 
    LibraryID = 2
GROUP BY 
    Genre;


-- GET /members/inactive ? List members with no loans 
SELECT 
    m.MemberID,
    m.FullName,
    m.Email
FROM 
    Member AS m
LEFT JOIN 
    Loan AS l ON m.MemberID = l.MemberID
WHERE 
    l.LoanID IS NULL;

-- GET /payments/summary ? Total fine paid per member 

SELECT 
    m.MemberID,
    m.FullName,
    SUM(p.Amount) AS TotalFinePaid
FROM 
    Payment AS p
JOIN 
    Member AS m ON p.PaymentID = m.MemberID
GROUP BY 
    m.MemberID, m.FullName;

-- GET /reviews ? Reviews with member and book info 

SELECT 
    r.ReviewID,
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    r.Rating,
    r.ReviewDate
FROM 
    Review AS r
JOIN 
    Member AS m ON r.MemberID = m.MemberID
JOIN 
    Book AS b ON r.BookID = b.BookID;

--GET /books/popular ? List top 3 books by number of times they were loaned

SELECT TOP 3
    b.BookID,
    b.Title,
    COUNT(l.LoanID) AS TimesLoaned
FROM 
    Book AS b
JOIN 
    Loan AS l ON b.BookID = l.BookID
GROUP BY 
    b.BookID, b.Title
ORDER BY 
    TimesLoaned DESC;


-- GET /members/:id/history ? Retrieve full loan history of a specific member including book title, 
--loan & return dates
SELECT 
    l.LoanID,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate,
    l.ReturnDate
FROM 
    Loan AS l
JOIN 
    Book AS b ON l.BookID = b.BookID
WHERE 
    l.MemberID = 2
ORDER BY 
    l.LoanDate DESC;

--• GET /books/:id/reviews ? Show all reviews for a book with member name and comments

SELECT 
    r.ReviewID,
    m.FullName AS MemberName,
    r.Rating,
    r.Comments,
    r.ReviewDate
FROM 
    Review AS r
JOIN 
    Member AS m ON r.MemberID = m.MemberID
WHERE 
    r.BookID = 3
ORDER BY 
    r.ReviewDate DESC;


--GET /libraries/:id/staff ? List all staff working in a given library

SELECT 
    s.StaffID,
    s.FullName,
    s.Position,
    s.ContactNumber
FROM 
    Staff AS s
WHERE 
    s.LibraryID = 1;

--• GET /books/price-range?min=5&max=15 ? Show books whose prices fall within a given range

SELECT 
    BookID,
    Title,
    Genre,
    Price,
    LibraryID
FROM 
    Book
WHERE 
    Price BETWEEN 5 AND 15;

--GET /loans/active ? List all currently active loans (not yet returned) with member and book info

SELECT 
    l.LoanID,
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate
FROM 
    Loan AS l
JOIN 
    Member AS m ON l.MemberID = m.MemberID
JOIN 
    Book AS b ON l.BookID = b.BookID
WHERE 
    l.ReturnDate IS NULL
ORDER BY 
    l.DueDate ASC;

-- GET /members/with-fines ? List members who have paid any fine

SELECT DISTINCT
    m.MemberID,
    m.FullName,
    m.Email
FROM 
    Payment AS p
JOIN 
    Member AS m ON p.PaymentID = m.MemberID
WHERE 
    p.Amount > 0;


--GET /books/never-reviewed ? List books that have never been reviewed

SELECT 
    b.BookID,
    b.Title,
    b.Genre,
    b.Price
FROM 
    Book AS b
LEFT JOIN 
    Review AS r ON b.BookID = r.BookID
WHERE 
    r.ReviewID IS NULL;

-- GET /members/:id/loan-history ?Show a member’s loan history with book titles and loan status.

SELECT 
    l.LoanID,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate,
    l.ReturnDate,
    CASE 
        WHEN l.ReturnDate IS NULL THEN 'Active'
        WHEN l.ReturnDate > l.DueDate THEN 'Returned Late'
        ELSE 'Returned On Time'
    END AS LoanStatus
FROM 
    Loan AS l
JOIN 
    Book AS b ON l.BookID = b.BookID
WHERE 
    l.MemberID = 2
ORDER BY 
    l.LoanDate DESC;

--GET /members/inactive ?List all members who have never borrowed any book.

SELECT 
    m.MemberID,
    m.FullName,
    m.Email
FROM 
    Member AS m
LEFT JOIN 
    Loan AS l ON m.MemberID = l.MemberID
WHERE 
    l.LoanID IS NULL;


--GET /books/never-loaned ? List books that were never loaned.

SELECT 
    b.BookID,
    b.Title,
    b.Genre,
    b.Price
FROM 
    Book AS b
LEFT JOIN 
    Loan AS l ON b.BookID = l.BookID
WHERE 
    l.LoanID IS NULL;

--GET /payments ?List all payments with member name and book title.

SELECT 
    p.PaymentID,
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    p.Amount,
    p.PaymentDate
FROM 
    Payment AS p
JOIN 
    Member AS m ON p.PaymentID = m.MemberID
JOIN 
    Loan AS l ON p.LoanID = l.LoanID
JOIN 
    Book AS b ON l.BookID = b.BookID
ORDER BY 
    p.PaymentDate DESC;

--GET /loans/overdue? List all overdue loans with member and book details.

SELECT 
    l.LoanID,
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate,
    l.ReturnDate
FROM 
    Loan AS l
JOIN 
    Member AS m ON l.MemberID = m.MemberID
JOIN 
    Book AS b ON l.BookID = b.BookID
WHERE 
    l.ReturnDate IS NULL
    AND l.DueDate < GETDATE()
ORDER BY 
    l.DueDate ASC;

--GET /books/:id/loan-count ? Show how many times a book has been loaned.
SELECT 
    b.BookID,
    b.Title,
    COUNT(l.LoanID) AS TimesLoaned
FROM 
    Book AS b
LEFT JOIN 
    Loan AS l ON b.BookID = l.BookID
WHERE 
    b.BookID = 3
GROUP BY 
    b.BookID, b.Title;

 --GET /members/:id/fines ? Get total fines paid by a member across all loans.

 SELECT 
    m.MemberID,
    m.FullName,
    SUM(p.Amount) AS TotalFinesPaid
FROM 
    Payment AS p
JOIN 
    Member AS m ON p.PaymentID = m.MemberID
WHERE 
    m.MemberID = 3
GROUP BY 
    m.MemberID, m.FullName;

--GET /libraries/:id/book-stats ? Show count of available and unavailable books in a library.

SELECT 
    b.LibraryID,
    SUM(CASE WHEN b.AvailabilityStatus = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
    SUM(CASE WHEN b.AvailabilityStatus = 0 THEN 1 ELSE 0 END) AS UnavailableBooks
FROM 
    Book AS b
WHERE 
    b.LibraryID = 1
GROUP BY 
    b.LibraryID;

--GET /reviews/top-rated ? Return books with more than 5 reviews and average rating > 4.5.

SELECT 
    b.BookID,
    b.Title,
    COUNT(r.ReviewID) AS TotalReviews,
    AVG(r.Rating) AS AverageRating
FROM 
    Book AS b
JOIN 
    Review AS r ON b.BookID = r.BookID
GROUP BY 
    b.BookID, b.Title
HAVING 
    COUNT(r.ReviewID) > 5
    AND AVG(r.Rating) > 4.5;

 


