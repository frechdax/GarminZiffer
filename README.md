# GarminZiffer

Ein eigenständiges Garmin-Connect-IQ-Watchface in Monkey C mit femininem, modernem AMOLED-Design.

## Aktueller Prototyp

- dunkler Plum-Hintergrund
- Blush-/Lavendel-Akzente
- große digitale Uhrzeit
- Datum
- Schritte
- Akkustand
- 12-/24-Stunden-Modus nach Geräteeinstellung
- reduzierter Always-on-/Low-Power-Modus
- direkte Skalierung über die Displaygröße

## Unterstützte Geräte (v1)

- Garmin Venu 3 (`venu3`, 454×454)
- Garmin Venu 3S (`venu3s`, 390×390)
- Garmin vívoactive 5 (`vivoactive5`, 390×390)

Weitere Geräte können in `manifest.xml` ergänzt werden. Der aktuelle Code zeichnet relativ zur Displaygröße und ist deshalb bereits auf zusätzliche runde Geräte vorbereitet.

## Projektstruktur

```text
GarminZiffer/
├── manifest.xml
├── monkey.jungle
├── source/
│   ├── GarminZifferApp.mc
│   └── GarminZifferView.mc
├── resources/
│   ├── drawables/
│   │   ├── drawables.xml
│   │   └── launcher_icon.png
│   └── strings/strings.xml
├── resources-deu/strings/strings.xml
├── resources-eng/strings/strings.xml
└── docs/INSTALL.md
```

## Build

Das Projekt ist für Garmin Connect IQ vorbereitet. Zum Build wird ein Garmin-Developer-Key benötigt.

Mit installiertem Connect IQ SDK lässt sich das Projekt über die Garmin Monkey-C-Erweiterung für VS Code oder `monkeyc` bauen.

Siehe `docs/INSTALL.md`.

## Design-Richtung

Der erste Stand ist bewusst elegant und feminin statt verspielt: dunkles Zifferblatt, roséfarbener Außenring, Lavendel-Details und klare Typografie. Die nächste Ausbaustufe kann konfigurierbare Farbschemata, Komplikationen, Herzfrequenz, Wetter und weitere Garmin-Daten enthalten.
