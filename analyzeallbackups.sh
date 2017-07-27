#!/usr/bin/env bash

rails db:drop
rails db:setup

./listofdumpscommands.sh

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

heroku pg:push reports_development DATABASE_URL --app evening-ravine-89617

heroku open

