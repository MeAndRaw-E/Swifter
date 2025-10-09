// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Swifter",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "Swifter",
            targets: ["Swifter"]
        )
    ],
    dependencies: [
        .package(
            path: "/Users/Raw-E/Desktop/Projects/Useful Swift Things/My Packages/Logging Time"
        )
    ],
    targets: [
        .target(
            name: "Swifter",
            dependencies: [
                .product(name: "LoggingTime", package: "Logging Time")
            ]
        )
    ]
)
