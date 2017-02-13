#!/bin/bash
unamestr=`uname`

mkdir -p Executables/
iverilog -o Executables/main.vvp Verilog/main.v

# macOS using Mach-style binaries means leaving some symbols hanging like that isn't viable without a special option.
if [ $unamestr = "Darwin" ]; then
    echo "Compiling for macOS."
    swift build -Xcc -I/usr/local/include/ -Xlinker -undefined -Xlinker dynamic_lookup
    clang -fPIC -dynamiclib -undefined dynamic_lookup -L$(dirname $(dirname $(which swift)))/lib/swift/macosx .build/debug/Swiftlog.build/Swiftlog.swift.o .build/debug/VPIAssistant.build/VPIAssistant.c.o -o Executables/main.vpi -rpath $(dirname $(dirname $(which swift)))/lib/swift/macosx
else
    echo "Compiling for Linux."
    swift build      
    clang -fPIC -shared .build/debug/Swiftlog.build/Swiftlog.swift.o .build/debug/VPIAssistant.build/VPIAssistant.c.o -o Executables/main.vpi -L$(dirname $(dirname $(which swift)))/lib/swift/linux -ldispatch -lFoundation -lswiftCore -lswiftGlibc -lswiftRemoteMirror -lswiftSwiftOnoneSupport -rpath $(dirname $(dirname $(which swift)))/lib/swift/linux
fi