///@SWIFTLOG: main.v
import Swiftlog
import VPIAssistant

@_cdecl("swiftlog_startup")
func startup() {
    let helloWorld = Procedure(name: "$hello_world", executionClosure: {
        _ in
        print("...and Hello from Swift!")
        return true
    })
    helloWorld.register()

    let result = Procedure(name: "$show_result", arguments: [.net], executionClosure: {
        arguments in
        print("Result:", arguments[0].asInt)
        return true
    })
    result.register()
}