---
layout: post
title: If it's stupid but it works, it's not stupid.
tags:
  - raspberry
  - microsd
  - linux
  - readonly
  - dd
  - OSMC
---

I was about to try the latest [OSMC](https://osmc.tv/) on my Raspberry Pi3, and I needed to backup my microSD before proceeding.

I fired up my laptop, booted linux, and typed my usual `dd` (with a hint of of `gzip` because we don't want 64GB of zeroes) and...

```
dd: opening `/dev/sdc': Read-only file system
```

The first thought was: "Fear not, padawan, it must be the SD lock", so I checked and, to my dismay, nothing happens!
I tried the usual reboot. Guess what? Nothing. Nada. Nichts.

## Please, I just need to backup my microSD! 

So I did what every developer do when things go awry: we go to stackoverflow.
And of course SO was full of the usual:

- try to fix permissions
- reboot your machine
- say a little prayer
- PEBKAC

Until i stumbled upon [this answer](https://raspberrypi.stackexchange.com/a/24535), buried between others because of a low score.
> You won't believe this, but spraying compressed air into the card slot near where the read-only switch is sensed fixed it for me. I hardly believe it.

And to me it sounded like "if it's stupid but it works, it's not stupid": I blew gently into the card slot, re-inserted the microsd, and BAM, it read & wrote as easy as 1-2-3.

Thank you, [Ian](https://raspberrypi.stackexchange.com/users/22713/ian)
