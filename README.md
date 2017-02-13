# Swiftlog
Swiftlog is a Swift bridge for IcarusVerilog's VPI (PLI 2.0).

The API is not "Swifty" yet, but ~all~ of your logic can be written in Swift!

# Usage
To build, run *build.sh*. This compiles the C, Swift and Verilog components, and generates two files inside **Executables**: main.vpi and main.vpp.

To run, run *run.sh*. If all goes well, you should see:

```bash
    Hello from Verilog!
    ...and Hello from Swift!
```

And you're ready to go! Use all the Swift files you want past this point by putting them in Swiftlog/. On startup, it calls Swiftlog.startup()- so initialize static classes there.

Your clock should be coming from Verilog, and you should provide update functions as such.


# Requirements
You need Swift 3.1-dev installed on your device, which you can get from [Swift.org](https://swift.org/download/#swift-31-development), and set it to work with bash. Swift 3.0 might also work, but just hasn't been been tested yet.

## Ubuntu
Other than Swift, you'll just need Clang and IcarusVerilog.

```bash
    sudo apt install clang iverilog
```

## macOS
You need the latest version of Xcode and IcarusVerilog headers installed to /usr/local/lib. To do that, we just recommend using the [Homebrew](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Installation.md) package manager.

```bash
    brew install icarus-verilog
```

# To-do
* Swiftier syntax. This is no more than an API import with the necessary modifications to make it link against iverilog at the moment.
* Allow more dynamic naming. As it stands, the name of the Verilog file that's loaded is stuck as "main.v". Obviously the user may modify the bash script as they see fit but it's not particularly user friendly.
* Makefile?

# License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.

*Please note that this licensing option was not my choice- it's simply because IcarusVerilog (and every free and open source Verilog simulator, for that matter) is under either GPLv2 or GPLv3 and Swiftlog links against them.

# References
[1] S. Sutherland. The Verilog PLI Handbook: A User's Guide and Comprehensive Reference on the Verilog Programming Language Interface (2nd ed.) 2002666.
