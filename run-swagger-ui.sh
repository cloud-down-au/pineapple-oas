#! /bin/bash

PORT=8080

docker run --rm \
  -p $PORT:8080 \
  -v $PWD/dist/pineapple-api.yml:/dist/pineapple-api.yml \
  -e SWAGGER_JSON=/dist/pineapple-api.yml \
  swaggerapi/swagger-ui:v4.12.0
