# Terraform Drei-Schichten-Architektur-Projekt

## Übersicht

*In diesem Abschnitt wird eine Einführung in das Projekt gegeben, einschließlich einer Beschreibung der Ziele, einer kurzen Erklärung der Drei-Schichten-Architektur und einer allgemeinen Übersicht über die Infrastruktur.*

## Projektstruktur

*Dieser Abschnitt erklärt den Aufbau des Terraform-Projekts. Es wird beschrieben, wie das Projekt organisiert ist, welche Ordner und Module es gibt und wie diese zusammenarbeiten.*

- **Netzwerkmodul**: *Dieses Modul definiert das virtuelle Netzwerk und die Subnetze für jede Schicht (Frontend, Backend, Datenbank).*

- **Speichermodul**: *Hier gibt es zwei Speicherkomponenten:*
  1. **Terraform-State-Speicher**: *Dieser Speicher wird verwendet, um den Terraform-State sicher abzulegen und Versionsverwaltung sowie Teamarbeit zu ermöglichen.*
  2. **Datenbank-Backup-Speicher**: *Dieser Speicher dient zur Sicherung der Container-Instanz, die die PostgreSQL-Datenbank hostet. Dies stellt sicher, dass Daten regelmäßig gesichert werden und bei Bedarf wiederhergestellt werden können.*

- **Frontend-Modul**: *Das Modul stellt die Frontend-Komponente (Speedtest Web-App) bereit, die in einer Container-Instanz läuft und in das Netzwerk integriert ist.*

- **Backend-Modul**: *Das Modul stellt die Geschäftslogik bereit, die Anfragen vom Frontend verarbeitet und die Kommunikation mit der Datenbank sicherstellt. Auch diese Schicht läuft in einer Container-Instanz.*

- **Datenbank-Modul**: *Dieses Modul sorgt für die Bereitstellung der Datenbank in einer Container-Instanz (PostgreSQL) sowie deren Integration in das Netzwerk und die Speicherung der Backups im separaten Speicher.*

## Nutzungsvoraussetzungen

Für die Nutzung dieses Projekts sind die folgenden Voraussetzungen notwendig:

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
