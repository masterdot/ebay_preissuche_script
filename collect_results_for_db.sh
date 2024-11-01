#!/bin/bash

# Ausgabe-Dateien definieren
output_file="zusammengefuegt_ebay_suche.csv"
sql_file="insert_statements.sql"
table_name="ebay_suche"

# Falls die Ausgabedateien bereits existieren, löschen
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

if [ -f "$sql_file" ]; then
    rm "$sql_file"
fi

# Überprüfen, ob mindestens eine passende CSV-Datei existiert
csv_files=$(ls ebay_suche_*.csv 2>/dev/null)
if [ -z "$csv_files" ]; then
    echo "Keine ebay_suche CSV-Dateien gefunden."
    exit 1
fi

# Beispiel für die Spaltenstruktur (bitte anpassen!)
# Annahme: Die CSV-Dateien haben drei Werte: ISBN, min_price, max_price, average_price
create_table="CREATE TABLE IF NOT EXISTS $table_name (
    isbn TEXT PRIMARY KEY,
    min_price REAL,
    max_price REAL,
    average_price REAL
);"

# CREATE TABLE-Anweisung in die SQL-Datei schreiben
echo "$create_table" > "$sql_file"

# Inhalte aller Dateien sortiert in die Ausgabedatei schreiben
for file in $(echo "$csv_files" | sort); do
    cat "$file" >> "$output_file" || { echo "Fehler beim Verarbeiten von $file"; exit 1; }

    # Einfügen der Werte in die SQL-Datei als INSERT-Anweisung
    while IFS=',' read -r isbn min_price max_price average_price; do
        echo "INSERT INTO $table_name (isbn, min_price, max_price, average_price) VALUES ('$isbn', $min_price, $max_price, $average_price);" >> "$sql_file"
    done < "$file"
done

echo "Alle Dateien wurden erfolgreich zusammengeführt in $output_file."
echo "SQL-Inserts und CREATE TABLE-Anweisung wurden in $sql_file geschrieben."
