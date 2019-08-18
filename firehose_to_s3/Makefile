SHELL = /bin/bash  
TOPDIR  := $(shell git rev-parse --show-toplevel)

.ONESHELL:
test: 
	@echo 'Building Analytics Infra on AWS' 	
	@cd  $(TOPDIR)/firehose_to_s3/tests && /usr/local/go/bin/go test
