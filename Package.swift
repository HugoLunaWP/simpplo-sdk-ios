// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpploSDK",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SimpploSDK",
            targets: ["SimpploSDK"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
            .binaryTarget(
                name: "SimpploSDK",
                url: "https://github.com/HugoLunaWP/simpplo-sdk-ios/releases/download/1.0.0/SimpploSDK.xcframework.zip", checksum: "8f60d58115098c71b969d9d3b3e6a382dde2f8c1a49d9f074b2a1458defcf03e"
            ),
        ]
)
