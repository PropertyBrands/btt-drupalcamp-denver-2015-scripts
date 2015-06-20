#!/bin/bash
echo "Enter Document Root without Trailing Slash:"
read DRUPAL
if [ -z "$DRUPAL" ]
then
  echo "Enter the webroot and we will find Drupal installs for you:"
  read WEBROOT
  DRUPAL=$(find $WEBROOT -maxdepth 5 -type f -wholename /var/www/\*\.com/\*/sites/default/settings.php | egrep -vi 'old|\.bak|_|drush' | grep default | sed -e 's/\/sites\/default\/settings\.php//g')
fi
echo "$DRUPAL"
IFS=' ' read -a TARGETS <<< ${DRUPAL}
for dir in ${TARGETS[@]}
        do echo "Updating Drupal Code Perms : $dir"
        chgrp apache $dir/sites/default/settings.php
        chmod 644 $dir/sites/default/settings.php
        FILESDIR="/0ffa68818f3b27c1c2ccc98542fa8939"
        pushd $dir
        VERSION=$(/usr/local/bin/drush st version | grep Drupal | sed 's/.*\([0-9]\)\.[0-9]*/\1/')
        if [ ${VERSION} = "6" ];then
                FILESDIR="$dir/`/usr/local/bin/drush eval "print variable_get('file_directory_path', 'sites/default/files')"`"
        elif [ ${VERSION} = "7" ];then
                FILESDIR="$dir/`/usr/local/bin/drush eval "print variable_get('file_public_path', 'sites/default/files')"`"
        fi
        popd
        # Initialize private to something that won't match anything in case no private dir exists
        PRIVATEDIR="/0ffa68818f3b27c1c2ccc98542fa8939"
        if [ -d $dir/sites/private ]; then
                PRIVATEDIR="$dir/sites/private"
        elif [ -d $dir/private ]; then
                PRIVATEDIR="$dir/private"
        fi
        find $dir -wholename ${FILESDIR}\* -prune -o -wholename ${PRIVATEDIR}\* -prune -o -type f -exec chmod 0644 {} \;
        find $dir -wholename ${FILESDIR}\* -prune -o -wholename ${PRIVATEDIR}\* -prune -o -type d -exec chmod 2755 {} \;
        if [ "${FILESDIR}" != "/0ffa68818f3b27c1c2ccc98542fa8939" ]; then
                echo "Making Writable: ${FILESDIR}"
                chmod 2775 ${FILESDIR}
                find ${FILESDIR} -type f ! -iname .htaccess -exec chmod 0664 {} \;
                find ${FILESDIR} -type d ! -exec chmod 2775 {} \;
                find ${FILESDIR} \( -path ./advagg\* -prune -o -type f \) -iname .htaccess -exec chmod 0755 {} \;
        fi
        if [ "${PRIVATEDIR}" != "/0ffa68818f3b27c1c2ccc98542fa8939" ]; then
                echo "Making Writable: ${PRIVATEDIR}"
                chmod 2775 ${PRIVATEDIR}
                find ${PRIVATEDIR} -type f ! -iname .htaccess -exec chmod 0664 {} \;
                find ${PRIVATEDIR} -type d ! -exec chmod 2775 {} \;
                find ${PRIVATEDIR} -type f -iname .htaccess -exec chmod 0755 {} \;
        fi
        chown -R --reference ${dir}/sites/default/settings.php ${dir}
done