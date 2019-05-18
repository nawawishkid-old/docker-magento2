FROM php:7.2-fpm

RUN apt-get update \
    && apt-get install -y libxml2-dev libpng-dev libxslt-dev zlib1g-dev;
    
RUN docker-php-ext-install bcmath gd intl pdo_mysql soap xsl zip;

# Install Composer.phar
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

COPY ./conf.d/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./composer.auth.json /root/.composer/auth.json
COPY ./docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]