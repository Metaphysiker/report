#!/usr/bin/env bash
# ./loadandanalyzeallreports.sh /home/sandro/Documents/philochbackups/*

for i in $@
   do
       echo The current file is $i

       # drop philosophiech database
       psql reports_development << EOF
       DROP DATABASE philosophiech001;
EOF

        # unzips dump
        bunzip2 -kc $i > /home/sandro/Documents/philochbackups/latest.dump

        # insert new database
        psql reports_development < /home/sandro/Documents/philochbackups/latest.dump

        # removes latest.dump
        rm /home/sandro/Documents/philochbackups/latest.dump

        # insert database to reports_development
        pg_dump philosophiech001 | psql reports_development

        # create datapoint


   done

echo "finished"

#OUTPUT="$(ls -1)"