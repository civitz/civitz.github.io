---
published: true
title: Tests improve design
layout: post
tags:
  - testing
  - design
  - code
  - quality
  - TDD
---
I came across [this wonderful article by Kelly Sutton](http://kellysutton.com/2017/04/18/design-pressure.html) about TDD and code design.

He states that the sole fact of having a test over your code helps you designing it better.

> Design Pressure is the little voice in the back of your head made manifest by a crappy test with too much setup. It’s a force that says when your tests become hard to write, you need to refactor your code.

That is, testing the interface of your code helps you focusing on the pain points of using your code.

I have also seen benefits on writing tests *after* writing the code. Often times I catch a bug on the code while writing the test (i.e. before I run it) because I know I did not code that particular edge case and the test will fail.

Write tests, save time.
