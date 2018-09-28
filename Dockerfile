FROM php:7.2-apache

# Install packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor pwgen && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client

EXPOSE 80
EXPOSE 443

CMD exec supervisord -n
