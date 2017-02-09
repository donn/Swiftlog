swift build
iverilog main.v -o main.vvp
cp .build/debug/Swiftlog.build/Swiftlog.swift.o .
cp .build/debug/VPIAssistant.build/VPIAssistant.c.o .
clang -fPIC -shared *.o -o main.vpi -L$(dirname $(dirname $(which swift)))/lib/swift/linux -ldispatch -lFoundation -lswiftCore -lswiftGlibc -lswiftRemoteMirror -lswiftSwiftOnoneSupport
rm -f *.o