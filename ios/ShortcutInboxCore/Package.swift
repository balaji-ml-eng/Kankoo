// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ShortcutInboxCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [.library(name: "ShortcutInboxCore", targets: ["ShortcutInboxCore"])],
    targets: [
        .target(name: "ShortcutInboxCore"),
        .testTarget(name: "ShortcutInboxCoreTests", dependencies: ["ShortcutInboxCore"])
    ]
)
