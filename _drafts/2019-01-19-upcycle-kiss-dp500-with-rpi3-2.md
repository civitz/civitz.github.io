---
published: false
---
## A New Post

It's beena long time since [last update on raspberry frankenstein]({% post_url 2016-12-28-upcycle-kiss-dp500-with-rpi3 %}), so here's an update.

After some trials, the power supply has shown its drawbacks. It did not erogate enough power and it is probably failing. The 12 Volt ATA circuitry seems to be still reliable enough to provide power.

So I bought some decent high power usb hub and re-did the internals of the project. The usb hub will provide power to the Rpi _and_ function as a powered usb hub. To do this, we have to "loop" the hub.
The following pictures show the usb hub and the cabling.

![]({{ site.baseurl }}/images/kissrpi3/power.jpg)
![]({{ site.baseurl }}/images/kissrpi3/disposition.jpg)

The usb hub and the HDMI cables are held by zip ties (I had to drill a couple of holes for them), this also protects the HDMI cable from yanking.

![]({{ site.baseurl }}/images/kissrpi3/back.jpg)

To provide power to the hub I had to conceal the hub's own power supply inside the case. I wanted to recycle the hub if anything goes wrong, so I did not want to break open the hub to power it. So I used a [screw terminal](https://en.wikipedia.org/wiki/Screw_terminal) to wire a socket inside the case, and attached the hub's power supply to the socket. The thing is depicted in the following picture:

![]({{ site.baseurl }}/images/kissrpi3/supply.jpg)

This way I can still use the power button at the front panel to power on the frankenstein. Luckly the hub's power supply is very small and I could fit it under the case power socket, see: 

![]({{ site.baseurl }}/images/kissrpi3/supply.jpg)

Multiple screw terminals can be arranged in the form of a barrier strip (as illustrated at the top right), with a number of short metal strips separated by a raised insulated "barrier" on an insulating "block" - each strip having a pair of screws with each screw connecting to a separate conductor, one at each end of the strip. These are known as connector strips or chocolate blocks ("choc blocks") in the UK. This nick-name arises from the first such connectors made in the UK by GEC, Witton in the 1950s. Moulded in brown plastic they were said to resemble a small bar of chocolate. [from https://en.wikipedia.org/wiki/Screw_terminal]
