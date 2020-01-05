// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LinkedList",
    products: [
        .library(name: "LinkedList", targets: ["ListEntry"])
    ],
    dependencies: [
        .package(path: "../Test")
    ],
    targets: [
        .target(name: "ListEntry"),
        .testTarget(
            name: "ListEntryTests",
            dependencies: ["ListEntry", "Test"])
    ]
)
