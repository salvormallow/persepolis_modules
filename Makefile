SHELL = /bin/bash

TOPDIR  := $(shell git rev-parse --show-toplevel)
BRANCH := $(git rev-parse --abbrev-ref HEAD)


test:
	@echo 'testing All Necessary modules all together.'
	@make -C firehose_to_s3 test
	@make -C lambda_cloudwatch_trigger test
	@make -C vpc test
