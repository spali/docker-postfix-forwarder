FROM debian:jessie

#######################################################################################
# setting default locale
ENV LC_ALL en_US.UTF-8

# prepare apt and system (first clean is required to prevent gpg keys errors)
RUN apt-get clean && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	locales && \
	sed -e 's/.*\(en_US\.UTF-8.*\)/\1/' \
		-i /etc/locale.gen && \
	DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	apt-get clean

# install packages
RUN	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	postfix ca-certificates openssl-blacklist sasl2-bin libsasl2-modules && \
	apt-get clean


#######################################################################################
# configuration variable defaults
#ENV CONF_POSTFIX_RELAYHOST
#ENV CONF_POSTFIX_RELAY_USER
#ENV CONF_POSTFIX_RELAY_PASSWORD
#ENV CONF_POSTFIX_MYNETWORKS

#######################################################################################
COPY files/ /
RUN chmod +x /scripts/*
ENTRYPOINT ["/scripts/docker-entrypoint.sh"]
CMD ["/scripts/docker-command.sh"]
#######################################################################################
# expose ports
EXPOSE 25
#######################################################################################

