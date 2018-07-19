FROM rdeinum/rpi-oracle-java:8-jdk

ARG archiva_version=2.2.3
ARG archiva_package=apache-archiva-${archiva_version}-bin.tar.gz
ARG archiva_download_url=http://apache.mirror.triple-it.nl/archiva/2.2.3/binaries/${archiva_package}
ARG archiva_download_sha256_hash=cf90d097e7c2763f6ff8df458b64be0348b35847de8b238c3e1e28e006da8bad
ARG archiva_user=archiva
ARG archiva_group=archiva
ARG archiva_uid=1000
ARG archiva_gid=1000

ENV ARCHIVA_VERSION=${archiva_version}
ENV ARCHIVA_HOME=/opt/apache-archiva-${ARCHIVA_VERSION}
ENV ARCHIVA_BASE=/var/archiva

RUN apt-get -y install xmlstarlet \
	&& mkdir $ARCHIVA_BASE

RUN curl -fSL ${archiva_download_url} -o /tmp/${archiva_package} \
	&& echo "${archiva_download_sha256_hash} /tmp/${archiva_package}" | sha256sum -c - \
	&& tar -C /opt -xvzf /tmp/${archiva_package} \
	&& rm /tmp/${archiva_package}

ARG wrapper_version=3.5.35
ARG wrapper_name=wrapper-linux-armhf-32-${wrapper_version}
ARG wrapper_package=${wrapper_name}.tar.gz
ARG wrapper_download_url=https://download.tanukisoftware.com/wrapper/${wrapper_version}/${wrapper_package}

RUN curl -fSL ${wrapper_download_url} -o /tmp/${wrapper_package} \
	&& tar -C /tmp -xvzf /tmp/${wrapper_package} \ 
	&& rm /tmp/${wrapper_package} \
	&& mv ${ARCHIVA_HOME}/lib/wrapper.jar ${ARCHIVA_HOME}/lib/wrapper.jar.org \
	&& cp /tmp/${wrapper_name}/lib/wrapper.jar ${ARCHIVA_HOME}/lib \ 
	&& chmod +x ${ARCHIVA_HOME}/lib/wrapper.jar \
	&& cp /tmp/${wrapper_name}/lib/libwrapper.so ${ARCHIVA_HOME}/lib \
	&& cp /tmp/${wrapper_name}/bin/wrapper ${ARCHIVA_HOME}/bin \
	&& rm -rf /tmp/${wrapper_name} 

COPY run-archiva /usr/local/bin

RUN groupadd -g ${archiva_gid} ${archiva_group} \
	&& useradd -u ${archiva_uid} -g ${archiva_gid} -m -s /bin/bash ${archiva_user} \
	&& chown -R ${archiva_uid}:${archiva_gid} ${ARCHIVA_HOME} \
	&& chown -R ${archiva_uid}:${archiva_gid} ${ARCHIVA_BASE}

USER ${archiva_user}

EXPOSE 8080

VOLUME ${ARCHIVA_BASE}

CMD ["run-archiva"]
