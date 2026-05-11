FROM php:8.4-fpm-alpine

RUN apk add --no-cache icu-dev libzip-dev libpng-dev freetype-dev libjpeg-turbo-dev musl-locales musl-locales-lang && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) intl pdo_mysql zip gd opcache exif && \
    echo "memory_limit=256M" > /usr/local/etc/php/conf.d/typo3.ini && \
    echo "max_execution_time=240" >> /usr/local/etc/php/conf.d/typo3.ini && \
    echo "max_input_vars=1500" >> /usr/local/etc/php/conf.d/typo3.ini && \
    echo "upload_max_filesize=32M" >> /usr/local/etc/php/conf.d/typo3.ini && \
    echo "post_max_size=32M" >> /usr/local/etc/php/conf.d/typo3.ini

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    MUSL_LOCPATH=/usr/share/i18n/locales/musl

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
