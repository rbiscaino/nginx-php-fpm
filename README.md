## Introduction
This is a Dockerfile to build a debian based container image running nginx and php-fpm 8.1.x / 8.0.x / 7.4.x / 7.3.x / 7.2.x / 7.1.x / 7.0.x & Composer.

### Versioning
| Docker Tag | GitHub Release | Nginx Version | PHP Version | Composer |
|------------|----------------|---------------|-------------|----------|
| latest     | master Branch  | latest        | 8.2.0-fpm   | 2.2.7    |
| 8.1        | 8.1            | latest        | 8.1.0-fpm   | 2.2.7    |


## Building from source
To build from source you need to clone the git repo and run docker build:
```
$ git clone https://github.com/rbiscaino/nginx-php-fpm.git
$ cd nginx-php-fpm
```

followed by
```
$ docker build -t nginx-php-fpm:php8.1 . # PHP 8.1.x
```


## Pulling from Docker Hub
```
$ docker pull rbiscaino/nginx-php-fpm:php8.1
```

## Running
To run the container:
```
$ sudo docker run -d rbiscaino/nginx-php-fpm:php8.1
```

Default web root:
```
/var/www/html
```
