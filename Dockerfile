FROM php:7.4.25-apache-bullseye
RUN mkdir /var/linuxmuster-limesurvey
RUN mkdir /usr/share/linuxmuster-limesurvey
COPY --chown=www-data limesurvey/  /var/www/html/
COPY --chown=www-data limesurvey/application/core/plugins/AuthLDAP/AuthLDAP.php  /usr/share/linuxmuster-limesurvey/AuthLDAP.php.dist
#COPY --chown=www-data ldapform.php.fix-14793 /var/www/html/application/views/admin/token/ldapform.php
COPY --chown=www-data upload/ /var/www/html/upload/
COPY --chown=www-data lmn-full-logo.png /var/www/html/themes/admin/Sea_Green/images/logo.png
#COPY locale.gen /etc/locale.gen
#COPY ldap.conf /etc/ldap/ldap.conf

# php-ldap
# php-gd with freetype, jpeg support
# php-zip
# php-pdo-mysql
# mysql-client

RUN apt-get update \
    && apt-get -y full-upgrade \
    && apt-get install -y libldap2-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install ldap \
    && apt-get install -y libfreetype6-dev libjpeg-dev libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && apt-get install -y libzip-dev \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && apt-get install -y default-mysql-client \
    && apt-get purge -y libc6-dev libfreetype6-dev libjpeg-dev libldap2-dev libpng-dev libzip-dev \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

##    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \

# locales
#COPY php.ini-production /usr/local/etc/php/php.ini

COPY linuxmuster-limesurvey-entrypoint /usr/local/bin/linuxmuster-limesurvey-entrypoint
ENTRYPOINT /usr/local/bin/linuxmuster-limesurvey-entrypoint
 
