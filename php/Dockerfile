FROM php:7.2-fpm

RUN apt-get update \
    && apt-get install -y libxml2-dev libpng-dev libjpeg62-turbo-dev libfreetype6-dev libxslt-dev zlib1g-dev libwebp-dev libxpm-dev;
    
RUN docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir

RUN docker-php-ext-install bcmath gd intl pdo_mysql soap xsl zip;

# Install Composer.phar
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# COPY ./conf.d/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./composer.auth.json /root/.composer/auth.json
COPY ./docker-entrypoint.sh /

WORKDIR /usr/share/nginx/html

ENV PATH="/usr/share/nginx/html/bin:${PATH}"

ENTRYPOINT [ "/docker-entrypoint.sh" ]