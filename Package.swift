// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserModels",
	platforms: [
			.iOS(.v18),
			.macOS(.v15),
			.tvOS(.v16),
			.watchOS(.v8),
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserModels",
            targets: ["UserModels"]),
    ],
	dependencies: [
			.package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserModels",
			dependencies: [
				.product(
					name: "Tagged",
					package: "swift-tagged"
				)
			]
		),
        .testTarget(
            name: "UserModelsTests",
            dependencies: ["UserModels"]
        ),
    ]
)
