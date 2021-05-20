// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "ezgrpc",
    platforms: [
      .macOS(.v10_15),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift", from: "1.0.0"),
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf", from: "1.16.0"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.1.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "ezrpc",
            dependencies: [
                "SwiftShell",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/ezrpc"
        ),
        
        .executableTarget(
            name: "protoc-gen-swift-grpc",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "SwiftProtobuf"),
                .product(name: "SwiftProtobufPluginLibrary", package: "SwiftProtobuf"),
            ],
            path: "Sources/protoc-gen-swift-grpc",
            exclude: ["README.md"]
        ),
        
        .executableTarget(
            name: "protoc-gen-kotlin-grpc",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "SwiftProtobuf"),
                .product(name: "SwiftProtobufPluginLibrary", package: "SwiftProtobuf"),
            ],
            path: "Sources/protoc-gen-kotlin-grpc",
            exclude: ["README.md"]
        ),

        .target(
          name: "GRPCKit",
          dependencies: [
            .product(name: "GRPC", package: "grpc-swift"),
          ],
          path: "Sources/Example/GRPCKit/"
        ),

        .executableTarget(
          name: "Client",
          dependencies: [
            .product(name: "GRPC", package: "grpc-swift"),
            .target(name: "GRPCKit"),
          ],
          path: "Sources/Example/Client"
        ),
    ]
)
