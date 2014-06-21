FROM ubuntu:14.04
MAINTAINER Luis Elizondo "lelizondo@gmail.com"

# Let's get serf
RUN apt-get install -qy supervisor unzip nginx
ADD https://dl.bintray.com/mitchellh/serf/0.6.1_linux_amd64.zip serf.zip
RUN unzip serf.zip
RUN mv serf /usr/bin/
RUN rm *.zip

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get remove --purge -y unzip
RUN apt-get autoremove -y

# Copy supervisor configuration
ADD ./config/nginx.conf /etc/nginx/nginx.conf
ADD ./config/default-example.conf /etc/nginx/sites-available/default.conf
ADD ./config/supervisord.conf /etc/supervisor/conf.d/supervisord-nginx-serf.conf

# Copy scripts
ADD ./scripts/serf-member-join.sh /serf-member-join.sh
ADD ./scripts/serf-member-leave.sh /serf-member-leave.sh
ADD ./scripts/serf-join.sh /serf-join.sh
ADD ./scripts/start-serf.sh /start-serf.sh
RUN chmod 755 /*.sh

EXPOSE 80

VOLUME ["/etc/nginx/sites-enabled", "/var/files"]

WORKDIR /var/www

CMD ["/usr/bin/supervisord", "-n"]
