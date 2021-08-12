# Настройка Laravel, Nginx и MySQL с Docker Compose
## Требования
1. Должна быть установлена система Docker
2. Должна быть установлена система Docker Compose  

## Установка
### Загрузка Laravel и установка зависимостей
1. Перейти в каталог проекта
2. Клонировать последнюю версию Laravel:  
`git clone https://github.com/laravel/laravel.git laravel`
3. Переместить содержимое каталога laravel в каталог проекта _(после этого каталог laravel можно удалить)_:  
`mv laravel/{.,}* .`  
`rm -rf laravel`
4. Смонтировать образ composer из Docker в текущий каталог _(чтобы не устанавливать его глобально)_:  
`docker run --rm -v $(pwd):/app composer install`
5. Установить в каталоге проекта такой уровень разрешений, чтобы его владельцем был пользователь без привелегий root:  
`sudo chown -R $USER:$USER .`

### Создание файла Docker Compose
1. В файле _docker-compose.yaml_ указать пароль ROOT для базы данных __PASSWORD_ROOT_MYSQL__ _(без квадратных скобочек)._

### Изменение настроек среды и запуск контейнеров
1. Создать копию файла _.env.example_  
`cp .env.example .env`
2. Изменить блок, задающий __DB_CONNECTION__, __[DB_USER]__ и __[DB_PASSWORD]__ задают имя пользователя и пароль базы данных.:  
`DB_CONNECTION=mysql`  
`DB_HOST=db`   
`DB_PORT=3306`   
`DB_DATABASE=laravel`   
`DB_USERNAME=[DB_USER]`   
`DB_PASSWORD=[DB_PASSWORD]`  

## Запуск
1. Запуск всех контейнеров, создания томов, настройки и подключения сетей:  
`docker compose up -d`
2. Открыть сайт в браузере по адресу [localhost:80](http://localhost:80).

## Дополнительно
1. Генерация ключа приложения Laravel:  
`docker-compose exec app php artisan key:generate`
2. Кэширование всех настроек в кэш:  
`docker-compose exec app php artisan config:cache`

## Создание пользователя MySQL
1. Запуск интерактивной оболчки bash в контейнере db:  
`docker-compose exec db bash`
2. Выполнить внутри контейнера вход в административную учетную запись MySQL root _(будет предложено ввести пароль, заданный для учетной записи MySQL __root__ в файл docker-compose)_:  
`mysql -u root -p`
3. Создать учетную запись пользователя, которой будет разрешен доступ к этой базе данных. Нужно использовать _имя пользователя_ и _пароль_, определенные в файле _.env_:  
`GRANT ALL ON laravel.* TO 'DB_USER'@'%' IDENTIFIED BY 'DB_PASSWORD';`
4. Обновить привелегии:  
`FLUSH PRIVILEGES;`
5. Закрыть MySQL:  
`EXIT;`