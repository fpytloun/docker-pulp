ORG ?=
SED := $(shell which gsed || which sed)
TAG := $(shell git describe --tags --abbrev=0)

images: build-pulp-core \
        build-pulp-api \
        build-pulp-content \
        build-pulp-worker

release: release-pulp-core \
         release-pulp-api \
         release-pulp-content \
         release-pulp-worker

images-podman: build-podman-pulp-core \
               build-podman-pulp-api \
               build-podman-pulp-content \
               build-podman-pulp-worker

release-podman: release-podman-pulp-core \
                release-podman-pulp-api \
                release-podman-pulp-content \
                release-podman-pulp-worker

build-podman-%:
	$(eval IMAGE := $(patsubst build-podman-%,%,$@))
	$(SED) -i "s,FROM pulp-core,FROM $(ORG)pulp-core,g" $(IMAGE)/Dockerfile
	cd $(IMAGE) && podman build --format=docker -t $(ORG)$(IMAGE) .

release-podman-%:
	$(eval IMAGE := $(patsubst release-podman-%,%,$@))
	cd $(IMAGE) && podman push $(ORG)$(IMAGE)

build-%:
	$(eval IMAGE := $(patsubst build-%,%,$@))
	$(SED) -i "s,FROM pulp-core,FROM $(ORG)pulp-core,g" $(IMAGE)/Dockerfile
	cd $(IMAGE) && docker build -t $(ORG)$(IMAGE) .

release-%:
	$(eval IMAGE := $(patsubst release-%,%,$@))
	cd $(IMAGE) && \
		docker tag $(ORG)$(IMAGE) $(ORG)$(IMAGE):$(TAG) && \
		docker push $(ORG)$(IMAGE) && \
		docker push $(ORG)$(IMAGE):$(TAG)
