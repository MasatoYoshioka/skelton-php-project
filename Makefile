TARGET=info
WORKDIR=/var/html/www/app
PROJECT=craftcms/craft

.PHONY: composer
composer:
	docker run \
		-u 1000:1000 \
		-v ${PWD}:/var/html/www \
		-v ${PWD}/.data:/tmp \
		-e COMPOSER_CACHE_DIR=/tmp \
		-w ${WORKDIR} \
		composer:latest \
		${TARGET}

.PHONY: install
install:
	make composer -e TARGET=install

.PHONY: dump-autoload
dump-autoload:
	make composer -e TARGET=dump-autoload

.PHONY: update
update:
	make composer -e TARGET=update

.PHONY: clean
clean:
	sudo rm -rf app/ etc/db/data/

.PHONY: create-project
create-project:
	make composer -e WORKDIR="/var/html/www" -e TARGET="create-project ${PROJECT} ./app"
	sudo chmod -R 777 app/storage

.PHOMY: setup
setup:
	make clean
	make create-project
	docker-compose down
	docker-compose up -d
	docker-compose exec php /usr/local/bin/php craft setup
