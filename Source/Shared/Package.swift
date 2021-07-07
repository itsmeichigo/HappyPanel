// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shared",
    platforms: [
        .macOS(.v11), .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Shared",
            targets: ["Shared"]),
    ],
    targets: [
        .target(
            name: "Shared",
            dependencies: [],
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "SharedTests",
            dependencies: ["Shared"]),
    ]
)
