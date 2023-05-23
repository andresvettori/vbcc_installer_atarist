shell=/bin/bash

all:
	@echo "VBCC Installer for macOS"
	@echo "Targets:"
	@echo " * download - downloads VBCC and dependencies"
	@echo " * setup - builds VBCC. Results are in ./sdk"
	@echo " * clean - removes everything ecept the downloaded files"
	@echo " * hello - builds a hello world (hello.c) test program"
	@echo
	@echo "Notes:"
	@echo " * When running setup, answer all questions with their default values."
	@echo
	@echo "EXAMPLE: Add the following to your .zhrc:"
	@echo "export PATH=/opt/vbcc/sdk/vbcc/bin:$$PATH"
	@echo "export VBCC=/opt/vbcc/sdk/vbcc"
	@echo

hello:
	@echo "building test program"
	@PATH=./sdk/vbcc/bin:$$PATH VBCC=./sdk/vbcc ./sdk/vbcc/bin/vc +kick13 -c99 hello.c -o hello
	@echo "DONE - hello"

.PHONY: download
download:
	@wget http://sun.hasenbraten.de/vlink/release/vlink.tar.gz
	@wget http://sun.hasenbraten.de/vasm/release/vasm.tar.gz
	@wget http://phoenix.owl.de/vbcc/2019-10-04/vbcc_target_m68k-amigaos.lha
	@wget http://phoenix.owl.de/vbcc/2019-10-04/vbcc_target_m68k-kick13.lha
	@wget http://phoenix.owl.de/vbcc/2019-10-04/vbcc_unix_config.tar.gz
	@wget http://phoenix.owl.de/tags/vbcc0_9g.tar.gz
	@wget http://www.haage-partner.de/download/AmigaOS/NDK39.lha
	@echo "DONE - download"

.PHONY: clean
clean:
	-@rm *.info
	-@rm -R ./vbcc
	-@rm -R ./vasm
	-@rm -R ./vlink
	-@rm -R ./vbcc_target_m68k-amigaos
	-@rm -R ./vbcc_target_m68k-kick13
	-@rm -R ./config
	@echo "DONE - clean"

.PHONY: setup
setup: build_compiler amiga_targets build_asm build_linker install_ndk
	@echo "DONE - setup"

.PHONY: build_compiler
build_compiler:
	@mkdir -p ./sdk/vbcc
	@mkdir -p ./vbcc/bin
	@tar xvfz vbcc0_9g.tar.gz
	@cd vbcc
	@cd ./vbcc && make TARGET=m68k
	@cp -r ./vbcc/bin ./sdk/vbcc
	@echo "DONE - build_compiler"

# EXPAND AMIGA TARGETS
.PHONY: amiga_targets
amiga_targets:
	@mkdir -p ./sdk/vbcc
	@tar xvfz vbcc_target_m68k-amigaos.lha
	@mv vbcc_target_m68k-amigaos\\targets\\m68k-amigaos\\include\\proto\\bevel.h vbcc_target_m68k-amigaos/targets/m68k-amigaos/include/proto/bevel.h
	@cp -R vbcc_target_m68k-amigaos/* ./sdk/vbcc
	@tar xvfz vbcc_target_m68k-kick13.lha
	@cp -R vbcc_target_m68k-kick13/* ./sdk/vbcc
	@tar xvfz vbcc_unix_config.tar.gz
	@rm -R ./sdk/vbcc/config
	@cp -R ./config ./sdk/vbcc
	@echo "DONE - amiga_targets"

# INSTALL VASM CROSS-ASSEMBLER
.PHONY: build_asm
build_asm:
	@mkdir -p ./sdk/vbcc/bin
	@tar xvfz vasm.tar.gz
	@cd ./vasm && make CPU=m68k SYNTAX=mot
	@cp ./vasm/vasmm68k_mot ./vasm/vobjdump ./sdk/vbcc/bin
	@echo "DONE - build_asm"

# INSTALL VLINK LINKER
.PHONY: build_linker
build_linker:
	@mkdir -p ./sdk/vbcc/bin
	@tar xvfz vlink.tar.gz
	@mkdir -p ./vlink/obj
	@cd ./vlink && make
	@cp ./vlink/vlink ./sdk/vbcc/bin
	@echo "DONE - build_linker"

# INSTALL AMIGA NDK
.PHONY: install_ndk
install_ndk:
	@lha x NDK39.lha
	@mv NDK_3.9 ./sdk
	@echo "DONE - install_ndk"