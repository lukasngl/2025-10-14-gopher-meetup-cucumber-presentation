# language: de
Funktionalität: Messung starten
  Als Qualitätsprüfer
  Möchte ich eine neue Messung basierend auf einer Messvorlage starten
  Damit ich die Messwerte für ein konkretes Werkstück erfassen kann

  Hintergrund:
    Angenommen eine Messvorlage "Stent-Typ-A" mit den Dimensionen existiert:
      | Name         | Einheit | Nominal | Untere Toleranz | Obere Toleranz |
      | Durchmesser  | mm      | 3.5     | 3.4             | 3.6            |
      | Stegbreite   | mm      | 0.08    | 0.075           | 0.085          |
      | Innen Radius | mm      | 1.5     | 1.48            | 1.52           |

  Szenario: Messung erfolgreich starten
    Wenn eine Messung für Vorlage "Stent-Typ-A" gestartet wird
    Dann sollte die Messung existieren
    Und die Messung ist unvollständig

  Szenario: Mehrere Messungen für dieselbe Vorlage starten
    Wenn eine Messung für Vorlage "Stent-Typ-A" gestartet wird
    Und eine weitere Messung für Vorlage "Stent-Typ-A" gestartet wird
    Dann sollten 2 Messungen für Vorlage "Stent-Typ-A" existieren

  Szenario: Messung für nicht existierende Vorlage starten
    Wenn versucht wird eine Messung für Vorlage "Nicht-Existent" zu starten
    Dann sollte ein Fehler auftreten
    Und die Fehlermeldung sollte "Messvorlage nicht gefunden" enthalten
