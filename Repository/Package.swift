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
        InternalDependencies.Design.library,
        .library(name: "NetworkOperator", targets: ["NetworkOperator"]),
        .library(name: "Endpoint", targets: ["Endpoint"]),
        .library(name: "Validator", targets: ["Validator"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Core", targets: ["Core"]),
        .library(name: "LoginModule", targets: ["LoginModule"]),
        .library(name: "HomeModule", targets: ["HomeModule"]),
        .library(name: "RootModule", targets: ["RootModule"]),
    ],
    targets: [
        InternalDependencies.SwiftFP.target,
        InternalDependencies.Redux.target,
        InternalDependencies.Extensions.target,
        InternalDependencies.Design.target,
        .target(name: "Validator"),
        .target(name: "Models"),
        .target(
            name: "Core",
            dependencies: [
                InternalDependencies.Redux.dependency,
            ]),
        .target(
            name: "RootModule",
            dependencies: [
                InternalDependencies.Redux.dependency,
                InternalDependencies.Extensions.dependency,
                "Core",
            ]),
        .target(
            name: "LoginModule",
            dependencies: [
                InternalDependencies.Redux.dependency,
                InternalDependencies.Extensions.dependency,
                InternalDependencies.Design.dependency,
                "Core",
                "Validator",
            ]),
        .target(
            name: "HomeModule",
            dependencies: [
                InternalDependencies.Redux.dependency,
                InternalDependencies.Extensions.dependency,
                "Core",
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

//MARK: - InternalDependencies
fileprivate enum InternalDependencies {
    case SwiftFP
    case Extensions
    case Redux
    case Design
    
    var library: Product {
        switch self {
        case .SwiftFP: return .library(name: "SwiftFP", targets: ["SwiftFP"])
        case .Extensions: return .library(name: "Extensions", targets: ["Extensions"])
        case .Redux: return .library(name: "Redux", targets: ["Redux"])
        case .Design: return .library(name: "Design", targets: ["Design"])
        }
    }
    
    var target: Target {
        switch self {
        case .SwiftFP: return .target(name: "SwiftFP")
        case .Extensions: return .target(name: "Extensions")
        case .Redux: return .target(name: "Redux")
        case .Design: return .target(name: "Design")
        }
    }
    
    var dependency: Target.Dependency {
        switch self {
        case .SwiftFP: return "SwiftFP"
        case .Extensions: return "Extensions"
        case .Redux: return "Redux"
        case .Design: return "Design"
        }
    }
    
}
