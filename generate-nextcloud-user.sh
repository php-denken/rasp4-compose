#!/bin/bash
set -e
[ ! -f nextcloud_admin_password.txt ] && openssl rand -base64 32 > nextcloud_admin_password.txt
[ ! -f nextcloud_admin_user.txt ] && openssl rand -base64 32 > nextcloud_admin_user.txt
[ ! -f postgres_db.txt ] && openssl rand -base64 32 > postgres_db.txt
[ ! -f postgres_password.txt ] && openssl rand -base64 32 > postgres_password.txt
[ ! -f postgres_user.txt ] && openssl rand -base64 32 > postgres_user.txt
