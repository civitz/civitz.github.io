---
published: false
---
## A New Post

Need to install:
```build-essential python-dev```
also `sudo pip install rpi.gpio` to support gpio

followed this tutorial http://razzpisampler.oreilly.com/ch07.html for initial code, however it needs modifications since it needs to interact with xbmc

```python
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

```
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
