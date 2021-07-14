#
#         _/|       |\_
#        /  |       |  \
#       |    \     /    |
#       |  \ /     \ /  |
#       | \  |     |  / |
#       | \ _\_/^\_/_ / |
#       |    --\//--    |                         Script to Upgrade MySQL 5.7 to MySQL 8
#        \_  \     /  _/                                Written by Chris Ruggieri
#          \__  |  __/                                   
#             \ _ /
#            _/   \_   
#           / _/|\_ \  
#            /  |  \   
#   
#Directions:
#
#Usage = ./mysql5.7-mysql8upgrade.sh <mysql_username> <mysql_password> <name of output_file>
#Sudo run Script 

#!/bin/bash

# Block of code to export non-schema specfic databases from MySQL 5.7
SQL="SET group_concat_max_len = 1024 * 1024;"
SQL="${SQL} SELECT GROUP_CONCAT(schema_name separator ' ')"
SQL="${SQL} FROM information_schema.schemata WHERE schema_name NOT IN"
SQL="${SQL} ('information_schema','performance_schema','mysql','sys')"
DBLIST=`mysql -u $1 -p$2 -AN -e"${SQL}"`
mysqldump -u $1 -p -B ${DBLIST} > $3

#Block of code to remove all vestiges of MySQL from the system
apt remove -y mysql* 
mv /var/lib/mysql /var/lib/mysql_old_backup
mv /etc/mysql /etc/mysql_old_backup
apt autoremove -y
apt-get clean 
apt-get purge mysql*
apt-get install -f -y


# Block to update APT library for MySQL 8 and install it
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.11-1_all.deb
dpkg -i mysql-apt-config_0.8.11-1_all.deb
apt-get update -y
apt install -y mysql-server 

# Block to import MySQL 5.7 datadump into MySQL 8
mysql -u $1 -p$2 < $3
systemctl restart mysql
