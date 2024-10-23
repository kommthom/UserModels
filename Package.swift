// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserModels",
	platforms: [
		.macOS(.v15)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserModels",
            targets: ["UserModels"]),
    ],
	dependencies: [
		.package(url: "https://github.com/vapor/vapor", from: "4.106.0"),
		.package(url: "https://github.com/vapor/fluent", from: "4.12.0"),
		.package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.8.0"),
		.package(name: "UserDTOs", path: "../UserDTOs"),
//		.package(name: "UsersLocalizations", path: "../UsersLocalizations"),
//		.package(name: "DateExtensions", path: "../DateExtensions"),
		.package(name: "AuthenticationDTOs", path: "../AuthenticationDTOs")
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserModels",
			dependencies: [
				.product(
					name: "Vapor",
					package: "Vapor"
				),
				.product(
					name: "Fluent",
					package: "Fluent"
				),
				.product(
					name: "FluentSQLiteDriver",
					package: "fluent-sqlite-driver"
				),
				.product(
					name: "UserDTOs",
					package: "UserDTOs"
				),
//				.product(
//					name: "Lingo",
//					package: "UsersLocalizations"
//				),
//				.product(
//					name: "DateExtensions",
//					package: "DateExtensions"
//				),
				.product(
					name: "AuthenticationDTOs",
					package: "AuthenticationDTOs"
				)
			]
		),
        .testTarget(
            name: "UserModelsTests",
            dependencies: ["UserModels"]
        ),
    ]
)
