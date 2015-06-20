#!/bin/bash
echo "Enter web root with out trailing slash:"
read WEBROOT
find ${WEBROOT} -maxdepth 5 -type f -wholename /var/www/\*\.com/\*/sites/default/settings.php | egrep -vi 'old|\.bak|_|drush' | grep default | sed -e 's/\/sites\/default\/settings\.php//g';
