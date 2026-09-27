# Garmin Ziffernblatt — Fleur

Eigenständiges Garmin-Connect-IQ-Watchface für runde AMOLED-Garmin-Uhren. **Fleur** ist ein femininer Prototyp mit Rosé-, Gold- und Flieder-Akzenten und wird vollständig in Monkey C gezeichnet.

![Fleur Vorschau](docs/fleur-display-preview.png)

## Funktionen

- große digitale Uhrzeit mit 12-/24-Stunden-Modus nach Geräteeinstellung
- Datum
- Schritte und Fortschritt zum Tagesziel
- letzter verfügbarer Herzfrequenzwert
- Garmin-Akkustand
- Body Battery, sofern das Gerät den Wert über Connect IQ `SensorHistory` bereitstellt
- florale Rosé-/Gold-/Flieder-Elemente
- stromsparender Always-on-/Low-Power-Modus
- prozedural gezeichnetes Layout ohne großes Hintergrundbild im Watchface-Speicher

## Aktuell gebaute Geräte

- Garmin Venu 3 (`venu3`)
- Garmin Venu 3S (`venu3s`)
- Garmin vívoactive 5 (`vivoactive5`)

Weitere runde Connect-IQ-Geräte können nach Geräteprüfung ergänzt werden.

## Automatische Builds

Bei Änderungen auf `main` bauen GitHub Actions automatisch `.prg`-Dateien. Zusätzlich werden aktuelle Sideload-Builds im Ordner [`downloads/`](downloads/) abgelegt.

Direktlinks nach erfolgreichem Build:

- [Venu 3](downloads/GarminZiffer-venu3.prg)
- [Venu 3S](downloads/GarminZiffer-venu3s.prg)
- [vívoactive 5](downloads/GarminZiffer-vivoactive5.prg)

Für einen dauerhaften Store-Release sollte `GARMIN_DEVELOPER_KEY_B64` als Repository Secret mit einem dauerhaft aufbewahrten Garmin Developer Key gesetzt werden.

## Installation auf der Uhr

1. Passende `.prg` aus `downloads/` herunterladen.
2. Garmin per USB verbinden.
3. Datei nach `GARMIN/APPS` kopieren.
4. Uhr trennen und **Fleur** in der Ziffernblatt-Auswahl auswählen.

Siehe auch [`docs/INSTALL.md`](docs/INSTALL.md).

## Projektstruktur

```text
GarminZiffer/
├── manifest.xml
├── monkey.jungle
├── source/
│   ├── GarminZifferApp.mc
│   └── GarminZifferView.mc
├── resources/
├── resources-deu/
├── resources-eng/
├── docs/
├── downloads/
├── store/
└── .github/workflows/
```

## Status

**Prototype v0.2.** Nächste sinnvolle Schritte sind zusätzliche Garmin-Modelle, konfigurierbare Farben/Datenfelder und eine stabil signierte Connect-IQ-Store-Version.
