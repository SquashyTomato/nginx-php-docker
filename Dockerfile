# Use Alpine Base
FROM alpine:3.18

# Install Packages
RUN apk add --no-cache \
    curl \
    supervisor \
    nginx \
    libnginx-mod-rtmp \
    php82 \
    php82-bcmath \
    php82-cli \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-fpm \
    php82-gd \
    php82-intl \
    php82-json \
    php82-mbstring \
    php82-mysql \
    php82-opcache \
    php82-openssl \
    php82-pdo \
    php82-phar \
    php82-session \
    php82-tokenizer \
    php82-xml \
    php82-xmlreader \
    php82-zip

# Configure PHP
RUN ln -s /usr/bin/php82 /usr/bin/php

# Install Composer
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/bin --filename=composer

# Copy Configuration Files
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/fpm-pool.conf /etc/php82/php-fpm.d/www.conf
COPY config/php.ini /etc/php82/conf.d/custom.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Check File Permissions
RUN chown -R nobody.nobody /var/www /run /var/lib/nginx /var/log/nginx

# Expose Web Ports
EXPOSE 80
EXPOSE 443

# Run Services with Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
