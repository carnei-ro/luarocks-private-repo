FROM kong:3.0 as inotify

USER root
RUN apk add --no-cache alpine-sdk 
RUN luarocks install inotify INOTIFY_INCDIR=/usr/include/


FROM kong:3.0

USER root
RUN mkdir -p /data/rocks && chown -R kong:kong /data
USER kong

COPY --from=inotify /usr/local/lib/lua/5.1/inotify.so /usr/local/lib/lua/5.1/inotify.so
COPY --from=inotify /usr/local/lib/luarocks/rocks-5.1/inotify /usr/local/lib/luarocks/rocks-5.1/inotify
COPY --from=inotify /usr/local/lib/luarocks/rocks-5.1/manifest /usr/local/lib/luarocks/rocks-5.1/manifest

COPY luarocks-admin-watcher.sh /usr/local/lib/luarocks-admin-watcher.sh
COPY luarocks-entrypoint.sh /luarocks-entrypoint.sh
COPY kong-http-include.conf /data/kong-http-include.conf

ENV KONG_NGINX_HTTP_INCLUDE=/tmp/kong-http-include.conf

ENTRYPOINT [ "/luarocks-entrypoint.sh" ]

CMD [ "kong", "docker-start" ]