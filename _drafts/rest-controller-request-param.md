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

Spring Boot bildet **automatisch** die HTTP GET Query Parameter auf die Parameter der entsprechenden Java Methode ab. In meinem obigen Beispiel heißt das, dass der HTTP GET Query Parameter `input=test` automatisch als Parameter der Java Methode `length` übergeben wird. Wichtig dabei ist, dass der Name der Java Variablen mit den Namen der HTTP Query Parameter übereinstimmen müssen.

## Optionals

## Required Parameter

## Spring Boot Service
