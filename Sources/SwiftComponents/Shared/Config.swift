import Foundation

public struct SwiftComponentsConfig: Initializable, Updatable {
  public var colors: Palette = .init()
  public var layout: Layout = .init()

  public init() {}
}

// MARK: - SwiftComponentsConfig + Shared

extension SwiftComponentsConfig {
  public static var shared: Self = .init()
}
