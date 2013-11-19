BUILD_DIR=./build
ARTIFACT_DIR=./dist
SSH_DIR=./.ssh

BUILD_DIR_ABSPATH=$(realpath $(BUILD_DIR))
ARTIFACT_DIR_ABSPATH=$(realpath $(ARTIFACT_DIR))
SSH_DIR_ABSPATH=$(realpath $(SSH_DIR))

#all: gnulinux-i386 gnulinux-x86_64 macosx-i386 windows-i386
all: gnulinux-i386 gnulinux-x86_64

gnulinux-i386:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant up; \
	vagrant destroy -f; \
	mv *.tar.gz $(ARTIFACT_DIR_ABSPATH)/

gnulinux-x86_64:
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant up; \
	vagrant destroy -f; \
	mv *.tar.gz $(ARTIFACT_DIR_ABSPATH)/

macosx-i386:
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	vagrant up; \
	vagrant provision; \
	scp -i $(SSH_DIR_ABSPATH)/id_rsa vagrant@192.168.10.10:~/bundle/*.zip $(ARTIFACT_DIR_ABSPATH)/; \
	vagrant destroy -f

windows-i386:
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant up; \
	vagrant provision; \
	scp -i $(SSH_DIR_ABSPATH)/id_rsa vagrant@192.168.10.11:~/bundle/*.exe $(ARTIFACT_DIR_ABSPATH)/; \
	vagrant destroy -f

clean:
	rm -v $(ARTIFACT_DIR_ABSPATH)/*
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-i386; \
	rm -rvf .vagrant
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/gnulinux-x86_64; \
	rm -rvf .vagrant
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/macosx-i386; \
	rm -rvf .vagrant
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	vagrant destroy -f
	@cd $(BUILD_DIR_ABSPATH)/windows-i386; \
	rm -rvf .vagrant
