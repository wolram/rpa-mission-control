// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "macos",
    platforms: [
        .macOS(.v14) // Forçando macOS 14 (Sonoma) para suportar NavigationSplitView e APIs modernas
    ],
    products: [
        .executable(name: "MissionControl", targets: ["MissionControl"]),
    ],
    targets: [
        .executableTarget(
            name: "MissionControl",
            dependencies: []),
        .testTarget(
            name: "macosTests",
            dependencies: ["MissionControl"]),
    ]
)
