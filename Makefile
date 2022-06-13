dist:
	swagger-cli bundle src/pineapple-api.yml --outfile dist/pineapple-api.yml --type yaml

validate:
	swagger-cli validate src/pineapple-api.yml

.PHONY: dist validate
