import PackageDescription

let package = Package(
    name: "ErrorLogger",
    products: [
        .library(
            name: "ErrorLogger",
            targets: ["ErrorLogger"]),
    ],
    targets: [
        .target(
            name: "ErrorLogger"),

    ]
)
