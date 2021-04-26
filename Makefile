THISDIR = $(shell pwd)
xray_dir="github.com/xtls/xray-core"
export GO111MODULE=on
export GOPROXY=https://goproxy.io
xray_VERSION := 1.4.2
xray_URL := https://codeload.github.com/XTLS/xray-core/tar.gz/v$(xray_VERSION)

all:download_xray clean build_extract build_xray

download_xray:
	( if [ ! -f $(THISDIR)/Xray-core-$(xray_VERSION).tar.gz ]; then \
	curl --create-dirs -L $(xray_URL) -o $(THISDIR)/Xray-core-$(xray_VERSION).tar.gz ; \
	fi )

build_extract:
	mkdir -p $(THISDIR)/github.com/xtls/
	mkdir -p $(THISDIR)/bin
	( if [ ! -d $(THISDIR)/github.com/xtls/xray-core ]; then \
	tar zxfv $(THISDIR)/Xray-core-$(xray_VERSION).tar.gz -C $(THISDIR)/github.com/xtls ; \
	mv $(THISDIR)/github.com/xtls/Xray-core-$(xray_VERSION) $(THISDIR)/github.com/xtls/xray-core ; \
	fi )

build_xray:
	( cd $(THISDIR)/$(xray_dir); \
	GOOS=linux GOARCH=mipsle go build -o $(THISDIR)/bin/v2ray -trimpath -ldflags "-s -w -buildid=" ./main; \
	upx --lzma --best $(THISDIR)/bin/v2ray; \
	)

clean:
	rm -rf $(THISDIR)/github.com
	rm -rf $(THISDIR)/bin

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/bin/v2ray /usr/bin/v2ray
