FROM golang AS build

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest
RUN xcaddy build --with github.com/aksdb/caddy-cgi@v2.0.1

FROM ruby:3-alpine
COPY --from=build /go/caddy /usr/bin/caddy
RUN apk add \
  bash curl jq fd ripgrep \
  build-base postgresql-client postgresql-dev git

RUN gem install pg
RUN mkdir -p /tmp/cgi-scratch

VOLUME /usr/local/cgi-bin
VOLUME /tmp/cgi-scratch
