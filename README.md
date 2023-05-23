# vbcc_installer

## About
An automated build script for [VBCC](http://sun.hasenbraten.de/vbcc/) m68k Amiga C Compilers for Unix based systems (MacOS, Linux, etc.).

## Usage
Steps to download VBCC, build it, and verify it by building a simple hello world program: 
```commandline
> make download
> make setup
> make hello
```

The VBCC compiler will be in the folder "sdk".

The other folders and files can be deleted.

## Changing Versions
Edit the `Makefile` and change the constants on top of it to download newer 
versions of VBCC and its targets.

## Dependencies
You need the following tools:
* a compiler, such as gcc or clang
* the `make` tool
* the `wget` tool to download VBCC
* the `lha` tool to extract `.lha` archives

On macOS you can install `wget` and `lha` via [Homebrew](https://brew.sh/) and
install XCode's command line tools to get `make` and a C compiler.  