FROM nginx:1.19.6


RUN set -eux \
  && export ARCH=$(uname -m) \
  && export OPENSSL_CONF=/etc/ssl/openssl.cnf \
  && apt-get update \
  && apt-get install libengine-gost-openssl1.1 -y \
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
  ## just for compatibility with older browsers, you may delete those two lines
  && sed -i 's/@SECLEVEL=2/@SECLEVEL=1/g' "${OPENSSL_CONF}" \
  && sed -i 's/TLSv1.2/TLSv1/g' "${OPENSSL_CONF}" \
  # clean up
  && unset OPENSSL_CONF \
  && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
