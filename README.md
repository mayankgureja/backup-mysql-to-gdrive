# backup-mysql-to-gdrive

Bash scripts for backing up MySQL DBs to GDrive

## Pre-requisites

We assume mysql is already installed, configured and running on your server.

### 1. Create MySQL user for extracting databases

Launch mysql:
```
sudo mysql -uroot -p
```
and run the following commands after replacing `'password_goes_here'` with a newly generated one for your server:

```
CREATE USER 'lazydev'@'localhost' IDENTIFIED BY 'password_goes_here';

GRANT ALL PRIVILEGES ON *.* TO 'lazydev'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```

### 2. Install and configure rclone

See `rclone` documentation for installation here: https://rclone.org/install

See `rclone` documentation for setting up Drive here: https://rclone.org/drive

For Linux, run:
```
curl https://rclone.org/install.sh | sudo bash

rclone config
```

## How to run

```
sh backup.sh
```

## Set up Cron job to run weekly backups

Open Cron (use Nano if asked):
```
crontab -e
```

Add the following line to your Cron file (change the path to `backup.sh` as needed):
```
@weekly sh /home/user/backup-mysql-to-gdrive/backup.sh >> /var/log/cron/mysqlbackup.log 2>&1
```

## Useful Links
https://taranjeet.cc/auto-backup-mysql-database-to-google-drive

https://gist.github.com/sutlxwhx/7355dd1a65ea2a0889fb8dee6059283e
