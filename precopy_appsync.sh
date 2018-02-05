#!/bin/bash

APP_VOLUME=${APP_VOLUME:-/app_sync}
HOST_VOLUME=${HOST_VOLUME:-/host_sync}
OWNER_UID=${OWNER_UID:-0}

if [ ! -f /unison/initial_sync_finished ]; then
  echo "doing initial sync with rsync"
  # we use ruby due to http://mywiki.wooledge.org/BashFAQ/050
  export EXCLUDES="${UNISON_EXCLUDES//-ignore='BelowPath /--exclude='/}"
  time ruby -e 'system "rsync --archive #{ENV["EXCLUDES"]} --numeric-ids --delete /host_sync/ /app_sync/"'
  echo "chown ing file to uid $OWNER_UID"
  chown -R $OWNER_UID $APP_VOLUME
  touch /unison/initial_sync_finished
  echo "initial sync done using rsync" >> /tmp/unison.log
else
  echo "skipping initial copy with rsync"
fi
