FROM php:8.2-apache

# Instala dependências do sistema e extensões PHP necessárias para o EcclesiaCRM
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd zip

# Configura o Apache para ler o site direto de dentro da pasta /src
ENV APACHE_DOCUMENT_ROOT /var/www/html/src
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Ativa o Mod_Rewrite do Apache (obrigatório para as rotas do EcclesiaCRM)
RUN a2enmod rewrite

# Copia todo o código do repositório para o container
COPY . /var/www/html/

# Ajusta as permissões para leitura e escrita
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

EXPOSE 80
