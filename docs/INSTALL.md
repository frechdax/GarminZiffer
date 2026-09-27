# Fleur installieren

## Ohne lokale Entwicklungsumgebung

Das Repository baut die Garmin-Dateien automatisch in GitHub Actions. Du brauchst auf deinem Mac weder VS Code noch das Garmin Connect IQ SDK.

1. Öffne im Repository den Ordner `downloads/`.
2. Lade die `.prg` für dein Garmin-Modell herunter.
3. Verbinde die Uhr per USB.
4. Kopiere die Datei nach `GARMIN/APPS`.
5. Trenne die Uhr und aktiviere **Fleur** in der Ziffernblatt-Auswahl.

## Unterstützte automatische Downloads

- `GarminZiffer-venu3.prg`
- `GarminZiffer-venu3s.prg`
- `GarminZiffer-vivoactive5.prg`

## GitHub Actions

`build-watchface.yml` erzeugt Build-Artefakte. `publish-downloads.yml` kompiliert zusätzlich die drei Sideload-Dateien und schreibt sie zurück in `downloads/`.

Für private Tests kann der Workflow einen temporären Developer Key erzeugen. Für dauerhaft updatefähige Store-Builds sollte ein eigener stabiler Developer Key über das Secret `GARMIN_DEVELOPER_KEY_B64` verwendet werden.
