#
# Mica2 server
#
mica_url=https://localhost:8445
username=administrator
password=password

mica_home = $(CURDIR)/target/mica_home
mica_log = ${mica_home}/logs
skipTests = false
mvn_exec = mvn -Dmaven.test.skip=${skipTests}

mica-help:
	@echo 
	@echo "Seed Mica server with some networks, studies and datasets. Requires mica python client to be installed."
	@echo
	@echo "Available make targets:"
	@echo "  seed-mica : Seed mica server"

seed-mica: seed-studies seed-datasets

seed-studies: seed-collection-studies seed-harmonization-studies

seed-collection-studies:
	mica import-zip -mk $(mica_url) -u $(username) -p $(password) -pub ./mica2/seed/collection-studies

seed-harmonization-studies:
	mica import-zip -mk $(mica_url) -u $(username) -p $(password) -pub ./mica2/seed/harmonization-studies

seed-datasets: seed-collection-datasets seed-harmonization-datasets

seed-collection-datasets:
	$(call dataset-create,collection,cls-wave1)
	$(call dataset-create,collection,cls-wave2)
	$(call dataset-create,collection,cls-wave3)
	$(call dataset-create,collection,cls-wave4)
	$(call dataset-create,collection,clsa)
	$(call dataset-create,collection,fnac)
	$(call dataset-create,collection,frele)
	$(call dataset-create,collection,lbls-1978)
	$(call dataset-create,collection,lbls-1981)
	$(call dataset-create,collection,lbls-1994)
	$(call dataset-create,collection,lbls-1997)
	$(call dataset-create,collection,lbls-2000)
	$(call dataset-create,collection,lbls-2003)
	$(call dataset-create,collection,lbls-2008)
	$(call dataset-create,collection,nuage-t1)
	$(call dataset-create,collection,nuage-t2)
	$(call dataset-create,collection,nuage-t3)
	$(call dataset-create,collection,nuage-t4)
	$(call dataset-create,collection,ulsam-50)
	$(call dataset-create,collection,ulsam-60)
	$(call dataset-create,collection,ulsam-70)
	$(call dataset-create,collection,ulsam-77)
	$(call dataset-create,collection,ulsam-82)
	$(call dataset-create,collection,ulsam-88)
	$(call dataset-create,collection,lasa-1)
	$(call dataset-create,collection,lasa-2)
	$(call dataset-create,collection,lasa-3)
	$(call dataset-create,collection,ship)
	$(call dataset-create,collection,ship-trend)

seed-harmonization-datasets:
	$(call dataset-create,harmonization,cptp-coreqx)
	$(call dataset-create,harmonization,chpt-generic-ds)

clean-mica:
	rm -rf ${mica_home}

launch-mica-debug:
	export MAVEN_OPTS=-agentlib:jdwp=transport=dt_socket,server=y,address=8002,suspend=n && \
	cd $(CURDIR)/../mica2/mica-webapp && \
	${mvn_exec} spring-boot:run -Pdev -Dspring.profiles.active=dev -DMICA_HOME="${mica_home}" -DMICA_LOG="${mica_log}"

#
# Functions
#
dataset-create = mica rest -mk $(mica_url) -u $(username) -p $(password) -m POST /draft/$(1)-datasets --content-type "application/json" < ./mica2/seed/$(1)-datasets/$(2).json && \
	mica rest -mk $(mica_url) -u $(username) -p $(password) -m PUT /draft/$(1)-dataset/$(2)/_publish
