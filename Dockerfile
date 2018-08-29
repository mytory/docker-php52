FROM pblaszczyk/debian-lenny

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN \
  apt-get update && \
  apt-get install -y --force-yes \
    curl \
    wget \
    vim \
    git \
    locales \
    apache2 \
    php5 \
    php5-mysql \
    php5-mcrypt \
    php5-gd \
    php5-curl \
    php-pear \
    php-apc \
    php5-cli \
    php5-curl \
    php5-mcrypt \
    php5-sqlite \
    php5-tidy \
    php5-imap \
    php5-json \
    php5-imagick \
    libapache2-mod-php5 && \
  a2enmod proxy && \
  a2enmod proxy_http && \
  a2enmod alias && \
  a2enmod dir && \
  a2enmod env && \
  a2enmod mime && \
  a2enmod rewrite && \
  a2enmod status && \
  a2enmod filter && \
  a2enmod deflate && \
  a2enmod setenvif && \
  a2enmod vhost_alias 

# xdebug
RUN apt-get install -y --force-yes --no-install-recommends build-essential php5-dev
RUN pecl install xdebug-2.2.7

# etc
RUN apt-get install -y --force-yes --no-install-recommends iputils-ping ssh rsync sudo mysql-client 


# timezone
RUN apt-get install --no-install-recommends -y tzdata
RUN ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# locales
RUN apt-get install --no-install-recommends -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# remove files only for build.
RUN apt-get remove -y --force-yes php5-dev build-essential
RUN apt-get autoremove -y

RUN ln -sf /dev/stderr /var/log/apache2/error.log

COPY dummy.crt  /etc/ssl/crt/dummy.crt
COPY dummy.key  /etc/ssl/crt/dummy.key
COPY php.ini    /etc/php5/apache2/conf.d/
COPY php.ini    /etc/php5/cli/conf.d/
COPY run.sh /run.sh

RUN chmod +x run.sh

EXPOSE 80 433

ENTRYPOINT ["/bin/bash", "/run.sh"]
