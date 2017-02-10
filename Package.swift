import PackageDescription

let package = Package(
    name: "Swiftlog",
    targets: [
        Target(name: "Swiftlog", dependencies: ["VPIAssistant"]),
        Target(name: "VPIAssistant")
    ],
    exclude: ["Executables", "Verilog"]
)