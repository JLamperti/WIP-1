	======================
	WIP - Walking In Place
	======================
	
	
Über WIP
========
WIP ermöglicht Kindern eine aufregende neuartige Navigation über geographische Karten. Die Schüler müssen lediglich Schrittbewegungen (möglichst ohne Vorwärtsbewegung) in eine bestimmte Richtung vornehmen, um so beispielsweise eine Europa- oder Deutschlandkarte zu erkunden. Des weiteren können in Europa einige Navigationsaufgaben absolviert werden, die das Wissen über bestimmte Sehenswürdigkeiten abfragen.


Für WIP benötigt
================
- Android-Smartphone + Datenkabel
- Processing 3.3 (https://processing.org/download/?processing)
	- Processing for Android
	- Ketai Library
	- oscP5 Library
- PC im gleichen Netzwerk wie das Smartphone
	
	
Konfiguration von Processing
============================
Um WIP aufrufen zu können muss noch einiges hinzugefügt werden:
- Zur Kommunikation mit dem Android-Gerät muss Processing for Android integriert sein (http://android.processing.org/install.html)
- Außerdem müssen die Ketai- und oscP5-Libraries hinzugefügt werden (https://github.com/processing/processing/wiki/How-to-Install-a-Contributed-Library)


Konfiguration der Anwendung
===========================
- Rufen Sie die Dateien WIP_Server_for_Compass/WIP_Server_for_Compass.pde sowie Compass/Compass.pde mit Processing auf.
- Achten Sie darauf, dass bei ersterer Datei in der oberen rechten Ecke "Java" ausgewählt ist, bei der Compass.pde muss "Android" ausgewählt sein.
- Finden Sie die IP-Adresse Ihres Smartphones heraus, die in den Geräteinformationen in den Einstellungen ihres Gerätes zu finden sein muss.
	- Springen Sie nun zu Zeile 12 der WIP_Server_for_Compass.pde und korrigieren Sie die angegebene IP-Adresse zu ihrer eigenen.
	(String remoteIP = "Ihre IP-Adresse";)
- Finden Sie die IP-Adresse Ihres PCs heraus. (Anleitung für Windows-Systeme: http://www.tippscout.de/ip-adresse-ermitteln_tipp_2676.html)
	- Springen Sie nun zu Zeile 13 der Compass.pde und korrigieren Sie die angegebene IP-Adresse zu ihrer eigenen.
	(String remoteIP = "Ihre IP-Adresse";)
- Aktivieren Sie "USB-Debugging" in den Entwickleroptionen auf Ihrem Smartphone.
Unter Umständen müssen diese noch aktiviert werden, sollten diese nicht als Unterpunkt in den Einstellung des Gerätes auftauchen, folgen Sie bitte dieser Anleitung zur Aktivierung der Entwickleroptionen: http://www.greenbot.com/article/2457986/how-to-enable-developer-options-on-your-android-phone-or-tablet.html
- Schließen Sie das Smartphone nun an Ihren PC an und starten Sie sowohl die Compass.pde als auch die WIP_Server_for_Compass.pde mit einem Klick auf den runden Play-Button ("Run on device").
- Achten Sie darauf, dass Ihr Smartphone entsperrt ist und warten Sie, bis die Anwendung am PC und dem Mobiltelefon gestartet ist.


Die Anwendung nutzen
====================
- Sobald die Anwendung bei PC und Smartphone gestartet ist, können Sie beginnen, die Anwendung zu nutzen.
- Zuerst kann in dem Hauptmenü am PC gewählt werden, welcher Steuerungsmodus genutzt werden möchte:
	- Smartphone in der Tasche
		Bei dieser Navigationsmethode können Sie das Smartphone (mit angeschaltetem Bildschirm) in die vordere Hosentasche stecken.
	- Smartphone in der Hand
		Bei dieser Navigationsmethode halten Sie das Smartphone in der Hand. Das hat den Vorteil, dass Sie - sollten sie die Europa-Karte
		nutzen - die gesuchte Sehenswürdigkeit jederzeit im Auge behalten. Wichtig ist hier, dass Sie auch Ihre Arme beim Gehen mitbewegen.
- Wählen Sie nun oben eine Karte aus.
- Folgen Sie den Anweisungen der PC-Anwendung. Zur Kalibrierung nutzen Sie den roten "Kalibrieren"-Button, der sich bei Erfolg grün färbt.
- Nun sollten Sie Walking In Place nutzen können. Beachten Sie, dass Sie auf dem Smartphone jederzeit die Bewegung stoppen oder die Aufgaben sowie Position zurücksetzen können (sollten Sie sich verlaufen haben).

Entwickelt von
==============
Björn Filter
Jonas Lamperti
Marcus Muttersbach
Arne Schrade
Steffen Wolter



 
