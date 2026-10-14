-include .env
export
DB ?= odoo20_dev
MODULE ?= hello_dev
ODOO_RUN = docker compose exec odoo odoo -c /etc/odoo/odoo.conf --no-http --max-cron-threads=0 --stop-after-init

.PHONY: init build up down restart logs shell psql initdb install update test debug scaffold src reset-db

init:        ## Buat .env dengan UID/GID host
	test -f .env || (cp .env.example .env && sed -i.bak "s/^USER_UID=.*/USER_UID=$$(id -u)/;s/^USER_GID=.*/USER_GID=$$(id -g)/" .env && rm -f .env.bak)
build: init  ## Build image (clone Odoo 20.0)
	docker compose build
up: init     ## Jalankan Odoo + PostgreSQL
	docker compose up -d
down:
	docker compose down
restart:
	docker compose restart odoo
logs:
	docker compose logs -f odoo
shell:       ## Shell bash di container
	docker compose exec odoo bash
psql:
	docker compose exec db psql -U odoo -d $(DB)
initdb:      ## Buat database baru (dengan demo data)
	$(ODOO_RUN) -d $(DB) -i base
install:     ## make install MODULE=nama_modul
	$(ODOO_RUN) -d $(DB) -i $(MODULE)
update:      ## make update MODULE=nama_modul
	$(ODOO_RUN) -d $(DB) -u $(MODULE)
test:        ## make test MODULE=nama_modul (DB terpisah: <DB>_test)
	$(ODOO_RUN) -d $(DB)_test -i $(MODULE) --test-tags /$(MODULE)
debug:       ## Jalankan mode debugpy (port 5678)
	DEBUG=1 docker compose up -d --force-recreate odoo
scaffold:    ## make scaffold MODULE=nama_modul
	docker compose exec odoo odoo scaffold $(MODULE) /mnt/extra-addons
src:         ## Clone source Odoo ke ./odoo-src untuk autocomplete IDE
	test -d odoo-src || git clone --depth 1 --branch $(ODOO_BRANCH) https://github.com/odoo/odoo.git odoo-src
reset-db:    ## HAPUS database $(DB)
	docker compose exec db dropdb -U odoo --if-exists $(DB)
