SHELL = /bin/bash
BURP_DIR = $(HOME)/.java/.userPrefs:$(DOCKER_HOME)/.java/.userPrefs
BURP_CONF = $(HOME)/.BurpSuite:$(DOCKER_HOME)/.BurpSuite
CONTAINER_NAME = burpinabox
CONTAINER_HOSTNAME = $(CONTAINER_NAME)
DOCKER_USER = burp
DOCKER_HOME = /home/$(DOCKER_USER)
XSOCK = /tmp/.X11-unix
XAUTH = /tmp/.docker.xauth

.PHONY: help,build,enable_gui,run,shell
default: help

build:  ## Builds the burp-in-a-box-container - Requires sudo
	sudo docker build -t $(CONTAINER_NAME) -f Dockerfile .

help:	## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

run:  ## This runs burpinabox with GUI enabled
	# GUI Support (https://stackoverflow.com/a/25280523)
	touch $(XAUTH)
	xauth nlist $(DISPLAY) | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -
	echo 'To launch Burp Suite run the command "burp"'
	# -u flag = https://github.com/moby/moby/issues/3206#issuecomment-152682860
	sudo docker run -it --rm -h $(CONTAINER_HOSTNAME) --name $(CONTAINER_NAME) \
	    -u $(shell id -u):$(shell id -g) \
	    -v $(XSOCK):$(XSOCK) -v $(XAUTH):$(XAUTH) -e XAUTHORITY=$(XAUTH) \
	    -v $(BURP_DIR) -v $(BURP_CONF) \
	    -p 8080:8080 \
	    --env="DISPLAY" \
	    burpinabox
