# Swiftlog
Swiftlog is a Swift bridge for IcarusVerilog's VPI (PLI 2.0).

The API is not "Swifty", but all of your logic can be written in Swift!

# Requirements
Swift 3.1-dev on Linux, Clang. macOS on the way.

# Usage
So this is slightly finicky. Just a fair warning.

First, run **setup.sh**. This will copy all of Swift's shared objects to /usr/lib. This is required- IcarusVerilog's vvp whatever isn't very flexible in this manner.

Second, run **build.sh**. The magic will happen.

Third, run **run.sh**. If all goes well, this should output.

    Hello from Verilog!
    ..and Hello from Swift!

And you're ready to go! Use all the Swift files you want past this point by putting them in Swiftlog/. On startup, it calls Swiftlog.startup()- so initialize static classes there.

You can delete build intermediates by running **clean.sh**.

Be sure to mark all of these as executable first.

Your clock should be coming from Verilog, and you should provide update functions as such.

# License
GNU GPLv2 or later (at your option). Check 'LICENSE'.