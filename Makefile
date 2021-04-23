THISDIR = $(shell pwd)
v2ray_dir="github.com/xtls/xray-core/main"
export GO111MODULE=on
export GOPROXY=https://goproxy.io
V2ray_VERSION := 1.4.2
V2ray_URL := https://codeload.github.com/XTLS/xray-core/tar.gz/v$(PKG_VERSION)

all:download_v2 build_extract build_v2ray

download_v2:
	( if [ ! -f $(THISDIR)/Xray-core-$(V2ray_VERSION).tar.gz ]; then \
	curl --create-dirs -L $(V2ray_URL) -o $(THISDIR)/Xray-core-$(V2ray_VERSION).tar.gz ; \
	fi )

build_extract:
	mkdir -p $(THISDIR)/github.com/xtls/
	mkdir -p $(THISDIR)/bin
	( if [ ! -d $(THISDIR)/github.com/xtls/xray-core ]; then \
	tar zxfv $(THISDIR)/Xray-core-$(V2ray_VERSION).tar.gz -C $(THISDIR)/github.com/xtls ; \
	mv $(THISDIR)/github.com/xtls/Xray-core-$(V2ray_VERSION) $(THISDIR)/github.com/xtls/xray-core ; \
	fi )

build_v2ray:
	( cd $(THISDIR)/$(v2ray_dir); \
	GOOS=linux GOARCH=mipsle go build -ldflags "-w -s" -o $(THISDIR)/bin/v2ray; \
	upx --lzma --best $(THISDIR)/bin/v2ray; \
	)

clean:
	rm -rf $(THISDIR)/github.com
	rm -rf $(THISDIR)/bin

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/bin/v2ray /usr/bin/v2ray
