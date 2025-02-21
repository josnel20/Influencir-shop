FROM php:8.1-apache

# Instalando dependências do sistema
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd mbstring zip pdo_mysql

# Habilitando módulos do Apache
RUN a2enmod rewrite

# Instalando Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definindo o diretório de trabalho
WORKDIR /var/www/html

# Copiando os arquivos do projeto
COPY . .

# Instalando as dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Permissão de escrita para o storage e cache
RUN chmod -R 777 storage bootstrap/cache

# Expondo a porta do Apache
EXPOSE 80

# Comando para iniciar o Apache
CMD ["apache2-foreground"]
