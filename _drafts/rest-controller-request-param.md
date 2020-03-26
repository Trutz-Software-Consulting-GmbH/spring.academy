---
layout: post
title: Request Parameter
---

Lerne wie du Parameter an REST Services in Spring Boot übergibst und verwende dabei die Annotation `@RequestParam`.

## Das minimale Beispiel

In dem [REST Controller Tutorial]({% post_url 2020-03-22-rest-controller %}) hast du gelernt, wie du einen minimalen REST Controller aufbaust. In diesem Tutorial gehe ich einen Schritt weiter und zeige ich dir, wie du Parameter an REST Services übergibst.

Ich starte wie immer mit einem minimalen Beispiel. Unten siehst du einen REST Controller mit einer trivialen Methode, die einen String als Input hat und die Länge des Strings zurückgibt.

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
class LengthController {

  @GetMapping("/length")
  int length(String input) {
    return input.length();
  }

}
```

Die obige Java Methode `length` wird aufgerufen, wenn der REST Client den HTTP GET Request mit dem Pfad `/length` aufruft. Wenn der REST Client also einen

```console
GET /length?input=test
```

Aufruf ausführt, dann antwortet, der `LengthController` mit der Zahl `4`, die der Länge des Strings `test` entspricht.

Spring Boot bildet **automatisch** die HTTP GET Query Parameter auf die Parameter der entsprechenden Java Methode ab. In meinem obigen Beispiel heißt das, dass der HTTP GET Query Parameter `input=test` automatisch als Parameter der Java Methode `length` übergeben wird. Wichtig dabei ist, dass der Name der HTTP Query Parameter mit den Namen der Java Variablen übereinstimmen müssen.

Zusammenfassend hast du also folgendes Mapping zwischen HTTP und Java

- HTTP Pfad `/length` wird abgebildet auf die mit `@GetMapping("/length")` annotierte Java Methode
- HTTP Query Parameter `?input=test` wird abgebildet auf Parameter der Java Methode `length(String input)`

## Optionals

Was passiert, wenn im obigen Beispiel der Query Parameter `input` nicht übergeben wird? Probiere es einfach aus

```console
curl -v http://localhost:8080/length
```

das Ergebnis ist eine Fehlermeldung mit einem HTTP 500 (Internal Server Error) Response

```console
< HTTP/1.1 500
< Content-Type: application/json
< Transfer-Encoding: chunked
< Date: Wed, 25 Mar 2020 05:29:16 GMT
< Connection: close
<
* Closing connection 0
{"timestamp":"2020-03-25T05:29:16.884+0000","status":500,"error":"Internal Server Error","message":"No message available","path":"/length"}
```

Im Log von Spring Boot erhältst du die Ursache des Problems

```
java.lang.NullPointerException: null
  at rest.controller.LengthController.length(LengthController.java:14) ~[classes/:na]
  ...
```

eine `NullPointerException` in der eigenen Methode `length`. Das heißt, dass der Parameter `input` der Java Methode `length` mit `null` belegt wurde, was von Spring Boot konsequent ist.

Du könntest dieses Problem mit einer `if(input!=null){...}` Abfrage sofort lösen. Eine elegantere Methode wäre aber aus dem Java Parameter `String input` ein `Optional<String> input` zu machen. Spring Boot kann mit dem `Optional` umgehen. Insgesamt sieht dann die `length` Methode folgendermassen aus:

```java
import java.util.Optional;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class LengthController {

  @GetMapping("/length")
  int length(Optional<String> input) {
    return input.map(String::length).orElse(0);
  }

}
```

Eine HTTP Anfrage

```console
curl http://localhost:8080/length
```

ohne `input` Parameter liefert jetzt einfach `0` zurück. Mit der Verwendung des `Optional` kommunizierst du als Entwickler, dass der Parameter `input` optional ist, dass er also in der HTTP Anfrage fehlen könnte.

## RequestParam

Der HTTP Query Parameter `input` konnte auf den Parameter der Java Methode `length(String input)` deshalb korrekt abgebildet werden, weil der Name des HTTP Parameters mit dem Namen des Methodenparameters `String input` übereinstimmte. Beide heißen `input`. Ich würde dir auch empfehlen, wann immer nur möglich diese Namensgleichheit beizubehalten. Wenn die HTTP Parameter und die Java Parameter gleich heißen, gibt es weniger Missverständnisse.

In manchen Fällen ist es aber notwendig, dass Parameter, die aufeinander abgebildet werden, nicht gleich heißen. Dann kommt die Java Annotation `@RequestParam` ins Spiel. Nehmen wir an, dass der Java Parameter der `length` Methode nicht mehr `input` sondern `message` heißen soll. Dann benötigst du ein Konstrukt mit dem du Spring Boot angeben kannst, dass der HTTP Parameter `input` auf den Java Parameter `String message` abgebildet werden soll.

In diesem Fall hast du die Möglichkeit den Java Parameter `message` mit `@RequestParam("input")` zu annotieren. Damit erkennt Spring Boot, dass der HTTP Parameter `input` auf den Java Parameter `message` abgebildet werden soll. Damit sieht nun die `lenght` Methode folgendermassen aus

```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
class LengthController {

  @GetMapping("/length")
  int length(@RequestParam("input") String message) {
    return message.length();
  }

}
```

und die HTTP Anfrage

```console
curl curl http://localhost:8080/length?input=test
```

liefert wie gewohnt die Länge des Strings `test` zurück.

## Required Parameter

Bei der Verwendung der Annotation `@RequestParam` wie im obigen Beispiel, betrachtet Spring Boot den HTTP Parameter `input` automatisch als **required**. Das heißt also, dass Spring Boot überprüft, ob dieser Parameter in der HTTP Anfrage enthalten ist. Ist er es nicht, zum Beispiel bei folgender Abfrage

```console
curl curl http://localhost:8080/length
```

dann liefert Spring eine sprechende Fehlermeldung

```console
Required String parameter 'input' is not present
```

in dem HTTP Response zusammen mit dem HTTP Status Code 400. Serverseitig enthält der Log folgende Exception

```console
MissingServletRequestParameterException: Required String parameter 'input' is not present
```

Das heißt, dass die Java Methode `length` gar nicht mehr ausgeführt wird, weil der required Parameter `input` in der HTTP Anfrage nicht enthalten war.

Bitte beachte, dass du beim Auslassen der Annotation `@RequestParam` ein anderes Verhalten hast (siehe Anfang des Tutorials). Ohne `@RequestParam` wird die Methode `length` ausgeführt und du erhälst einen HTTP Status 500 und eine `NullPointerException`, da der `input` Parameter `null` war.

## Fazit

Wie du in diesem Tutorial gesehen hast, bildet Spring Boot sehr intuitiv die übergebenen HTTP Parameter auf die Java Parameter der entsprechenden Java Methoden ab.

Es gibt aus meiner Sicht drei Strategien der Parameterübergabe, die du kennen und auch verwenden solltest:

1. die Methodenparameter werden nicht annotiert und das Mapping erfolgt anhand es Namens der Java Variablen,
1. du verwendest `Optional` um die Parameter als optional zu markieren und der Zugriff auf die Parameter erfolgt über `ifPresent(...)`, `map(...).orElse(...)`,
1. du verwendest `@RequestParam` wie oben gezeigt um die HTTP Parameter auf die Java Parameter abzubilden.

## Diskussion
