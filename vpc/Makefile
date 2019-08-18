SHELL = /bin/bash  
TOPDIR  := $(shell git rev-parse --show-toplevel)  
test: 
	@echo 'Building Analytics Infra on AWS' 	
	@cd  $(TOPDIR)/vpc/tests; /usr/local/go/bin/go test
