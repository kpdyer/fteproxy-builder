BUILD_DIR=./build
ARTIFACT_DIR=./dist
SSH_DIR=./.ssh

FTEPROXY_VER=0.3.0
FTEPROXY_TAG=master#$(FTEPROXY_VER)

BUILD_DIR_ABSPATH=$(realpath $(BUILD_DIR))
ARTIFACT_DIR_ABSPATH=$(realpath $(ARTIFACT_DIR))
SSH_DIR_ABSPATH=$(realpath $(SSH_DIR))

all: .envsetup src gnulinux-i386 gnulinux-x86_64 macosx-i386 windows-i386

.envsetup:
	chmod 600 $(SSH_DIR)/id_rsa
	touch .envsetup

src: dist/fteproxy-$(FTEPROXY_VER)-src.tar.gz
gnulinux-i386: dist/fteproxy-$(FTEPROXY_VER)-linux-i386.tar.gz
gnulinux-x86_64: dist/fteproxy-$(FTEPROXY_VER)-linux-x86_64.tar.gz
macosx-i386: dist/fteproxy-$(FTEPROXY_VER)-darwin-i386.tar.gz
windows-i386: dist/fteproxy-$(FTEPROXY_VER)-windows-i386.zip

dist/fteproxy-$(FTEPROXY_VER)-src.tar.gz:
	cd dist; \
	wget https://github.com/kpdyer/fteproxy/archive/$(FTEPROXY_TAG).zip; \
	unzip $(FTEPROXY_TAG).zip; \
	rm $(FTEPROXY_TAG).zip; \
	mv fteproxy-$(FTEPROXY_TAG) fteproxy-$(FTEPROXY_VER)-src; \
	tar cvf fteproxy-$(FTEPROXY_VER)-src.tar fteproxy-$(FTEPROXY_VER)-src; \
	gzip -9 fteproxy-$(FTEPROXY_VER)-src.tar; \
	rm -rfv fteproxy-$(FTEPROXY_VER)-src; \
	rm -fv $(FTEPROXY_VER).zip

dist/fteproxy-$(FTEPROXY_VER)-linux-i386.tar.gz:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant up; \
	cp sandbox/fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/; \
	cp sandbox/fteproxy/dist/*.deb $(ARTIFACT_DIR_ABSPATH)/

dist/fteproxy-$(FTEPROXY_VER)-linux-x86_64.tar.gz:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant up; \
	cp sandbox/fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/; \
	cp sandbox/fteproxy/dist/*.deb $(ARTIFACT_DIR_ABSPATH)/

dist/fteproxy-$(FTEPROXY_VER)-darwin-i386.tar.gz:
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	./build_fteproxy.sh; \
	cp sandbox/fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/

dist/fteproxy-$(FTEPROXY_VER)-windows-i386.zip:
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant up; \
	cp sandbox/fteproxy/dist/*.zip $(ARTIFACT_DIR_ABSPATH)/

clean:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	rm -rvf .vagrant sandbox
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	rm -rvf .vagrant sandbox
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	rm -rvf .vagrant sandbox
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	rm -rvf .vagrant sandbox
