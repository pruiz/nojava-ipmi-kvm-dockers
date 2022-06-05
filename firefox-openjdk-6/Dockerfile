FROM mablanco/firefox-java-vnc:20200830
LABEL maintainer="Pablo Ruiz <pablo.ruiz@gmail.com>"

RUN echo "deb http://archive.debian.org/debian wheezy main contrib" > /etc/apt/sources.list \
 && echo "deb http://archive.debian.org/debian wheezy-backports main contrib" >> /etc/apt/sources.list \
 && echo "deb http://archive.debian.org/debian-security wheezy updates/main updates/contrib" >> /etc/apt/sources.list

COPY websockify_0.6.0+dfsg1-1_amd64.deb /tmp

RUN apt-get update \
 && apt-get install -y --force-yes --no-install-recommends ca-certificates curl supervisor python-numpy \
 && dpkg -i /tmp/websockify* \
 && update-alternatives --set itweb-settings /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/itweb-settings \
 && apt-get -y autoremove \
 && apt-get clean \
 && rm -rf /var/lib/{apt,dpkg,cache,log}

#RUN pip install -i https://pypi.python.org/simple -U pip distribute
#RUN pip install future requests websockify

RUN NOVNC_VERSION="1.1.0" && \
    curl -o /tmp/novnc.tar.gz  -L "https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz" && \
    tar -xvf /tmp/novnc.tar.gz -C /opt/ && \
    ln -s "/opt/noVNC-${NOVNC_VERSION}/utils/launch.sh" /usr/local/bin/launch_novnc && \
    rm -f /tmp/novnc.tar.gz

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY init.sh /init.sh

WORKDIR /tmp

ENV DISPLAY :0
EXPOSE 8080

ENTRYPOINT ["/init.sh"]
