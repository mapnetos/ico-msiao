FROM php:8.2-apache

# Instala dependências do sistema e ferramentas para o Composer
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd zip gettext

# Instala o Composer oficial dentro do container
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configura o Apache para ler o site direto de dentro da pasta /src
ENV APACHE_DOCUMENT_ROOT=/var/www/html/src
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Ativa o Mod_Rewrite do Apache
RUN a2enmod rewrite

# Define a pasta de trabalho principal
WORKDIR /var/www/html

# Copia todo o código do repositório para o container
COPY . .

# Entra na pasta src (onde está o composer.json) e baixa as dependências
RUN cd src && composer install --no-dev --optimize-autoloader

# Ajusta as permissões finais em todo o diretório
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
