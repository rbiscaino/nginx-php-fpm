# Imagem base para o PHP-FPM
FROM php:8.1-cli

ENV COMPOSER_VERSION 2.2.7

# Atualiza os pacotes do sistema
RUN apt-get update

# Instala as dependências do PHP e algumas extensões comuns
RUN apt-get install -y \
    nano \
    supervisor \
    cron \
    python3-pip \
    git \
    libzip-dev \
    zip \
    unzip \
    mcrypt \
    openssl \
    libcurl4-openssl-dev \
    libxml2-dev \
    libedit-dev \
    librust-onig-sys-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libfreetype6-dev \
    libgif-dev \
    libxpm-dev \
    libmagickwand-dev

# Instala extensões do php com PECL
RUN pecl install imagick; \
    docker-php-ext-enable imagick;

# Instala extensões do php
RUN docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli pdo_mysql dom opcache curl intl xml exif

# Instala o Nginx
RUN apt-get install -y nginx

# Instala o Redis
RUN pecl install redis && docker-php-ext-enable redis

### Instalar e Habilitar o Swoole
RUN pecl install swoole
RUN docker-php-ext-enable swoole

# Instala o Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm -rf /tmp/composer-setup.php 

# Limpando o apt-get
RUN apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Copia o arquivo de configuração do Nginx
COPY default.conf /etc/nginx/conf.d/default.conf

# Configura o PHP-FPM para ser executado em um socket Unix
#RUN echo "listen = /var/run/php-fpm.sock" >> /usr/local/etc/php-fpm.d/www.conf

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia o código-fonte do seu projeto para o diretório de trabalho
COPY . /var/www/html

# Exponha a porta 80 para o Nginx
EXPOSE 80
EXPOSE 443
#EXPOSE 8000

# Criando diretorio log do supervisord
RUN mkdir -p /var/log/supervisor && mkdir -p /var/run/supervisor

# Copia o arquivo de configuração do Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Comando para iniciar o Supervisor
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
