---
layout: post
title: How To Spot Single Responsibility Principle Violation
---

So you've read about [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) and you're confused about the Single Responsibility Principle.

What amount of responsiblity is *too much(tm)*?
<!--more-->
I think there's a single question you can ask yourself about a piece of code to spot a SRP violation:

> If you describe what a piece of code does with an "AND", it's probably violating the SRP.

E.g. if you say "this method makes an http request AND parses its output to a bean" then the method shall be split in 2.
Of course you'll need a glue method to chain the two calls, but now you can separately test the two main methods in an isolated way. The tests will be more focused on the specific behavior, while the glue code won't need much testing at all, since all it will do is to chain calls.

Like every advice you see on the internet, please take this with a grain of salt: this is not a _one size fits all_ solution, sometimes it is safer to keep well-functioning short code together rather than forcing every method to be less than 10 lines.

Use it while rubber-ducking on your problem.
