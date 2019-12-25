FROM ruby:2.6-slim-stretch

RUN apt-get update && apt-get install -y wget git locales && locale-gen ja_JP.UTF-8
RUN wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
WORKDIR /opt
ENV GOPATH /go
ENV RUBYOPT -EUTF-8
ENV PATH $PATH:/usr/local/go/bin
ENV PATH $PATH:/root/go/bin
RUN go get -u github.com/golang/dep/cmd/dep

COPY .licensed.yaml /opt/.licensed.yaml
# COPY licensed-2.2.0-linux-x64.tar.gz /opt/licensed-2.2.0-linux-x64.tar.gz
# RUN cd /opt && tar xzvf licensed-2.2.0-linux-x64.tar.gz
ADD https://github.com/github/licensed/releases/download/2.2.0/licensed-2.2.0-linux-x64.tar.gz /opt/licensed
RUN cd /opt && tar xvf licensed

# RUN go get gopkg.in/src-d/go-license-detector.v3/cmd/license-detector \
#     && go build -v gopkg.in/src-d/go-license-detector.v3/cmd/license-detector

# Inherit this image and do the following (golang dep)
# COPY . /go/src/local
# RUN cd /go/src/local && dep ensure -v -vendor-only
# ...

CMD ["/bin/sh", "-c", "./licensed cache && ./licensed status && ./licensed list"]
