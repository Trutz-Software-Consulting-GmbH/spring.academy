---
layout: post
title: REST Controller
---

Lerne in 10 Minuten, wie du from scratch einen minimalen REST Service baust und erstelle dabei einen Spring Boot `@RestController`.

## Screencast

{% video rest-controller-hb REST Service mit Spring Boot in 10 Minuten %}

## Der minimale REST Controller

Die zentralle Java Klasse eines REST Webservices in Spring Boot ist der sogenannte **REST Controller**. Er nimmt die HTTP Anfragen entgegen und verarbeitet sie.

Ein REST Controller ist

-   eine mit `@RESTController` annotierte Java Klasse, die
-   Methoden hat, die mit `@GetMapping`, `@PostMapping`, `@PutMapping` oder `@DeleteMapping` annotiert sind.

Die Methodenannotationen entsprechen dabei den [HTTP-Anfragemethoden](https://de.wikipedia.org/wiki/Hypertext_Transfer_Protocol#HTTP-Anfragemethoden) `GET`, `POST`, `PUT` und `DELETE`.

Ein minimaler REST Controller sieht wie folgt aus:

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class OkController {

  @GetMapping("/sayok")
  String sayok() {
    return "ok";
  }

}
```

Die obige `@GetMapping` Annotation bewirkt, dass bei einer HTTP Anfrage

```console
GET /sayok HTTP/1.1
```

die Methode

```java
String sayok() {
  return "ok";
}
```

ausgeführt wird und der Rückgabewert der Methode `sayok()` über die HTTP Antwort

```console
HTTP/1.1 200
Content-Type: text/plain;charset=UTF-8
Content-Length: 2

ok
```

zurückgeliefert wird.

Die Zuordnung des HTTP GET Requests auf die mit `@GetMapping` annotierte Methode `sayok()` übernimmt das Spring Boot Framework. Du als Entwickler kannst dich vollständig auf die Implementierung der Methode `sayok()` konzentrieren 😉.

## Maven Dependency

Damit du den obigen trivialen REST Service in Spring Boot ausprobieren kannst, benötigst du in deiner `pom.xml` folgende Dependency

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

wobei in deiner `pom.xml` natürlich `spring-boot-starter-parent` als Parent stehen muss.

## curl und Postman

Wenn du jetzt die Spring Boot Anwendung startest und im Browser die URL <http://localhost:8080/sayok> aufrufst, dann erhältst du im Browser wie erwartet den String `ok`. In diesem Fall fungiert der Browser als REST Client.

Ein weiterer sehr nützlicher REST Client ist das Kommandozeilentool [`curl`](https://curl.haxx.se/). Mit dem Befehl

```shell
curl http://localhost:8080/sayok
```

kannst du deinen Spring Boot Webservice aufrufen.

Mit `curl` kannst du auch die Kommunikation zwischen Client und Server mitverfolgen. Verwende einfach `-v` als zusätzlichen Parameter

```shell
curl -v localhost:8080/sayok
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> GET /sayok HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 200
< Content-Type: text/plain;charset=UTF-8
< Content-Length: 2
< Date: Thu, 19 Mar 2020 01:54:02 GMT
<
* Connection #0 to host localhost left intact
ok* Closing connection 0
```

dann siehst du mit

-   `>` markiert den Request HTTP Header und mit
-   `<` markiert den Response HTTP Header.

Möchtest du eine Anwendung als REST Client verwenden, dann ist [Postman](https://www.postman.com/) die erste Wahl. Sowohl `curl`als auch Postman sind sehr ausgereifte Produkte, die ich dir empfehlen möchte.

## Weitere Schritte

Ich habe mit dem obigen trivialen REST Service lediglich die Oberfläche der REST Welt angekratzt. Mit Spring Boot kannst du natürlich professionelle REST Anwendungen und Microservices aufbauen. Weiterführende Themen aus diesem Bereich sind

-   [die Spring Boot Dokumentation](https://spring.io/guides/gs/rest-service/)
-   [Spring HATEOAS](https://spring.io/projects/spring-hateoas)
-   [Open API](https://www.openapis.org/) über [Swagger](https://swagger.io/)

und vieles mehr.
Schöne Themen für weitere Tutorials ...

## Quellcode

Den kompletten Quellcode dieses Tutorials findest du in GitHub unter <https://github.com/Trutz-Software-Consulting-GmbH/rest-controller>.
