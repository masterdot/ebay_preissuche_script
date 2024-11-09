DROP VIEW IF EXISTS library_summary;

CREATE VIEW library_summary AS
SELECT 
    li.ean_isbn13,
    'Titel: ' || IFNULL(li.title, '') || 
        CASE 
            WHEN li.creators IS NOT NULL AND li.creators != '' 
            THEN ' von ' || li.creators 
            ELSE '' 
        END || 
        CASE 
            WHEN li.publish_date IS NOT NULL AND li.publisher IS NOT NULL 
            THEN ' (' || li.publish_date || ' bei ' || li.publisher || ' veröffentlicht)'
            WHEN li.publish_date IS NOT NULL 
            THEN ' (' || li.publish_date || ' veröffentlicht)'
            WHEN li.publisher IS NOT NULL 
            THEN ' (bei ' || li.publisher || ' veröffentlicht)'
            ELSE '' 
        END AS summary,
    CASE WHEN es.min_price IS NOT NULL THEN printf('%.2f', es.min_price) ELSE NULL END AS min_price,
    CASE WHEN es.max_price IS NOT NULL THEN printf('%.2f', es.max_price) ELSE NULL END AS max_price,
    CASE WHEN es.average_price IS NOT NULL THEN printf('%.2f', es.average_price) ELSE NULL END AS average_price
FROM 
    library_items li
LEFT JOIN
    ebay_suche es
ON
    li.ean_isbn13 = es.isbn;

