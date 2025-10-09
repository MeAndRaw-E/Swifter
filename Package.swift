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
        .package(url: "https://github.com/MeAndRaw-E/LoggingTime", branch: "master")
    ],
    targets: [
        .target(
            name: "Swifter",
            dependencies: [
                .product(name: "LoggingTime", package: "LoggingTime")
            ]
        )
    ]
)
