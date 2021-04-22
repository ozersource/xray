THISDIR = $(shell pwd)
PKG_NAME:=Xray-core
PKG_VERSION := 1.4.2
PKG_RELEASE:=1
export GO111MODULE=on
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
export GOPROXY=https://goproxy.io

PKG_URL := https://codeload.github.com/XTLS/xray-core/tar.gz/v$(PKG_VERSION)

all:download_PKG build_extract build

build_extract:
	mkdir -p $(THISDIR)/Xray
	mkdir -p $(THISDIR)/bin
	( if [ ! -d $(THISDIR)/$(PKG_SOURCE) ]; then \
	tar zxfv $(THISDIR)/$(PKG_SOURCE) -C $(THISDIR)/Xray ; \
	fi )

build:
	( cd $(THISDIR)/Xray/$(PKG_NAME)-$(PKG_VERSION)/; \
	GOOS=linux GOARCH=mipsle go build -o $(THISDIR)/bin/v2ray -trimpath -ldflags "-s -w -buildid=" ./main; \
	upx --lzma --best $(THISDIR)/bin/v2ray; \
	) 

download_PKG:
	( if [ ! -f $(THISDIR)/$(PKG_SOURCE) ]; then \
	curl --create-dirs -L $(PKG_URL) -o $(THISDIR)/$(PKG_SOURCE) ; \
	fi )

clean:
	rm -rf $(THISDIR)/Xray
	rm -rf $(THISDIR)/bin

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/bin/v2ray /usr/bin/v2ray
	$(ROMFSINST) -p +x $(THISDIR)/bin/v2ray /$(THISDIR)/v2ray