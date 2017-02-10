swift build
mkdir -p Executables/
iverilog Verilog/main.v -o Executables/main.vvp
clang -fPIC -shared .build/debug/Swiftlog.build/Swiftlog.swift.o .build/debug/VPIAssistant.build/VPIAssistant.c.o -o Executables/main.vpi -L$(dirname $(dirname $(which swift)))/lib/swift/linux -ldispatch -lFoundation -lswiftCore -lswiftGlibc -lswiftRemoteMirror -lswiftSwiftOnoneSupport