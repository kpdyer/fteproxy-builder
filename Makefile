BUILD_DIR=./build
ARTIFACT_DIR=./dist
SSH_DIR=./.ssh

BUILD_DIR_ABSPATH=$(realpath $(BUILD_DIR))
ARTIFACT_DIR_ABSPATH=$(realpath $(ARTIFACT_DIR))
SSH_DIR_ABSPATH=$(realpath $(SSH_DIR))

all: gnulinux-i386 gnulinux-x86_64 macosx-i386 windows-i386

setup:
	chmod 600 $(SSH_DIR_ABSPATH)/id_rsa
	mkdir -p $(ARTIFACT_DIR_ABSPATH)

gnulinux-i386: setup
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant up; \
	vagrant destroy -f; \
	cp fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/

gnulinux-x86_64: setup
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant up; \
	vagrant destroy -f; \
	cp fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/

macosx-i386: setup
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	vagrant up; \
	vagrant provision; \
	scp -i $(SSH_DIR_ABSPATH)/id_rsa vagrant@192.168.10.10:/vagrant/fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/; \
	vagrant destroy -f

windows-i386: setup
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant up; \
	vagrant provision; \
	scp -i $(SSH_DIR_ABSPATH)/id_rsa vagrant@192.168.10.11:/vagrant/fteproxy/dist/*.tar.gz $(ARTIFACT_DIR_ABSPATH)/; \
	vagrant destroy -f

clean:
	rm -vf $(ARTIFACT_DIR_ABSPATH)/*
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	rm -rvf .vagrant fteproxy build_fteproxy.sh
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	rm -rvf .vagrant fteproxy build_fteproxy.sh
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	rm -rvf .vagrant fteproxy build_fteproxy.sh
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	rm -rvf .vagrant
