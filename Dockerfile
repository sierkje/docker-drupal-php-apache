FROM php:7.2-apache-stretch

# Install packages.
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install git \
                       libjpeg62-turbo-dev \
                       libpng-dev \
                       libpq-dev \
                       mysql-client \
                       unzip \
                       wget

# Configure PHP extensions.
RUN docker-php-ext-configure gd \
                             --with-jpeg-dir=/usr \
                             --with-png-dir=/usr && \
    docker-php-ext-configure opcache \
                             --enable-opcache

# Install PHP extensions.
RUN docker-php-ext-install gd \
                           mbstring \
                           opcache \
                           pdo \
                           pdo_mysql \
                           pdo_pgsql \
                           mysqli \
                           zip

# Enable Apache mod-rewrite.
RUN a2enmod rewrite

# Install Redis.
RUN pecl install redis && \
    docker-php-ext-enable redis

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer

# Install Drush Launcher.
RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.6.0/drush.phar && \
    chmod +x drush.phar && \
    mv drush.phar /usr/bin/drush

# Install Drupal Console Launcher.
RUN curl https://drupalconsole.com/installer -L -o drupal.phar && \
    chmod +x drupal.phar && \
    mv drupal.phar /usr/bin/drupal

# Clean up.
RUN rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean

ENTRYPOINT ["docker-php-entrypoint"]
WORKDIR /var/www/html
EXPOSE 80
CMD ["apache2-foreground"]
