#!/bin/bash

read -r -s PASSWD
#echo "${PASSWD}" | /usr/local/bin/get_java_viewer -o /tmp/launch.jnlp "$@"
return_code="$?"
if [[ "${return_code}" -ne 0 ]]; then
    exit "${return_code}"
fi

# Replace variables in `/etc/supervisord.conf`
for v in XRES VNC_PASSWD; do
    eval sed -i "s/{$v}/\$$v/" /etc/supervisor/conf.d/supervisord.conf
done

# Set the lowest possible security level
# But first, call `import` to init the config directory structure (command will fail without X, but this is OK)
mkdir -p "/root/.java/deployment"
itweb-settings set deployment.security.level ALLOW_UNSIGNED
itweb-settings set deployment.security.jsse.hostmismatch.warning false
#itweb-settings set deployment.manifest.attributes.check false
itweb-settings set deployment.manifest.attributes.check NONE
itweb-settings set deployment.security.notinca.warning false
itweb-settings set deployment.security.expired.warning false
export JAVA_SECURITY_DIR="/root/.config/icedtea-web/security"
mkdir -p "${JAVA_SECURITY_DIR}"
#echo | openssl s_client -showcerts -servername ${KVM_HOSTNAME} -connect ${KVM_HOSTNAME}:443 2>/dev/null | openssl x509 -inform pem -outform pem > /root/cert.pem
#keytool -importcert -noprompt -file /root/cert.pem -keystore "${JAVA_SECURITY_DIR}/trusted.certs" -storepass changeit
#python /usr/local/bin/import_jnlp_cert.py

exec /usr/bin/supervisord
