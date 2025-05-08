# PHPベース
FROM php:8.4-fpm

# 必要なパッケージ
RUN apt-get update && apt-get install -y \
    git unzip curl libpq-dev sudo

# PHP拡張
RUN docker-php-ext-install pdo pdo_pgsql

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 非rootユーザー作成
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# 作業ディレクトリ
WORKDIR /var/www/html/laravel

# デフォルトユーザー切り替え
USER $USERNAME
