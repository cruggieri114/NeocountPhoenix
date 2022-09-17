#
#         _/|       |\_
#        /  |       |  \
#       |    \     /    |
#       |  \ /     \ /  |
#       | \  |     |  / |
#       | \ _\_/^\_/_ / |
#       |    --\//--    |                         Script to Harden SSL/TLS settings and remove weak, deprecated Cipher Suites for Linux
#        \_  \     /  _/                                Written by Chris Ruggieri
#          \__  |  __/                                   
#             \ _ /
#            _/   \_   
#           / _/|\_ \  
#            /  |  \   
#   
# NOTE: This does not disable SSLv2.0, SSLv3.0, TLSv1.0, or TLSv1.1.  Those settings are found in the perspective web server directories
# Apache = /etc/httpd/conf.d/httpd.conf or /etc/apache2/mods-available/ssl.conf depending on CentOS/RHEL or Ubuntu/Debian = SSLProtocol All -SSLv2 -SSLv3 -TLSv1.0 -TLSv1.1
# Nginx = /etc/sysconfig/nginx (usually) = ssl_protocols TLSv1.2; 
# Exim (email server) = /etc/exim.conf = ALL:!ADH:+HIGH:+MEDIUM:-LOW:-SSLv2:-SSLv3:!TLSv1.0:!TLSv1.1:-EXP
# Dovecot = /etc/dovecot/local.conf = ssl_protocols = !SSLv2 !SSLv3 !TLSv1.0 !TLSv1.1
# and remember to restart the services when you're done
#
#Usage = Run as sudo CipherSuite_Hardening.sh

#!/bin/bash

#This will strip out the weak cipher suites server side
sshd -T | grep ciphers | sed -e "s/\(3des-cbc\|aes128-cbc\|aes192-cbc\|aes256-cbc\|arcfour\|arcfour128\|arcfour256\|blowfish-cbc\|cast128-cbc\|rijndael-cbc@lysator.liu.se\)\,\?//g" >> /etc/ssh/sshd_config

#This will strip out the weak cipher suites client side
sshd -T | grep ciphers | sed -e "s/\(3des-cbc\|aes128-cbc\|aes192-cbc\|aes256-cbc\|arcfour\|arcfour128\|arcfour256\|blowfish-cbc\|cast128-cbc\|rijndael-cbc@lysator.liu.se\)\,\?//g" >> /etc/ssh/sshd_config

#This of course restarts the service.
service sshd restart