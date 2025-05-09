shell=/bin/bash

URL_TARGETS_DIR=http://phoenix.owl.de/vbcc/2022-05-22
URL_VBCC=http://phoenix.owl.de/tags/vbcc.tar.gz
URL_VLINK=http://phoenix.owl.de/tags/vlink.tar.gz
URL_VASM=http://phoenix.owl.de/tags/vasm.tar.gz

DOWNLOAD_DIR=./downloads

all:
	@echo "VBCC Installer for macOS / Linux"
	@echo "--------------------------------"
	@echo
	@echo "Targets:"
	@echo " * download - downloads VBCC and dependencies"
	@echo " * setup - builds VBCC. Results are in ./sdk"
	@echo " * clean - removes everything ecept the downloaded files"
	@echo " * hello - builds a hello world (hello.c) test program"
	@echo
	@echo "Notes:"
	@echo " * When running setup, answer all questions with their default values."

hello:
	@echo "building test program"
	PATH=./sdk/vbcc/bin:$$PATH VBCC=./sdk/vbcc ./sdk/vbcc/bin/vc  +tos16 -o hello.tos hello.c
	@echo "DONE - hello"

.PHONY: download
download:
	@mkdir -p $(DOWNLOAD_DIR)
	@wget $(URL_VLINK) -O $(DOWNLOAD_DIR)/vlink.tar.gz
	@wget $(URL_VASM) -O $(DOWNLOAD_DIR)/vasm.tar.gz
	@wget $(URL_TARGETS_DIR)/vbcc_target_m68k-atari.tar.gz -P $(DOWNLOAD_DIR)
	@wget $(URL_TARGETS_DIR)/vbcc_unix_config.tar.gz -P $(DOWNLOAD_DIR)
	@wget $(URL_VBCC) -O $(DOWNLOAD_DIR)/vbcc.tar.gz
	@echo "DONE - download"

.PHONY: clean
clean:
	-@rm *.info
	-@rm -R ./vbcc
	-@rm -R ./vasm
	-@rm -R ./vlink
	-@rm -R ./vbcc_target_m68k-atari
	-@rm -R ./config
	-@rm -R ./sdk
	-@rm -R $(DOWNLOAD_DIR)
	-@rm hello
	@echo "DONE - clean"

.PHONY: setup
setup: build_compiler atari_targets build_asm build_linker 
	@echo "DONE - setup"

.PHONY: build_compiler
build_compiler:
	@mkdir -p ./sdk/vbcc
	@mkdir -p ./vbcc/bin
	@tar xvfz $(DOWNLOAD_DIR)/vbcc.tar.gz -C .
	@cd vbcc
	@cd ./vbcc && make TARGET=m68k
	@cp -r ./vbcc/bin ./sdk/vbcc
	@echo "DONE - build_compiler"

# EXPAND ATARI TARGETS
.PHONY: atari_targets
atari_targets:
	@mkdir -p ./sdk/vbcc
	@tar xvfz $(DOWNLOAD_DIR)/vbcc_target_m68k-atari.tar.gz -C .
	@cp -R vbcc_target_m68k-atari/* ./sdk/vbcc
	@tar xvfz $(DOWNLOAD_DIR)/vbcc_unix_config.tar.gz -C .
	@cp -R ./config ./sdk/vbcc	
	@echo "DONE - atari_targets"

# INSTALL VASM CROSS-ASSEMBLER
.PHONY: build_asm
build_asm:
	@mkdir -p ./sdk/vbcc/bin
	@tar xvfz $(DOWNLOAD_DIR)/vasm.tar.gz -C .
	@cd ./vasm && make CPU=m68k SYNTAX=mot
	@cp ./vasm/vasmm68k_mot ./vasm/vobjdump ./sdk/vbcc/bin
	@echo "DONE - build_asm"

# INSTALL VLINK LINKER
.PHONY: build_linker
build_linker:
	@mkdir -p ./sdk/vbcc/bin
	@tar xvfz $(DOWNLOAD_DIR)/vlink.tar.gz -C .
	@mkdir -p ./vlink/obj
	@cd ./vlink && make
	@cp ./vlink/vlink ./sdk/vbcc/bin
	@echo "DONE - build_linker"

