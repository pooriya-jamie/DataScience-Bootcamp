-- Section1
WITH PopularArtists AS (
  SELECT a1.Name AS artist_A, c1.CustomerId, COUNT(c1.CustomerId) AS num_occurrence
  FROM Artist a1
  JOIN Album al1 ON a1.ArtistId = al1.ArtistId
  JOIN Track t1 ON al1.AlbumId = t1.AlbumId
  JOIN InvoiceLine il1 ON t1.TrackId = il1.TrackId
  JOIN Invoice i1 ON il1.InvoiceId = i1.InvoiceId
  JOIN Customer c1 ON i1.CustomerId = c1.CustomerId
  GROUP BY artist_A, c1.CustomerId
)

SELECT pa1.artist_A AS artist_A, pa2.artist_A AS artist_B, COUNT(DISTINCT pa1.CustomerId) AS num_occurrences
FROM PopularArtists pa1
JOIN PopularArtists pa2 ON pa1.CustomerId = pa2.CustomerId
WHERE pa1.artist_A < pa2.artist_A
GROUP BY pa1.artist_A, pa2.artist_A
ORDER BY num_occurrences DESC, artist_A ASC, artist_B ASC
LIMIT 200;


-- Section2
    WITH CustomerSales AS (
        SELECT c.CustomerId, c.FirstName, c.LastName, SUM(il.UnitPrice * il.Quantity) AS total_spent,
               PERCENT_RANK() OVER (ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS sales_percent_rank
        FROM Customer AS c
        JOIN Invoice AS i ON c.CustomerId = i.CustomerId
        JOIN InvoiceLine AS il ON i.InvoiceId = il.InvoiceId
        WHERE i.InvoiceDate >= '2010-01-01'
        GROUP BY c.CustomerId, c.FirstName, c.LastName
    )
    SELECT FirstName, LastName, total_spent,
           CASE
               WHEN sales_percent_rank <= 0.3 THEN 'top'
               WHEN sales_percent_rank > 0.7 THEN 'low'
               ELSE 'middle'
           END AS customer_level
    FROM CustomerSales
    ORDER BY total_spent DESC, LastName ASC;
