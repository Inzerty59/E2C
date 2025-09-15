# FROM wordpress:php8.3-apache

# # Limite upload 10 Mo
# COPY php/conf.d/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# # Sécurité Apache
# COPY apache/hardening.conf /etc/apache2/conf-available/zzz-hardening.conf
# RUN a2enconf zzz-hardening

# # Vhost domaine
# COPY apache/site.conf /etc/apache2/sites-available/zzz-site.conf
# RUN a2ensite zzz-site && a2dissite 000-default

# # curl pour healthcheck
# RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# # ✅ Crée le script d'entrypoint directement dans l'image (heredoc bien formé)
# RUN set -eux; mkdir -p /docker-entrypoint.d; \
#   cat > /docker-entrypoint.d/10-fix-permissions.sh <<'EOF'
# #!/bin/bash
# set -e
# mkdir -p /var/www/html/wp-content/uploads
# chown -R www-data:www-data /var/www/html/wp-content || true
# find /var/www/html/wp-content -type d -exec chmod 755 {} \; || true
# find /var/www/html/wp-content -type f -exec chmod 644 {} \; || true
# exit 0
# EOF
# RUN chmod +x /docker-entrypoint.d/10-fix-permissions.sh

# /var/www/E2C/wordpress/Dockerfile
FROM wordpress:php8.3-apache

# Limites d'upload
COPY php/conf.d/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# OPcache + extension Redis (perf)
RUN docker-php-ext-install opcache \
 && pecl install redis \
 && docker-php-ext-enable redis

# OPcache tuning
COPY php/conf.d/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Sécurité Apache (headers, expires, etc.)
COPY apache/hardening.conf /etc/apache2/conf-available/zzz-hardening.conf
RUN a2enconf zzz-hardening

# Vhost principal
COPY apache/site.conf /etc/apache2/sites-available/zzz-site.conf
RUN a2ensite zzz-site && a2dissite 000-default

# Outils pour healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Activer modules utiles
RUN a2enmod headers expires deflate rewrite

# Script d'entrypoint : permissions wp-content
RUN set -eux; mkdir -p /docker-entrypoint.d; \
  cat > /docker-entrypoint.d/10-fix-permissions.sh <<'EOF'
#!/bin/bash
set -e
mkdir -p /var/www/html/wp-content/uploads
chown -R www-data:www-data /var/www/html/wp-content || true
find /var/www/html/wp-content -type d -exec chmod 755 {} \; || true
find /var/www/html/wp-content -type f -exec chmod 644 {} \; || true
exit 0
EOF
RUN chmod +x /docker-entrypoint.d/10-fix-permissions.sh

