# Swiftlog
Swiftlog is a Swift bridge for IcarusVerilog's VPI (PLI 2.0).

A Swiftier API is in the works, but \~all\~ of your logic can be written in Swift!

# Usage
Make a folder with your VPI module's name. Copy all verilog modules inside, and make sure all includes use that folder as root (i.e. \`include "Mux.v", not \`include "SwiftlogExample/Mux.v").

Create a file called Startup.swift, and use this template:

```swift
///@SWIFTLOG: <Verilog File To Simulate Here>
import Swiftlog
import VPIAssistant

@_cdecl("swiftlog_startup")
func startup() {
    //Initialize here...
}
```

Then set up your procedures where it says initialize here.

An example has been provided, to run it, just write `./simulate SwiftlogExample`. If all goes well, you should see.

```bash
    Hello from Verilog!
    ...and Hello from Swift!
    Result: 999
```

Your clock should be coming from Verilog, and you should provide update functions as such.


# Requirements
You need Swift 5.0, which you can get from [Swift.org](https://swift.org/download), and add it to the PATH. On macOS, that means Xcode and the Xcode commandline tools must be active.

## macOS
As a result of the changes to Swift library locations, only **macOS 10.15 Catalina is supported**. (Sorry.)

You need the latest version of Xcode and IcarusVerilog headers installed to /usr/local/lib. To do that, we just recommend using the [Homebrew](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Installation.md) package manager.

```bash
    brew install icarus-verilog
```


## Ubuntu
Other than Swift, you'll just need Clang and IcarusVerilog.

```bash
    sudo apt install clang iverilog
```
# License
GNU General Public License v2 or (at your option), any later version. Check 'LICENSE'.

*Please note that this licensing option was not my choice- it's simply because IcarusVerilog (and every free and open source Verilog simulator, for that matter) is under either GPLv2 or GPLv3 and Swiftlog links against them.

# References
[1] S. Sutherland. The Verilog PLI Handbook: A User's Guide and Comprehensive Reference on the Verilog Programming Language Interface (2nd ed.) 2002666.
