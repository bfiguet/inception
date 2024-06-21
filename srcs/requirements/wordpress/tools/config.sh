#!/bin//bash
sleep 10
cd /var/www/wordpress
FILE=wp-config.php
if [ ! -f "$FILE" ]; then
	sleep 2
	wp config create	--allow-root \
				--dbname=$SQL_DATABASE \
				--dbuser=$SQL_USER \
				--dbpass=$SQL_PASSWORD \
				--dbhost=mariadb:3306 \
				--path='/var/www/wordpress'
	sleep 2
	wp core install	--allow-root \
			--url=https://${DOMAIN_NAME} \
			--title=${SITE_TITLE} \
			--admin_user=${ADMIN_USER} \
			--admin_password=${ADMIN_PASSWORD} \
			--admin_email=${ADMIN_EMAIL};
	sleep 2
	wp user create	--allow-root ${USER1_LOGIN} ${USER1_MAIL}\
	       	--role=author \
	       	--user_pass=${USER1_PASS};

wp cache flush --allow-root
wp plugin install contact-form-7 --activate --allow-root
wp language core install en_US --activate --allow-root
wp theme install kidsgen --activate --allow-root
wp rewrite structure '/%postname%/' --allow-root
wp option update title ${SITE_TITLE} --allow-root
wp option update blogname '42_Inception' --allow-root
wp option update timezone_string 'Europe/Paris' --allow-root
wp option update date_format 'j F Y' --allow-root
wp option update time_format 'H:i' --allow-root
wp option update blogdescription 'Just another 42_Inception in the World!' --allow-root
wp menu create "Main Menu" --allow-root
wp menu location assign main-menu primary --allow-root
wp menu item add-custom main-menu "Home" "/" --allow-root
wp menu item add-custom main-menu "Contact" "/" --allow-root
wp menu item add-custom main-menu "About" "/" --allow-root
wp menu item add-custom main-menu "Blog" "/" --allow-root


fi

mkdir -p /run/php

php-fpm7.4 --nodaemonize --fpm-config /etc/php.7.3/fpm/pool.d/www.conf
