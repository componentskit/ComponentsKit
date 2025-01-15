import SwiftUI

/// A SwiftUI component that displays a badge.
public struct SUBadge: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: BadgeVM

  // MARK: Initialization

  /// Initializes a new instance of `SUBadge`.
  /// - Parameter model: A model that defines the appearance properties.
  public init(model: BadgeVM) {
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    Text(self.model.title)
      .font(self.model.font.font)
      .padding(self.model.paddings.edgeInsets)
      .foregroundStyle(self.model.foregroundColor.color)
      .background(self.model.backgroundColor.color)
      .clipShape(
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value())
      )
  }
}
