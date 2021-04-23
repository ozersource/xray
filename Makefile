TOPDIR = $(shell pwd)
PKG_NAME:=Xray-core
PKG_VERSION := 1.4.2
PKG_RELEASE:=1
export GO111MODULE=off
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
export GOPROXY=https://goproxy.io

PKG_URL := https://codeload.github.com/XTLS/xray-core/tar.gz/v$(PKG_VERSION)

all:download_PKG build_extract build

build_extract:
	mkdir -p $(TOPDIR)/github.com/xtls
	mkdir -p $(TOPDIR)/bin
	( if [  -d $(TOPDIR)/github.com/xtls/xray-core ]; then \
	tar zxfv $(TOPDIR)/$(PKG_SOURCE) -C $(TOPDIR)/github.com/xtls ; \
	mv $(TOPDIR)/github.com/xtls/$(PKG_NAME)-$(PKG_VERSION) $(TOPDIR)/github.com/xtls/xray-core ; \
	fi )

build:
	( cd $(TOPDIR)/github.com/xtls/xray-core/main ; \
	GOOS=linux GOARCH=mipsle go build -ldflags "-w -s" -o $(TOPDIR)/bin/v2ray; \
	upx --lzma --best $(TOPDIR)/bin/v2ray; \
	)

download_PKG:
	( if [ ! -f /$(TOPDIR)/$(PKG_SOURCE) ]; then \
	curl --create-dirs -L $(PKG_URL) -o /$(TOPDIR)/$(PKG_SOURCE) ; \
	fi )

clean:
	rm -rf $(TOPDIR)/github.com
	rm -rf $(TOPDIR)/bin

