#!/bin/sh
mkdir -p ${LUAROCKS_ADMIN_ROCKS_DIR:-/data/rocks} && \
echo "Watching .rock files in ${LUAROCKS_ADMIN_ROCKS_DIR:-/data/rocks}" && \

sed -e "s|__ROCKS_DIR__|${LUAROCKS_ADMIN_ROCKS_DIR:-/data/rocks}|g" \
  /usr/local/lib/luarocks-admin-watcher.sh > /tmp/luarocks-admin-watcher.sh && \
chmod +x /tmp/luarocks-admin-watcher.sh && \

sed -e "s|__LUAROCKS_ADMIN_LISTEN__|${LUAROCKS_ADMIN_LISTEN:-127.0.0.1:7080}|g" \
    -e "s|__ROCKS_DIR__|${LUAROCKS_ADMIN_ROCKS_DIR:-/data/rocks}|g" \
     /data/kong-http-include.conf > /tmp/kong-http-include.conf && \

/tmp/luarocks-admin-watcher.sh 2>&1 &
/docker-entrypoint.sh "$@"