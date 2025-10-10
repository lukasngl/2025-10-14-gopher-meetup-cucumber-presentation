# language: de
Funktionalität: Messstatus abfragen
  Als Qualitätsprüfer
  Möchte ich den Status einer laufenden oder abgeschlossenen Messung abfragen
  Damit ich sehe, welche Dimensionen bereits gemessen wurden und ob das Teil maßhaltig ist

  Hintergrund:
    Angenommen eine Messvorlage "Stent-Typ-A" mit den Dimensionen existiert:
      | Name         | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser  | mm      | 3.5     | 3.4             | 3.6            |
      | Stegbreite   | mm      | 0.08    | 0.075           | 0.085          |
      | Innen Radius | mm      | 1.5     | 1.48            | 1.52           |

  Szenario: Status einer neu gestarteten Messung
    Angenommen eine Messung für Vorlage "Stent-Typ-A" gestartet wurde
    Wenn der Messstatus abgefragt wird
    Dann ist die Messung unvollständig
    Und 0 von 3 Dimensionen wurden gemessen

  Szenario: Status nach teilweiser Erfassung
    Angenommen eine Messung für Vorlage "Stent-Typ-A" gestartet wurde
    Und der Wert 3.52 für "Durchmesser" erfasst wurde
    Und der Wert 0.082 für "Stegbreite" erfasst wurde
    Wenn der Messstatus abgefragt wird
    Dann ist die Messung unvollständig
    Und 2 von 3 Dimensionen wurden gemessen
    Und die gemessenen Werte sind:
      | Dimension   | Wert  | Im Toleranzbereich |
      | Durchmesser | 3.52  | Ja                 |
      | Stegbreite  | 0.082 | Ja                 |

  Szenario: Status einer abgeschlossenen maßhaltigen Messung
    Angenommen eine Messung für Vorlage "Stent-Typ-A" gestartet wurde
    Und der Wert 3.52 für "Durchmesser" erfasst wurde
    Und der Wert 0.082 für "Stegbreite" erfasst wurde
    Und der Wert 1.50 für "Innen Radius" erfasst wurde
    Wenn der Messstatus abgefragt wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist maßhaltig
    Und 3 von 3 Dimensionen wurden gemessen

  Szenario: Status einer nicht maßhaltigen Messung
    Angenommen eine Messung für Vorlage "Stent-Typ-A" gestartet wurde
    Und der Wert 3.7 für "Durchmesser" erfasst wurde
    Wenn der Messstatus abgefragt wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist nicht maßhaltig
    Und die gemessenen Werte sind:
      | Dimension   | Wert | Im Toleranzbereich |
      | Durchmesser | 3.7  | Nein               |
