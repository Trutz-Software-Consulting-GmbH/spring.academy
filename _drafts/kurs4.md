---
layout: post
title: Kurs 4
---
Eine schnelle Einführung in Docker und Kubernetes für Entwickler. Der Fokus liegt auf Kubernetes, wir fangen aber mit einer kurzen Einführung in Docker.

## Die Entwicklungsumgebung

Das Ziel dieses ersten Abschnitts ist das Tooling für den kompletten Kurs aufzubauen. Ich arbeite mit OSX als Betriebsystem. OSX ist aber nicht entscheidend, Linux und Windows funktionieren genauso gut. Ich setze voraus, dass du Java, Maven, Eclipse und Git kennst.

Den Quellcode das kompletten Kurses findest in GitHub du unter [https://github.com/Trutz-Software-Consulting-GmbH/kurs4](https://github.com/Trutz-Software-Consulting-GmbH/kurs4).

Am Ende des Abschnitts wirst du:

- eine Entwicklungsumgebung mit dem neuesten Eclipse und OpenJDK 13 und
- ein leeres Spring Boot Projekt mit Java 13

haben. Damit hast du die Grundlage für die weiteren Abschnitte des Kurses gelegt.

### OpenJDK 13 und Eclipse Installation

Wir legen *from scratch* los und starten mit der Installation einer Entwicklungsumgebung. Es ist eine gute Idee eine definierte Umgebung für diesen Kurs zu haben. Lade deshalb das *OpenJDK 13* und die *Eclipse IDE for Java Developers* unter den folgenden Links herunter:

- [https://jdk.java.net/13/](https://jdk.java.net/13/)
- [https://www.eclipse.org/downloads/packages/](https://www.eclipse.org/downloads/packages/)

und installiere sie wie in dem unteren Video:

{% video openjdk-eclipse-installation OpenJDK 13 und Eclipse Installation %}

Beachte bitte, dass du die `[ECLIPSE_INSTALLATION]/eclipse.ini` Datei anpassen musst, damit Eclipse das heruntergeladene OpenJDK 13 verwendet. Füge deshalb die folgenden zwei Zeilen

```
  --vm
  ../../../jdk-13/Contents/Home/bin/java
```

in die `eclipse.ini` Datei ein. Dann startet Eclipse mit dem vorhin installierten OpenJDK. Unter Windows und Linux sind die Zwischenverzeichnisse `Contents/Home` nicht da. Wenn du den Pfad zur Java VM in der `eclipse.ini` wie oben relativ angibst, dann kannst du die Eclipse und OpenJDK 13 Installationen zusammen an einer anderen Stelle in deinem Verzeichnisbaum kopieren.

### Das Spring Boot Projekt

Lege ein neues Maven Projekt in dem frisch heruntergeladenen Eclipse an. Aus diesem leeren Maven Projekt machst du ein Spring Boot Projekt indem du folgenden `spring-boot-starter` [Parent](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html) in der `pom.xml` einträgst:

```xml
  <parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.2.4.RELEASE</version>
  </parent>
```

In dem unteren Video zeige ich dir, wie du in Eclipse ein neues Spring Boot Projekt anlegst und es auf Java 13 einstellst. Das vorhin heruntergeladene OpenJDK 13 wird dabei natürlich verwendet.

{% video spring-boot-projekt Das Spring Boot Projekt %}

Die Spring Boot Version `2.2.4.RELEASE` ist Ende Februar 2020 die aktuellste. Die jeweils aktuellste Spring Boot Version findest du in dem Maven Central Repository [https://search.maven.org/](https://search.maven.org/). Suche in diesem Repository nach `g:org.springframework.boot a:spring-boot-starter-parent`. Nachdem du den `spring-boot-starter-parent` in die `pom.xml` eingetragen hast, vergiss bitte nicht in Eclipse das Maven Projekt zu aktualisieren.

Spring Boot verwendet standardmäßig Java 8. Durch das Setzen des Maven Property `java.version` in der `pom.xml`, kann das gesammte Projekt auf Java 13 umgestellt werden:

```xml
  <properties>
    <java.version>13</java.version>
  </properties>
```

Das Property `java.version` wird im Spring Boot Parent ausgelesen um das [Maven Compiler Plugin](https://maven.apache.org/plugins/maven-compiler-plugin/) auf die entsprechende Java Version zu konfigurieren. In Eclipse wird die Maven Konfiguration verwendet um das Eclipse Projekt entsprechend auf Java 13 zu konfigurieren.

Ein leeres Spring Boot Projekt kannst du auch über das Tool Spring Initializr [https://start.spring.io/](https://start.spring.io/) anlegen. Du verwendest Spring Initializr entweder
- direkt auf der Webseite [https://start.spring.io/](https://start.spring.io/)  oder
- du installierst dir das Spring Initializr Plugin in Eclipse/IntelliJ/Visual Code oder
- du installiest und verwendest das [Spring Boot CLI](https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-cli.html#cli-init) Tool in der Konsole.

### Das GitHub Projekt

Es ist nun ein guter Zeitpunkt unser Projekt in GitHub hochzuladen. In dem unteren Video lege ich in GitHub ein neues Projekt an:

{% video github-projekt Das GitHub Projekt %}

Dabei zeige ich dir, wie du einen [RSA](https://de.wikipedia.org/wiki/RSA-Kryptosystem) Schlüssel mit [OpenSSL](https://de.wikipedia.org/wiki/OpenSSL) erzeugst und verwendest. Es geht dabei um die Authentifizierung an GitHub ohne Anmeldung (Benutzername und Passwort). Sowohl in Eclipse als auch in der Konsole.

Du findest das Projekt in GitHub unter [https://github.com/Trutz-Software-Consulting-GmbH/kurs4](https://github.com/Trutz-Software-Consulting-GmbH/kurs4).

### Was ist REST?

...

### Der minimale REST Controller

In dieser Lektion möchte ich einen minimalen REST Service mit Spring Boot aufbauen. Die zentrale Java Klasse dabei ist der sogenannte **REST Controller**.

Ein REST Controller ist:
- eine mit `@RESTController` annotierte Java Klasse, die
- Methoden hat, die mit `@GetMapping`, `@PostMapping`, `@PutMapping` oder `@DeleteMapping` annotiert sind.

Die Methodenannotationen entsprechen dabei den [HTTP-Anfragemethoden](https://de.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP-Anfragemethoden) `GET`, `POST`, `PUT` und `DELETE`.

Ein minimaler REST Controller sieht wie folgt aus:
```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OkController {

  @GetMapping("/sayok")
  String sayok() {
    return "ok";
  }

}
```

Die obige `@GetMapping` Annotation sagt aus, dass bei einer HTTP Anfrage
```console
  GET /sayok HTTP/1.1
```
die Methode
```java
  String sayok() {
    return "ok";
  }
```
ausgeführt wird. Der Rückgabewert der Methode `sayok` wird in der HTTP Antwort
```console
  HTTP/1.1 200
  Content-Type: text/plain;charset=UTF-8
  Content-Length: 2

  ok
```
zurückgeliefert.
