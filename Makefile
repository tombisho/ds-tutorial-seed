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

include seed/Makefile
include drupal/Makefile

help: seed-help drupal-help

clean:
	rm -rf target
