# language: de
Funktionalität: Messvorlage erstellen
  Als Qualitätsmanager
  Möchte ich Messvorlagen mit definierten Dimensionen erstellen
  Damit Prüfer wissen, welche Maße zu erfassen sind und welche Toleranzen gelten

  Szenario: Messvorlage mit einer Dimension erstellen
    Wenn eine Messvorlage "Stent-Basic" mit den Dimensionen erstellt wird:
      | Name        | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser | mm      | 3.5     | 3.4             | 3.6            |
    Dann sollte die Messvorlage "Stent-Basic" existieren
    Und die Messvorlage sollte 1 Dimension haben

  Szenario: Messvorlage mit mehreren Dimensionen erstellen
    Wenn eine Messvorlage "Stent-Typ-A" mit den Dimensionen erstellt wird:
      | Name         | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser  | mm      | 3.5     | 3.4             | 3.6            |
      | Stegbreite   | mm      | 0.08    | 0.075           | 0.085          |
      | Innen Radius | mm      | 1.5     | 1.48            | 1.52           |
    Dann sollte die Messvorlage "Stent-Typ-A" existieren
    Und die Messvorlage sollte 3 Dimensionen haben

  Szenario: Messvorlage mit ungültiger Toleranz
    Wenn versucht wird eine Messvorlage mit ungültigen Toleranzen zu erstellen:
      | Name        | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser | mm      | 3.5     | 3.6             | 3.4            |
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Untere Toleranz muss kleiner als obere Toleranz sein" enthalten

  Szenario: Messvorlage ohne Dimensionen
    Wenn versucht wird eine Messvorlage ohne Dimensionen zu erstellen
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Messvorlage muss mindestens eine Dimension haben" enthalten
