---
published: true
layout: post
title: Upcycle a KiSS DP-500 with Raspberry Pi 3 - Part 3
---

After posting [our previous issue]({% post_url 2019-02-17-upcycle-kiss-dp500-with-rpi3-2 %}) to [reddit](https://www.reddit.com/r/raspberry_pi/comments/as0k4y/recycled_a_kiss_dp500_case_to_make_an_rpi3_osmc/) i finally had time to tinker with the frankenstein (shall we call it *FrankenKiss*?). We need to find our way to the eject button!

A closer inspection of the eject button reveals that it's pins are protruding from the inside panel as shown in this animation:

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

This code is good but it is constantly polling for the button status and we wanted a better solution.

So i coded an interrupt-based solution following the tutorial from [https://raspi.tv/2013/how-to-use-interrupts-with-python-on-the-raspberry-pi-and-rpi-gpio-part-3](https://raspi.tv/2013/how-to-use-interrupts-with-python-on-the-raspberry-pi-and-rpi-gpio-part-3) with some tweaks here and there:

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
