#! /bin/bash

PORT=8080

docker run --rm -p 80:$PORT swaggerapi/swagger-ui
