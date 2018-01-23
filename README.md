poa2-web
=======

Out-of-the-box Web image (Apache + PHP)


Usage
-----

To create the image `poa/poa2-web`, execute the following command on the poa2-web folder:

	docker build -t poa/poa2-web .

You can now push your new image to the registry:

	docker push poa/poa2-web


Running your LAMP docker image
------------------------------

Start your image binding the external ports 80 and 3306 in all interfaces to your container:

	docker run -d -p 80:80 poa/poa2-web

Test your deployment:

	curl http://localhost/

Hello world!

Disabling .htaccess
--------------------

`.htaccess` is enabled by default. To disable `.htaccess`, you can remove the following contents from `Dockerfile`

	# config to enable .htaccess
    ADD apache_default /etc/apache2/sites-available/000-default.conf
    RUN a2enmod rewrite
