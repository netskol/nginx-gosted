FROM nginx:1.15.7

RUN set -eux \
  && export OPENSSL_CONF=/etc/ssl/openssl.cnf \
  && export GOST_PACKAGE=libengine-gost-openssl1.1_1.1.0.3-1_amd64.deb \
  && apt-get update \
  && apt-get install openssl wget -y \
  # get Gost engine deb packet
  && cd /tmp && wget http://ftp.ru.debian.org/debian/pool/main/libe/libengine-gost-openssl1.1/"${GOST_PACKAGE}" \
  && dpkg -i /tmp/"${GOST_PACKAGE}" \
  # enable GOST engine
  # enable GOST engine
  && sed -i '6i openssl_conf=openssl_def' "${OPENSSL_CONF}" \
  && echo "" >> "${OPENSSL_CONF}" \
  && echo "# OpenSSL default section" >> "${OPENSSL_CONF}" \
  && echo "[openssl_def]" >> "${OPENSSL_CONF}" \
  && echo "engines = engine_section" >> "${OPENSSL_CONF}" \
  && echo "" >> "${OPENSSL_CONF}" \
  && echo "# Engine scetion" >> "${OPENSSL_CONF}" \
  && echo "[engine_section]" >> "${OPENSSL_CONF}" \
  && echo "gost = gost_section" >> "${OPENSSL_CONF}" \
  && echo "" >> "${OPENSSL_CONF}" \
  && echo "# Engine gost section" >> "${OPENSSL_CONF}" \
  && echo "[gost_section]" >> "${OPENSSL_CONF}" \
  && echo "engine_id = gost" >> "${OPENSSL_CONF}" \
  && echo "dynamic_path = /usr/lib/x86_64-linux-gnu/engines-1.1/gost.so" >> "${OPENSSL_CONF}" \
  && echo "default_algorithms = ALL" >> "${OPENSSL_CONF}" \
  && echo "CRYPT_PARAMS = id-Gost28147-89-CryptoPro-A-ParamSet" >> "${OPENSSL_CONF}" \
  # clean up
  && apt-get remove --purge --auto-remove -y wget \
  && unset OPENSSL_CONF && unset GOST_PACKAGE \
  && rm -rf /var/lib/apt/lists/* /tmp/*.deb

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
