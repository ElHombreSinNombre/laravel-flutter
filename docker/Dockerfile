FROM php:8.1.7-apache
WORKDIR /var/www
RUN docker-php-ext-install mysqli \
    && apt-get update \
    && apt-get install -y libzip-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install zip \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-install pdo_mysql
ADD . /var/www
RUN chown -R www-data:www-data /var/www
RUN a2enmod rewrite
COPY virtualhost.conf /etc/apache2/sites-enabled/000-default.conf