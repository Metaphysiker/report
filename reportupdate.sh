#!/usr/bin/env bash
#sudo -u sandro
export DISPLAY=:0
#check if there was a check today
#rails runner 'Checked.new.wasthereachecktoday?'

result="$(rails runner "puts Checked.new.wasthereachecktoday?")"
#result="false"
#result=$(./wasthereachecktoday.sh)

if [ "$result" == false ]
then
  kdialog --passivepopup 'Reports are being created.' 5

  # Get today's dump
  # scp -P 22000 vpsadmin@havps11.iron.bsa.oriented.ch:/var/backups/pgsql/havps11.pgsql_all.dump.bz2 /home/sandro/Documents/philochbackups/"$(date '+\%d-\%m-\%Y').dump.bz2"
  scp -P 22000 vpsadmin@havps11.iron.bsa.oriented.ch:/var/backups/pgsql/havps11.pgsql_all.dump.bz2 /home/sandro/Documents/philochbackups/"$(date '+%d-%m-%Y').dump.bz2"

  # this will create the reports
  ./createspecialreports.sh

elif [ "$result" == true ]
then
  echo "There was already a check. Nothing will happen."
  #kdialog --passivepopup 'There was already a check. Nothing will happen.' 5
else
logger "else"
   kdialog --passivepopup 'Error - Reportupdate.' 5
   echo "error"
fi

