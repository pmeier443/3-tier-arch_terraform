Terraform 3-Tier Architecture Web App
Übersicht
Eine Einführung in das Projekt, einschließlich einer Beschreibung der Ziele und einer kurzen Erklärung der Drei-Schichten-Architektur.

Projektstruktur
Dieser Abschnitt erklärt den Aufbau des Terraform-Projekts. Hier wird beschrieben, wie das Projekt organisiert ist und welche Module enthalten sind:

Netzwerkmodul: Erstellt das virtuelle Netzwerk und die Subnetze für jede Schicht (Frontend, Backend, Datenbank).
Speichermodul:
Terraform-State-Speicher: Speichert den Terraform-State für Versionsverwaltung und Teamarbeit.
Datenbank-Backup-Speicher: Sichert die Container-Instanz der PostgreSQL-Datenbank.
Frontend-Modul: Stellt das Frontend (Speedtest Web-App) als Container-Instanz bereit.
Backend-Modul: Bereitstellung der Geschäftslogik, die Anfragen vom Frontend verarbeitet, ebenfalls in einer Container-Instanz.
Datenbank-Modul: Stellt die PostgreSQL-Datenbank in einer Container-Instanz bereit und sichert sie in einem separaten Speicher.
Nutzung
Konfiguration und Anpassung
Hier werden die verschiedenen Konfigurationsmöglichkeiten erläutert, die über Terraform-Variablen gesteuert werden können. Folgende Punkte sind besonders hervorzuheben:

Docker-Images: Die Benutzer können ihre eigenen Docker-Images für Frontend, Backend und Datenbank angeben.
Backend-Variablen: Konfiguration von Port, Datenbanktyp und Backend-Image.
Datenbank-Zugangsdaten: Variablen zur Anpassung des Datenbankbenutzernamens, Passworts und Datenbanknamens.
Datenbank-Speicher: Speicherpfad für die Datenbankdaten, der auch für Backups genutzt wird.
Subnetze: Das Netzwerk wird über intern vordefinierte Subnetze bereitgestellt.
Bereitstellung der Infrastruktur
Nachdem du die gewünschten Anpassungen vorgenommen hast, kannst du mit den folgenden Terraform-Befehlen die Infrastruktur bereitstellen. Du hast dabei die Möglichkeit, entweder das gesamte Projekt oder nur spezifische Module zu planen und anzuwenden.

Terraform initialisieren: Dieser Schritt lädt die benötigten Provider und Module, um das Projekt vorzubereiten.

```bash terraform init ```

Komplette Infrastruktur planen und anwenden: Wenn du die gesamte Infrastruktur (alle Module) planen und bereitstellen möchtest, kannst du den normalen Plan- und Anwendungsprozess durchführen:

Plan erstellen: ```bash terraform plan ```

Änderungen anwenden: ```bash terraform apply ```

Nachdem der apply-Prozess abgeschlossen ist, wird Terraform im Output sowohl die IP-Adresse als auch den Hostname der Web-Applikation anzeigen, unter der das Frontend erreichbar ist. Diese Informationen können dann verwendet werden, um auf die bereitgestellte Applikation zuzugreifen.

Nur spezifisches Modul planen und anwenden: Wenn du nur ein spezifisches Modul (z. B. das Frontend) planen und anwenden möchtest, kannst du mit -target das Zielmodul angeben.

Beispiel: Plan und Anwendung nur für das Frontend-Modul:

Plan erstellen: ```bash terraform plan -target=module.frontend ```

Änderungen anwenden: ```bash terraform apply -target=module.frontend ```

Dies ist besonders nützlich, wenn du nur eine bestimmte Schicht der Infrastruktur anpassen oder aktualisieren möchtest, ohne die gesamte Infrastruktur erneut bereitstellen zu müssen.

Weitere Beispiele für Modul-spezifische Befehle:

Backend-Modul planen und anwenden: ```bash terraform plan -target=module.backend terraform apply -target=module.backend ```

Datenbank-Modul planen und anwenden: ```bash terraform plan -target=module.database terraform apply -target=module.database ```

Update der Applikation
Wenn du den Frontend-Container updaten möchtest, beispielsweise um eine neue NGINX-Version einzusetzen, kannst du den Prozess in wenigen Schritten durchführen. Im Folgenden wird ein Beispiel für ein solches Update gezeigt:

Neuen Container bauen und in der Registry bereitstellen:

Stelle sicher, dass du einen neuen Docker-Container mit der gewünschten NGINX-Version baust und in der Container-Registry bereitstellst. Hier ein Beispiel, wie du eine neuere NGINX-Version baust und hochlädst:
```bash docker build -t mein-repo.azurecr.io/nginx
.19 . docker push mein-repo.azurecr.io/nginx
.19 ```

Wichtig:

Wenn du bereits ein funktionierendes Dockerfile für den NGINX-Container hast, das alle wichtigen Konfigurationsdateien und Umgebungsvariablen beinhaltet, musst du beim Update nicht alles neu erstellen. Du kannst einfach das Base-Image (zum Beispiel die NGINX-Version) ändern, während die restliche Konfiguration bestehen bleibt. Das spart viel Zeit, da du nur das NGINX-Image austauschst und keine weiteren Anpassungen an den Konfigurationsdateien oder den Umgebungsvariablen machen musst.

Überprüfe dennoch, dass alle Variablen, die du mit Terraform übergibst, auch im Container korrekt ankommen. Das gilt insbesondere für dynamische Werte wie Ports, Hostnamen oder Zugangsdaten, die in den Konfigurationsdateien verwendet werden. Die Umgebungsvariablen müssen im Dockerfile oder in den entsprechenden Konfigurationsdateien wie gewohnt verwendet werden.

Beispiel: Falls der NGINX-Container eine Konfigurationsdatei (z. B. nginx.conf) verwendet, stelle sicher, dass die durch Terraform übergebenen Variablen, wie z. B. der Port oder der Hostname, korrekt durch Umgebungsvariablen oder andere Mechanismen in die Konfigurationsdatei eingefügt werden:

```bash ENV NGINX_PORT=${backend_port} ```

Dies stellt sicher, dass Änderungen, die du im Terraform-Code vornimmst, auch korrekt in der Konfiguration des Containers ankommen.

Terraform-Code anpassen: Nachdem der neue Container bereitgestellt wurde, musst du den Terraform-Code anpassen, um auf die neue Version des Containers zu verweisen. In diesem Fall sind es die folgenden Variablen, die du ändern musst:

frontend_image: Passe die Variable an, um das neue NGINX-Image zu referenzieren.
Beispiel: ```hcl variable "frontend_image" { default = "mein-repo.azurecr.io/nginx
.19" } ```

Änderungen anwenden: Nachdem du die Änderungen im Terraform-Code vorgenommen hast, kannst du den Plan und die Anwendung erneut durchführen, um den neuen Container zu verwenden:

Plan erstellen: ```bash terraform plan ```

Änderungen anwenden: ```bash terraform apply ```

Aufräumen
Dieser Abschnitt erklärt, wie die Infrastruktur nach der Nutzung entfernt werden kann, um unnötige Kosten zu vermeiden.

```bash terraform destroy ```
