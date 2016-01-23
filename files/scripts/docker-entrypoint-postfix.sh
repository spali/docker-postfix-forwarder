#!/bin/bash
###############################################################################
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

echo "Executing $BASH_SOURCE"

if [ ${ENTRYPOINT_INITIALIZED}=false ]; then

	postconf "smtp_tls_key_file = ${SSL_DIR}/postfix.key"

	if [ -n "${CONF_POSTFIX_RELAYHOST=}" ]; then
		postconf "relayhost = ${CONF_POSTFIX_RELAYHOST}"
		if [ -n "${CONF_POSTFIX_RELAY_USER=}" ]; then
			echo "${CONF_POSTFIX_RELAYHOST}	${CONF_POSTFIX_RELAY_USER}:${CONF_POSTFIX_RELAY_PASSWORD=}" >/etc/postfix/sasl_passwd
			chmod 400 /etc/postfix/sasl_passwd
			postmap /etc/postfix/sasl_passwd
			postconf "smtp_sasl_auth_enable = yes"
			postconf "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd"
		fi
		if [ -n "${CONF_POSTFIX_MYNETWORKS=}" ]; then
			postconf "mynetworks = ${CONF_POSTFIX_MYNETWORKS} 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"
		fi
	fi

	# disable chroot
	postconf -F smtp/inet/chroot=n

fi

# copy config files required postfix
cp /etc/services /var/spool/postfix/etc/services
cp /etc/resolv.conf /var/spool/postfix/etc


