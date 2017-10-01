#!/usr/bin/env bash

#First Half Year with most closest backup
./loadsingledump.sh "/home/sandro/Documents/philochbackups/15-07-2017.dump.bz2"

echo "Command.new.specialcreate('firsthalfyear', Date.parse('15-07-2017'), Date.parse('01-01-2017'), Date.parse('30-06-2017'))" | rails c

#Third quarter
./loadsingledump.sh "/home/sandro/Documents/philochbackups/30-09-2017.dump.bz2"

echo "Command.new.specialcreate('thirdquarter', Date.parse('30-09-2017'), Date.parse('30-06-2017'), Date.parse('30-09-2017'))" | rails c


#Latest report for all time, with newest backup
LATESTDUMP=$(./getlatestdump.sh)
echo $LATESTDUMP
DATE=$(echo $LATESTDUMP | cut -b 39-48)
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('alltime', Date.parse('$DATE'), Date.parse('01-10-2016'), Date.parse('$DATE'))" | rails c

#latest report for 30-06-2017 - today
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('secondhalfyear', Date.parse('$DATE'), Date.parse('30-06-2017'), Date.parse('$DATE'))" | rails c



heroku pg:reset --confirm evening-ravine-89617


#push to heroku
heroku pg:push reports_development DATABASE_URL --app evening-ravine-89617

heroku open

#pg_dump -a philosophiech001 | psql reports_development