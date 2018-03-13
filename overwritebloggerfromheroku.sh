#!/usr/bin/env bash
export DISPLAY=:0
# this gets database of heroku
heroku pg:backups:capture

heroku pg:backups:download

# this overwrites database
pg_restore --verbose --clean -t bloggers -d reports_development latest.dump

#migrate?
rails db:migrate


kdialog --passivepopup 'Finished.' 5