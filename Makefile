DOCKER_RUN=docker run --rm
DOCKER_CLI=$(DOCKER_RUN) $(DOCKER_VOLUMES) $(DOCKER_IMAGE)
DOCKER_IMAGE=kierans777/oas-builder:1.0.0
DOCKER_RENDER_ERROR=$(DOCKER_RENDER_TEMPLATE) $(ERROR_TEMPLATE)
DOCKER_RENDER_TEMPLATE=$(DOCKER_CLI) /usr/local/bin/render-template.sh
DOCKER_SERVE=$(DOCKER_RUN) -p 8080:8080 $(DOCKER_VOLUMES) $(DOCKER_IMAGE)
DOCKER_VOLUMES=-v $(CURDIR):/oas

DIST_SPEC=/oas/dist/pineapple-api.json
SRC_SPEC=/oas/src/pineapple-api.yml

ERROR_TEMPLATE=/oas/src/schemas/errors/generic-error.yml.hbs

assemble: generate
	@$(DOCKER_CLI) npx redocly bundle $(SRC_SPEC) --output $(DIST_SPEC) --lint --ext=json

clean:
	rm -rf dist
	docker images | grep "^<none>" | awk '{print $$3}' | xargs -n1 docker rmi

dist: assemble
	@$(DOCKER_CLI) npx redoc-cli build $(DIST_SPEC) --output /oas/dist/doc/index.html

generate: src/schemas/errors/bad-request.yml \
          src/schemas/errors/forbidden.yml \
          src/schemas/errors/not-found.yml \
          src/schemas/errors/server-error.yml \
          src/schemas/errors/unauthorised.yml

serve:
	$(DOCKER_SERVE) npx redocly preview-docs $(DIST_SPEC) --host=0.0.0.0

src/schemas/errors/bad-request.yml: src/schemas/errors/generic-error.yml.hbs
	$(DOCKER_RENDER_ERROR) '{ "title": "BadRequestError", "code": 400, "error": "Bad Request" }' > src/schemas/errors/bad-request.yml

src/schemas/errors/forbidden.yml: src/schemas/errors/generic-error.yml.hbs
	$(DOCKER_RENDER_ERROR) '{ "title": "ForbiddenError", "code": 403, "error": "Forbidden", "message": "Forbidden resource" }' > src/schemas/errors/forbidden.yml

src/schemas/errors/not-found.yml: src/schemas/errors/generic-error.yml.hbs
	$(DOCKER_RENDER_ERROR) '{ "title": "NotFoundError", "code": 404, "error": "Not Found", "message": "Resource not found" }' > src/schemas/errors/not-found.yml

src/schemas/errors/server-error.yml: src/schemas/errors/generic-error.yml.hbs
	$(DOCKER_RENDER_ERROR) '{ "title": "InternalServerError", "code": 500, "error": "Internal Server Error", "message": "Something went wrong" }' > src/schemas/errors/server-error.yml

src/schemas/errors/unauthorised.yml: src/schemas/errors/generic-error.yml.hbs
	$(DOCKER_RENDER_ERROR) '{ "title": "UnauthorizedError", "code": 401, "error": "Unauthorized", "message": "Missing bearer token" }' > src/schemas/errors/unauthorised.yml

.PHONY: assemble clean dist docker
