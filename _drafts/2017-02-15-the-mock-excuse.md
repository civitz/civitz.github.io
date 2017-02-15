---
layout: post
title: On blaming mocks to avoid testing
---

Too often I hear that testing is hard or unnecessary because the need for mocks. 

And there is some truth in that: mocking isn't always the best solution for testing.
They are painful to create (even with frameworks) and too often you find yourself re-writing 
your domain logic in tests to assure your code works as intended.
Re-writing you logic in tests is tedious, but, more importantly, useless: it's the purpose of tests to ignore the logic, right?

And it's easy to point out this, expecially if you're trying to push your colleagues to write more tests!

## A symptom, not a cause

But what if this is a symptom, rather than a cause for not testing?

* What if the excessive use of mocks means that your abstraction is wrong? 
* What if this means you need to move some part of the logic to a separate class?
* What if writing the third expected call on a mock makes you think "oh boy, this method is huuuge" ?

This would mean that if you are frustrated by doing tests or seeing old tests fail after writing new code, 
chances are that the problem lies in production code, not your tests.

Having code that relies on preexistent state is the first reason for using mocks: unless your logic is pure (in functional programming terms: referentially transparent), you are gonna need some database or some state being pulled in your methods.
But the last phrase contains the answer: you can move the logic to a separate method, and make the original method call the second _after_ pulling the state. This way you can isolate the tests for state-pulling logic, which now consists in mocking the database call (or whatever you need for it), and test your logic by providing raw data directly _without mocks_!

Also, fewer lines of code means fewer lines of tests: would you prefer testing a 100-lines method or ten 10-lines methods? Or maybe twenty-five 4-lines methods? I would die for 4-lines methods!

Moving parts of your logic into separate methods or classes brings you exactly into this direction: it eases up your testing, and, as a byproduct, makes your code easier to understand.

## Further reasoning

With this frame of mind, one can even point out that: 

* using mocks is actually the first sign your code is bad
* the entire purpose of mocking frameworks is pointing out this

But this is a bit **too much**, mocking is not bad _per se_, 
I'm just saying that you can be aware of these symptoms to avoid writing complicated code.

In fact, it was writing tests with mocks that made realize how complicated my code was: if it is hard to prove the code was right, maybe the code was not _that_ right in the first place...
I feel my code is better now, because i make my parameters explicit, my logic more pure, my dependencies are injected, and so on. 

If I hadn't felt the pain of writing tests with mocks, I wouldn't have realized all of this. So the lesson is: do write more tests, and use your frustration to make your _production_ code better.
