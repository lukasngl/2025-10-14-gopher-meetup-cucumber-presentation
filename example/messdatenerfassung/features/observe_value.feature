# language: de
Funktionalität: Messwert erfassen
  Als Qualitätsprüfer
  Möchte ich gemessene Werte für definierte Dimensionen erfassen
  Damit die Maßhaltigkeit des Werkstücks dokumentiert wird

  Hintergrund:
    Angenommen eine Messvorlage "Stent-Typ-A" mit den Dimensionen existiert:
      | Name         | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser  | mm      | 3.5     | 3.4             | 3.6            |
      | Stegbreite   | mm      | 0.08    | 0.075           | 0.085          |
      | Innen Radius | mm      | 1.5     | 1.48            | 1.52           |
    Und eine Messung für Vorlage "Stent-Typ-A" gestartet wurde

  Szenario: Erfolgreiche Messung aller Dimensionen
    Wenn der Wert 3.52 für "Durchmesser" erfasst wird
    Dann ist die Messung unvollständig
    Wenn der Wert 0.082 für "Stegbreite" erfasst wird
    Dann ist die Messung unvollständig
    Wenn der Wert 1.50 für "Innen Radius" erfasst wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist maßhaltig

  Szenario: Messwert außerhalb Toleranz
    Wenn der Wert 3.7 für "Durchmesser" erfasst wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist nicht maßhaltig

  Szenario: Grenzwerte der Toleranz
    Wenn der Wert 3.4 für "Durchmesser" erfasst wird
    Und der Wert 0.085 für "Stegbreite" erfasst wird
    Und der Wert 1.48 für "Innen Radius" erfasst wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist maßhaltig

  Szenario: Knapp außerhalb der Toleranz
    Wenn der Wert 3.61 für "Durchmesser" erfasst wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist nicht maßhaltig

  Szenario: Mehrere Werte außerhalb Toleranz
    Wenn der Wert 3.7 für "Durchmesser" erfasst wird
    Und der Wert 0.09 für "Stegbreite" erfasst wird
    Dann ist die Messung vollständig
    Und das gemessene Teil ist nicht maßhaltig

  Szenario: Messwert für nicht existierende Dimension
    Wenn versucht wird den Wert 5.0 für "Wandstärke" zu erfassen
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Dimension nicht in Messvorlage vorhanden" enthalten

  Szenario: Messwert nach Abschluss der Messung erfassen
    Angenommen der Wert 3.7 für "Durchmesser" erfasst wurde
    Und die Messung ist vollständig
    Wenn versucht wird den Wert 0.08 für "Stegbreite" zu erfassen
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Messung bereits abgeschlossen" enthalten

  Szenario: Dimension doppelt messen
    Angenommen der Wert 3.5 für "Durchmesser" erfasst wurde
    Wenn versucht wird den Wert 3.52 für "Durchmesser" zu erfassen
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Dimension bereits gemessen" enthalten
