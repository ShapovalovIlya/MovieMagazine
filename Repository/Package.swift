// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        InternalDependencies.SwiftFP.library,
        InternalDependencies.Redux.library,
        InternalDependencies.Extensions.library,
        .library(name: "NetworkOperator", targets: ["NetworkOperator"]),
        .library(name: "Endpoint", targets: ["Endpoint"]),
        .library(name: "Validator", targets: ["Validator"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Login", targets: ["Login"]),
    ],
    targets: [
        InternalDependencies.SwiftFP.target,
        InternalDependencies.Redux.target,
        InternalDependencies.Extensions.target,
        .target(name: "Validator"),
        .target(name: "Models"),
        .target(
            name: "Core",
            dependencies: [
                InternalDependencies.Redux.dependency,
            ]),
        .target(
            name: "Login",
            dependencies: [
                InternalDependencies.Redux.dependency,
                InternalDependencies.Extensions.dependency,
                "Core",
                "Validator",
            ]),
        .target(
            name: "NetworkOperator",
            dependencies: [
                InternalDependencies.SwiftFP.dependency
            ]),
        .target(
            name: "Endpoint",
            dependencies: [
                InternalDependencies.SwiftFP.dependency
            ]),
        .testTarget(name: "CoreTests", dependencies: ["Core"]),
    ]
)

fileprivate enum InternalDependencies {
    case SwiftFP
    case Extensions
    case Redux
    
    var library: Product {
        switch self {
        case .SwiftFP: return .library(name: "SwiftFP", targets: ["SwiftFP"])
        case .Extensions: return .library(name: "Extensions", targets: ["Extensions"])
        case .Redux: return .library(name: "Redux", targets: ["Redux"])
        }
    }
    
    var target: Target {
        switch self {
        case .SwiftFP: return .target(name: "SwiftFP")
        case .Extensions: return .target(name: "Extensions")
        case .Redux: return .target(name: "Redux")
        }
    }
    
    var dependency: Target.Dependency {
        switch self {
        case .SwiftFP: return "SwiftFP"
        case .Extensions: return "Extensions"
        case .Redux: return "Redux"
        }
    }
    
}
