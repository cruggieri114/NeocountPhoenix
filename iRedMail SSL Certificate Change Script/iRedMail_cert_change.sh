#! /bin/bash

date +"%Y"
date +"%y"
 
## Store to a shell variable ##
mydate=$(date +'%Y')
myyear=`date +'%Y'`

echo "########### Command 1: Extracting Key and Cert from PFX ###########"

openssl pkcs12 -in /home/user/path/to/your/cert/yourcert.pfx -nocerts -out /home/user/path/to/your/cert/cert_staging/iRedMail.key -nodes
openssl pkcs12 -in /home/user/path/to/your/cert/yourcert.pfx -nokeys -out /home/user/path/to/your/cert/cert_staging/iRedMail.crt

echo "########### Command 2: Renameing and Moving Old Certificates ###########"

mv /etc/ssl/certs/iRedMail.crt /home/user/path/to/your/cert/oldcerts/$myyear.yourcert.crt.bak       # Backup. Rename iRedMail.crt to [currentyear].yourcert.crt.bak
mv /etc/ssl/private/iRedMail.key /home/user/path/to/your/cert/oldcerts/$myyear.mail.yourcert.key.bak       # Backup. Rename iRedMail.key to [currentyear].yourcert.key.bak

echo "########### Command 3: Moving New Certificates Into Place ###########"

cp /home/user/path/to/your/cert/cert_staging/iRedMail.crt /etc/ssl/certs/iRedMail.crt              #Copy the new certificate into place
cp /home/user/path/to/your/cert/cert_staging/iRedMail.key /etc/ssl/private/iRedMail.key            #Copy the new key into place

echo "########### Command 4: Start Network Services ###########"    

service postfix restart
service dovecot restart
service nginx restart
service mysql restart

echo "########### Command 5: Cleanup ###########"  

rm -f /home/user/path/to/your/cert/cert_staging/*