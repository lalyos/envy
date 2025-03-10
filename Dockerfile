FROM alpine:3.21
RUN apk --update add bash curl go git mercurial musl-dev

RUN curl -Ls https://github.com/progrium/execd/releases/download/v0.1.0/execd_0.1.0_Linux_x86_64.tgz \
    | tar -zxC /bin \
  && curl -Ls https://github.com/progrium/entrykit/releases/download/v0.2.0/entrykit_0.2.0_Linux_x86_64.tgz \
    | tar -zxC /bin \
  && curl -sL  https://download.docker.com/linux/static/stable/x86_64/docker-28.0.0.tgz | tar -xzv docker/docker --strip-components 1 -C /bin \
  && entrykit --symlink

ADD ./data /tmp/data

ENV GOPATH /go
COPY . /go/src/github.com/progrium/envy
WORKDIR /go/src/github.com/progrium/envy
RUN go get && CGO_ENABLED=0 go build -a -buildmode exe -installsuffix cgo -o /bin/envy \
  && ln -s /bin/envy /bin/enter \
  && ln -s /bin/envy /bin/auth \
  && ln -s /bin/envy /bin/serve

VOLUME /envy
EXPOSE 22 80
ENTRYPOINT ["codep", "/bin/execd -e -k /tmp/data/id_host /bin/auth /bin/enter", "/bin/serve"]
