// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .library(name: "NetworkOperator", targets: ["NetworkOperator"]),
        .library(name: "Endpoint", targets: ["Endpoint"]),
        .library(name: "SwiftFP", targets: ["SwiftFP"]),
        .library(name: "Validator", targets: ["Validator"]),
        .library(name: "Core", targets: ["Core"]),
    ],
    targets: [
        .target(name: "SwiftFP"),
        .target(name: "Validator"),
        .target(name: "Core"),
        .target(
            name: "NetworkOperator",
            dependencies: [
                "SwiftFP"
            ]),
        .target(
            name: "Endpoint",
            dependencies: [
                "SwiftFP"
            ]),
//        .testTarget(
//            name: "RepositoryTests",
//            dependencies: [
//                "Endpoint"
//            ])
    ]
)
