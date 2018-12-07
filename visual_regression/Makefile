SHELL := /bin/bash
# BackstopJS Command helper
backstop_dir=~/projects/obiba-home/visual_regression
lagServer=1

#layout 2
LAYOUT2SCENARIOS = $(patsubst layout2/%.js,%,$(wildcard layout2/*.js))
#Layout 1
LAYOUT1SCENARIOS = $(patsubst layout1/%.js,%,$(wildcard layout1/*.js))

#dev
dev_scenario=scenariosCollectedDatasetsListPage
layout_dev=layout2
dev=dev

test-help:
	@echo
	@echo "Test inetegration installation and facilities"
	@echo
	@echo "Available make targets:"
	@echo "  install-test   : Install the test frame-work + dependecies (backstopJs)"
	@echo "  site-reference 		: Create the references test (@param  lagServer :A coefficient to delay a waits on desired screens to shots, host : the target host default : http://localhost/drupal), referenceUrl: The choosen target host : (https://localhost/release-drupal)"
	@echo "  site-test 		: test the target web site (@param  lagServer :A coefficient to delay the waits on desired screens to shots, host : the target host default : http://localhost/drupal), referenceUrl: The choosen target host : (https://localhost/release-drupal)"
	@echo "  site-report 	: Open a report for the last test (@param  host : the target host default : http://localhost/drupal), referenceUrl: The choosen target host : (https://localhost/release-drupal)"
	@echo "  test-dev 		: test a dev config the target web site (@param  lagServer :A coefficient to delay the waits on desired screens to shots, host : the target host default : http://localhost/drupal), referenceUrl: The choosen target host : (https://localhost/release-drupal), dev: optional if 'last' perform the last test scenario"
	@echo "  reference-dev 	: Create the references test using dev config (@param  lagServer :A coefficient to delay the waits on desired screens to shots, host : the target host default : http://localhost/drupal), referenceUrl: The choosen target host : (https://localhost/release-drupal)"
	@echo

install-test: 
	echo "backstopjs installtion dependecies" && \
	npm install backstopjs -g && \
	npm install minimist && \
	npm install  xpath-to-css

site-reference:
	$(call backstop-action,reference,layout1,$(LAYOUT1SCENARIOS)) && \
	$(call backstop-action,reference,layout2,$(LAYOUT2SCENARIOS))
	echo "Test complete"

site-test:
	$(call backstop-action,test,layout1,$(LAYOUT1SCENARIOS)) || \
	$(call backstop-action,test,layout2,$(LAYOUT2SCENARIOS))

site-report:
	$(call backstop-action,openReport,layout1,$(LAYOUT1SCENARIOS)) && \
	$(call backstop-action,openReport,layout2,$(LAYOUT2SCENARIOS))

site-approve:
	pushd $(backstop_dir) && \
	$(call switch-layout,$(layout_dev)) && \
	backstop approve --configPath=backstop.js --scenariosSet=$(scenario).js --host=$(host) --referenceUrl=$(referenceUrl) --lagServer=$(lagServer) --testFolder=$(scenario) --layout=$(layout) && popd

reference-dev:
	pushd $(backstop_dir) && \
	$(call switch-layout,$(layout_dev)) && \
	backstop reference --configPath=backstop.js --dev=$(dev) --scenariosSet=$(dev_scenario).js --host=$(host) --referenceUrl=$(referenceUrl) --lagServer=$(lagServer) --testFolder=$(dev_scenario) --layout=$(layout_dev) && popd

test-dev:
	pushd $(backstop_dir) && \
	$(call switch-layout,$(layout_dev)) && \
	backstop test --configPath=backstop.js --dev=$(dev) --scenariosSet=$(dev_scenario).js --host=$(host) --referenceUrl=$(referenceUrl) --lagServer=$(lagServer) --testFolder=$(dev_scenario) --layout=$(layout_dev) && popd


backstop-action = pushd $(backstop_dir) && \
				$(call switch-layout,$(2)) && \
				for file in $(3) ; \
				do \
						$(call backstop-command,$(1),$(host),$(lagServer),$(referenceUrl),$(2),$$file) ; \
				done


backstop-command = backstop $(1) --configPath=backstop.js --scenariosSet=$(6).js --host=$(2) --referenceUrl=$(4) --lagServer=$(3) --testFolder=$(6) --layout=$(5)

switch-layout = sed 's/@layout@/$(1)/g' config.json.layout > config.json && \
	mica rest /config -m PUT  -u administrator -p password -mk http://localhost:8082 --content-type  application/json < config.json && \
	rm -rf config.json