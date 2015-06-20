#!/bin/bash
# THIS SCRIPT IS ONLY AN EXAMPLE OF HOW THIS CAN BE ACCOMPLISHED.
HOST="dev.mysite.com";
USER="mystdev";
    SUB=$(ssh -oStrictHostKeyChecking=no ${USER}prd@${HOST} "
    if [ -d ~/htdocs/sites/all/modules/contrib/views ]; then
      cd htdocs
      drush cc all
      curl -O  https://www.drupal.org/files/issues/views-asset-diff-2018737-37.patch >> views-asset-diff-2018737-37.patch
      cd ~/htdocs/sites/all/modules/contrib/views
      patch -p1 < ~/views-asset-diff-2018737-37.patch
      git add .
      git commit -m \"Views patch to eliminate warnings.\"
      git push origin master
      rm -f ~/views-asset-diff-2018737-37.patch
    fi
    ")