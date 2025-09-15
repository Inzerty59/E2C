#!/bin/bash
set -e

# S'assurer que le dossier uploads existe
mkdir -p /var/www/html/wp-content/uploads

# Mettre les bons droits
chown -R www-data:www-data /var/www/html/wp-content || true
find /var/www/html/wp-content -type d -exec chmod 755 {} \; || true
find /var/www/html/wp-content -type f -exec chmod 644 {} \; || true

exit 0
