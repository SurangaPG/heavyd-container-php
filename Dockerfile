#!/usr/bin/env docker

FROM ubuntu:16.04
MAINTAINER Suranga Gamage <suranga@webct.bem>

ENV INITRD=No TERM=dumb MY_TZ=Europe/Brussels
ENV DEBIAN_FRONTEND noninteractive

# Install LAMP stack
RUN apt-get update
RUN apt-get -qq upgrade

RUN apt-get install -y --force-yes \
	build-essential \
	imagemagick \
	ca-certificates \
	apache2 \
	libapache2-mod-php7.0 \
	php7.0 \
	php7.0-cli \
	php7.0-dev \
	php7.0-bcmath \
	php7.0-bz2 \
	php7.0-mysql \
	php7.0-mbstring \
	php7.0-mcrypt \
	php7.0-gd \
	php-imagick \
	php7.0-curl \
	php7.0-intl \
	php7.0-common \
	php7.0-json \
	php7.0-opcache \
	php7.0-recode \
	php7.0-soap \
	php7.0-xml \
	php7.0-zip \
	php7.0-opcache \
    php7.0-ldap \
	php-apcu \
	php-gettext \
	rsyslog \
	curl  \
	wget

RUN apt-get install -y locales
RUN rm /etc/timezone && echo $MY_TZ >> /etc/timezone && locale-gen nl_BE.UTF-8 && LC_ALL=nl_BE.UTF-8

# Add supervisord
RUN apt-get install -y supervisor

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Configure /webdata folder 
RUN mkdir -p /webdata

# Configure PHP memory settings
RUN sed -ri -e 's/128M/256M/' /etc/php/7.0/apache2/php.ini

# Environment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 250M
ENV PHP_POST_MAX_SIZE 250M

#Clean up 
RUN apt-get autoclean && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Container ports and commands
EXPOSE 80 
CMD ["/run.sh"]
