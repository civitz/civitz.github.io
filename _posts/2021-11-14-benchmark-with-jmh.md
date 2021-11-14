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

For example: if we want to send postcards to 1000 friends, and the text is the same a part from the name we can make a template with a placeholder text in it in place of the name. The template's placeholders usually follow a convention, for example if we want to make personalized documents with `Hello name` inside, where `name` is changed for every person we want to send this document, then the template will be something like `Hello [name], ...`

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

Suppose we have a sample *naive* algorithm that accepts square brackets (`[` and `]`) as placeholder indicator in template - please note that in our sample we use the VAVR library:
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
The code above generates a template with 10 placeholders, evenly spaced with text, for a total of around 3.5KB of text. Then it also generate 10 values for the placeholder text, so that all placeholders have a matched value. This represents an average case for, say, an email.

Now for the actual benchmark:
```java
@Benchmark
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
public void _10_args_averageCase_naiveRegex(AllMatched10AverageText torender, Blackhole blackhole) {
    blackhole.consume(TemplateRenderers.naiveRegexReplace(torender.template, torender.values));
}
```
Notice the `Blackhole` usage: if the compiler detects that we make no use of a certain result, and it can determine that it can delete code, then our benchmark would measure nothing. To avoid this we can use the Blackhole, which consumes the result, so that the compiler will not optimize our code away.

We can run the benchmark by running the default `main` method.
The results are shown in the coonsole like the following (text has been modified to fit this post):

```
Benchmark                                    Mode  Cnt    Score    Error  Units
MyBenchmark._10_args_averageCase_naiveRegex  avgt    6  224,164 ±  8,813  us/op
```

Well, now we have a baseline! We can now work on a different algorithm. For the specific case we noticed that the string is being duplicated over and over for each round of `replaceAll`. We implemented a windowed/scrolling template renderer, you can see the code below:
```java
public static String scrolling(String template, Map<String, String> values) {
    int pendingBracketPos = -1;
    StringBuilder buffer = new StringBuilder(template.length());
    for (int pos = 0; pos < template.length(); pos++) {
        char c = template.charAt(pos);
        if (c == '[') {
            if (pendingBracketPos != -1) {
                buffer.append(template, pendingBracketPos, pos);
            }
            pendingBracketPos = pos;
        } else if (c == ']') {
            if (pendingBracketPos == -1) {
                buffer.append(c);
            } else {
                String possibleKey = template.substring(pendingBracketPos + 1, pos).trim();
                Option<String> possibleValue = values.get(possibleKey);
                if (possibleValue.isDefined()) {
                    buffer.append(possibleValue.get());
                } else {
                    buffer.append(template, pendingBracketPos, pos + 1);
                }
                pendingBracketPos = -1;
            }
        } else if (pendingBracketPos == -1) {
            buffer.append(c);
        }
    }
    return buffer.toString();
}
```

We now have two different algorithms we can compare between, so let's do it! Add another benchmark:
```java
@Benchmark
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
public void _10_args_averageCase_scrolling(AllMatched10AverageText torender, Blackhole blackhole) {
    blackhole.consume(TemplateRenderers.scrolling(torender.template, torender.values));
}
```

Now we can compare the two results by running another time the benchmark:
```
Benchmark                                    Mode  Cnt    Score    Error  Units
MyBenchmark._10_args_averageCase_naiveRegex  avgt    6  224,164 ±  8,813  us/op
MyBenchmark._10_args_averageCase_scrolling   avgt    6   40,114 ±  1,729  us/op
```

Well, that's a speedup of ~5x!

Now you've seen the basis of JMH performance testing, you can further test your algorithms' performance by:
- adding different combination of data
- confronting more algorithms together
- changing the benchmark parameters such as:
  + warmup runs to trigger JIT optimizations
  + forks to run the test on multiple instance of the same JVM to account for slight context variations between runs (e.g. cpu power state, background activity, memory paging situation,etc...)
  + measurement iterations
  + garbage collection
  + profiling

We added a full example in the [java experiments repo](https://github.com/civitz/java-experiments), you can see the code (with tests!) [here](https://github.com/civitz/java-experiments/tree/master/src/main/java/io/github/civitz/java/experiments/templater).
The repo also contains:
- an even more optimized version of the `scrolling` algorithm
- the possibility to generate a runnable jar to run the benchmark as a standalone app
- more benchmark cases
- unit tests for all the algorithms

Have a nice performance testing!