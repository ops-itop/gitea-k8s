REPO ?= registry.cn-beijing.aliyuncs.com/kubebase/gitea
TAG ?= $(shell git describe --always --dirty)

all: build push
build:
	docker build -t $(REPO):$(TAG) .

push:
	docker push $(REPO):$(TAG)
	docker tag $(REPO):$(TAG) $(REPO):latest
	docker push $(REPO):latest

