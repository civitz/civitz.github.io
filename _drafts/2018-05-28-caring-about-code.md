---
published: false
layout: post
title: Caring about code
tags:
  - code review
  - testing
  - care
  - code
  - quality
---
# Caring about code

What does testing and code review, have in common? These are all ways to make you face your own work, forcing you to mentally check and re-check what you have done.

### TDD and testing in general
Test driven development makes you forge your code in such a way it's easy to test. Code like this tends to be more modular and easier to reason about. It does this by [making you think about the interface of your code, rather than the algorithm behind it](https://www.youtube.com/watch?v=fr1E9aVnBxw). By testing you are also sure that your code works as intended (well, most of the times).

### Code review
Code review is a way to check that your code is not obviously wrong. Colleagues have a look at each other's code and together they find bugs or ways to improve the quality of your work. Code that makes it through code review tends to be easier to understand (because it was understood by at least one person other than you) and generally more correct.

## So what?
Over time I have found that it's not the practice of these two methods that makes code better.

Testing makes you build better interfaces, and often times you catch a bug before the tests because it was obvious from the interface itself. You need fewer tests to be confident your code is right.

Code reviews makes you care about the way your code looks. Maybe you try to help your colleagues by putting a little more comments, only to find you were wrong about your code and your function does not behave well when you pass an age below zero... and you catch the bug before code review.

## The takeaway
It does not matter how many tests you do, how much coverage you get, or how many eyes look at your code. The real thing that makes your work better is caring about your work.