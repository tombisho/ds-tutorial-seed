mica_current_tag = 1.0.3-dev
mica_branch_version=1.0.x
drupal_version = 7.34
mica_version=$(drupal_version)-$(mica_current_tag)
drupal_org_mica=git.drupal.org:project/obiba_mica.git
obiba-progressbar-version=1.0.0

#
# Mysql db access
#
db_name = drupal
db_user = root
db_pass = 1234

#
# www settings
#
www=html/drupal

#
# Release tags
#
mica-drupal7_version=7.x-1.0.3
agate-drupal7_version=7.x-1.0.0
protobuf-drupal7_version=7.x-1.0.0
bootstrap-drupal7_version=7.x-1.0.3


drupal-help:
	@echo
	@echo "Build Mica Drupal7 site with modules/themes: obiba_mica, obiba_agate, obiba_protobuf, obiba_bootstrap."
	@echo
	@echo "Available make targets:"
	@echo "  drupal         : Clean & setup Drupal with a symlink to Mica modules/themes in target directory and import drupal.sql"
	@echo "  drupal-release : Clean & setup Drupal with released Mica modules/themes in target directory and import drupal.sql"
	@echo

drupal: drupal-clean setup-drupal enable-modules setup-dependencies cc

drupal-release: drupal-clean setup-drupal-release enable-modules setup-dependencies cc

drupal-clean:
	rm -rf target/drupal

#
# Drupal
#

setup-drupal: prepare-drupal www import-sql settings

prepare-drupal: prepare-install-drupal
	ln -s $(CURDIR)/../mica-drupal7 $(CURDIR)/target/drupal/sites/all/modules/obiba_mica && \
	ln -s $(CURDIR)/../bootstrap-drupal7 $(CURDIR)/target/drupal/sites/all/themes/obiba_bootstrap && \
	ln -s $(CURDIR)/../agate-drupal7 $(CURDIR)/target/drupal/sites/all/modules/obiba_agate && \
	ln -s $(CURDIR)/../protobuf-drupal7  $(CURDIR)/target/drupal/sites/all/modules/obiba_protobuf

setup-drupal-release: prepare-drupal-release www import-sql settings

prepare-drupal-release: prepare-install-drupal
	cd /tmp && rm -f $(mica-drupal7_version).zip && rm -rf mica-drupal7-$(mica-drupal7_version) && \
	  wget -q https://github.com/obiba/mica-drupal7/archive/$(mica-drupal7_version).zip && \
	  unzip $(mica-drupal7_version).zip && \
	  mv mica-drupal7-$(mica-drupal7_version) $(CURDIR)/target/drupal/sites/all/modules/obiba_mica && \
	  rm -f $(mica-drupal7_version).zip
	cd /tmp && rm -f $(agate-drupal7_version).zip && rm -rf agate-drupal7-$(agate-drupal7_version) && \
	  wget -q https://github.com/obiba/agate-drupal7/archive/$(agate-drupal7_version).zip && \
	  unzip $(agate-drupal7_version).zip && \
	  mv agate-drupal7-$(agate-drupal7_version) $(CURDIR)/target/drupal/sites/all/modules/obiba_agate && \
	  rm -f $(agate-drupal7_version).zip
	cd /tmp && rm -f $(protobuf-drupal7_version).zip && rm -rf protobuf-drupal7-$(protobuf-drupal7_version) && \
	  wget -q https://github.com/obiba/protobuf-drupal7/archive/$(protobuf-drupal7_version).zip && \
	  unzip $(protobuf-drupal7_version).zip && \
	  mv protobuf-drupal7-$(protobuf-drupal7_version) $(CURDIR)/target/drupal/sites/all/modules/obiba_protobuf && \
	  rm -f $(protobuf-drupal7_version).zip
	cd /tmp && rm -f $(bootstrap-drupal7_version).zip && rm -rf bootstrap-drupal7-$(bootstrap-drupal7_version) && \
	  wget -q https://github.com/obiba/bootstrap-drupal7/archive/$(bootstrap-drupal7_version).zip && \
	  unzip $(bootstrap-drupal7_version).zip && \
	  mv bootstrap-drupal7-$(bootstrap-drupal7_version) $(CURDIR)/target/drupal/sites/all/themes/obiba_bootstrap && \
	  rm -f $(bootstrap-drupal7_version).zip

prepare-install-drupal:
	drush make --prepare-install drupal/drupal-basic.make target/drupal && \
	chmod -R a+w target/drupal
	
www:
	sudo rm -f /var/www/$(www) && \
	sudo ln -s $(CURDIR)/target/drupal /var/www/$(www) && \
	sudo chown -R www-data:www-data /var/www/$(www)

dump-sql:
	mysqldump -u $(db_user) --password=$(db_pass) --hex-blob $(db_name) --result-file="drupal/drupal-$(drupal_version).sql"

create-sql:
	mysql -u $(db_user) --password=$(db_pass) -e "drop database if exists $(db_name); create database $(db_name);"

import-sql: create-sql
	mysql -u $(db_user) --password=$(db_pass) $(db_name) < "drupal/drupal-$(drupal_version).sql"

settings:
	sed  's/@db_name@/$(db_name)/g' drupal/settings.php | sed  's/@db_user@/$(db_user)/g' | sed  's/@db_pass@/$(db_pass)/g' > target/drupal/sites/default/settings.php
	cp drupal/.htaccess target/drupal

#
# Mica related Modules
#

enable-modules: enable-bootstrap enable-mica enable-angular-app enable-obiba-agate enable-data-access

enable-bootstrap:
	cd target/drupal && \
	drush dl -y bootstrap && \
	drush en -y bootstrap && \
	drush en -y obiba_bootstrap && \
	drush vset -y theme_default obiba_bootstrap && \
	drush vset -y admin_theme seven

enable-mica:
	cd target/drupal && \
	drush en -y obiba_mica

enable-angular-app:
	cd target/drupal && \
	drush en -y obiba_main_app_angular && \
	rm -rf sites/all/libraries/angular-app  && \
	drush angular-app

enable-obiba-agate:
	cd target/drupal && \
	drush en -y obiba_agate

enable-data-access:
	cd target/drupal && \
	drush en -y obiba_mica_data_access_request

#
# Dependencies
#

setup-dependencies: jquery_update datatables obiba-progressbar

jquery_update:
	cd target/drupal && \
	drush dl -y jquery_update && \
	drush en -y jquery_update && \
	drush vset -y jquery_update_jquery_version 1.8 && \
	drush vset -y jquery_update_jquery_admin_version 1.8

chart-enable:
	cd target/drupal && \
	drush highcharts-download && \
	drush en -y charts_highcharts

datatables: datatables-download datatables-plugins-download

datatables-download:
	cd target/drupal && \
	drush datatables-download

datatables-plugins-download:
	cd target/drupal && \
	drush datatables-plugins-download

obiba-progressbar:
	cd target/drupal && \
	drush vset -y obiba-progressbar-lib obiba-progressbar-$(obiba-progressbar-version) && \
	drush vset -y obiba-progressbar-file "dist/obiba-progressbar" && \
	drush obiba-progressbar-download $(obiba-progressbar-version)

#
# Development tools
#

less-css:
	lessc $(CURDIR)/../bootstrap-drupal7/less/style.less $(CURDIR)/../bootstrap-drupal7/css/style.css
	lessc $(CURDIR)/../bootstrap-drupal7/less/obiba.less $(CURDIR)/../bootstrap-drupal7/css/obiba.css

devel:
	cd target/drupal && \
	drush dl -y devel && \
	drush en -y devel

cc:
	cd target/drupal && drush cc all
