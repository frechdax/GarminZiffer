# Installation / Test auf einer Garmin-Uhr

## 1. Connect IQ Build erzeugen

Für ein Garmin-Watchface muss der Monkey-C-Quellcode mit dem Garmin Connect IQ SDK kompiliert und signiert werden. Ein Developer Key ist dafür erforderlich.

Garmins üblicher Weg:

1. Connect IQ SDK installieren.
2. Garmin Monkey-C-Erweiterung in VS Code verwenden oder `monkeyc` über die Kommandozeile aufrufen.
3. Simulator-Ziel auswählen (z. B. `venu3`).
4. Projekt bauen und im Simulator testen.
5. Für die Store-Verteilung über **Export Project** ein `.iq`-Paket erzeugen.

## 2. Direktes Sideloading

Für einen privaten Test kann eine erzeugte `.prg`-Datei bei unterstützten Uhren über USB in den Ordner `Garmin/Apps/` kopiert werden.

## 3. Connect IQ Store

Für eine öffentliche Veröffentlichung wird das exportierte `.iq`-Paket im Connect IQ Developer Dashboard hochgeladen und von Garmin geprüft.

## Aktuelle Zielgeräte

Die erste Version zielt auf Venu 3, Venu 3S und vívoactive 5. Weitere Produkt-IDs können später über Garmins **Edit Products**-Funktion zum Manifest hinzugefügt werden.
