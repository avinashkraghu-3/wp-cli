#!/bin/bash
echo "nginx configuration"
echo " importent note - change root path "
echo "change server name also thank  you"
var=/etc/nginx/sites-available/wordpress.conf
cat << EOF > $var
server {
        listen 80;
        listen [::]:80;

        root /var/www/wordpress;

        index index.php;

        server_name 127.0.0.1;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }
}
EOF
ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
