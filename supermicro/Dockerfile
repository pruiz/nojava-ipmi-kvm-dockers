FROM debian:bullseye
LABEL maintainer="Pablo Ruiz <pablo.ruiz@gmail.com>"

# Install needed packages and Java dependencies (second `apt-get install` call)
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl lftp wget eterm fluxbox net-tools procps python3-numpy \
                                               python3-pip python3-pyquery python3-wheel supervisor tar x11vnc xvfb && \
    # Add support for asian characters
    apt-get install -y --no-install-recommends fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho \
                                               fonts-ipafont-gothic fonts-unfonts-core && \
    pip install future requests 'websockify<0.10' && \
    rm -rf /var/lib/apt/lists/*

RUN NOVNC_VERSION="1.1.0" && \
    curl -o /tmp/novnc.tar.gz  -L "https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz" && \
    tar -xvf /tmp/novnc.tar.gz -C /opt/ && \
    ln -s "/opt/noVNC-${NOVNC_VERSION}/utils/launch.sh" /usr/local/bin/launch_novnc && \
    rm -f /tmp/novnc.tar.gz

ARG SMCIT=https://www.supermicro.com/wdl/utility/SMCIPMITool/Linux/SMCIPMITool_2.26.0_build.220209_bundleJRE_Linux_x64.tar.gz
#ARG SMCIT=ftp://ftp.oldskool.org/pub/drivers/SuperMicro/SMCIPMITool_2.16.0_build.160816_bundleJRE_Linux_x64.tar.gz
#ARG SMCIT=ftp://ftp.abacus.cz/distribuce/supermicro/sw/SMCIPMITool/SMCIPMITool_2.16.0_build.160816_bundleJRE_Linux_x64.tar.gz
RUN wget -O /tmp/pkg.tgz "$SMCIT" && \
    tar -xvf /tmp/pkg.tgz -C /opt/ && \
    mv /opt/SMCIPMITool_* /opt/SMCIPMITool && \
    rm -f /tmp/pkg.tgz 

COPY main.sh /init.sh
COPY smtool.sh /smtool.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /root

ENV DISPLAY :0
EXPOSE 8080

ENTRYPOINT ["/init.sh"]
