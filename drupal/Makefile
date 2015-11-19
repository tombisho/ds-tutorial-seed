#
# Drupal
#
drupal_version = 7.41
obiba-progressbar-version=1.0.0
obiba-timeline-version=1.0
drupal_dir=$(CURDIR)/target/drupal

#
# Mysql db access
#
db_name = drupal
db_user = root
db_pass = 1234
db_host = localhost

#
# www settings
#
www=html/drupal

#
# Release tags
#
mica-drupal7_version=7.x-1.2
agate-drupal7_version=7.x-1.2
bootstrap-drupal7_version=7.x-1.2


drupal-help:
	@echo
	@echo "Build Mica Drupal7 site with modules/themes: obiba_mica, obiba_agate, obiba_protobuf, obiba_bootstrap."
	@echo
	@echo "Available make targets:"
	@echo "  drupal         : Clean & setup Drupal with a symlink to Mica modules/themes in target directory and import drupal.sql"
	@echo "  drupal-release : Clean & setup Drupal with released Mica modules/themes in target directory and import drupal.sql"
	@echo

# Install drupal with mica/agate related modules for development
drupal: drupal-clean setup-drupal enable-modules setup-dependencies cc

# Install drupal with mica/agate related modules for production
drupal-release: drupal-clean setup-drupal enable-modules-release cc

# Install drupal with mica/agate related modules from master branches
drupal-snapshot: drupal-clean setup-drupal-snapshot

# Prepare drupal installation, for making a clean reference SQL database
drupal-empty: drupal-clean setup-drupal-empty

drupal-clean:
	rm -rf $(drupal_dir)

#
# Drupal
#

# Empty
setup-drupal-empty: prepare-drupal www create-sql

# Development
setup-drupal: prepare-drupal www import-sql finalize-drupal

prepare-drupal: prepare-install-drupal prepare-drupal-modules

prepare-drupal-modules:
	ln -s $(CURDIR)/../mica-drupal7 $(drupal_dir)/sites/all/modules/obiba_mica && \
	ln -s $(CURDIR)/../bootstrap-drupal7 $(drupal_dir)/sites/all/themes/obiba_bootstrap && \
	ln -s $(CURDIR)/../agate-drupal7 $(drupal_dir)/sites/all/modules/obiba_agate

# Snapshot (docker for nigthly)
setup-drupal-snapshot: prepare-drupal-snapshot www import-sql finalize-drupal

prepare-drupal-snapshot: prepare-install-drupal prepare-drupal-modules-snapshot

prepare-drupal-modules-snapshot:
	$(call github-install,mica-drupal7,master,modules,obiba_mica)
	$(call github-install,agate-drupal7,master,modules,obiba_agate)
	$(call github-install,bootstrap-drupal7,master,themes,obiba_bootstrap)

prepare-install-drupal:
	drush make --prepare-install drupal/drupal-basic.make $(drupal_dir) && \
	chmod -R a+w $(drupal_dir)

www:
	sudo rm -f /var/www/$(www) && \
	sudo ln -s $(drupal_dir) /var/www/$(www) && \
	sudo chown -R www-data:www-data /var/www/$(www)

dump-sql:
	mysqldump -h $(db_host) -u $(db_user) --password=$(db_pass) --hex-blob $(db_name) --result-file="drupal/drupal-$(drupal_version).sql"

create-sql:
	mysql -h $(db_host) -u $(db_user) --password=$(db_pass) -e "drop database if exists $(db_name); create database $(db_name);"

import-sql: create-sql import-sql-tables

import-sql-tables:
	mysql -h $(db_host) -u $(db_user) --password=$(db_pass) $(db_name) < "drupal/drupal-$(drupal_version).sql"

finalize-drupal: settings htaccess

settings:
	sed  's/@db_name@/$(db_name)/g' drupal/settings.php | sed 's/@db_user@/$(db_user)/g' | sed 's/@db_pass@/$(db_pass)/g'  | sed 's/@db_host@/$(db_host)/g' > $(drupal_dir)/sites/default/settings.php

htaccess:
	cp drupal/.htaccess $(drupal_dir)

#
# Mica related Modules
#

enable-modules: enable-bootstrap enable-mica enable-angular-app enable-data-access

# Enabled modules for a production environment
enable-modules-release: enable-bootstrap enable-mica enable-data-access download-dependencies jquery_update

enable-bootstrap:
	cd $(drupal_dir) && \
	drush dl -y bootstrap && \
	drush en -y bootstrap && \
	drush en -y obiba_bootstrap

enable-mica:
	cd $(drupal_dir) && \
	drush en -y obiba_mica

enable-angular-app:
	cd $(drupal_dir) && \
	rm -rf sites/all/libraries/angular-app  && \
	drush angular-app

enable-data-access:
	cd $(drupal_dir) && \
	drush en -y obiba_mica_data_access_request

deploy-dependencies:
	rm -rf /tmp/mica-drupal-js-libraries && \
	git clone git@github.com:obiba/mica-drupal-js-libraries.git /tmp/mica-drupal-js-libraries && \
	cd /tmp/mica-drupal-js-libraries && \
	cp -r $(drupal_dir)/sites/all/libraries/* . && \
	git add . && \
	(git commit -a -m "Deploying the JavaScript libraries" && git push origin master) || \
	echo "Deployment completed."

#
# Dependencies
#

download-dependencies:
	cd $(drupal_dir) && \
	drush download-dependencies

setup-dependencies: jquery_update datatables obiba-progressbar obiba-timeline

chart-enable:
	cd $(drupal_dir) && \
	drush highcharts-download && \
	drush en -y charts_highcharts

jquery_update:
	cd $(drupal_dir) && \
	drush vset -y --format=string jquery_update_jquery_version 1.10 && \
	drush vset -y --format=string jquery_update_jquery_admin_version 1.10

datatables: datatables-download datatables-plugins-download

datatables-download:
	cd $(drupal_dir) && \
	drush datatables-download

datatables-plugins-download:
	cd $(drupal_dir) && \
	drush datatables-plugins-download

obiba-progressbar:
	cd $(drupal_dir) && \
	drush obiba-progressbar-download $(obiba-progressbar-version)

obiba-timeline:
	cd $(drupal_dir) && \
	drush mica-study-timeline-download $(obiba-timeline-version)

#
# Additional modules
#

enable-autologout:
	cd $(drupal_dir) && \
	drush dl -y autologout && \
	drush en -y autologout && \
	drush vset -y autologout_redirect_url "<front>" && \
	drush vset -y autologout_no_dialog TRUE

#
# Development tools
#

less-css:
	lessc $(CURDIR)/../bootstrap-drupal7/less/style.less $(CURDIR)/../bootstrap-drupal7/css/style.css --source-map=$(CURDIR)/../bootstrap-drupal7/css/style.css.map --source-map-basepath=$(CURDIR)/../bootstrap-drupal7/css
	lessc $(CURDIR)/../bootstrap-drupal7/less/obiba.less $(CURDIR)/../bootstrap-drupal7/css/obiba.css --source-map=$(CURDIR)/../bootstrap-drupal7/css/obiba.css.map --source-map-basepath=$(CURDIR)/../bootstrap-drupal7/css

enable-obiba:
	ln -s $(CURDIR)/../obiba_bootstrap $(drupal_dir)/sites/all/themes/obiba_bootstrap && \
	cd $(drupal_dir) && \
	drush vset -y --format=string theme_default obiba_bootstrap

devel:
	cd $(drupal_dir) && \
	drush dl -y devel && \
	drush en -y devel

cc:
	cd $(drupal_dir) && drush cc all && \
	sudo chown -R www-data:www-data .


#
# Functions
#

# Install a module/them from a github repository given a tag or a branch name
github-install = cd /tmp && rm -f $(2).zip && rm -rf $(1)-$(2) && \
	  wget -q https://github.com/obiba/$(1)/archive/$(2).zip && \
	  unzip -q $(2).zip && \
	  mv $(1)-$(2) $(drupal_dir)/sites/all/$(3)/$(4) && \
	  rm -f $(2).zip
