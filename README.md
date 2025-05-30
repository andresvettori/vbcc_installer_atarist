# vbcc_installer

## About
An automated build script for [VBCC](http://sun.hasenbraten.de/vbcc/) m68k ATARI TOS GEM C Compilers for Unix based systems (MacOS, Linux, etc.).

## Usage
Steps to download VBCC, build it, and verify it by building a simple hello world program: 
```commandline
> make download
> make setup
> make hello
```

The compiled VBCC compiler will be in the folder `./sdk`.

The other folders and files can be deleted.

## Installation

The compiler can be found in the `sdk` folder. You can then copy it to its final destination, such as the `/usr/local` or the `/opt` directory.

Finally, add the VBCC executables to the path and set the VBCC environment variable.
You can do this in the config file of your shell, such as .zhrc (zsh) or .bashrc (bash)

Example, assuming installation in `/opt`:
```bash
export PATH=/opt/vbcc/sdk/vbcc/bin:$PATH
export VBCC=/opt/vbcc/sdk/vbcc
```

## Changing VBCC Versions
Edit the `Makefile` and change the constants on top of it to download newer 
versions of VBCC and its targets.

## Compiling Code
Before you compile, make sure the `sdk/vbcc/bin` is in your PATH and that the VBCC environment variable is set.

Compiling (assuming installation in `/opt`):
```commandline
> vc +tos16 -o hello.tos hello.c 
```

## Dependencies
You need the following tools:
* a compiler, such as gcc or clang
* the `make` tool
* the `wget` tool to download VBCC
* the `lha` tool to extract `.lha` archives

On macOS you can install `wget` and `lha` via [Homebrew](https://brew.sh/) and
install XCode's command line tools to get `make` and a C compiler.  

brew install wget
brew install lhasa

