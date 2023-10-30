// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        
    ],
    targets: [
        .target(name: "Endpoint"),
        .testTarget(
            name: "RepositoryTests",
            dependencies: [
                "Endpoint"
            ])
    ]
)
