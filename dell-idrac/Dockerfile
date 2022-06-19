ARG BASE=latest-openjdk-7
FROM sciapp/nojava-ipmi-kvm:${BASE}
LABEL maintainer="Pablo Ruiz <pablo.ruiz@gmail.com>"

COPY get_java_viewer.sh /usr/local/bin/get_java_viewer
COPY import_jnlp_cert.py /usr/local/bin/import_jnlp_cert.py

WORKDIR /root

ENV DISPLAY :0
EXPOSE 8080

#ENTRYPOINT ["/init.sh"]
