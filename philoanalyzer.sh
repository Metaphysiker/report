#!/bin/sh
# This program analyzes and philosophie.ch-databases

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
DELETE FROM universities;
DELETE FROM alchemy_contents;
DELETE FROM alchemy_cells;
DELETE FROM alchemy_pages;
DELETE FROM alchemy_elements;
EOF


# delete previous database from philosophie.ch, backups are still availbe in the form of dumps documents/backups
psql reports_development << EOF
       DROP DATABASE philosophiech001;
EOF

# get daily backup from philosophie.ch
scp -P 22000 vpsadmin@havps11.iron.bsa.oriented.ch:/var/backups/pgsql/havps11.pgsql_all.dump.bz2 ~/Downloads

# unzip it
bunzip2 /home/sandro/Downloads/havps11.pgsql_all.dump.bz2

# insert new database
psql reports_development < /home/sandro/Downloads/havps11.pgsql_all.dump

#move it and rename it: documents/backups
mv /home/sandro/Downloads/havps11.pgsql_all.dump /home/sandro/Documents/backups

mv /home/sandro/Documents/backups/havps11.pgsql_all.dump /home/sandro/Documents/backups/"$(date '+%d-%m-%Y').dump"

pg_dump philosophiech001 | psql reports_development

#  create new report -> new analysis

echo 'Command.new.create(date: Date.today)' | rails c

heroku pg:reset --confirm evening-ravine-89617

#push to heroku
heroku pg:push reports_development DATABASE_URL --app evening-ravine-89617

heroku open
