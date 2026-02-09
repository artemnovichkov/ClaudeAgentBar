// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "StatsClient",
    platforms: [.macOS(.v14)],
    products: [
        .library(
            name: "StatsClient",
            targets: ["StatsClient"]
        ),
    ],
    targets: [
        .target(name: "StatsClient"),
    ]
)
