

--3. Functions – Reusable Logic


--GetBookAverageRating(BookID) Returns average rating of a book

CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @AvgRating FLOAT;

    SELECT @AvgRating = AVG(Rating)
    FROM Review
    WHERE BookID = @BookID;

    RETURN @AvgRating;
END;



--GetNextAvailableBook(Genre, Title, LibraryID) Fetches the next available book

CREATE FUNCTION GetNextAvailableBook (
    @Genre NVARCHAR(50),
    @Title NVARCHAR(100),
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
SELECT TOP 1 *
FROM Book
WHERE 
    Genre = @Genre AND 
    Title = @Title AND 
    LibraryID = @LibraryID AND 
    AvailabilityStatus = 1;




--CalculateLibraryOccupancyRate(LibraryID) Returns % of books currently issued
CREATE FUNCTION CalculateLibraryOccupancyRate (@LibraryID INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Total INT, @Unavailable INT;

    SELECT @Total = COUNT(*) FROM Book WHERE LibraryID = @LibraryID;
    SELECT @Unavailable = COUNT(*) FROM Book WHERE LibraryID = @LibraryID AND AvailabilityStatus = 0;

    RETURN CASE WHEN @Total = 0 THEN 0 ELSE CAST(@Unavailable AS FLOAT) / @Total * 100 END;
END;


--fn_GetMemberLoanCount Return the total number of loans made by a given member
CREATE FUNCTION fn_GetMemberLoanCount (@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*) FROM Loan WHERE MemberID = @MemberID;

    RETURN @Count;
END;


--fn_GetLateReturnDays Return the number of late days for a loan (0 if not late).
CREATE FUNCTION fn_GetLateReturnDays (@LoanID INT)
RETURNS INT
AS
BEGIN
    DECLARE @LateDays INT;

    SELECT @LateDays = 
        CASE 
            WHEN ReturnDate IS NULL THEN 0
            WHEN ReturnDate > DueDate THEN DATEDIFF(DAY, DueDate, ReturnDate)
            ELSE 0
        END
    FROM Loan
    WHERE LoanID = @LoanID;

    RETURN ISNULL(@LateDays, 0);
END;

--fn_ListAvailableBooksByLibrary Returns a table of available books from a specific library
CREATE FUNCTION fn_ListAvailableBooksByLibrary (@LibraryID INT)
RETURNS TABLE
AS
RETURN
SELECT *
FROM Book
WHERE LibraryID = @LibraryID AND AvailabilityStatus = 1;

--fn_GetTopRatedBooks Returns books with average rating ? 4.5
CREATE FUNCTION fn_GetTopRatedBooks ()
RETURNS TABLE
AS
RETURN
SELECT 
    b.BookID,
    b.Title,
    AVG(r.Rating) AS AvgRating
FROM 
    Book b
JOIN 
    Review r ON b.BookID = r.BookID
GROUP BY 
    b.BookID, b.Title
HAVING 
    AVG(r.Rating) >= 4.5;

--fn_FormatMemberName Returns the full name formatted as "LastName, FirstName"

CREATE FUNCTION fn_GetTopRatedBooks ()
RETURNS TABLE
AS
RETURN
SELECT 
    b.BookID,
    b.Title,
    AVG(r.Rating) AS AvgRating
FROM 
    Book b
JOIN 
    Review r ON b.BookID = r.BookID
GROUP BY 
    b.BookID, b.Title
HAVING 
    AVG(r.Rating) >= 4.5;




