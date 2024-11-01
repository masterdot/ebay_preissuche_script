#!/bin/bash

# Ausgabe-Datei definieren
output_file="zusammengefuegt_ebay_suche.csv"

# Falls die Ausgabe-Datei bereits existiert, löschen
if [ -f "$output_file" ]; then
    rm "$output_file"
fi

# Überprüfen, ob mindestens eine passende Datei existiert
csv_files=$(ls ebay_suche_*.csv 2>/dev/null)
if [ -z "$csv_files" ]; then
    echo "Keine ebay_suche CSV-Dateien gefunden."
    exit 1
fi

# Inhalte aller Dateien sortiert in die Ausgabedatei schreiben
for file in $(echo "$csv_files" | sort); do
    cat "$file" >> "$output_file" || { echo "Fehler beim Verarbeiten von $file"; exit 1; }
done

echo "Alle Dateien wurden erfolgreich zusammengeführt in $output_file."
