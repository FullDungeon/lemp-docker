#!/bin/bash

# Исходные файлы
git clone https://github.com/FullDungeon/lemp-docker.git
cp -r lemp-docker/. .
rm -rf lemp-docker

# Загрузка Laravel и установка зависимостей
git clone https://github.com/laravel/laravel.git laravel
mv laravel/{.,}* .
rm -rf laravel
docker run --rm -v $(pwd):/app composer install
sudo chown -R $USER:$USER .

# Изменение настроек среды и запуск контейнеров
cp .env.example .env

# удалить ненужные файлы
rm -rf .gir readme.md install.sh