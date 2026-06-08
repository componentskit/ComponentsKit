// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "ComponentsKit",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "ComponentsKit",
      targets: ["ComponentsKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/componentskit/AutoLayout", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "ComponentsKit",
      dependencies: [
        .product(name: "AutoLayout", package: "AutoLayout")
      ],
      resources: [
        .process("Resources/PrivacyInfo.xcprivacy")
      ]
    )
  ]
)
