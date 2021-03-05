# rasp4-compose
docker compose for a raspberry pi 4 with 4 GB of storrage with attached SSD.

Provided features will be
-docker host
-nextcloud
-pi hole

## What we start with

Raspberry with ubuntu server installed docker and docker-compose

Video guide https://www.youtube.com/watch?v=tlf_73MCeXQ

## Nextcloud

### Dyndns
https://ddnss.de/
Configure fritzbox internet->freigaben->dyndns

### Desktop
desktop is usefull for first run of nextcloud
recomanded for a raspberry is lubuntu
https://www.raspberry-pi-geek.de/ausgaben/rpg/2020/02/ubuntu-server-19-10-in-32-und-64-bit-auf-dem-raspberry-pi/

```
sudo apt install lubuntu-desktop
```

use sddm as display manager if asked

reboot and use desktop with attach display.

language package with

```
sudo apt install language-pack-kde-de
```


Preferences->Language Support->Install/Remove Languages choose German and apply.
Move Deutsch (Deutschland) to first position in list
"Language for menus and windows" and enable "Apply System-Wide"
SSDM-Login-Manager switch to german and disable on screenkeyboard with:

```
echo "setxkbmap de" | sudo tee -a /usr/share/sddm/scripts/Xsetup
echo -e "[General]\nInputMethod=" | sudo tee -a /etc/sddm.conf
```

to save some space remove libre office

```
sudo apt-get remove --purge libreoffice*
sudo apt-get clean
sudo apt-get autoremove
```

### Remote Desktop

https://wiki.ubuntu.com/Lubuntu/RemoteDesktop

```
sudo apt-get install vino

vino-preferences
```

### Nexcloud with docker compose
According to the offical guide from nextcloud on github
https://github.com/nextcloud/docker#docker-secrets
the docker-compose.yml file in this repo is configured.

Secret PW and user files can be randomly generated with the
generate-nextcloud-user.sh script

start all containers with:
```
docker compose up
```

### Make Nextcloud available

If Nextcloud is running now and locally available we have to make it public
available.

#### Letsencrypt for https

https://github.com/nextcloud/docker#make-your-nextcloud-available-from-the-internet

#### Portforwarding to make it finally available
portforwarding like https://canox.net/2016/06/die-eigene-cloud-mit-dem-raspberry-pi-und-nextcloud/
