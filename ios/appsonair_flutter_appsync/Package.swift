// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "appsonair_flutter_appsync",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "appsonair-flutter-appsync", targets: ["appsonair_flutter_appsync"])
    ],
    dependencies: [
        .package(url: "https://github.com/apps-on-air/AppsOnAir-iOS-AppSync.git", exact: "1.3.1")
    ],
    targets: [
        .target(
            name: "appsonair_flutter_appsync",
            dependencies: [
                .product(name: "AppsOnAir-AppSync", package: "AppsOnAir-iOS-AppSync")
            ],
            path: "Sources/appsonair_flutter_appsync"
        )
    ]
)
