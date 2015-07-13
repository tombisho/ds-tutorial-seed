# opal and mica servers
opal_url=https://localhost:8443
mica_url=https://localhost:8445
username=administrator
password=password

# database name in opal
database=opal_data

seed-help:
	@echo 
	@echo "Seed Opal and Mica servers with Maelstrom data. Requires opal and mica python clients to be installed."
	@echo
	@echo "Available make targets:"
	@echo "  seed      : Seed opal and mica servers"
	@echo "  seed-opal : Seed opal server"
	@echo "  seed-mica : Seed mica server"

seed: seed-opal seed-mica

seed-mica: seed-studies seed-datasets seed-harmonization-datasets

seed-studies:
	mica import-zip -mk $(mica_url) -u $(username) -p $(password) -pub ./seed/mica/studies

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

seed-opal: seed-projects seed-tables seed-taxonomies

seed-projects:
	$(call project-create,CPTP)
	$(call project-create,FNAC)
	$(call project-create,CLS)
	$(call project-create,CLSA)
	$(call project-create,FRELE)
	$(call project-create,HELIAD)
	$(call project-create,LASA)
	$(call project-create,LBLS)
	$(call project-create,NuAge)
	$(call project-create,PATH)
	$(call project-create,SHIP)
	$(call project-create,ULSAM)
	
seed-tables:
	$(call tables-import,CPTP)
	$(call tables-import,FNAC)
	$(call tables-import,CLS)
	$(call tables-import,CLSA)
	$(call tables-import,FRELE)
	$(call tables-import,HELIAD)
	$(call tables-import,LASA)
	$(call tables-import,LBLS)
	$(call tables-import,NuAge)
	$(call tables-import,PATH)
	$(call tables-import,SHIP)
	$(call tables-import,ULSAM)

seed-index:
	$(call table-index,FNAC,FNAC)
	$(call table-index,CPTP,Atlantic2_coreqx)
	$(call table-index,CPTP,Atlantic_Online_coreqx)
	$(call table-index,CPTP,Bcgp-onl_coreqx)
	$(call table-index,CPTP,Bcgp-opal_coreqx)
	$(call table-index,CPTP,Bcgp-tel_coreqx)
	$(call table-index,CPTP,Cag_coreqx)
	$(call table-index,CPTP,OHS1_coreqx)
	$(call table-index,CPTP,OHS2_coreqx)
	$(call table-index,CPTP,TTP_CoreQA_coreqx)
	$(call table-index,CPTP,TTP_UHLQ_coreqx)

seed-taxonomies:
	$(call taxonomy-import,AreaOfInformation)
	$(call taxonomy-import,Harmonization)
	$(call taxonomy-import,AdditionalInformation)
	$(call taxonomy-import,scales/Cognition)
	$(call taxonomy-import,scales/GeneralHealth)
	$(call taxonomy-import,scales/Habits)
	$(call taxonomy-import,scales/Social)

#
# Functions
#
project-create = sed 's/@database@/$(database)/g' ./seed/opal/projects/project-template.json | sed 's/@name@/$(1)/g' | opal rest -o $(opal_url) -u $(username) -p $(password) -m POST /projects --content-type "application/json"

tables-import = opal file -o $(opal_url) -u $(username) -p $(password) -up ./seed/opal/dictionaries/$(1).zip /tmp && \
	opal import-xml -o $(opal_url) -u $(username) -p $(password) -pa /tmp/$(1).zip -d $(1) && \
	while [ `opal rest -o $(opal_url) -u $(username) -p $(password) -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ] ; do echo -n "."; sleep 5; done; echo "."

dataset-create = mica rest -mk $(mica_url) -u $(username) -p $(password) -m POST /draft/$(1)-datasets --content-type "application/json" < ./seed/mica/$(1)-datasets/$(2).json && \
	mica rest -mk $(mica_url) -u $(username) -p $(password) -m PUT /draft/$(1)-dataset/$(2)/_publish

taxonomy-import = opal rest -o $(opal_url) -u $(username) -p $(password) -m POST "/system/conf/taxonomies/import/_github?repo=maelstrom-taxonomies&file=$(1).yml"

table-index = opal rest -o $(opal_url) -u $(username) -p $(password) -m PUT "/datasource/$(1)/table/$(2)/index"