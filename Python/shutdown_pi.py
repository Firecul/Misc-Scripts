#!/bin/python
# Shutdown script, obviously

import RPi.GPIO as GPIO
import time
import os

GPIO.setmode(GPIO.BCM)
GPIO.setup(21, GPIO.IN, pull_up_down=GPIO.PUD_UP)


# setup shutdown function
def Shutdown(channel):
    #	os.system("sudo /etc/init.d/kismet stop")
    #	os.system("/bin/sleep 15")
    os.system("sudo shutdown -P 1")


# Call when pressed
GPIO.add_event_detect(21, GPIO.FALLING, callback=Shutdown, bouncetime=2000)

while 1:
    time.sleep(1)
