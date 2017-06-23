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

seed-mica: seed-studies seed-harmonization-studies seed-datasets seed-harmonization-datasets

seed-studies:
	mica import-zip -mk $(mica_url) -u $(username) -p $(password) -pub ./mica2/seed/studies

seed-harmonization-studies:
	mica import-zip -mk $(mica_url) -u $(username) -p $(password) -pub ./mica2/seed/harmonization-studies

seed-datasets: seed-study-datasets

seed-study-datasets: seed-study-datasets-cls seed-study-datasets-clsa seed-study-datasets-fnac seed-study-datasets-frele seed-study-datasets-lbls seed-study-datasets-nuage seed-study-datasets-ulsam seed-study-datasets-lasa seed-study-datasets-ship

seed-study-datasets-cls:
	$(call dataset-create,study,cls-wave1)
	$(call dataset-create,study,cls-wave2)
	$(call dataset-create,study,cls-wave3)
	$(call dataset-create,study,cls-wave4)

seed-study-datasets-clsa:
	$(call dataset-create,study,clsa)

seed-study-datasets-fnac:
	$(call dataset-create,study,fnac)

seed-study-datasets-frele:
	$(call dataset-create,study,frele)

seed-study-datasets-lbls:
	$(call dataset-create,study,lbls-1978)
	$(call dataset-create,study,lbls-1981)
	$(call dataset-create,study,lbls-1994)
	$(call dataset-create,study,lbls-1997)
	$(call dataset-create,study,lbls-2000)
	$(call dataset-create,study,lbls-2003)
	$(call dataset-create,study,lbls-2008)

seed-study-datasets-nuage:
	$(call dataset-create,study,nuage-t1)
	$(call dataset-create,study,nuage-t2)
	$(call dataset-create,study,nuage-t3)
	$(call dataset-create,study,nuage-t4)

seed-study-datasets-ulsam:
	$(call dataset-create,study,ulsam-50)
	$(call dataset-create,study,ulsam-60)
	$(call dataset-create,study,ulsam-70)
	$(call dataset-create,study,ulsam-77)
	$(call dataset-create,study,ulsam-82)
	$(call dataset-create,study,ulsam-88)

seed-study-datasets-lasa:
	$(call dataset-create,study,lasa-1)
	$(call dataset-create,study,lasa-2)
	$(call dataset-create,study,lasa-3)

seed-study-datasets-ship:
	$(call dataset-create,study,ship)
	$(call dataset-create,study,ship-trend)

seed-harmonization-datasets:
	$(call dataset-create,harmonization,cptp-coreqx)

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
