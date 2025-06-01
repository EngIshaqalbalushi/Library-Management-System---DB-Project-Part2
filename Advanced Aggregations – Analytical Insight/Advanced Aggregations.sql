


-- Advanced Aggregations – Analytical Insight Includes:

-- HAVING for filtering aggregates

SELECT 
    b.Genre,
    AVG(r.Rating) AS AvgRating
FROM 
    Book b
JOIN 
    Review r ON b.BookID = r.BookID
GROUP BY 
    b.Genre
HAVING 
    AVG(r.Rating) > 1;




-- Subqueries for complex logic (e.g., max price per genre)
SELECT b.Genre, b.Title, b.Price
FROM Book b
JOIN (
    SELECT Genre, MAX(Price) AS MaxPrice
    FROM Book
    GROUP BY Genre
) g ON b.Genre = g.Genre AND b.Price = g.MaxPrice;


--Occupancy rate calculations
SELECT 
    LibraryID,
    COUNT(CASE WHEN AvailabilityStatus = 0 THEN 1 END) * 1.0 / COUNT(*) * 100 AS OccupancyRatePercent
FROM 
    Book
GROUP BY 
    LibraryID;


-- Members with loans but no fine
SELECT 
    LibraryID,
    COUNT(CASE WHEN AvailabilityStatus = 0 THEN 1 END) * 1.0 / COUNT(*) * 100 AS OccupancyRatePercent
FROM 
    Book
GROUP BY 
    LibraryID;


-- Genres with high average ratings
SELECT 
    Genre,
    COUNT(*) AS TotalBooks
FROM 
    Book
GROUP BY 
    Genre
HAVING 
    COUNT(*) > 2;

