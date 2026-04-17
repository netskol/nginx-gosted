FROM nginx:1.30.0-bookworm

RUN set -eux \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    openssl \
    curl \
    libengine-gost-openssl \
  && rm -rf /var/lib/apt/lists/*

COPY openssl-gost.cnf.append /tmp/openssl-gost.cnf.append

RUN set -eux \
  && OPENSSL_CONF=/etc/ssl/openssl.cnf \
  && sed -i '/\[openssl_init\]/ a engines = engine_section' "${OPENSSL_CONF}" \
  && cat /tmp/openssl-gost.cnf.append >> "${OPENSSL_CONF}" \
  && rm /tmp/openssl-gost.cnf.append

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

STOPSIGNAL SIGTERM

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD openssl engine gost && nginx -t || exit 1

CMD ["nginx", "-g", "daemon off;"]
