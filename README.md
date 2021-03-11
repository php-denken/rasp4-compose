# rasp4-compose
docker compose for a raspberry pi 4 with 4 GB of storrage with attached SSD.

Provided features will be
-docker host
-nextcloud
-pi hole

## What we start with

Raspberry with ubuntu server installed docker and docker-compose

Video guide https://www.youtube.com/watch?v=tlf_73MCeXQ

## Pi hole

like https://goneuland.de/pi-hole-mit-docker-compose-und-traefik-installieren/
but with proxy ngnix because of ports like here https://discourse.pi-hole.net/t/pihole-in-docker-together-with-nextlcoud-and-nginx/35974

mkdir -p ~/pi-hole/{pihole,dnsmasq}

pihole:
  container_name: pihole
  image: pihole/pihole:latest
  restart: unless-stopped
  ports:
    - "###RASPBERRY_HOST_IP###:53:53/tcp"
    - "###RASPBERRY_HOST_IP###:53:53/udp"
  environment:
    TZ: 'Europe/Berlin'
    WEBPASSWORD: 'sicheresPasswort'  # hier euer Passwort eingeben
  volumes:
     - '~/pi-hole/pihole/:/etc/pihole/'
     - '~/pi-hole/dnsmasq/:/etc/dnsmasq.d/'
  dns:
    - 127.0.0.1
    - 1.1.1.1


## Nextcloud

### Dyndns
https://ddnss.de/

Configure fritzbox internet->freigaben->dyndns
Use domain in config.cfg
for
DYNDNS_DOMAIN
Also set
MAIL_FOR_CERT

### Nexcloud with docker compose

https://www.instructables.com/Installing-Nextcloud-on-a-Raspberry-Pi-Using-Docke/

Create required folders

mkdir -p ~/nextcloud/{config,data}
mkdir -p ~/mariadb/config
mkdir ~/traefik
touch ~/traefik/acme.json && chmod 600 ~/traefik/acme.json

The acme.json is to hold details for letsencrypt to authorise your certificate.
Create docker container


docker-compose up -d


for firefox: accept self singned cert like https://javorszky.co.uk/2019/11/06/get-firefox-to-trust-your-self-signed-certificates/

go to https://rasp-ip:9443
initial configuration of nextcloud. Select Mariadd as db with password and user
like defined in the config.cfg. Attention DB host is not localhost it is like in
the docker compose file "mariadb" from the docker network.


### Make Nextcloud available

If Nextcloud is running now and locally available we have to make it public
available.

#### Letsencrypt for https

https://github.com/nextcloud/docker#make-your-nextcloud-available-from-the-internet

#### Portforwarding to make it finally available
portforwarding like https://canox.net/2016/06/die-eigene-cloud-mit-dem-raspberry-pi-und-nextcloud/
