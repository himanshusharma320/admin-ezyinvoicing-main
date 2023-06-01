################# DELETE MORE THAN 3 ITERATIONS  ###########

find /home/frappe/DBbackup  -maxdepth 1 -type f -mtime +2 -exec rm -rf {} \;

###############Backups for every 3 hours ###############

cd /home/frappe/frappe-bench/ && /usr/local/bin/bench --verbose --site all backup --with-files --compress --backup-path /home/frappe/DBbackup
