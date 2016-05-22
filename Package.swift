import PackageDescription

let package = Package(
    name: "Swift-OPC", 
    dependencies: [
    	.Package(url: "https://github.com/IBM-Swift/BlueSocket.git", majorVersion: 0, minor: 5)
    ],
    targets: [Target(name: "OPC")],
    exclude: ["Swift-OPC.xcodeproj", "README.md","Tests"]
)
