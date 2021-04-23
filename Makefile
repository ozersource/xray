THISDIR = $(shell pwd)
PKG_NAME:=Xray-core
PKG_VERSION := 1.4.2
PKG_RELEASE:=1
export GO111MODULE=off
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
export GOPROXY=https://goproxy.io

PKG_URL := https://codeload.github.com/XTLS/xray-core/tar.gz/v$(PKG_VERSION)

all:download_PKG build_extract build

build_extract:
	
	mkdir -p $(THISDIR)/bin
	
	tar zxfv $(THISDIR)/$(PKG_SOURCE) -C $(THISDIR)


build:
	( cd $(THISDIR)/$(PKG_NAME)-$(PKG_VERSION) ; \
	GOOS=linux GOARCH=mipsle go build -ldflags "-w -s buildid=" ./main -o $(THISDIR)/bin/v2ray; \
	upx --lzma --best $(THISDIR)/bin/v2ray; \
	)

download_PKG:
	( if [ ! -f $(THISDIR)/$(PKG_SOURCE) ]; then \
	curl --create-dirs -L $(PKG_URL) -o $(THISDIR)/$(PKG_SOURCE) ; \
	fi )

clean:
	rm -rf $(THISDIR)/$(PKG_NAME)-$(PKG_VERSION)
	rm -rf $(THISDIR)/bin

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/bin/v2ray /usr/bin/v2ray
