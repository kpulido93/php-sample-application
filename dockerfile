FROM php:7.1-apache

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libmariadb-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copiar los archivos del proyecto al contenedor
COPY . /var/www/html

# Cambiar al directorio correcto
WORKDIR /var/www/html

# Instalar dependencias de Composer
RUN composer install

# Modificar DocumentRoot para apuntar a la carpeta 'web'
RUN echo 'DocumentRoot /var/www/html/web' > /etc/apache2/sites-available/000-default.conf

# RUN mv /var/www/html/config-dev /var/www/html/config

# Permitir el acceso al directorio 'web'
RUN echo '<Directory /var/www/html/web>' >> /etc/apache2/apache2.conf \
    && echo '    Options Indexes FollowSymLinks' >> /etc/apache2/apache2.conf \
    && echo '    AllowOverride All' >> /etc/apache2/apache2.conf \
    && echo '    Require all granted' >> /etc/apache2/apache2.conf \
    && echo '</Directory>' >> /etc/apache2/apache2.conf

# Exponer el puerto 80
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]
