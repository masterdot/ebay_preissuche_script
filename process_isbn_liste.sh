#!/bin/bash

# Überprüfen, ob die ISBN-Liste angegeben wurde
if [ -z "$1" ]; then
  echo "Bitte geben Sie den Pfad zu einer Datei mit ISBN-Nummern an."
  exit 1
fi

# Überprüfen, ob die Datei existiert
ISBN_LIST_FILE="$1"
if [ ! -f "$ISBN_LIST_FILE" ]; then
  echo "Die Datei $ISBN_LIST_FILE existiert nicht."
  exit 1
fi

# Datei für die Ergebnisse
RESULT_FILE="isbn_search_results.txt"
echo "Ergebnisse der ISBN-Suche" > "$RESULT_FILE"

# Schleife durch jede Zeile in der Datei
while IFS= read -r isbn; do
  if [ -n "$isbn" ]; then
    echo "Verarbeite ISBN: $isbn"
    
    # Führt das eBay-Suchskript aus und leitet die Ausgabe in das Ergebnisfile
    ./ebay_suche.sh "$isbn" >> "$RESULT_FILE"
    
    # Fügt eine Trennzeile zwischen den ISBN-Suchergebnissen hinzu
    echo -e "\n---\n" >> "$RESULT_FILE"
  fi
done < "$ISBN_LIST_FILE"

echo "Alle ISBNs wurden verarbeitet. Ergebnisse in $RESULT_FILE gespeichert."
