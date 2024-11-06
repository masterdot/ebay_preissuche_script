CREATE TABLE library_items (
    item_type TEXT,
    title TEXT,
    creators TEXT,
    first_name TEXT,
    last_name TEXT,
    ean_isbn13 INTEGER,
    upc_isbn10 INTEGER,
    description TEXT,
    publisher TEXT,
    publish_date TEXT, -- SQLite speichert DATE als TEXT im Format 'YYYY-MM-DD'
    "group" TEXT,      -- Klammern um das reservierte Wort
    tags TEXT,
    notes TEXT,
    price REAL,
    length INTEGER,
    number_of_discs INTEGER,
    number_of_players INTEGER,
    age_group TEXT,
    ensemble TEXT,
    aspect_ratio TEXT,
    esrb TEXT,
    rating REAL,
    review TEXT,
    review_date TEXT, -- ebenfalls als TEXT im Format 'YYYY-MM-DD'
    status TEXT,
    began TEXT,
    completed TEXT,
    added TEXT,
    copies INTEGER
);

