---
layout: post
title: How To Spot Single Responsibility Principle Violation
---

So you've read about [SOLID](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) and you're confused about the Single Responsibility Principle.

What amount of responsiblity is *too much(tm)*?

I think there's a single question you can ask yourself about a piece of code to spot a SRP violation:

> If you describe what a piece of code does with an "AND", it's probably violating the SRP

E.g. if you say "this method makes an http request and parses its output to a bean" then the method shall be split in 2.
Of course you'll need a glue method to chain the two calls, but now you can separately test the two main methods 
