FROM centos:latest
MAINTAINER ingktds <tadashi.1027@gmail.com>

RUN yum -y install postfix cyrus-sasl epel-release
RUN yum -y install supervisor
ENV	DOMAIN "ingk.xyz"
ENV PASSWORD "webmaster"
RUN postconf -e myhostname=mail.${DOMAIN}
RUN postconf -e mydomain=${DOMAIN}
RUN postconf -e myorigin=\$mydomain
RUN postconf -e inet_interfaces=all
RUN postconf -e mydestination=\$myhostname,localhost.\$mydomain,localhost,\$mydomain
RUN postconf -e home_mailbox=Maildir/
RUN postconf -e smtpd_bunner='$myhostname ESMTP unknown'
RUN postconf -e smtpd_sasl_auth_enable=yes
RUN postconf -e smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd
RUN postconf -e smtp_sasl_mechanism_filter=plain
RUN postconf -e smtpd_sasl_local_domain=$myhostname
RUN postconf -e smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_unauth_destination
RUN sed -i 's/nodaemon=false/nodaemon=true/' /etc/supervisord.conf
RUN sed -i 's/;port=127\.0\.0\.1:9001/port=0.0.0.0:9001/' /etc/supervisord.conf
RUN sed -i 's/^serverurl/;serverurl/' /etc/supervisord.conf
RUN sed -i 's#;serverurl=http://127.0.0.1:9001#serverurl=http://0.0.0.0:9001#' /etc/supervisord.conf
ADD postfix.ini /etc/supervisord.d/
ADD saslauthd.ini /etc/supervisord.d/
RUN useradd -s /sbin/nologin -p $PASSWORD webmaster

EXPOSE 25
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]