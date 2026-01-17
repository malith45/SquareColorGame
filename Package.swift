// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SquareColorGame",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SquareColorGame",
            targets: ["SquareColorGame"]),
    ],
    targets: [
        .target(
            name: "SquareColorGame",
            path: "SquareColorGame"
        )
    ]
)
