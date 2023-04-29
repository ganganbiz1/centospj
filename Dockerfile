FROM --platform=linux/amd64 gangan001/centos6.5-apache2.2-php5.4.22:latest

COPY httpd.conf ./etc/httpd/conf/httpd.conf

COPY index.php ./var/www/html/.

CMD [ "/bin/bash"]
