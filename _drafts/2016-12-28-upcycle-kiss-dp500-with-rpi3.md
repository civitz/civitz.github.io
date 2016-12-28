---
layout: post
title: Upcycle a KiSS DP-500 with Raspberry Pi 3
---

So i got this old beauty from my dad:

![]({{ site.baseurl }}/images/kissrpi3/front.jpg)


On the great days (2003?) it used to be one of the first DivX players available on the market.
It worked great, but, as it turns out, technology runs fast and faster, so it became useless in 4-5 years.

What shall we do with such an obsolete piece of hardware? Donate it? It won't work with modern video file formats...

So I got an idea...

# Let's open it!

First, unscrew the unscrew-able screws on the sides:

![]({{ site.baseurl }}/images/kissrpi3/screw1.jpg)

and on the back:

![]({{ site.baseurl }}/images/kissrpi3/screw2.jpg)

Now inspect the internal:


![]({{ site.baseurl }}/images/kissrpi3/internal.jpg)
By looking at the available hardware, it seems to have a fairly standard ATA DVD reader, with some custom boards and a relatively compact PSU.
What is astonishing, though, is the wasted space: it is clearly an unpolished product, underlying the fact that it was very niche when it came out.

A little [googling](http://familien-hartvig.dk/wiki/index.php?title=Psu) made me discover that the PSU has a 5V outlet capable of outputting 1.5A.

Then it clicked: why not enclosing a Raspberry Pi into this? And up-cycle this _scrap metal frame_ into a fully-fledged media center?

# I am not able to solder properly

As it turns out, Raspberry Pi 3 needs at least 2A to run, but why not try?
Fortunately, though, we won't have overcurrent/overvoltage problems because the micro-USB input of the RPi3 has power protection circuitry.

First, find the two wires that will give power to the Raspberry:

![]({{ site.baseurl }}/images/kissrpi3/wiring.jpg)

Then find a suitable microusb plug to sacrifice to the DIY gods, and solder its power endpoint:

![]({{ site.baseurl }}/images/kissrpi3/bad_solder.jpg)

Please allow a moment to contemplate this really bad soldering technique.

...

...

Ok, that's enough.


# Will it blend?

Connect the frankenstein USB to the RPi3, connect the HDMI cable to a TV, and press that power button on the KiSS.
To my great surprise, the whole thing not only powers on:

![]({{ site.baseurl }}/images/kissrpi3/lights.jpg)

but also boots to NOOBS:

![]({{ site.baseurl }}/images/kissrpi3/noobs.jpg)

and proceeds to fully boot OpenELEC/Kodi:

![]({{ site.baseurl }}/images/kissrpi3/kodi.jpg)

But the real surprise is that it can also stream content from the internet!

![]({{ site.baseurl }}/images/kissrpi3/works.jpg)

Not pictured here: I tried streaming with the metal cover on, and it seems to work too.

# What's next?

Next steps could be:

- recycle and use the DVD reader via an ATA adapter (but the button may not work...I'll try)
- debug and reuse the front panel with the buttons (useless but can be fun)
- debug and reuse the front IR receiver (useless if your TV can route the remote through HDMI)
- reuse the ATA connection with an old ATA HD
- reuse the ATA power cord and an adapter to recycle any SATA HD

We'll see what my dad has in his basement...and I will surely post updates on this.
