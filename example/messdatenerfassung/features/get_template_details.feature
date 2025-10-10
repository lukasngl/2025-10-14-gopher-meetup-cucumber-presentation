# language: de
Funktionalität: Messvorlagen-Details abfragen
  Als Qualitätsprüfer
  Möchte ich die Details einer Messvorlage einsehen
  Damit ich weiß, welche Dimensionen ich messen muss und welche Toleranzen gelten

  Szenario: Details einer einfachen Messvorlage abfragen
    Angenommen eine Messvorlage "Stent-Basic" mit den Dimensionen existiert:
      | Name        | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser | mm      | 3.5     | 3.4             | 3.6            |
    Wenn die Details der Messvorlage "Stent-Basic" abgefragt werden
    Dann sollte die Messvorlage folgende Dimensionen haben:
      | Name        | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser | mm      | 3.5     | 3.4             | 3.6            |

  Szenario: Details einer komplexen Messvorlage abfragen
    Angenommen eine Messvorlage "Stent-Typ-A" mit den Dimensionen existiert:
      | Name         | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser  | mm      | 3.5     | 3.4             | 3.6            |
      | Stegbreite   | mm      | 0.08    | 0.075           | 0.085          |
      | Innen Radius | mm      | 1.5     | 1.48            | 1.52           |
    Wenn die Details der Messvorlage "Stent-Typ-A" abgefragt werden
    Dann sollte die Messvorlage 3 Dimensionen haben
    Und die Messvorlage sollte folgende Dimensionen haben:
      | Name         | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser  | mm      | 3.5     | 3.4             | 3.6            |
      | Stegbreite   | mm      | 0.08    | 0.075           | 0.085          |
      | Innen Radius | mm      | 1.5     | 1.48            | 1.52           |

  Szenario: Details einer nicht existierenden Messvorlage abfragen
    Wenn versucht wird die Details der Messvorlage "Nicht-Existent" abzufragen
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Messvorlage nicht gefunden" enthalten
