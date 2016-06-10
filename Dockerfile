FROM centos:latest
MAINTAINER ingktds <tadashi.1027@gmail.com>

ADD setup.sh /usr/local/bin/setup.sh
RUN /usr/local/bin/setup.sh

EXPOSE 25
EXPOSE 587
CMD [ "/sbin/init" ]
