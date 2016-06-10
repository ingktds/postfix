#!/bin/bash

# install package
yum -y install postfix cyrus-sasl-*

# main.cf settings
DOMAIN=toban.ingk.xyz
cat <<EOF >> /etc/postfix/main.cf
myhostname = mail.${DOMAIN}
mydomain = ${DOMAIN}
myorigin = \$mydomain
inet_interfaces = all
mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain
home_mailbox = Maildir/
smtpd_banner = \$myhostname ESMTP unknown
smtpd_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_mechanism_filter = plain
smtpd_sasl_local_domain = \$myhostname
smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
EOF

# master.cf settings
sed -i -r 's/#submission(.*)/submission\1/' /etc/postfix/master.cf
sed -i '1,/#  -o smtpd_sasl_auth_enable=yes/s/#  -o smtpd_sasl_auth_enable=yes/  -o smtpd_sasl_auth_enable=yes/' /etc/postfix/master.cf
sed -i '1,/#  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject/s/#  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject/  -o smtpd_recipient_restrictions=permit_sasl_authenticated,reject/' /etc/postfix/master.cf

mkdir -p -m 700 /etc/skel/Maildir/{new,cur,tmp}
useradd -s /sbin/nologin info

systemctl enable postfix.service
systemctl enable saslauthd.service

