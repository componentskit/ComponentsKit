import Foundation

extension Theme {
  /// A structure that defines the layout-related configurations for components in the framework.
  public struct Layout: Initializable, Updatable, Equatable {
    // MARK: - Radius

    /// A structure representing radius values for components.
    public struct Radius: Equatable {
      /// The small radius size.
      public var small: CGFloat
      /// The medium radius size.
      public var medium: CGFloat
      /// The large radius size.
      public var large: CGFloat

      /// Initializes a new `Radius` instance.
      ///
      /// - Parameters:
      ///   - small: The small radius size.
      ///   - medium: The medium radius size.
      ///   - large: The large radius size.
      public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
        self.small = small
        self.medium = medium
        self.large = large
      }
    }

    // MARK: - BorderWidth

    /// A structure representing border width values for components.
    public struct BorderWidth: Equatable {
      /// The small border width.
      public var small: CGFloat
      /// The medium border width.
      public var medium: CGFloat
      /// The large border width.
      public var large: CGFloat

      /// Initializes a new `BorderWidth` instance.
      ///
      /// - Parameters:
      ///   - small: The small border width.
      ///   - medium: The medium border width.
      ///   - large: The large border width.
      public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
        self.small = small
        self.medium = medium
        self.large = large
      }
    }

    // MARK: - AnimationScale

    /// A structure representing animation scale values for components.
    ///
    /// The values must be between `0.0` and `1.0`.
    public struct AnimationScale: Equatable {
      /// The small animation scale.
      public var small: CGFloat
      /// The medium animation scale.
      public var medium: CGFloat
      /// The large animation scale.
      public var large: CGFloat

      /// Initializes a new `AnimationScale` instance.
      ///
      /// - Parameters:
      ///   - small: The small animation scale (0.0–1.0).
      ///   - medium: The medium animation scale (0.0–1.0).
      ///   - large: The large animation scale (0.0–1.0).
      /// - Warning: This initializer will crash if the values are outside the range of `0.0` to `1.0`.
      public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
        guard small >= 0 && small <= 1.0,
              medium >= 0 && medium <= 1.0,
              large >= 0 && large <= 1.0
        else {
          fatalError("Animation scale values should be between 0 and 1")
        }

        self.small = small
        self.medium = medium
        self.large = large
      }
    }

    // MARK: - Shadow

    /// A structure that defines the parameters for a shadow effect.
    public struct ShadowParams: Equatable {
      /// The blur radius of the shadow.
      ///
      /// A larger radius results in a more diffuse shadow.
      public var radius: CGFloat

      /// The offset of the shadow, defining its position relative to the component.
      ///
      /// - `width`: Moves the shadow horizontally.
      /// - `height`: Moves the shadow vertically.
      public var offset: CGSize

      /// The color of the shadow.
      public var color: UniversalColor

      // MARK: - Initialization

      /// Initializes a new `ShadowParams` instance with the specified radius, offset, and color.
      ///
      /// - Parameters:
      ///   - radius: The blur radius of the shadow.
      ///   - offset: The offset of the shadow as a `CGSize`.
      ///   - color: The color of the shadow.
      public init(radius: CGFloat, offset: CGSize, color: UniversalColor) {
        self.radius = radius
        self.offset = offset
        self.color = color
      }
    }

    /// A structure that defines shadow presets for small, medium, and large shadows.
    public struct Shadow: Equatable {
      /// The shadow parameters for a small shadow.
      public var small: ShadowParams

      /// The shadow parameters for a medium shadow.
      public var medium: ShadowParams

      /// The shadow parameters for a large shadow.
      public var large: ShadowParams

      // MARK: - Initialization

      /// Initializes a new `Shadow` instance with the specified small, medium, and large shadow parameters.
      ///
      /// - Parameters:
      ///   - small: The parameters for a small shadow.
      ///   - medium: The parameters for a medium shadow.
      ///   - large: The parameters for a large shadow.
      public init(small: ShadowParams, medium: ShadowParams, large: ShadowParams) {
        self.small = small
        self.medium = medium
        self.large = large
      }
    }

    // MARK: - Typography

    /// A structure representing a set of fonts for different component sizes.
    public struct FontSet: Equatable {
      /// The small font.
      public var small: UniversalFont
      /// The medium font.
      public var medium: UniversalFont
      /// The large font.
      public var large: UniversalFont

      /// Initializes a new `FontSet` instance.
      ///
      /// - Parameters:
      ///   - small: The small font.
      ///   - medium: The medium font.
      ///   - large: The large font.
      public init(small: UniversalFont, medium: UniversalFont, large: UniversalFont) {
        self.small = small
        self.medium = medium
        self.large = large
      }
    }

    /// A structure representing typography settings for various components.
    public struct Typography: Equatable {
      /// The font set for headlines.
      public var headline: FontSet
      /// The font set for body text.
      public var body: FontSet
      /// The font set for buttons.
      public var button: FontSet
      /// The font set for captions.
      public var caption: FontSet

      /// Initializes a new `Typography` instance.
      ///
      /// - Parameters:
      ///   - headline: The font set for headlines.
      ///   - body: The font set for body text.
      ///   - button: The font set for buttons.
      ///   - caption: The font set for captions.
      public init(headline: FontSet, body: FontSet, button: FontSet, caption: FontSet) {
        self.headline = headline
        self.body = body
        self.button = button
        self.caption = caption
      }
    }

    // MARK: - Properties

    /// The opacity level for disabled components.
    public var disabledOpacity: CGFloat = 0.5

    /// The radius configuration for components.
    public var componentRadius: Radius = .init(
      small: 10.0,
      medium: 12.0,
      large: 16.0
    )

    /// The radius configuration for content containers such as modals, cards, etc.
    public var containerRadius: Radius = .init(
      small: 16.0,
      medium: 20.0,
      large: 26.0
    )

    /// The shadow configuration for components.
    public var shadow: Shadow = .init(
      small: .init(
        radius: 10.0,
        offset: .init(width: 0, height: 6),
        color: .themed(
          light: .rgba(r: 0, g: 0, b: 0, a: 0.1),
          dark: .rgba(r: 255, g: 255, b: 255, a: 0.1)
        )
      ),
      medium: .init(
        radius: 16.0,
        offset: .init(width: 0, height: 10),
        color: .themed(
          light: .rgba(r: 0, g: 0, b: 0, a: 0.15),
          dark: .rgba(r: 255, g: 255, b: 255, a: 0.15)
        )
      ),
      large: .init(
        radius: 20.0,
        offset: .init(width: 0, height: 12),
        color: .themed(
          light: .rgba(r: 0, g: 0, b: 0, a: 0.2),
          dark: .rgba(r: 255, g: 255, b: 255, a: 0.2)
        )
      )
    )

    /// The border width configuration for components.
    public var borderWidth: BorderWidth = .init(
      small: 0.5,
      medium: 1.0,
      large: 2.0
    )

    /// The animation scale configuration for components.
    public var animationScale: AnimationScale = .init(
      small: 0.99,
      medium: 0.98,
      large: 0.95
    )

    /// The typography configuration for components.
    public var typography: Typography = .init(
      headline: .init(
        small: .system(size: 14, weight: .semibold),
        medium: .system(size: 20, weight: .semibold),
        large: .system(size: 24, weight: .semibold)
      ),
      body: .init(
        small: .system(size: 14, weight: .regular),
        medium: .system(size: 16, weight: .regular),
        large: .system(size: 18, weight: .regular)
      ),
      button: .init(
        small: .system(size: 14, weight: .medium),
        medium: .system(size: 16, weight: .medium),
        large: .system(size: 20, weight: .medium)
      ),
      caption: .init(
        small: .system(size: 10, weight: .regular),
        medium: .system(size: 12, weight: .regular),
        large: .system(size: 14, weight: .regular)
      )
    )

    // MARK: - Initialization

    /// Initializes a new `Layout` instance with default values.
    public init() {}
  }
}
