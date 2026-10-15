---
title: Meat proxies, and the bear dumpster dilemma
draft: true
---

In this agentic AI era, software development is no longer a safe bet for a young person looking for a career.
New graduates not only have to compete with other graduates for new jobs, but also the "competition" of AI agents being on par with (or better than) their skills.

Senior professionals are now asked to do more than before, especially since now the grunt work is offset by an automation that is both cheap and relentless. We are now product managers of the software: we design, evaluate, decide, test, profile and ultimately review what others do.

"Others" being AI agents, since more and [more companies are basically not hiring juniors or consultants anymore](https://www.youtube.com/watch?v=_s8RqDhM_1E). [^junior]
And on the same note **the value added by a software engineer behind an agent is reduced day by day** because the agents are getting more capable. Or at least the *perceived* value added by a software engineer. [^salary] 


So of course a sane person does what a sane person would do: you learn to use the tools of the trade, and use AI agents to accelerate your work, you try to be more effective. You learn to coordinate work rather than do it, in the hope that the new round of models cannot keep up with what you add, and you do not burn out splitting your synapses.

But then again, what do you add? What is it that you do with your agents?

If you take your tickets, or requests from your boss, paste them into the prompt, and take the output without verifying anything, what are you doing? If a senior colleague delegates some tedious-but-important work to you and you do not take the agent output with at least a little skepticism about its correctness...what are you adding to the agent's work? Well, if you are not verifying, you are indeed a *meat proxy*, you add a layer of communication friction on top of an untrustworthy output. And believe me, it's very easy to spot something that's not verified.

When I realize I am evaluating what appears to be slop from an agent, I can't help but think about a quote from a park ranger.
In parks with bears there's always a problem with food attracting animals to humans and causing issues. This is especially true for dumpsters since a bear may smell rotten food from kilometers away. You don't want a bear to be able to open the dumpster, but you also want a human to be able to do it, possibly without solving a complicated puzzle.
A park ranger[^ranger] was once commenting on how difficult it is to design a dumpster that is hard for bears to open but easy for humans:

> There is a considerable overlap between the intelligence of the smartest bears and the dumbest tourists

To which I add a corollary:

> There is a considerable overlap between the intelligence of the "smartest" model and the dumbest human

From my experience agents are force multipliers. They let skilled engineers do a lot of work in a short time. But a person with no experience (or will to verify) may miss a critical flaw in an otherwise very convincing output text from most top of the line models. And the more I interact with those models, the more I understand that newer models can do, at the same time:
- more grunt work, even "hard" work like debugging a convoluted issue
- more spectacularly broken suggestions, while appearing firmly confident of them.

So make sure the operand you bring is above zero or you'd be multiplying yourself to oblivion.

I get the feeling that the I in AI is like the D in Django: it's silent, you have to add it.

[^junior]: And yeah, you can argue that by not hiring juniors, you no longer have what is the "insurance" that keeps the know-how inside the company. And I would agree with you, I really do, it's the truth. But truth and business decisions are not always correlated.

[^salary]: As a take-home exercise, ask your manager: if job offers reduce in number because AI can do your job, are offered salaries going up or down?

[^ranger]: [Slashdot comment from 2006, but the quote can be traced back even more](https://yro.slashdot.org/comments.pl?sid=191810&cid=15757347)