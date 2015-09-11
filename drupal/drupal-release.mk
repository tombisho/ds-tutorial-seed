version=1.1.1-dev
drupal_org_mica-client=git.drupal.org:project/obiba_mica.git
drupal_org_agate-drupal7=git.drupal.org:project/obiba_agate.git
drupal_org_protobuf-drupal7=git.drupal.org:project/obiba_protobuf.git
drupal_org_bootstrap-drupal7=git.drupal.org:project/obiba_bootstrap.git
drupal_branch_version=7.x
branch=$(drupal_branch_version)-1.x


#
# Push to Drupal.org
#
git-push-mica-client: clear-version-info git-prepare-modules git-finish-modules


# clear-version-info function: remove (if present) version number from project info file
clear-version-info = sed -i "/^version/d" $(1)/$2/$2.info && \
	sed -i "/^project/d" $(1)/$2/$2.info && \
	sed -i "/^datestamp/d" $(1)/$2/$2.info && \
	sed -i "/Information added by obiba.org packaging script/d" $(1)/$2/$2.info

# clear-version-info function: remove (if present) version number from project info file
clear-version-info-module = sed -i "/^version/d" $(1)/$2.info && \
	sed -i "/^project/d" $(1)/$2.info && \
	sed -i "/^datestamp/d" $(1)/$2.info && \
	sed -i "/Information added by obiba.org packaging script/d" $(1)/$2.info

#git-prepare: checkout git repo $(1) to target $(2) and delete all files from this repo
git-prepare = rm -rf target/drupal.org/$(2) && \
	mkdir -p target/drupal.org && \
	echo "Enter Drupal username?" && \
	read git_username && \
	git clone --branch $(branch) $$git_username@$(1) target/drupal.org/$(2) && \
	cd target/drupal.org/$(2) && \
	git rm -rf *

#git-finish: sanitize, add, commit and push all files to Git
git-finish = cp -r ../$(1)/* target/drupal.org/$(2)/ && \
	cd target/drupal.org/$(2)  && \
	rm -rf `find . -type f -name LICENSE.txt` && \
	rm -rf `find . -type f -name COPYRIGHT.txt` && \
	echo "Enter Drupal user mail ?" && \
	read git_user_email &&\
	git config user.email $$git_user_email && \
	git add . && \
	git status && \
	echo "Enter a message for this commit?" && \
	read git_commit_msg && \
	git commit -m "$$git_commit_msg" && \
	git push -u origin $(branch) && \
	cd ../../

git-finish-modules:
	$(call git-finish,obiba_mica,obiba_mica)
	$(call git-finish,agate-drupal7,obiba_agate)
	$(call git-finish,protobuf-drupal7,obiba_protobuf)
	$(call git-finish,bootstrap-drupal7,obiba_bootstrap)

git-prepare-modules:
	$(call git-prepare,$(drupal_org_mica-client),obiba_mica)
	$(call git-prepare,$(drupal_org_agate-drupal7),obiba_agate)
	$(call git-prepare,$(drupal_org_protobuf-drupal7),obiba_protobuf)
	$(call git-prepare,$(drupal_org_bootstrap-drupal7),obiba_bootstrap)

clear-version-info: less-css
	$(call clear-version-info-module,../agate-drupal7,obiba_agate)
	$(call clear-version-info-module,../bootstrap-drupal7,obiba_bootstrap)
	$(call clear-version-info-module,../protobuf-drupal7,obiba_protobuf)
	$(call clear-version-info-module,../mica-drupal7,obiba_mica)
