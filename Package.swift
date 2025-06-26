// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "MyConnectTVSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "MyConnectTVSDK",
            targets: ["MyConnectTVSDK"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/google/castlabs-ios-sdk.git", exact: "2.7.1") // or replace with actual working Cast SDK URL
    ],
    targets: [
        .target(
            name: "MyConnectTVSDK",
            dependencies: [],
            path: "core",
            exclude: [
                "ConnectSDK*Tests",
                "Frameworks/LGCast/**/*.h",
                "Frameworks/asi-http-request/External/Reachability",
                "Frameworks/asi-http-request/Classes"
            ],
            resources: [],
            publicHeadersPath: ".",
            cSettings: [
                .define("CONNECT_SDK_VERSION", to: "\"1.0.0\"")
            ]
        )
    ]
)
