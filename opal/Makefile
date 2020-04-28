#
# Opal server
#
opal_url=https://localhost:8443
username=administrator
password=password
taxonomies_ref=1.0
taxonomies_key=4929750633404868

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
	$(call project-create,CHPT,Mica)
	$(call project-create,CPTP,Mica)
	$(call project-create,FNAC,Mica)
	$(call project-create,CLS,Mica)
	$(call project-create,CLSA,Mica)
	$(call project-create,FRELE,Mica)
	$(call project-create,HELIAD,Mica)
	$(call project-create,LASA,Mica)
	$(call project-create,LBLS,Mica)
	$(call project-create,NuAge,Mica)
	$(call project-create,PATH,Mica)
	$(call project-create,SHIP,Mica)
	$(call project-create,ULSAM,Mica)
	$(call project-create,CaG,Mica)

seed-tables:
	$(call tables-import,CHPT)
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
	$(call tables-import,CaG)

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

seed-datashield:
	$(call project-create,CNSIM,DataSHIELD)
	$(call tables-import,CNSIM)
	$(call project-create,DASIM,DataSHIELD)
	$(call tables-import,DASIM)
	$(call project-create,DISCORDANT,DataSHIELD)
	$(call tables-import,DISCORDANT)
	$(call project-create,SURVIVAL,DataSHIELD)
	$(call tables-import,SURVIVAL)
	$(call project-create,TESTING,DataSHIELD)
	$(call tables-import,TESTING)

seed-resources:
	$(call project-create,test,Resources)
	$(call resource-create,test,GSE66351)
	$(call resource-create,test,GSE80970)
	$(call resource-create,test,CNSIM1)
	$(call resource-create,test,CNSIM2)
	$(call resource-create,test,CNSIM3)
	$(call resource-create,test,example.vcf)
	$(call resource-create,test,1000G_vcf)
	$(call resource-create,test,1000G_covars)
	$(call resource-create,test,brge_vcf)
	$(call resource-create,test,tcga_liver)
	$(call resource-create,test,brge)
	$(call resource-create,test,obesity_plink)
	$(call resource-create,test,obesity_plink_remote)
	$(call resource-create,test,gps_data)
	$(call resource-create,test,takeaway_gps)
	opal rest -o $(opal_url) -u $(username) -p $(password) -ct "application/json" -m POST /system/subject-token/_current/tokens < ./opal/seed/auth/token.json
	sudo mkdir -p /tmp/rserver/data
	sudo cp opal/seed/data/CNSIM2.zsav /tmp/rserver/data
	sudo cp opal/seed/data/GSE80970.Rdata /tmp/rserver/data
	sudo mkdir -p /tmp/opal/fs/projects/test
	sudo cp opal/seed/data/CNSIM3.zip /tmp/opal/fs/projects/test
	sudo cp opal/seed/data/*RData /tmp/opal/fs/projects/test
	opal rest -o $(opal_url) -u $(username) -p $(password) -m POST "/project/test/permissions/resources?type=USER&permission=RESOURCES_VIEW&principal=dsuser"
	opal user -o $(opal_url) -u $(username) -p $(password) -n dsuser -upa password -a
	opal perm-datashield -o $(opal_url) -u $(username) -p $(password) -s dsuser -ty user -pe use -a

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
project-create = sed 's/@database@/$(database)/g' ./opal/seed/projects/project-template.json | sed 's/@name@/$(1)/g' | sed 's/@tag@/$(2)/g' | opal rest -o $(opal_url) -u $(username) -p $(password) -m POST /projects --content-type "application/json"

tables-import = opal file -o $(opal_url) -u $(username) -p $(password) -up ./opal/seed/dictionaries/$(1).zip /tmp && \
	opal import-xml -o $(opal_url) -u $(username) -p $(password) -pa /tmp/$(1).zip -d $(1) && \
	while [ `opal rest -o $(opal_url) -u $(username) -p $(password) -m GET /shell/commands -j | grep -ch "NOT_STARTED\|IN_PROGRESS"` -gt 0 ] ; do echo -n "."; sleep 5; done; echo "."

taxonomy-import = opal rest -o $(opal_url) -u $(username) -p $(password) -m POST "/system/conf/taxonomies/import/_github?repo=maelstrom-taxonomies&key=$(taxonomies_key)&override=true&file=$(1).yml"

table-index = opal rest -o $(opal_url) -u $(username) -p $(password) -m PUT "/datasource/$(1)/table/$(2)/index"

resource-create = opal rest -o $(opal_url) -u $(username) -p $(password) -ct "application/json" -m POST "/project/$(1)/resources" < ./opal/seed/resources/$(2).json
