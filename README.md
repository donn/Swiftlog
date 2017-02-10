# Swiftlog
Swiftlog is a Swift bridge for IcarusVerilog's VPI (PLI 2.0).

The API is not "Swifty" yet, but ~all~ of your logic can be written in Swift!

# Usage
So this is slightly finicky. Just a fair warning.

## Ubuntu
### First Time Setup
Before running this for the first time, you need 

```bash
    sudo cp -r $(dirname $(dirname $(which swift)))/lib/swift/linux/* /usr/lib
```

This will copy everything from your current version of Swift to /usr/lib. It's not optimal, but it is the only place where IcarusVerilog looks when loading dynamic modules as far as I know.

### Running
To build, run *build.sh*. This compiles the C, Swift and Verilog components, and generates two files: main.vpi and main.vpp. You may get a warning about Verilog being empty- ignore it. That's the Swift Package Manager.

To run, run *run.sh*. If all goes well, you should see:

    Hello from Verilog!
    ...and Hello from Swift!

And you're ready to go! Use all the Swift files you want past this point by putting them in Swiftlog/. On startup, it calls Swiftlog.startup()- so initialize static classes there.

Your clock should be coming from Verilog, and you should provide update functions as such.

# Requirements
You need Swift 3.1-dev installed on your device, which you can get from [Swift.org](https://swift.org/download/#swift-31-development). Swift 3.0 might also work, but just hasn't been been tested yet.

## Ubuntu
Other than Swift, you'll just need Clang and IcarusVerilog.
```bash
    sudo apt install clang iverilog
```

## macOS
Coming soon.

# To-do
* Swiftier-syntax. This is no more than an API import with the necessary modifications to make it link against iverilog at the moment.
* macOS support. We'll likely need some modifications to some scripts to support the Objective-C runtime.
* Allow more dynamic naming. As it stands, the name of the Verilog file that's loaded is stuck as "main.v". Obviously the user may modify the bash script as they see fit but it's not particularly user friendly.
* Makefile?

# License
GNU GPLv2 or later (at your option). Check 'LICENSE'.

*Please note that this licensing option was not my choice- it's simply because IcarusVerilog (and every free and open source Verilog simulator, for that matter) is under either GPLv2 or GPLv3 and Swiftlog links against them.

# References
[1] S. Sutherland. The Verilog PLI Handbook: A User's Guide and Comprehensive Reference on the Verilog Programming Language Interface (2nd ed.) 2002666.