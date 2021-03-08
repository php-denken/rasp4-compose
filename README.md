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

mkdir -p ~/pi-hole/{pihole,dnsmasq}


## Nextcloud

### Dyndns
https://ddnss.de/
Configure fritzbox internet->freigaben->dyndns


### Nexcloud with docker compose

https://www.instructables.com/Installing-Nextcloud-on-a-Raspberry-Pi-Using-Docke/

Create required folders

mkdir -p ~/nextcloud/{config,data}
mkdir -p ~/mariadb/config
mkdir ~/traefik
touch ~/traefik/acme.json && chmod 600 ~/traefik/acme.json

The acme.json is to hold details for letsencrypt to authorise your certificate.
Create docker container

Install docker-compose

sudo apt install docker-compose

Create a docker-compose.yml file in the home directory with following content (swap out the password, domain and email details with your own).

version: "2"
services:
  nextcloud:
    image: linuxserver/nextcloud
    container_name: nextcloud
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - ~/nextcloud/config:/config
      - ~/nextcloud/data:/data
    ports:
      - 9443:443
    restart: unless-stopped
    labels:
      - traefik.enable=true
      - traefik.http.routers.nextcloud.entrypoints=websecure
      - traefik.http.routers.nextcloud.rule=Host("your-domain-name")
      - traefik.http.routers.nextcloud.tls=true
      - traefik.http.routers.nextcloud.tls.certresolver=myhttpchallenge
      - traefik.http.routers.nextcloud.service=nextcloud
      - traefik.http.routers.nextcloud.middlewares=nextcloud-regex,nextcloud-headers
      - traefik.http.services.nextcloud.loadbalancer.server.port=443
      - traefik.http.services.nextcloud.loadbalancer.server.scheme=https
      - traefik.http.middlewares.nextcloud-regex.redirectregex.regex=https://(.*)/.well-known/(card|cal)dav
      - traefik.http.middlewares.nextcloud-regex.redirectregex.replacement=https://$$1/remote.php/dav/
      - traefik.http.middlewares.nextcloud-regex.redirectregex.permanent=true
      - traefik.http.middlewares.nextcloud-headers.headers.customFrameOptionsValue=SAMEORIGIN
      - traefik.http.middlewares.nextcloud-headers.headers.stsSeconds=15552000
  mariadb:
    image: linuxserver/mariadb
    container_name: mariadb
    environment:
      - PUID=1000
      - PGID=1000
      - MYSQL_ROOT_PASSWORD=ChangeMePlease
      - TZ=Europe/London
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_PASSWORD=ChangeMeAlso
    volumes:
      - ~/mariadb/config:/config
    ports:
      - 3306:3306
    restart: unless-stopped
  traefik:
    image: traefik:v2.0
    container_name: traefik
    command:
      - --providers.docker=true
      - --providers.docker.exposedbydefault=false
      - --entrypoints.web.address=:80
      - --entrypoints.websecure.address=:443
      - --certificatesresolvers.myhttpchallenge.acme.httpchallenge=true
      - --certificatesresolvers.myhttpchallenge.acme.httpchallenge.entrypoint=web
      - --certificatesresolvers.myhttpchallenge.acme.email=someaddress@somedomain.com
      - --certificatesresolvers.myhttpchallenge.acme.storage=/acme.json
      - --serverstransport.insecureskipverify
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ~/traefik/acme.json:/acme.json
    restart: unless-stopped

Create container:

docker-compose up -d


accept self singned cert like https://javorszky.co.uk/2019/11/06/get-firefox-to-trust-your-self-signed-certificates/


### Make Nextcloud available

If Nextcloud is running now and locally available we have to make it public
available.

#### Letsencrypt for https

https://github.com/nextcloud/docker#make-your-nextcloud-available-from-the-internet

#### Portforwarding to make it finally available
portforwarding like https://canox.net/2016/06/die-eigene-cloud-mit-dem-raspberry-pi-und-nextcloud/
