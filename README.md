# backup-mysql-to-gdrive

Bash scripts for backing up MySQL DBs to GDrive

## Prerequisites

We assume `mysql` is already installed, configured and running on your server.

### 1. Create MySQL User For Exporting Databases

Launch mysql:
```shell
sudo mysql -uroot -p
```
and run the following commands after replacing `'password_goes_here'` with a newly generated one for your server:

```sql
CREATE USER 'lazydev'@'localhost' IDENTIFIED BY 'password_goes_here';

GRANT ALL PRIVILEGES ON *.* TO 'lazydev'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
```

### 2. Install and configure `rclone`

See `rclone` documentation for installation here: https://rclone.org/install

See `rclone` documentation for setting up Drive here: https://rclone.org/drive

For Linux, run:
```shell
curl https://rclone.org/install.sh | sudo bash

rclone config
```

**Tip:** Set up a common *remote* for all servers where this task will run, so you can reuse for multiple servers' database backups. This will allow you to run `rclone config` only once and then copy the `rclone.conf` file to each server without needing to go through configuration again. You can differentiate between the backups for each server using the `SERVER_ALIAS` environment variable outlined below.

### 3. Setup Environment Variables

Make a copy of `.env.example` in the root of this application and name it `.env`. Change the variables as needed.

**NOTE: These should be kept secret and not checked-in to any source control.**

```shell
DB_USERNAME=As set up in Step 1 above
DB_PASSWORD=As set up in Step 1 above
RCLONE_REMOTE=The name of the remote you set up in Step 2
SERVER_ALIAS=The name of the folder into which the server's backup is stored within the remote. Name as appropriate to help differentiate between servers
```

## How To Run

```shell
sh backup.sh
```

## Run Weekly Backups Using Cron

Open Cron (use Nano if asked):
```shell
crontab -e
```

Add the following line to your Cron file (change the path to `backup.sh` as needed):
```shell
@weekly sh /home/user/backup-mysql-to-gdrive/backup.sh >> /home/user/backup-mysql-to-gdrive/logs/cron.log 2>&1
```

## Useful Links

https://taranjeet.cc/auto-backup-mysql-database-to-google-drive

https://gist.github.com/sutlxwhx/7355dd1a65ea2a0889fb8dee6059283e
