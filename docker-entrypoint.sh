#!/bin/bash

if [ -z "$VNC" ]; then
	echo >&2 'error: No password for VNC connection set.'
	echo >&2 '  Did you forget to add -e VNC=... ?'
	exit 1
fi

if [ -z "$XFB_SCREEN" ]; then
	XFB_SCREEN=1024x768x24
fi


mkdir -p /var/jenkins_workspace/Xauthority 


mcookie | sed -e 's/^/add :0 MIT-MAGIC-COOKIE-1 /' | xauth -q

xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f /var/jenkins_workspace/Xauthority/xserver.xauth nmerge -

# now boot X-Server, tell it to our cookie and give it sometime to start up
Xvfb :0 -auth ~/.Xauthority -screen 0 $XFB_SCREEN >>~/xvfb.log 2>&1 &
Xvfb :1 -ac -screen 0 $XFB_SCREEN >>~/xvfb10.log 2>&1 &
sleep 2

x11vnc -forever -passwd $VNC -display :1
