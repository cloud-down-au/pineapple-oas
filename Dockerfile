FROM node:14.20-alpine

RUN npm install -g \
  @redocly/cli@latest \
  redoc-cli@0.13.16

# redocly serve
EXPOSE 8080
