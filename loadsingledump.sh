#!/usr/bin/env bash
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


# delete previous database from philosophie.ch, backups are still availbe in the form of dumps documents/backups
psql reports_development << EOF
       DROP DATABASE philosophiech001;
EOF

echo "argument: $1"

# unzips dump
bunzip2 -kc $1 > /home/sandro/Documents/philochbackups/latest.dump

# insert new database
psql reports_development < /home/sandro/Documents/philochbackups/latest.dump

# removes latest.dump
rm /home/sandro/Documents/philochbackups/latest.dump

# insert database to reports_development
pg_dump -a philosophiech001 | psql reports_development

