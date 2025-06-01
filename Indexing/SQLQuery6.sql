

--1. Indexing Strategy – Performance Optimization

--Library Table

--Non-clustered on Name ? Search by name
CREATE NONCLUSTERED INDEX IX_Library_Name 
ON Library (Name);

-- Non-clustered on Location ? Filter by location

CREATE NONCLUSTERED INDEX IX_Library_Location 
ON Library (Location);


--Book Table


--Clustered on LibraryID, ISBN ? Lookup by book in specific library

CREATE CLUSTERED INDEX LibraryID_ISBN 
ON Book (LibraryID, ISBN);

--Non-clustered on Genre ? Filter by genre
CREATE NONCLUSTERED INDEX IX_Book_Genre 
ON Book (Genre);

--Loan Table

-- Non-clustered on MemberID ? Loan history

CREATE NONCLUSTERED INDEX Loan_MemberID 
ON Loan (MemberID);

-- Non-clustered on Status ? Filter by status

CREATE NONCLUSTERED INDEX IX_Loan_Status 
ON Loan (Status);
-- Composite index on BookID, LoanDate, ReturnDate ? Optimize overdue checks

CREATE NONCLUSTERED INDEX IX_Loan_BookID_LoanDate_ReturnDate 
ON Loan (BookID, LoanDate, ReturnDate)

