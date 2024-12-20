#!/bin/sh

INSTALL_DIR="$HOME/.backup-borg"

case $(uname -s) in
  Linux)
    if [ -x "/usr/bin/apt" ]; then
      # Debian/Ubuntu
      sudo apt update
      sudo apt install -y borgbackup
      if [ ! -x "/usr/sbin/cron" ]; then
        sudo apt install -y cron
      fi
    elif [ -x "/usr/bin/zypper" ]; then
      # OpenSUSE
      sudo zypper --non-interactive install borgbackup
      if [ ! -x "/usr/sbin/cron" ]; then
        sudo zypper --non-interactive install cron
      fi
    elif [ -x "/usr/bin/dnf" ]; then
      # RHEL
      sudo dnf install -y borgbackup
      if [ ! -x "/usr/sbin/crond" ]; then
        sudo dnf install -y cronie
      fi
    elif [ -x "/usr/bin/apk" ]; then
      # Alpine Linux
      sudo apk add -y borgbackup
      if [ ! -x "/usr/sbin/cron" ]; then
        sudo apk add -y cron
      fi
    else
      echo "Unsupported Linux distribution"
      exit 1
    fi
    ;;
  FreeBSD)
    # FreeBSD
    sudo pkg install -y py37-borgbackup
    if [ ! -x "/usr/sbin/cron" ]; then
      sudo pkg install -y cron
    fi
    ;;
  *)
    echo "Unsupported platform"
    exit 1
    ;;
esac

git clone git@github.com:ackmelab/backup-borg.git "$INSTALL_DIR"

# Create crontab for user to run borg_backup.sh every day at 11pm if it does not already exist
if ! crontab -l | grep -q "$INSTALL_DIR/borg_backup.sh"; then
  (crontab -l ; echo "0 23 * * * $INSTALL_DIR/borg_backup.sh") | crontab -
fi

# Create crontab for user to run borg_update.sh every day at 10pm if it does not already exist
if ! crontab -l | grep -q "$INSTALL_DIR/borg_update.sh"; then
  (crontab -l ; echo "0 22 * * * $INSTALL_DIR/borg_update.sh") | crontab -
fi

crontab -l