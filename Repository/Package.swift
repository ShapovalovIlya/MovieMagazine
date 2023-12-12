// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        InternalDependencies.SwiftFP.library,
        InternalDependencies.Extensions.library,
        InternalDependencies.Design.library,
        InternalDependencies.Analytics.library,
        .library(name: "NetworkOperator", targets: ["NetworkOperator"]),
        .library(name: "Endpoint", targets: ["Endpoint"]),
        .library(name: "Validator", targets: ["Validator"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "LoginModule", targets: ["LoginModule"]),
        .library(name: "HomeModule", targets: ["HomeModule"]),
        .library(name: "RootModule", targets: ["RootModule"]),
    ],
    dependencies: [
        .package(url: "git@github.com:ShapovalovIlya/ReduxCore.git", branch: "main"),
    ],
    targets: [
        InternalDependencies.SwiftFP.target,
        InternalDependencies.Extensions.target,
        InternalDependencies.Design.target,
        InternalDependencies.Analytics.target,
        .target(name: "Validator"),
        .target(name: "Models"),
        .target(
            name: "Core",
            dependencies: [
                "Models",
                .product(name: "ReduxCore", package: "ReduxCore"),
            ]),
        .target(
            name: "RootModule",
            dependencies: [
                InternalDependencies.Extensions.dependency,
                InternalDependencies.Analytics.dependency,
                "Core",
            ]),
        .target(
            name: "LoginModule",
            dependencies: [
                InternalDependencies.Extensions.dependency,
                InternalDependencies.Design.dependency,
                InternalDependencies.Analytics.dependency,
                "Core",
                "Validator",
            ]),
        .target(
            name: "HomeModule",
            dependencies: [
                InternalDependencies.Extensions.dependency,
                InternalDependencies.Analytics.dependency,
                "Core",
            ]),
        .target(
            name: "NetworkOperator",
            dependencies: [
                InternalDependencies.SwiftFP.dependency,
                InternalDependencies.Analytics.dependency,
            ]),
        .target(
            name: "Endpoint",
            dependencies: [
                InternalDependencies.SwiftFP.dependency
            ]),
//        .testTarget(name: "CoreTests", dependencies: ["Core"]),
    ]
)

//MARK: - InternalDependencies
fileprivate enum InternalDependencies {
    case SwiftFP
    case Extensions
    case Design
    case Analytics
    
    var library: Product {
        switch self {
        case .SwiftFP: return .library(name: "SwiftFP", targets: ["SwiftFP"])
        case .Extensions: return .library(name: "Extensions", targets: ["Extensions"])
        case .Design: return .library(name: "Design", targets: ["Design"])
        case .Analytics: return .library(name: "Analytics", targets: ["Analytics"])
        }
    }
    
    var target: Target {
        switch self {
        case .SwiftFP: return .target(name: "SwiftFP")
        case .Extensions: return .target(name: "Extensions")
        case .Design: return .target(name: "Design")
        case .Analytics: return .target(name: "Analytics")
        }
    }
    
    var dependency: Target.Dependency {
        switch self {
        case .SwiftFP: return "SwiftFP"
        case .Extensions: return "Extensions"
        case .Design: return "Design"
        case .Analytics: return "Analytics"
        }
    }
    
}
