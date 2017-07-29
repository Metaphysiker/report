#!/usr/bin/env bash

#First Half Year with most closest backup
./loadsingledump.sh "/home/sandro/Documents/philochbackups/15-07-2017.dump.bz2"

echo "Command.new.specialcreate('firsthalfyear', Date.parse('15-07-2017'), Date.parse('01-01-2017'), Date.parse('30-06-2017'))" | rails c

#Latest report for all time, with newest backup
LATESTDUMP=$(./getlatestdump.sh)
echo $LATESTDUMP
DATE=$(echo $LATESTDUMP | cut -b 39-48)
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('alltime', Date.parse('$DATE'), Date.parse('01-10-2016'), Date.parse('$DATE'))" | rails c

#latest report for 30-06-2017 - today
./loadsingledump.sh $LATESTDUMP
echo "Command.new.specialcreate('secondhalfyear', Date.parse('$DATE'), Date.parse('30-06-2017'), Date.parse('$DATE'))" | rails c

# deletes all previous data, except reports and universities
psql reports_development << EOF
DELETE FROM alchemy_essence_dates;
DELETE FROM alchemy_attachments;
DELETE FROM alchemy_elements_alchemy_pages;
DELETE FROM alchemy_essence_booleans;
DELETE FROM alchemy_essence_files;
DELETE FROM alchemy_essence_htmls;
DELETE FROM alchemy_essence_links;
DELETE FROM alchemy_essence_pictures;
DELETE FROM alchemy_essence_richtexts;
DELETE FROM alchemy_essence_selects;
DELETE FROM alchemy_essence_texts;
DELETE FROM alchemy_essence_topics;
DELETE FROM alchemy_essence_topics_topics;
DELETE FROM alchemy_folded_pages;
DELETE FROM alchemy_languages;
DELETE FROM alchemy_legacy_page_urls;
DELETE FROM alchemy_pictures;
DELETE FROM alchemy_sites;
DELETE FROM alchemy_users;
DELETE FROM comments;
DELETE FROM follows;
DELETE FROM friendly_id_slugs;
DELETE FROM profiles;
DELETE FROM profiles_topics;
DELETE FROM societies;
DELETE FROM subscriptions;
DELETE FROM subscriptions_topics;
DELETE FROM taggings;
DELETE FROM tags;
DELETE FROM topics;
DELETE FROM alchemy_contents;
DELETE FROM alchemy_cells;
DELETE FROM alchemy_pages;
DELETE FROM alchemy_elements;
EOF

heroku pg:reset --confirm evening-ravine-89617

#push to heroku
heroku pg:push reports_development DATABASE_URL --app evening-ravine-89617

heroku open