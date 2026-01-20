// swift-tools-version: 6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Buildable",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(name: "Buildable", targets: ["Buildable"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0"..<"603.0.0"),
    ],
    targets: [
        .macro(
            name: "BuildableMacro",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "Buildable", dependencies: ["BuildableMacro"]),
        .target(name: "BuildableClientTestData", dependencies: ["Buildable"]),
        .executableTarget(name: "BuildableClient", dependencies: ["Buildable", "BuildableClientTestData"]),
        .testTarget(
            name: "BuildableMacroTests",
            dependencies: [
                "BuildableMacro",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)

// See also `swift -print-supported-features`
package.targets.forEach {
    $0.swiftSettings = [
        .enableUpcomingFeature("ImmutableWeakCaptures"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
//        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("ExistentialAny"),
    ]
}
