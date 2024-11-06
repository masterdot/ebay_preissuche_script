drop view isbns;
CREATE VIEW isbns AS 
SELECT ean_isbn13 
FROM library_items
WHERE ean_isbn13 IS NOT NULL AND ean_isbn13 <> '';
