# Composer依存インストールステージ
FROM composer:2 as vendor

WORKDIR /app

COPY laravel/ ./
RUN composer install --no-dev --optimize-autoloader

# Node.js依存インストール＆ビルドステージ
FROM node:22 as frontend

WORKDIR /app

COPY laravel/package.json laravel/package-lock.json ./
RUN npm ci

COPY laravel/ ./
RUN npm run build

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

# Viteのビルド済みファイルコピー
COPY --from=frontend /app/public/build ./public/build

# デバッグ出力：public/build ディレクトリ確認
RUN echo "==== /public/build contents ====" \
    && ls -l ./public/build \
    && echo "==== /public/build/css contents ====" \
    && ls -l ./public/build/css \
    && echo "==== /public/build/js contents ====" \
    && ls -l ./public/build/js

# 権限設定
RUN chown -R www-data:www-data storage bootstrap/cache

# ポート公開（Render用: 10000番）
EXPOSE 10000

# 起動スクリプト
CMD php artisan migrate --force && service nginx start && php-fpm
