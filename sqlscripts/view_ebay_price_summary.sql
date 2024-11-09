drop view ebay_price_summary;
CREATE VIEW ebay_price_summary AS
SELECT 
    SUM(min_price) AS total_min_price,
    SUM(max_price) AS total_max_price,
    SUM(average_price) AS total_average_price
FROM 
    ebay_suche;

