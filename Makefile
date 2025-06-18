# Using the "Makes" Makefile setup - https://github.com/makeplus/makes
M := $(or $(MAKES_REPO_DIR),.cache/makes)
$(shell [ -d $M ] || git clone -q https://github.com/makeplus/makes $M)
include $M/init.mk
include $M/clean.mk
include $M/ys.mk
include $M/yq.mk

SETTINGS-XSD := settings-1.0.0.xsd
SETTINGS-XSD-URL := https://maven.apache.org/xsd/$(SETTINGS-XSD)

SETTINGS-YAML := settings.yaml
SETTINGS-SCHEMA-YAML := $(SETTINGS-XSD:%.xsd=%.yaml)

MAKES-CLEAN := \
  $(RM) $(SETTINGS-YAML) \
  $(SETTINGS-SCHEMA-YAML) \
  $(SETTINGS-XSD) \


default:: all

all: $(SETTINGS-YAML) $(SETTINGS-SCHEMA-YAML)

%.yaml: %.xml $(YQ) $(YS)
	yq -p xml -o yaml $< | ys -Y - > $@

%.yaml: %.xsd $(YQ) $(YS)
	yq -p xml -o yaml $< | ys -Y - > $@

$(SETTINGS-XSD):
	curl -s $(SETTINGS-XSD-URL) > $@
