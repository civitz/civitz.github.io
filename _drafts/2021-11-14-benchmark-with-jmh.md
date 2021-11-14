---
layout: post
published: true
title: "Test code performance with JMH"
tags:
  - jmh
  - java
  - benchmark
  - template
  - render
---

I was reviewing a piece of code for a template renderer lately, and noticed something was a little bit off.
A template renderer is used to make personalized documents given a fixed text (the template) and a set of parameters.

For example: if we want to send postcards to 1000 friends, and the text is the same a part from the name we can make one template text with a placeholder text in it in place of the name. The template's placeholders usually follow a convention, for example if we want to make personalized documents with `Hello name` inside, where `name` is changed for every person we want to send this document, then the template will be something like `Hello [name], ...`

A template renderer is an algorithm which takes a template (a string with token or placeholders) and some parameters (a map of string to string) and returns a rendered text (also a string). In the rendered text the algorithm:
- replaces every matched placeholder with the parameters value (e.g. every occurrence of `[name]` with `John`)
- leaves placeholders if there is no replacement (e.g. if there is no replacement for `[destination]` for the template `We will reach [destination]`, then the result of the render is `We will reach [destination]`)
- ignores any extra parameters that are not mentioned as placeholders
- ignores corner cases, like unmatched characters (`hello, [i [like [brackets` ) or nested/unmatched template (`this [is a nested [bracketName]]`)

To put it all together, if we have a template:
```
Hello [name],

Meet me at [place] at around [time].
```

With parameters:
```json
{
    "name": "Jane",
    "place": "the park",
    "time": "noon"
}
```
Then the result should be:
```
Hello Jane,

Meet me at the park at around noon.
```

So I was reviewing a template renderer, and the code did not look very performant. How would I evaluate the different performance of a new algorithm? We need a benchmark!
The *de facto* standard of benchmarks in the Java world is JMH - [Java Microbenchmark Harness](https://github.com/openjdk/jmh).
JMH is a tool to build code benchmarks that accounts for some peculiarities of the JVM (Java Virtual Machine), such as compiler optimizations, bytecode optimizations, and JIT (Just In Time) optimizations.

Suppose we have a sample *naive* algorithm that accepts square brackets (`[` and `]`) as placeholder indicator in template - please not that in our sample we use the VAVR library:
```java
public static String naiveRegexReplace(String template, Map<String, String> values) {
    return values.foldLeft(template, (replaced, kv) -> replaced.replaceAll("\\[[\\s]*" + kv._1 + "[\\s]*\\]", kv._2));
}
```
To test its performance we need to set up a JMH project. You can do it via the convenient maven archetype:
```
mvn archetype:generate \
    -DinteractiveMode=false \
    -DarchetypeGroupId=org.openjdk.jmh \
    -DarchetypeArtifactId=jmh-java-benchmark-archetype \
    -DgroupId=com.mycompany \
    -DartifactId=benchmarks \
    -Dversion=1.0-SNAPSHOT
```
Then you can go straight to edit the `MyBenchmark` class.

For our case we need a sample data, which we can generate using the `@State(Scope.Benchmark)` annotation on a class with a no-arg constructor. This avoids a compiler optimization which would make the compiler return the result of a computation, as long as it can calculate that the result at compile-time.
```java
@State(Scope.Benchmark)
public static class AllMatched10AverageText {
    public String template;
    public Map<String, String> values;

    public AllMatched10AverageText() {
        values = Stream.range(0, 10)
                .toMap(i -> Tuple.of("key" + i, "value" + i));
        String mediumGap = Stream.range(0, 100)
                .map(ign -> "rand")
                .mkString("");
        template = values.map(Tuple2::_1).mkString("[","]"+mediumGap+"[","]");
    }
}
```

Now for the actual benchmark:
```java
@Benchmark
public void _10_args_averageCase_naiveRegex(AllMatched10AverageText torender, Blackhole blackhole) {
    blackhole.consume(TemplateRenderers.naiveRegexReplace(torender.template, torender.values));
}
```
Notice the `Blackhole` usage: if the compiler detects that we make no use of a certain result, and it can determine that it can delete code, then our benchmark would measure nothing. To avoid this we can use the Blackhole, which consumes the result, so that the compiler will not optimize our code away.

