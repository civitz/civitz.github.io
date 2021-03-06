---
published: true
layout: post
title: Upcycle a KiSS DP-500 with Raspberry Pi 3 - Part 3
---

After posting [our previous issue]({% post_url 2019-02-17-upcycle-kiss-dp500-with-rpi3-2 %}) to [reddit](https://www.reddit.com/r/raspberry_pi/comments/as0k4y/recycled_a_kiss_dp500_case_to_make_an_rpi3_osmc/) i finally had time to tinker with the frankenstein (shall we call it *FrankenKiss*?). This time we tackle the DVD reader.

After the old IDE HDD gave up, I connected the IDE-to-USB adapter to the DVD reader, plugged the power cable, and it got recognized by debian/osmc without any hassle. Osmc sees the dvd or cd as the right thing (e.g. dvd with files, or standard video dvd, and so on) and lets you play media from it.

I said recognized but it turns out there is no physical button directly attached to the eject mechanism of the reader, so to operate the tray I had to manually input `eject` on the command line. It worked, but it was inconvenient and my dad could not do this on its own.

I tried a workaround on this, by forcing the visibility of the "Disc" menu on osmc's skin, but it was an ugly hack and I will not discuss it here...

I instead focused on the front panel: the KiSS has a 8 buttons, which used to work to eject the disk, play, change tracks, etcetera. These buttons are connected to a board, which in turns exposes whats looks like a serial cable. The cable was connected to the main board of the original KiSS so the kind of connection could be anything: there were not enough wires for them to be one per button, and the protocol that the board uses could be an I2C or a proprietary protocol. I had no time for that :)

A closer inspection of the eject button reveals that its pins are protruding from the inside panel as shown in this animation:

![]({{ site.baseurl }}/images/kissrpi3/part3/button-placement.gif)

A quick check with a multimeter confirm my hopes: pressing the button closes the circuit. Time for some GPIO i guess!

First, some setup for my osmc box: we need to install GPIO support for python.

```bash
$ sudo apt install build-essential python-dev
```
and also
```bash
$ sudo pip install rpi.gpio
```

Then I followed this tutorial [http://razzpisampler.oreilly.com/ch07.html](http://razzpisampler.oreilly.com/ch07.html) for soldering and initial code.

As always, my soldering technique is far from good, but I managed to do a decent contact and that's what I was looking for.

![]({{ site.baseurl }}/images/kissrpi3/part3/solder1.jpg)
![]({{ site.baseurl }}/images/kissrpi3/part3/solder2.jpg)

After that, I followed the tutorial to see if the whole thing could work. So I coded the example:

```python
import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)

GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
    input_state = GPIO.input(18)
    if input_state == False:
        print('Button Pressed')
        time.sleep(0.2)
```

And launched:

![]({{ site.baseurl }}/images/kissrpi3/part3/press.gif)

So it works! I tinkered a bit and added a call to the `eject` linux command inside the loop.
```python
#!/usr/bin/env python2.7 
import RPi.GPIO as GPIO
import time
import os

GPIO.setmode(GPIO.BCM)

GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
    input_state = GPIO.input(18)
    if input_state == False:
        print('Button Pressed, ejecting cdrom')
        os.system("eject -T")
        time.sleep(0.2)
```

And this time it actually ejected the dvd drive!

![]({{ site.baseurl }}/images/kissrpi3/part3/eject.gif)

This code does its job but it is constantly polling for the button status and I wanted a better solution.

So I coded an interrupt-based solution following the tutorial from [https://raspi.tv/2013/how-to-use-interrupts-with-python-on-the-raspberry-pi-and-rpi-gpio-part-3](https://raspi.tv/2013/how-to-use-interrupts-with-python-on-the-raspberry-pi-and-rpi-gpio-part-3) with some tweaks here and there:

```python
#!/usr/bin/env python2.7 
import RPi.GPIO as GPIO
import time
import os

def toggledvd(channel):
    print('Button Pressed, ejecting cdrom')
    os.system("eject -T")

GPIO.setmode(GPIO.BCM)
GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_UP)
print("setting callback")
GPIO.add_event_detect(18, GPIO.RISING, callback=toggledvd, bouncetime=5000)

try:
    while True:
        print("waiting 10 seconds just so we do not die")
        time.sleep(10)
except KeyboardInterrupt:
    GPIO.cleanup()       # clean up GPIO on CTRL+C exit
GPIO.cleanup()           # clean up GPIO on normal exit

print("goodbye")
```

It still has a busy loop but at least it is not constantly polling the GPIO.

Then I registered the script as a `systemd` service by writing a service descriptor:

```bash
osmc@osmc:~/cdeject$ cat /lib/systemd/system/cdejector.service
[Unit]                                                        
Description = GPIO DVD ejector                                
Wants=network-online.target                                   
After=network-online.target                                   
                                                              
[Service]                                                     
Type = idle                                                   
ExecStart = /opt/cdejector/cdejector.py                       
                                                              
[Install]                                                     
WantedBy = multi-user.target                                  
```

And after that I registered the service as a boot service:

```bash
sudo systemctl daemon-reload
sudo systemctl start cdejector
sudo systemctl enable cdejector
```

This way I can eject and close the dvd tray with the button outside the FrankenKiss.

Kodi is also smart enough to lock the dvd eject if any media is playing, so no further coding is necessary here.

Next up: LCD panel, back side ports, more buttons?
