FROM centos:latest
MAINTAINER ingktds <tadashi.1027@gmail.com>

RUN yum -y install postfix cyrus-sasl
ENV	DOMAIN "ingk.xyz"
ENV PASSWORD "webmaster"
RUN postconf -e myhostname=toban.${DOMAIN}
RUN postconf -e mydomain=${DOMAIN}
RUN postconf -e myorigin='$mydomain'
RUN postconf -e inet_interfaces=all
RUN postconf -e mydestination='$myhostname, localhost.$mydomain, localhost, $mydomain'
RUN postconf -e home_mailbox=Maildir/
RUN postconf -e smtpd_banner='$myhostname ESMTP unknown'
RUN postconf -e relayhost=
RUN postconf -e smtpd_sasl_auth_enable=yes
RUN postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
RUN postconf -e smtp_sasl_mechanism_filter=plain
RUN postconf -e smtpd_sasl_local_domain='$myhostname'
RUN postconf -e smtpd_recipient_restrictions='permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
RUN mkdir -p -m 700 /etc/skel/Maildir/{new,cur,tmp}
RUN useradd -s /sbin/nologin -p $PASSWORD webmaster
RUN echo $PASSWORD | saslpasswd2 -p -u $DOMAIN -c webmaster
RUN sasldblistusers2
RUN chgrp postfix /etc/sasldb2
RUN systemctl enable postfix.service
RUN systemctl enable saslauthd.service

EXPOSE 25
CMD [ "/sbin/init" ]
