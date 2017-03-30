	======================
	WIP - Walking In Place
	======================
	
	
�ber WIP
========
WIP erm�glicht Kindern eine aufregende neuartige Navigation �ber geographische Karten. Die Sch�ler m�ssen lediglich Schrittbewegungen (m�glichst ohne Vorw�rtsbewegung) in eine bestimmte Richtung vornehmen, um so beispielsweise eine Europa- oder Deutschlandkarte zu erkunden. Des weiteren k�nnen in Europa einige Navigationsaufgaben absolviert werden, die das Wissen �ber bestimmte Sehensw�rdigkeiten abfragen.


F�r WIP ben�tigt
================
- Android-Smartphone + Datenkabel
- Processing 3.3 (https://processing.org/download/?processing)
	- Processing for Android
	- Ketai Library
	- oscP5 Library
- PC im gleichen Netzwerk wie das Smartphone
	
	
Konfiguration von Processing
============================
Um WIP aufrufen zu k�nnen muss noch einiges hinzugef�gt werden:
- Zur Kommunikation mit dem Android-Ger�t muss Processing for Android integriert sein (http://android.processing.org/install.html)
- Au�erdem m�ssen die Ketai- und oscP5-Libraries hinzugef�gt werden (https://github.com/processing/processing/wiki/How-to-Install-a-Contributed-Library)


Konfiguration der Anwendung
===========================
- Rufen Sie die Dateien WIP_Server_for_Compass/WIP_Server_for_Compass.pde sowie Compass/Compass.pde mit Processing auf.
- Achten Sie darauf, dass bei ersterer Datei in der oberen rechten Ecke "Java" ausgew�hlt ist, bei der Compass.pde muss "Android" ausgew�hlt sein.
- Finden Sie die IP-Adresse Ihres Smartphones heraus, die in den Ger�teinformationen in den Einstellungen ihres Ger�tes zu finden sein muss.
	- Springen Sie nun zu Zeile 12 der WIP_Server_for_Compass.pde und korrigieren Sie die angegebene IP-Adresse zu ihrer eigenen.
	(String remoteIP = "Ihre IP-Adresse";)
- Finden Sie die IP-Adresse Ihres PCs heraus. (Anleitung f�r Windows-Systeme: http://www.tippscout.de/ip-adresse-ermitteln_tipp_2676.html)
	- Springen Sie nun zu Zeile 13 der Compass.pde und korrigieren Sie die angegebene IP-Adresse zu ihrer eigenen.
	(String remoteIP = "Ihre IP-Adresse";)
- Aktivieren Sie "USB-Debugging" in den Entwickleroptionen auf Ihrem Smartphone.
Unter Umst�nden m�ssen diese noch aktiviert werden, sollten diese nicht als Unterpunkt in den Einstellung des Ger�tes auftauchen, folgen Sie bitte dieser Anleitung zur Aktivierung der Entwickleroptionen: http://www.greenbot.com/article/2457986/how-to-enable-developer-options-on-your-android-phone-or-tablet.html
- Schlie�en Sie das Smartphone nun an Ihren PC an und starten Sie sowohl die Compass.pde als auch die WIP_Server_for_Compass.pde mit einem Klick auf den runden Play-Button ("Run on device").
- Achten Sie darauf, dass Ihr Smartphone entsperrt ist und warten Sie, bis die Anwendung am PC und dem Mobiltelefon gestartet ist.


Die Anwendung nutzen
====================
- Sobald die Anwendung bei PC und Smartphone gestartet ist, k�nnen Sie beginnen, die Anwendung zu nutzen.
- Zuerst kann in dem Hauptmen� am PC gew�hlt werden, welcher Steuerungsmodus genutzt werden m�chte:
	- Smartphone in der Tasche
		Bei dieser Navigationsmethode k�nnen Sie das Smartphone (mit angeschaltetem Bildschirm) in die vordere Hosentasche stecken.
	- Smartphone in der Hand
		Bei dieser Navigationsmethode halten Sie das Smartphone in der Hand. Das hat den Vorteil, dass Sie - sollten sie die Europa-Karte
		nutzen - die gesuchte Sehensw�rdigkeit jederzeit im Auge behalten. Wichtig ist hier, dass Sie auch Ihre Arme beim Gehen mitbewegen.
- W�hlen Sie nun oben eine Karte aus.
- Folgen Sie den Anweisungen der PC-Anwendung. Zur Kalibrierung nutzen Sie den roten "Kalibrieren"-Button, der sich bei Erfolg gr�n f�rbt.
- Nun sollten Sie Walking In Place nutzen k�nnen. Beachten Sie, dass Sie auf dem Smartphone jederzeit die Bewegung stoppen oder die Aufgaben sowie Position zur�cksetzen k�nnen (sollten Sie sich verlaufen haben).

Entwickelt von
==============
Bj�rn Filter
Jonas Lamperti
Marcus Muttersbach
Arne Schrade
Steffen Wolter



 
