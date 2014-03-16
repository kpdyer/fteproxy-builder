BUILD_DIR=./build
ARTIFACT_DIR=./dist
SSH_DIR=./.ssh

FTEPROXY_TAG=master

BUILD_DIR_ABSPATH=$(realpath $(BUILD_DIR))
ARTIFACT_DIR_ABSPATH=$(realpath $(ARTIFACT_DIR))
SSH_DIR_ABSPATH=$(realpath $(SSH_DIR))

all: .envsetup src gnulinux-i386 gnulinux-x86_64 macosx-i386 windows-i386

.envsetup:
	chmod 600 $(SSH_DIR)/id_rsa
	touch .envsetup

src: dist/fteproxy-$(FTEPROXY_TAG)-src.tar.gz
gnulinux-i386: dist/fteproxy-$(FTEPROXY_TAG)-linux-i686.tar.gz
gnulinux-x86_64: dist/fteproxy-$(FTEPROXY_TAG)-linux-x86_64.tar.gz
macosx-i386: dist/fteproxy-$(FTEPROXY_TAG)-darwin-i386.tar.gz
windows-i386: dist/fteproxy-$(FTEPROXY_TAG)-windows-i686.zip

dist/fteproxy-$(FTEPROXY_TAG)-src.tar.gz:
	cd dist; \
	wget https://github.com/kpdyer/fteproxy/archive/$(FTEPROXY_TAG).zip; \
	unzip $(FTEPROXY_TAG).zip; \
	mv fteproxy-$(FTEPROXY_TAG) fteproxy-$(FTEPROXY_TAG)-src; \
	tar cvf fteproxy-$(FTEPROXY_TAG)-src.tar fteproxy-$(FTEPROXY_TAG)-src; \
	gzip -9 fteproxy-$(FTEPROXY_TAG)-src.tar; \
	rm -rfv fteproxy-$(FTEPROXY_TAG)-src; \
	rm -fv $(FTEPROXY_TAG).zip

dist/fteproxy-$(FTEPROXY_TAG)-linux-i686.tar.gz:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant up; \
	vagrant destroy -f; \
	cp fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/

dist/fteproxy-$(FTEPROXY_TAG)-linux-x86_64.tar.gz:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant up; \
	vagrant destroy -f; \
	cp fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/

dist/fteproxy-$(FTEPROXY_TAG)-darwin-i386.tar.gz:
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	vagrant up; \
	vagrant provision; \
	scp -oStrictHostKeyChecking=no -i $(SSH_DIR_ABSPATH)/id_rsa vagrant@192.168.10.10:/vagrant/fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/; \
	vagrant destroy -f

dist/fteproxy-$(FTEPROXY_TAG)-windows-i686.zip:
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant up; \
	vagrant provision; \
	scp -oStrictHostKeyChecking=no -i $(SSH_DIR_ABSPATH)/id_rsa vagrant@192.168.10.11:/vagrant/fteproxy/dist/*.zip $(ARTIFACT_DIR_ABSPATH)/; \
	vagrant destroy -f

clean:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	rm -rvf .vagrant fteproxy
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	rm -rvf .vagrant fteproxy
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	rm -rvf .vagrant fteproxy
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	rm -rvf .vagrant *.msi
