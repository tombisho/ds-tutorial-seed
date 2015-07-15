

include mica2/Makefile
include opal/Makefile
include drupal/Makefile

help: mica-help opal-help drupal-help

clean:
	rm -rf target


