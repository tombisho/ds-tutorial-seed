bootstrap_mica_branch_version=1.x
bootstrap_drupal_branch_version=7.x
bootstrap_tag_bootstrap_version=1.4
bootstrap_branch=$(bootstrap_drupal_branch_version)-$(bootstrap_mica_bootstrap_branch_version)
bootstrap_version_obiba_bootstrap=$(bootstrap_drupal_branch_version)-$(bootstrap_tag_bootstrap_version)

#drupal.org repositories :
drupal_org_obiba_bootstrap-drupal7=git.drupal.org:project/obiba_bootstrap.git

#GitHub repositories :
gitHub_obiba_bootstrap-drupal7=https://github.com/obiba/bootstrap-drupal7.git

#Repositories folders
git_hub=target/github_repo
git_drupal=target/git_drupal_repo

#
# Release Drupal.org
#

release-obiba-bootstrap :
	$(call release-drupal-module,$(bootstrap_branch),$(bootstrap_drupal_org_obiba_bootstrap-drupal7),$(bootstrap_version_obiba_bootstrap),$(bootstrap_gitHub_obiba_bootstrap-drupal7),bootstrap_bootstrap-drupal7,bootstrap_obiba_bootstrap)
