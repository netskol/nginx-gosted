FROM nginx:1.21.5

RUN set -eux \
  && apt-get update \
  && apt-get install openssl wget -y \
  && export ARCH=$(uname -m) \
  && if [ "$ARCH" = "aarch64" ] ; then export SUFFIX="arm64"; else export SUFFIX="amd64"; fi \
  && export OPENSSL_CONF=/etc/ssl/openssl.cnf \
  && export GOST_PACKAGE=libengine-gost-openssl1.1_1.1.0.3-1_"${SUFFIX}".deb \
  # get Gost engine deb packet
  && cd /tmp && wget http://ftp.ru.debian.org/debian/pool/main/libe/libengine-gost-openssl1.1/"${GOST_PACKAGE}" \
  && dpkg -i /tmp/"${GOST_PACKAGE}" \
  # enable GOST engine
  && sed -i '/\[default_conf\]/ a engines = engine_section' "${OPENSSL_CONF}" \
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
  && echo "dynamic_path = /usr/lib/"${ARCH}"-linux-gnu/engines-1.1/gost.so" >> "${OPENSSL_CONF}" \
  && echo "default_algorithms = ALL" >> "${OPENSSL_CONF}" \
  && echo "CRYPT_PARAMS = id-Gost28147-89-CryptoPro-A-ParamSet" >> "${OPENSSL_CONF}" \
   # clean up
  && unset OPENSSL_CONF \
  && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
