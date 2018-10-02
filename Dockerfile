FROM lvinkim/php-env-docker:php7.2.10-pure

# 安装 swoole
RUN cd /opt \
  && pecl download swoole-4.2.1 \
  && tar -zxvf swoole-4.2.1.tgz \
  && cd swoole-4.2.1 \
  && phpize \
  && ./configure --enable-openssl \
  && make && make install \
  && echo "extension=swoole.so" > /etc/php/7.2/mods-available/swoole.ini \
  && phpenmod swoole \
  && rm -rf /opt/swoole-*

## 安装 imagick 扩展
RUN apt-get update && apt-get install -y \
    libmagickwand-dev \
    imagemagick \
    pkg-config \
  && pecl install imagick \
  && echo "extension=imagick.so" > /etc/php/7.2/mods-available/imagick.ini \
  && phpenmod imagick \
  && rm -rf /var/lib/apt/lists/* && apt-get clean

# 安装 composer 相关
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    wget \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && wget -O /usr/local/bin/composer https://getcomposer.org/download/1.6.2/composer.phar \
  && chmod +x /usr/local/bin/composer