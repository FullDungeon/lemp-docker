# Настройка Laravel, Nginx и MySQL с Docker Compose
## Требования
1. Должна быть установлена система Docker
2. Должна быть установлена система Docker Compose  

## Установка
### Исходные файлы
1. Клонировать репозиторий в папку с проектом  
```
git clone https://github.com/FullDungeon/lemp-docker.git
```
2. Скопировать необходимые файлы из каталога lemp-docker в каталог проекта, игнорируя скрытый каталог .git  
```
cp -r lemp-docker/. .
```
3. Удалить каталог lemp-docker  
```
rm -rf lemp-docker
```
### Загрузка Laravel и установка зависимостей
4. Перейти в каталог проекта
5. Клонировать последнюю версию Laravel:  
```
git clone https://github.com/laravel/laravel.git laravel
```
6. Переместить содержимое каталога laravel в каталог проекта _(после этого каталог laravel можно удалить)_:  
```
mv laravel/{.,}* .
rm -rf laravel
```
7. Смонтировать образ composer из Docker в текущий каталог _(чтобы не устанавливать его глобально)_:  
```
docker run --rm -v $(pwd):/app composer install
```
8. Установить в каталоге проекта такой уровень разрешений, чтобы его владельцем был пользователь без привелегий root:  
```
sudo chown -R $USER:$USER .
```

### Создание файла Docker Compose
9. В файле _docker-compose.yaml_ указать пароль ROOT для базы данных __PASSWORD_ROOT_MYSQL__ _(без квадратных скобочек)._

### Изменение настроек среды и запуск контейнеров
10. Создать копию файла _.env.example_  
```
cp .env.example .env
```
11. Изменить блок, задающий __DB_CONNECTION__, __[DB_USER]__ и __[DB_PASSWORD]__ задают имя пользователя и пароль базы данных.:  
`DB_CONNECTION=mysql`  
`DB_HOST=db`   
`DB_PORT=3306`   
`DB_DATABASE=laravel`   
`DB_USERNAME=[DB_USER]`   
`DB_PASSWORD=[DB_PASSWORD]`  

### _Дополнительно_
___Использую данный скрипт можно пропустить 1-8, 10 пункты___   
`#!/bin/bash`   

___`# Исходные файлы`___  
`git clone https://github.com/FullDungeon/lemp-docker.git`  
`cp -r lemp-docker/. .`  
`rm -rf lemp-docker`  

___`# Загрузка Laravel и установка зависимостей`___  
`git clone https://github.com/laravel/laravel.git laravel`  
`mv laravel/{.,}* .`  
`rm -rf laravel`  
`docker run --rm -v $(pwd):/app composer install`  
`sudo chown -R $USER:$USER .`    

___`# Изменение настроек среды и запуск контейнеров`___  
`cp .env.example .env`  

___`# удалить ненужные файлы`___  
`rm -rf .gir readme.md`  

<hr>

## Запуск
1. Запуск всех контейнеров, создания томов, настройки и подключения сетей:  
```
docker compose up -d
```
2. Открыть сайт в браузере по адресу [localhost:80](http://localhost:80).

## Завершение настройки приложения
3. Генерация ключа приложения Laravel:  
```
docker-compose exec app php artisan key:generate
```
4. Кэширование всех настроек в кэш:  
```
docker-compose exec app php artisan config:cache
```

<hr>

## Создание пользователя MySQL
1. Запуск интерактивной оболчки bash в контейнере db:  
```
docker-compose exec db bash
```
2. Выполнить внутри контейнера вход в административную учетную запись MySQL root _(будет предложено ввести пароль, заданный для учетной записи MySQL __root__ в файл docker-compose)_:  
```
mysql -u root -p
```
3. Создать учетную запись пользователя, которой будет разрешен доступ к этой базе данных. Нужно использовать _имя пользователя_ и _пароль_, определенные в файле _.env_:  
```
GRANT ALL ON laravel.* TO 'DB_USER'@'%' IDENTIFIED BY 'DB_PASSWORD';
```
4. Обновить привелегии:  
```
FLUSH PRIVILEGES;
```
5. Закрыть MySQL:  
```
EXIT;
```

