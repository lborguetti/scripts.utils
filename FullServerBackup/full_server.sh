#!/bin/bash

mkdir -p /backups
cd /
tar -cvzpf /backups/full_server.tar.gz --directory=/ --exclude=proc --exclude=sys --exclude=dev/pts --exclude=backups . > /dev/null 2>&1

