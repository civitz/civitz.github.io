---
published: true
layout: post
title: Upcycle a KiSS DP-500 with Raspberry Pi 3 - Part 2
---
## Upcycle a KiSS DP-500 with Raspberry Pi 3 - Part 2

It's been a long time since [last update on raspberry frankenstein]({% post_url 2016-12-28-upcycle-kiss-dp500-with-rpi3 %}), so here's an update.

After some trials, the power supply has shown its drawbacks. The 5 Volt supply did not provide enough power for the RPi and it is probably failing. The 12 Volt ATA circuitry seems to be still reliable enough to provide power.

So I bought some decent high power usb hub and re-did the internals of the project. The usb hub will provide power to the RPi _and_ function as a powered usb hub. To do this, we have to "loop" the hub.
The following pictures show the usb hub and the cabling.

![]({{ site.baseurl }}/images/kissrpi3/power.jpg)
![]({{ site.baseurl }}/images/kissrpi3/disposition.jpg)

The usb hub and the HDMI cables are held by zip ties (I had to drill a couple of holes for them), this also protects the HDMI cable from yanking.

![]({{ site.baseurl }}/images/kissrpi3/back.jpg)

To provide power to the hub I had to conceal the hub's own power supply inside the case. I wanted to recycle the hub if anything goes wrong, so I did not want to break open the hub to power it. So I used a [screw terminal](https://en.wikipedia.org/wiki/Screw_terminal) to wire a socket inside the case, and attached the hub's power supply to the socket. The thing is depicted in the following picture:

![]({{ site.baseurl }}/images/kissrpi3/supply.jpg)

This way I can still use the power button at the front panel to power on the frankenstein. Luckly the hub's power supply is very small and I could fit it under the case power socket, see: 

![]({{ site.baseurl }}/images/kissrpi3/supply2.jpg)

I then attached the usb-to-IDE adapter to the hard disk. The hard disk itself is powered by the original KiSS power supply.
The final setup looks like this:

![]({{ site.baseurl }}/images/kissrpi3/final.jpg)

Later on the hard disk proved faulty, so I replaced it with an external usb hard disk: since the hub is powerful enough, all I needed to do was to zip-tie the hard disk inside the case, and plug the hard disk to the hub.

Next phase would be to use the IDE cable to bring life to the DVD-reader, so that the KiSS re-gains its original functionality of being a DVD/DivX reader.
