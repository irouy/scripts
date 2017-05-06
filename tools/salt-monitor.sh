#!/bin/bash

salt "*" cmd.run "df -h" > /srv/www/htdocs/SALT/MONITOR/salt-diskspace
salt "*" cmd.run "uptime" > /srv/www/htdocs/SALT/MONITOR/salt-uptime
salt "*" cmd.run "uname -a" > /srv/www/htdocs/SALT/MONITOR/salt-uname
salt "*" cmd.run "date" > /srv/www/htdocs/SALT/MONITOR/salt-date
salt-key -L > /srv/www/htdocs/SALT/MONITOR/salt-key
