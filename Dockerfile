# ビルド用ステージ
FROM composer:2 as vendor

WORKDIR /app

COPY laravel/ ./
RUN composer install --no-dev --optimize-autoloader

# 本番用ステージ
FROM php:8.4-fpm

# 必要パッケージ
RUN apt-get update && apt-get install -y \
    nginx curl git unzip libpq-dev libzip-dev \
    && docker-php-ext-install pdo pdo_pgsql zip

# Nginx設定
COPY nginx/default.prod.conf /etc/nginx/conf.d/default.conf

# 作業ディレクトリ
WORKDIR /var/www/html/laravel

# アプリケーションコードコピー
COPY laravel/ .

# Composerのvendorコピー
COPY --from=vendor /app/vendor ./vendor

# 権限設定
RUN chmod -R 775 storage bootstrap/cache

# ポート公開（Render用: 10000番）
EXPOSE 10000

# 起動スクリプト
CMD php artisan migrate --force && service nginx start && php-fpm
