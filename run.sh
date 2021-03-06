#!/bin/bash

echo "Webroot set at: " ${WEB_ROOT}
echo Linking /var/www/html to the ${WEB_ROOT:-/webdata}
rm -fr /var/www/html && ln -s ${WEB_ROOT:-/webdata} /var/www/html

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php/7.0/apache2/php.ini
exec supervisord -n