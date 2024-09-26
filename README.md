Terraform 3-Tier Architecture Web App
Übersicht
In diesem Abschnitt wird eine Einführung in das Projekt gegeben, einschließlich einer Beschreibung der Ziele, einer kurzen Erklärung der Drei-Schichten-Architektur und einer allgemeinen Übersicht über die Infrastruktur.

Projektstruktur
Dieser Abschnitt erklärt den Aufbau des Terraform-Projekts. Es wird beschrieben, wie das Projekt organisiert ist, welche Ordner und Module es gibt und wie diese zusammenarbeiten.

Netzwerkmodul: Dieses Modul definiert das virtuelle Netzwerk und die Subnetze für jede Schicht (Frontend, Backend, Datenbank).

Speichermodul: Hier gibt es zwei Speicherkomponenten:

Terraform-State-Speicher: Dieser Speicher wird verwendet, um den Terraform-State sicher abzulegen und Versionsverwaltung sowie Teamarbeit zu ermöglichen.
Datenbank-Backup-Speicher: Dieser Speicher dient zur Sicherung der Container-Instanz, die die PostgreSQL-Datenbank hostet. Dies stellt sicher, dass Daten regelmäßig gesichert werden und bei Bedarf wiederhergestellt werden können.
Frontend-Modul: Das Modul stellt die Frontend-Komponente (Speedtest Web-App) bereit, die in einer Container-Instanz läuft und in das Netzwerk integriert ist.

Backend-Modul: Das Modul stellt die Geschäftslogik bereit, die Anfragen vom Frontend verarbeitet und die Kommunikation mit der Datenbank sicherstellt. Auch diese Schicht läuft in einer Container-Instanz.

Datenbank-Modul: Dieses Modul sorgt für die Bereitstellung der Datenbank in einer Container-Instanz (PostgreSQL) sowie deren Integration in das Netzwerk und die Speicherung der Backups im separaten Speicher.

Nutzung
Konfiguration und Anpassung
Bevor die Infrastruktur bereitgestellt wird, kannst du verschiedene Parameter im Code über Variablen anpassen, um die Bereitstellung nach deinen Anforderungen zu konfigurieren. Dies ermöglicht dir eine flexible Anpassung der Infrastruktur ohne tief in den Terraform-Code eingreifen zu müssen.

Anpassungsmöglichkeiten:
Docker-Images:

Für die Bereitstellung der Frontend-, Backend- und Datenbank-Komponenten kannst du eigene Docker-Images verwenden. Dies ist besonders nützlich, wenn du Anpassungen an der Anwendung vornehmen möchtest, ohne den Terraform-Code zu ändern. Wenn du deine eigenen Docker-Images aus einer privaten Registry verwenden möchtest, sind folgende Variablen zu konfigurieren:
frontend_image, backend_image, database_image: Die Images für die jeweiligen Komponenten (Frontend, Backend, Datenbank).
image_registry_server: Die URL deiner privaten Container-Registry.
image_registry_username: Dein Benutzername für die Registry.
image_registry_password: Das Passwort für den Zugriff auf die Container-Registry.
Beispiel:

hcl
Code kopieren
frontend_image         = "mein-repo.azurecr.io/mein-frontend-image:v1.2"
backend_image          = "mein-repo.azurecr.io/mein-backend-image:v1.2"
database_image         = "mein-repo.azurecr.io/mein-db-image:v1.2"
image_registry_server  = "mein-repo.azurecr.io"
image_registry_username = "mein-username"
image_registry_password = "mein-passwort"
Backend-Variablen:

Das Backend hat verschiedene konfigurierbare Variablen, die für die Verbindung zum Frontend und zur Datenbank relevant sind:

Backend-Port (backend_port): Dieser definiert, auf welchem Port das Backend vom Frontend aus erreichbar ist.

Beispiel:

hcl
Code kopieren
backend_port = "8080"
Datenbanktyp (database_type): Der Typ der Datenbank, mit der sich das Backend verbindet (z. B. PostgreSQL, MySQL). Dieser Wert ist entscheidend, um sicherzustellen, dass die Verbindung zur richtigen Datenbankart hergestellt wird.

Beispiel:

hcl
Code kopieren
database_type = "postgresql"
Backend-Image (backend_image): Das Docker-Image, das das Backend enthält. Änderungen am Backend können durch Aktualisieren dieses Images vorgenommen werden.

Beispiel:

hcl
Code kopieren
backend_image = "mein-repo.azurecr.io/mein-backend-image:v1.2"
Datenbank-Zugangsdaten:

Der Benutzername, das Passwort und der Datenbankname für die PostgreSQL-Datenbank können über Variablen angepasst werden. Diese Zugangsdaten werden sowohl für die Bereitstellung der Datenbank als auch dem Backend-Container bereitgestellt, um sicherzustellen, dass die Verbindung zur Datenbank reibungslos funktioniert.
Beispiel:

hcl
Code kopieren
database_user     = "mein-db-user"
database_password = "mein-db-passwort"
database_name     = "mein-db-name"
Datenbank-Speicher (database_data):

Die Variable database_data legt den Speicherort der Datenbankdaten auf dem Dateisystem des Containers fest. Dieser Pfad ist nicht nur für den Betrieb der Datenbank relevant, sondern auch für das Backup. Das Speicher-Modul der Infrastruktur bezieht sich auf dieses Verzeichnis, um von dort aus regelmäßige Backups der Datenbank zu erstellen und im Azure Blob Storage abzulegen. Dies stellt sicher, dass alle wichtigen Daten gesichert und bei Bedarf wiederhergestellt werden können.
Beispiel:

hcl
Code kopieren
database_data = "/var/lib/postgresql/data"
Subnetze:

Das Netzwerkmodul erstellt ein virtuelles Netzwerk mit drei Subnetzen: eines für die Frontend-Komponente, eines für das Backend und eines für die Datenbank. Diese Subnetze sind intern vordefiniert, und die IP-Adressen werden im Hintergrund verwaltet, sodass keine Anpassung von außen erforderlich ist.
Bereitstellung der Infrastruktur
Nachdem du die gewünschten Anpassungen vorgenommen hast, kannst du mit den folgenden Terraform-Befehlen die Infrastruktur bereitstellen:

Terraform initialisieren: Dieser Schritt lädt die benötigten Provider und Module, um das Projekt vorzubereiten.

bash
Code kopieren
terraform init
Plan erstellen: Erstelle einen Plan, um alle geplanten Änderungen an der Infrastruktur zu überprüfen, bevor du sie anwendest. Dies ist besonders hilfreich, um sicherzustellen, dass die Anpassungen korrekt sind.

bash
Code kopieren
terraform plan
Änderungen anwenden: Wende den Plan an und setze die Infrastruktur in Azure um.

bash
Code kopieren
terraform apply
Aufräumen
Dieser Abschnitt erklärt, wie die Infrastruktur nach der Nutzung entfernt werden kann, um unnötige Kosten zu vermeiden.

bash
Code kopieren
terraform destroy
Bekannte Probleme und Fehlerbehebung
In diesem Abschnitt werden häufig auftretende Probleme bei der Bereitstellung oder beim Update beschrieben und Lösungen angeboten.
