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
RUN postconf -e smtpd_sasl_auth_enable=yes
RUN postconf -e smtp_sasl_mechanism_filter=plain
RUN postconf -e smtpd_sasl_local_domain=$myhostname
RUN postconf -e smtpd_recipient_restrictions='permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination'
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
RUN useradd -s /sbin/nologin -p $PASSWORD webmaster

EXPOSE 25
CMD [ "/usr/local/bin/run.sh" ]
