ARG BASE=latest-html5
FROM sciapp/nojava-ipmi-kvm:${BASE}
LABEL maintainer="Pablo Ruiz <pablo.ruiz@gmail.com>"

COPY main.js /usr/local/kvm-html5/main.js

WORKDIR /root

ENV DISPLAY :0
EXPOSE 8080

