drop view library_with_prices;
CREATE VIEW library_with_prices AS
SELECT 
    li.item_type,
    li.title,
    li.creators,
    li.ean_isbn13,
    li.description,
    li.publisher,
    li.publish_date,
    li.length,
    li.number_of_discs,
	printf('%.2f', es.min_price) AS min_price,
	printf('%.2f', es.max_price) AS max_price,
	printf('%.2f', es.average_price) AS average_price
FROM 
    library_items li
LEFT JOIN 
    ebay_suche es 
ON 
    li.ean_isbn13 = es.isbn;
