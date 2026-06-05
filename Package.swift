// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftBlocks",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "SwiftBlocks",
            targets: ["SwiftBlocks"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftBlocks"
        ),
        .testTarget(
            name: "SwiftBlocksTests",
            dependencies: ["SwiftBlocks"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
