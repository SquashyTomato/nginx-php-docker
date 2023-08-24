# Use Alpine Base
FROM alpine:3.18

# Install Packages
RUN apk add --no-cache \
    curl \
    supervisor \
    nginx \
    libnginx-mod-rtmp \
    php82 \
    php82-{bcmath,cli,ctype,curl,dom,fpm,gd,intl,json,mbstring,mysql,opcache,openssl,pdo,phar,session,tokenizer,xml,xmlreader,zip}

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
