repos = yunity-core yunity-sockets

pg_user = postgres

db_user = yunity-user
db_name = yunity-database
db_test_name = test_yunity-database
db_password = yunity

pg = sudo -u $(pg_user) $(1) -U $(pg_user)

PSQL = $(call pg,psql)
CREATEDB = $(call pg,createdb)
CREATEUSER = $(call pg,createuser)
DROPDB= $(call pg,dropdb)
DROPUSER= $(call pg,dropuser)

home = $(shell pwd)

update_repo = @cd $(1) && \
		git fetch --all && \
		git reset --hard origin/master && \
		git clean -fd

#---------------------------------------------------------------------------

define LOCAL_SETTINGS_PY
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '$(db_name)',
        'USER': '$(db_user)',
        'PASSWORD': '$(db_password)',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
endef
export LOCAL_SETTINGS_PY

#---------------------------------------------------------------------------

define SYSTEMD_DJANGO
[Unit]
Description=yunity django app
After=network.target

[Service]
PIDFile=/tmp/django.pid
User=vagrant
Group=vagrant
WorkingDirectory=$(home)/yunity-core
ExecStart=$(home)/yunity-core/env/bin/gunicorn --pid /tmp/django.pid --bind 0.0.0.0:8000 config.wsgi
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
endef
export SYSTEMD_DJANGO

#---------------------------------------------------------------------------

define SYSTEMD_SOCKETS
[Unit]
Description=yunity sockets app
After=network.target

[Service]
User=vagrant
Group=vagrant
WorkingDirectory=$(home)/yunity-sockets
ExecStart=/usr/bin/node index.js -w 8080 -p 9080
PrivateTmp=true

[Install]
WantedBy=multi-user.target
endef
export SYSTEMD_SOCKETS

#---------------------------------------------------------------------------

define POSTGRES_CONF
listen_addresses = '*'
port = 5432
log_timezone = 'UTC'
timezone = 'UTC'
data_directory = '/var/lib/postgresql/9.4/main'
hba_file = '/etc/postgresql/9.4/main/pg_hba.conf'
ident_file = '/etc/postgresql/9.4/main/pg_ident.conf'
unix_socket_directories = '/var/run/postgresql'
external_pid_file = '/var/run/postgresql/9.4-main.pid'
stats_temp_directory = '/var/run/postgresql/9.4-main.pg_stat_tmp'
max_connections = 100
ssl = true
ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'
shared_buffers = 128MB
dynamic_shared_memory_type = posix
log_line_prefix = '%t [%p-%l] %q%u@%d '
datestyle = 'iso, mdy'
lc_messages = 'en_US.UTF-8'
lc_monetary = 'en_US.UTF-8'
lc_numeric = 'en_US.UTF-8'
lc_time = 'en_US.UTF-8'
default_text_search_config = 'pg_catalog.english'
endef
export POSTGRES_CONF

#---------------------------------------------------------------------------

define POSTGRES_HBA
local   all             postgres                                peer
local   all             all                                     peer
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               trust
endef
export POSTGRES_HBA

#---------------------------------------------------------------------------

install: install-django install-sockets

install-django: | setup-yunity-core setup-gunicorn setup-postgres
	@echo && echo "# $@" && echo
	@echo "$$SYSTEMD_DJANGO" | sudo tee /etc/systemd/system/yunity-django.service >/dev/null
	@sudo systemctl daemon-reload
	@sudo systemctl enable yunity-django
	@sudo systemctl start yunity-django

setup-postgres:
	@echo "$$POSTGRES_CONF" | sudo tee /etc/postgresql/9.4/main/postgresql.conf >/dev/null
	@echo "$$POSTGRES_HBA" | sudo tee /etc/postgresql/9.4/main/pg_hba.conf >/dev/null
	@sudo systemctl restart postgresql
	

install-sockets: | setup-sockets
	@echo && echo "# $@" && echo
	@echo "$$SYSTEMD_SOCKETS" | sudo tee /etc/systemd/system/yunity-sockets.service >/dev/null
	@sudo systemctl daemon-reload
	@sudo systemctl enable yunity-sockets
	@sudo systemctl start yunity-sockets

update: | yunity-core yunity-sockets git-update install-django install-sockets

git-update:
	@echo && echo "# $@" && echo
	$(call update_repo,yunity-core)
	$(call update_repo,yunity-sockets)

$(repos):
	@echo && echo "# $@" && echo
	@git clone https://github.com/yunity/$@.git

yunity-core/env: yunity-core
	@echo && echo "# $@" && echo
	@virtualenv --python=python3 --no-site-packages yunity-core/env

yunity-core/env/bin/gunicorn:
	@echo && echo "# $@" && echo
	@cd yunity-core && env/bin/pip install gunicorn

pip-install: yunity-core/env
	@echo && echo "# $@" && echo
	@cd yunity-core && env/bin/pip install -r requirements.txt

init-db: setup-postgres
	@echo && echo "# $@" && echo
	@$(PSQL) postgres -tAc \
		"SELECT 1 FROM pg_roles WHERE rolname='$(db_user)'" | grep -q 1 || \
		$(PSQL) -tAc "create user \"$(db_user)\" with CREATEDB password '$(db_password)'"  || \
		echo "--> failed to create db user $(db_user), please set pg_user or pg in local_settings.make or ensure the default 'postgres' db role is available"
	@$(PSQL) postgres -tAc \
		"SELECT 1 FROM pg_database WHERE datname = '$(db_name)'" | grep -q 1 || \
		$(CREATEDB) $(db_name) || \
		echo "--> failed to create db user $(db_user), please set pg_user or pg in local_settings.make or ensure the default 'postgres' db role is available"

drop-db:
	@echo && echo "# $@" && echo
	@$(PSQL) postgres -tAc "SELECT pg_terminate_backend(pg_stat_activity.pid) \
				FROM pg_stat_activity \
				WHERE pg_stat_activity.datname = '$(db_name)' \
				AND pid <> pg_backend_pid();"
	@$(DROPDB) $(db_name) --if-exists
	@$(DROPDB) $(db_test_name) --if-exists
	@$(DROPUSER) $(db_user) --if-exists

recreate-db: | drop-db init-db
	@echo && echo "# $@" && echo

trash-db: | drop-db
	@echo && echo "# $@" && echo
	@# TODO: only allow this if systemd service is already installed...
	@sudo systemctl stop yunity-django
	@make migrate-db
	@sudo systemctl start yunity-django

migrate-db: yunity-core/env init-db pip-install
	@echo && echo "# $@" && echo
	@echo "$$LOCAL_SETTINGS_PY" > yunity-core/config/local_settings.py
	@cd yunity-core && env/bin/python manage.py migrate

setup-yunity-core: | yunity-core migrate-db

setup-sockets: yunity-sockets npm-cache
	@echo && echo "# $@" && echo
	@cd yunity-sockets && npm-cache install npm --unsafe-perm

setup-gunicorn: yunity-core/env/bin/gunicorn
	
npm-cache:
	@echo && echo "# $@" && echo
	@which npm-cache || sudo npm install -g npm-cache

runserver: setup-gunicorn
	@echo && echo "# $@" && echo
	@cd yunity-core && env/bin/gunicorn config.wsgi

runsockets: setup-sockets
	@echo && echo "# $@" && echo
	@cd yunity-sockets && node index.js -w 8080 -p 9080
