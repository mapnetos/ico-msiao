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

# Ativa o Mod_Rewrite do Apache (obrigatório para as rotas do EcclesiaCRM)
RUN a2enmod rewrite

# Copia o código do repositório para a pasta do servidor web
COPY . /var/www/html/

# Ajusta as permissões para que o Apache possa rodar e salvar uploads
RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80
