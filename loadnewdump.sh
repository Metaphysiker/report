#!/usr/bin/env bash

 # get daily backup from philosophie.ch
  scp -P 22000 vpsadmin@havps11.iron.bsa.oriented.ch:/var/backups/pgsql/havps11.pgsql_all.dump.bz2 /home/sandro/Documents/philochbackups/"$(date '+%d-%m-%Y').dump.bz2"
