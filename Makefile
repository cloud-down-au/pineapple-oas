DOCKER_RUN=docker run --rm
DOCKER_CLI=$(DOCKER_RUN) $(DOCKER_VOLUMES) $(DOCKER_IMAGE)
DOCKER_IMAGE=pineapple-oas
DOCKER_SERVE=$(DOCKER_RUN) -p 8080:8080 $(DOCKER_VOLUMES) $(DOCKER_IMAGE)
DOCKER_VOLUMES=-v $(CURDIR):/oas

DIST_SPEC=/oas/dist/pineapple-api.json
SRC_SPEC=/oas/src/pineapple-api.yml

assemble:
	@$(DOCKER_CLI) redocly bundle $(SRC_SPEC) --output $(DIST_SPEC) --lint --ext=json

clean:
	rm -rf dist
	docker images | grep "^<none>" | awk '{print $$3}' | xargs -n1 docker rmi

dist: assemble
	@$(DOCKER_CLI) redoc-cli build $(DIST_SPEC) --output /oas/dist/doc/index.html

docker:
	docker build -t pineapple-oas .

serve:
	$(DOCKER_SERVE) redocly preview-docs $(DIST_SPEC) --host=0.0.0.0

.PHONY: assemble clean dist docker
