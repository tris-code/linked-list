// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "LinkedList",
    products: [
        .library(name: "LinkedList", targets: ["ListEntry"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/test.git",
            .branch("master"))
    ],
    targets: [
        .target(name: "ListEntry"),
        .testTarget(
            name: "ListEntryTests",
            dependencies: ["ListEntry", "Test"])
    ]
)
