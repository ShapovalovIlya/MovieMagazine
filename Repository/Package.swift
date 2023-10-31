// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "NetworkFetcher", targets: ["NetworkFetcher"]),
        .library(name: "Endpoint", targets: ["Endpoint"]),
    ],
    targets: [
        .target(name: "SwiftFP"),
        .target(
            name: "NetworkFetcher",
            dependencies: [
                "SwiftFP"
            ]),
        .target(
            name: "Endpoint",
            dependencies: [
                "SwiftFP"
            ]),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "Endpoint"
            ])
    ]
)
