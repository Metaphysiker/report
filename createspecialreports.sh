#!/usr/bin/env bash

#In case relations are not found, do this: rails db < db/reportswithoutconnect.dump
# Then ./createspecialreports.sh

#create a check entry
rails runner 'Checked.new.checkfinished'

#delete existing reports
rails runner 'Report.delete_all'

# name - date of backup - startdate - enddate

# First Half Year 2017 with most closest backup
./loadsingledump.sh "/home/sandro/Documents/philochbackups/15-07-2017.dump.bz2"

echo "Command.new.specialcreate('firsthalfyear2017', Date.parse('15-07-2017'), Date.parse('01-01-2017'), Date.parse('30-06-2017'))" | rails c

# Second half year 2017

./loadsingledump.sh "/home/sandro/Documents/philochbackups/01-01-2018.dump.bz2"

echo "Command.new.specialcreate('secondhalfyear2017', Date.parse('01-01-2018'), Date.parse('01-07-2017'), Date.parse('31-12-2017'))" | rails c

#year 2017

./loadsingledump.sh "/home/sandro/Documents/philochbackups/31-12-2017.dump.bz2"

echo "Command.new.specialcreate('year2017', Date.parse('31-12-2017'), Date.parse('01-01-2017'), Date.parse('31-12-2017'))" | rails c

#year 2018

./loadsingledump.sh "/home/sandro/Documents/philochbackups/31-12-2018.dump.bz2"

echo "Command.new.specialcreate('year2018', Date.parse('31-12-2018'), Date.parse('01-01-2018'), Date.parse('31-12-2018'))" | rails c


# First Half Year 2018
./loadsingledump.sh "/home/sandro/Documents/philochbackups/01-07-2018.dump.bz2"

echo "Command.new.specialcreate('firsthalfyear2018', Date.parse('01-07-2018'), Date.parse('01-01-2018'), Date.parse('30-06-2018'))" | rails c

#Third quarter - removed from auswahl
#./loadsingledump.sh "/home/sandro/Documents/philochbackups/30-09-2017.dump.bz2"

#echo "Command.new.specialcreate('thirdquarter', Date.parse('30-09-2017'), Date.parse('30-06-2017'), Date.parse('30-09-2017'))" | rails c


#First quarter 2018 - removed from auswahl
#./loadsingledump.sh "/home/sandro/Documents/philochbackups/01-04-2018.dump.bz2"

#echo "Command.new.specialcreate('firstquarter18', Date.parse('01-04-2018'), Date.parse('30-06-2017'), Date.parse('31-03-2018'))" | rails c


#Latest report for all time, with newest backup
LATESTDUMP=$(./getlatestdump.sh)
echo $LATESTDUMP
DATE=$(echo $LATESTDUMP | cut -b 39-48)
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('alltime', Date.parse('$DATE'), Date.parse('01-10-2016'), Date.parse('$DATE'))" | rails c

#latest report for 30-06-2017 - today - removed from auswahl
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('secondhalfyear2017f', Date.parse('$DATE'), Date.parse('30-06-2017'), Date.parse('$DATE'))" | rails c

#latest report for 01-01-2017 - today
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('actual2017', Date.parse('$DATE'), Date.parse('01-01-2017'), Date.parse('$DATE'))" | rails c

#latest report for 01-01-2018 - today
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('actual2018', Date.parse('$DATE'), Date.parse('01-01-2018'), Date.parse('$DATE'))" | rails c

#latest report for 01-01-2019 - today
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('actual2019', Date.parse('$DATE'), Date.parse('01-01-2019'), Date.parse('$DATE'))" | rails c



heroku pg:reset --confirm reportseite


#push to heroku
heroku pg:push reports_development DATABASE_URL --app reportseite

heroku open

#pg_dump -a philosophiech001 | psql reports_development.
