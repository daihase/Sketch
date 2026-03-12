// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Sketch",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Sketch",
            targets: ["Sketch"]
        )
    ],
    targets: [
        .target(
            name: "Sketch",
            path: "Sketch",
            exclude: ["Assets"],
            sources: ["Classes"],
            resources: [
                .process("Resources"),
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
