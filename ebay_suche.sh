#!/bin/bash

# Parameter-Überprüfung
if [ -z "$1" ]; then
  echo "Bitte eine ISBN angeben."
  exit 1
fi

# Eingabeparameter
ISBN=$1
OUTFILE="ebay_suche_$ISBN.txt"
OUTFILECSV="ebay_suche_$ISBN.csv"
# URL für die eBay-Suche mit der angegebenen ISBN
URL="https://www.ebay.de/sch/i.html?_from=R40&_trksid=p2334524.m570.l1313&_nkw=$ISBN&_sacat=11232&_odkw=$ISBN&_osacat=11232&LH_Complete=1&LH_Sold=1"

# Funktion zum Berechnen des Durchschnitts
function calculate_average() {
  local sum=0
  local count=0

  for price in "$@"; do
    sum=$(echo "$sum + $price" | bc)
    count=$((count + 1))
  done

  echo "scale=2; $sum / $count" | bc
}

# Anfrage an eBay und Fehlerbehandlung
echo "Suche auf eBay für ISBN: $ISBN"
curl -s "$URL" > "$OUTFILE"
if [ $? -ne 0 ]; then
  echo "Ein Fehler ist aufgetreten. Siehe $OUTFILE für Details."
  echo "Fehler: Zugriff auf eBay fehlgeschlagen" >> "$OUTFILE"
  exit 1
fi

# Extrahieren der Preise aus der HTML-Datei
PRICES=$(grep -oP '(?<=EUR )\d+,\d+' "$OUTFILE" | sed 's/,/./g')

# Fehlerbehandlung für fehlende Ergebnisse
if [ -z "$PRICES" ]; then
  echo "Ein Fehler ist aufgetreten. Keine Preise gefunden." | tee -a "$OUTFILE"
  exit 1
fi

# Berechnen des minimalen, maximalen und durchschnittlichen Preises
MIN_PRICE=$(echo "$PRICES" | sort -n | head -n1)
MAX_PRICE=$(echo "$PRICES" | sort -n | tail -n1)
AVG_PRICE=$(calculate_average $PRICES)
OUTPUT="${ISBN},${MIN_PRICE},${MAX_PRICE},${AVG_PRICE}"
# Ausgabe in die Konsole und Speichern in der Datei
{
  echo "Ergebnisse für ISBN: $ISBN"
  echo "Geringster Preis: EUR $MIN_PRICE"
  echo "Höchster Preis: EUR $MAX_PRICE"
  echo "Durchschnittlicher Preis: EUR $AVG_PRICE"
} | tee -a "$OUTFILE"
{
  echo "$OUTPUT"
} | tee -a "$OUTFILECSV"
