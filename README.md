# Terraform Drei-Schichten-Architektur-Projekt

## Übersicht

*Dieses Projekt implementiert eine Drei-Schichten-Architektur in Azure unter Verwendung von Terraform. Die Infrastruktur besteht aus einem Frontend, einem Backend und einer Datenbankschicht, die alle in Container-Instanzen laufen und über ein Load Balancer verbunden sind.*

## Projektstruktur

*Dieser Abschnitt erklärt den Aufbau der Infrastruktur und der Terraform-Module.*

- **Netzwerkarchitektur**:
  - **Virtuelles Netzwerk (VNet)**: Alle Subnetze (Frontend, Backend und Datenbank) sind in einem virtuellen Netzwerk organisiert, um eine sichere Kommunikation zwischen den Schichten zu ermöglichen.
  - **Subnetze**:
    - *Frontend-Subnet*: Beinhaltet die Container-Gruppe für den NGINX-Proxy.
    - *Backend-Subnet*: Beinhaltet die Container-Gruppe für die Anwendungslogik (HTML/PHP).
    - *Datenbank-Subnet*: Beinhaltet die PostgreSQL-Container-Gruppe.
  - **Netzwerksicherheitsgruppen (NSG)**: Regelt den Datenverkehr zwischen den Subnetzen. Zugelassene Verbindungen:
    - *Frontend*: HTTP (Port 80) und HTTPS (Port 443) für Webanfragen.
    - *Backend*: Port 8082 für Anfragen vom Frontend.
    - *Datenbank*: Port 5432 für PostgreSQL-Verbindungen.

- **Load Balancer**:
  - Der Azure Load Balancer verteilt den eingehenden HTTP(S)-Verkehr auf die NGINX-Container-Gruppe im Frontend. Der Load Balancer bietet Hochverfügbarkeit und leitet den Traffic von Port 443 an das Frontend weiter.

- **Container-Gruppen**:
  - **Frontend**: NGINX Reverse Proxy, der Anfragen von Benutzern entgegennimmt und an das Backend weiterleitet.
  - **Backend**: HTML/PHP-Container, der die Anwendungslogik verarbeitet und mit der Datenbank kommuniziert.
  - **Datenbank**: PostgreSQL-Container, der Anfragen auf Port 5432 vom Backend verarbeitet.

- **Speichermodul**:
  - **Terraform-State-Speicher**: Der Terraform-State wird in einem Azure Storage Account gespeichert, um Versionskontrolle und Zusammenarbeit zu ermöglichen.
  - **Datenbank-Backup-Speicher**: Ein separater Azure Storage Account wird für die Sicherung der PostgreSQL-Datenbank genutzt, um Daten persistent und unabhängig vom Lebenszyklus der Container zu speichern.

## Nutzungsvoraussetzungen

1. **Azure-Subscription und Terraform-Installation**:
   - Für die Bereitstellung der Infrastruktur wird eine Azure-Subscription benötigt. Zudem muss Terraform lokal installiert und konfiguriert sein.

2. **Kenntnisse in Docker und Container-Management**:
   - Da die gesamte Anwendung in Docker-Containern läuft, die in einer privaten Container-Registry hinterlegt sind, ist ein grundlegendes Verständnis von Docker notwendig. Alle Docker-Images wurden von dir vorkonfiguriert und müssen bei Bedarf an die spezifischen Anforderungen angepasst werden.
   - Änderungen an der Applikation (Frontend, Backend, Datenbank) sind durch den Einsatz von Docker einfach umzusetzen, da Anpassungen an den Images meist keine umfangreichen Änderungen im Terraform-Code erfordern. Ein Update des Images in der Registry und minimaler Terraform-Aufwand genügen oft, um die Änderungen produktiv zu nehmen.

3. **Vorteil der vorkonfigurierten Container-Images**:
   - Die vorkonfigurierten Container-Images ermöglichen es, Änderungen an den einzelnen Komponenten (Frontend, Backend, Datenbank) isoliert und unabhängig durchzuführen. Durch diese Struktur können tiefgehende Änderungen vorgenommen werden, ohne die gesamte Infrastruktur anzupassen. Sobald die Container-Images aktualisiert sind, erfordert die Infrastruktur nur eine minimale Aktualisierung über Terraform.

## Nutzung

### Einrichtung des Projekts

*Hier wird Schritt für Schritt beschrieben, wie man das Repository klont, Terraform initialisiert, Variablen anpasst und die Infrastruktur bereitstellt.*

Beispielschritte:

1. Klone das Repository:
    ```bash
    git clone <repository-url>
    cd <repository-folder>
    ```

2. Initialisiere Terraform:
    ```bash
    terraform init
    ```

3. Passe die Konfigurationswerte an:
    ```bash
    # Beispielbefehl zum Bearbeiten von terraform.tfvars
    terraform apply
    ```

## Konfiguration und Anpassung

*In diesem Abschnitt wird erklärt, wie Benutzer die Infrastruktur durch Änderungen an bestimmten Terraform-Variablen konfigurieren und anpassen können. Hier werden Platzhalter für die Erklärung der Variablen eingefügt (z. B. `frontend_image`, `backend_image` usw.).*

## Update-Prozess

*In diesem Abschnitt wird der Prozess zum Aktualisieren der Anwendung und der Infrastruktur beschrieben. Dieser Teil ersetzt den Abschnitt "Testing".*

- **Anwendungsupdate**: *Anleitung, wie Docker-Images aktualisiert, in die Container-Registry geladen und die Terraform-Konfiguration angepasst wird.*
- **Infrastrukturupdate**: *Schritte zur Änderung der Infrastrukturressourcen und deren erneuter Bereitstellung mit Terraform.*

## Aufräumen

*Dieser Abschnitt erklärt, wie die Infrastruktur nach der Nutzung entfernt werden kann, um unnötige Kosten zu vermeiden.*

```bash
terraform destroy
