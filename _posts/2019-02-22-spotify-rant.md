---
published: true
layout: post
title: Spotify does not make sense for musically curious people
tags:
  - spotify
  - music
  - machinelearning
  - collaborativefiltering
  - rant
---
So you have a spotify account because you love music.
You care a lot about quality of music, and you try everything: Piano solo? [Check](https://open.spotify.com/track/0T4KV1pj8as2xvdHZAP5ae?si=ePyL2TziT2qL5FQqVLfSKw). Acoustic fingerstyle? [Sure](https://open.spotify.com/track/1G4WAevBC1nzpEsmR90M0A?si=tq5ZvT7gSAGLMwi_NWAJ5Q). Glitch electronica? [Very yes](https://open.spotify.com/track/36mKvcSraxyyLzJimZAh4l?si=DgRtv_FtRmaUypOcV7nkBw). Vegetarian progressive grindcore? [Areyoukiddingme..yes](https://www.youtube.com/watch?v=Hreqn9j3PHI)!

And you thought it was a good idea to settle for the most common service for music streaming, so there it is, your account.
At first you listen progressively to what is known to you, in the hope that the system somehow help you find more music that you like.

But then, the great surprise: a the beginning everithing is alright, you listen to Keith Jarret, Philip Glass pops out. Nice, let's try something else: Opeth? Spotify suggests some Cynic work. All good.

And then, after a while, you feel a little stale... is it because it's the 100th time Porcupine Tree appears in your "Discover" page? You can never get enough Porcupine Tree, don't ya?
Sometimes you get surprised: you hear a famous song over in an advertisement and you look for it. You find it on spotify and BOOM, suddenly everything it suggests is related to this.

You spot a pattern...

Listened to Madonna once? Here's Michael Jackson and Kylie Minogue.
Listened to Girl from Ipanema? You'll surely like these 10 brazilian artist you've never heard about. But maybe you just wanted Girl from Ipanema _once_.

This is [collaborative filtering](https://en.wikipedia.org/wiki/Collaborative_filtering) in action. A bunch of people listen to similar songs, and the algorithm picks from the common pool if you happen to listen one of pool's songs.

The problem with collaborative filtering is that it creates filter bubbles, areas where you can enter but not exit: once you start listening to songs _inside_ the bubble, you get recommended the same artists over and over. Facebook and Youtube have the same problem.

This is why you get recommended Spice girls if you've listened Madonna _once_. Sorry Spotify, nothing bad to say about Spice Girls, but I like Madonna because she has *PERFECT* production, not because I love '90 teenage music. I have [djent](https://open.spotify.com/track/0PYlcAw00yb0Sfy1UqSP4t?si=oPIeWdSfQkyGWOdQlB0vcw) artists in my listening history, why don't Spotify aknowledge this?

There is [a post](https://hackernoon.com/spotifys-discover-weekly-how-machine-learning-finds-your-new-music-19a41ab76efe) regarding Spotify's filtering and recommendation engine where it is explained how it calculates the next song to suggest: the company have all the data and all the ML power at their hands.

What I (we?) need is a way to somehow
* abstract the latent semantic of what I am listening to: it may be audio features, or other information such as genre, or years, or anything really
* address the filter bubble(s) I may be in, possibly inverting its weight
* suggest me something related to the semantic of what I listen, but stricly outside the bubble.

For example, if I listen to Rage Against the Machine and World's End Girlfriend, maybe I have a thing for bass lines, strong guitars, and challenging rithms, so some jazz/progressive metal is a good solution to exit the filter bubble: Ephel Duath, Periphery, Gojira may be candidates.

Can you do it, Spotify?
