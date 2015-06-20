#!/bin/bash
echo "Enter ServerAdmin email:"
read SERVERADMIN
echo "Enter Application Instance Name:"
read INSTANCENAME
echo "Enter Document Root without Trailing Slash:"
read DOCUMENTROOT
function admin {
echo "<VirtualHost *:80>
  ServerAdmin ${SERVERADMIN}
  DocumentRoot ${DOCUMENTROOT}/${INSTANCENAME}
  ServerName ${INSTANCENAME}
  ErrorLog logs/${INSTANCENAME}_error.log
  CustomLog logs/${INSTANCENAME}_access.log
</VirtualHost>"
>> /etc/httpd/conf.d/${INSTANCENAME}.conf
}
admin;
