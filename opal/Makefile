#
# Opal server
#
opal_url=https://localhost:8443
username=administrator
password=password
taxonomies_ref=1.0
taxonomies_key=xxx

# Database name in opal
database=opal_data

opal-help:
	@echo 
	@echo "Seed Opal server with some generated data. Requires opal python client to be installed."
	@echo
	@echo "Available make targets:"
	@echo "  seed-opal : Seed opal server"

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
	opal rest -o $(opal_url) -u $(username) -p $(password) -m POST "/system/conf/taxonomies/import/_github?user=maelstrom-research&repo=maelstrom-taxonomies&override=true&ref=$(taxonomies_ref)&key=$(taxonomies_key)"

seed-taxonomies-latest:
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
project-create = sed 's/@database@/$(database)/g' ./opal/seed/projects/project-template.json | sed 's/@name@/$(1)/g' | opal rest -o $(opal_url) -u $(username) -p $(password) -m POST /projects --content-type "application/json"

tables-import = opal file -o $(opal_url) -u $(username) -p $(password) -up ./opal/seed/dictionaries/$(1).zip /tmp && \
	opal import-xml -o $(opal_url) -u $(username) -p $(password) -pa /tmp/$(1).zip -d $(1) && \
	while [ `opal rest -o $(opal_url) -u $(username) -p $(password) -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ] ; do echo -n "."; sleep 5; done; echo "."

taxonomy-import = opal rest -o $(opal_url) -u $(username) -p $(password) -m POST "/system/conf/taxonomies/import/_github?repo=maelstrom-taxonomies&key=$(taxonomies_key)&override=true&file=$(1).yml"

table-index = opal rest -o $(opal_url) -u $(username) -p $(password) -m PUT "/datasource/$(1)/table/$(2)/index"