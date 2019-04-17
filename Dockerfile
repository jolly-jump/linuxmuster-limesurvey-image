FROM php:7.3.3-apache-stretch
COPY --chown=www-data limesurvey/  /var/www/html/
RUN mkdir /var/linuxmuster-limesurvey
#COPY locale.gen /etc/locale.gen
#COPY ldap.conf /etc/ldap/ldap.conf
RUN apt-get update 
# php-ldap
RUN apt-get install -y libldap2-dev 
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-install ldap
# php-gd with freetype, jpeg support
RUN apt-get install -y libfreetype6-dev libjpeg-dev libpng-dev
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
# php-zip
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip
# php-pdo-mysql
RUN docker-php-ext-install pdo_mysql
# mysql-client
RUN apt-get install -y mysql-client

RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

# locales
#COPY php.ini-production /usr/local/etc/php/php.ini

COPY linuxmuster-limesurvey-entrypoint /usr/local/bin/linuxmuster-limesurvey-entrypoint
ENTRYPOINT /usr/local/bin/linuxmuster-limesurvey-entrypoint
 
