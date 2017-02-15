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

TODO EDIT FROM HERE
Fewer lines of code means fewer lines of tests: and moving parts of your logic into separate methods or classes does

THIS MAY AS WELL REMAIN AT THE BOTTOM
## Further reasoning

With this frame of mind, one can even point out that: 

* using mocks is actually the first sign your code is bad
* the entire purpose of mocking frameworks is pointing out this

But this is a bit **too much**, mocking is not bad _per se_, 
I'm just saying that you can be aware of these symptoms to avoid writing complicated code in the first place

