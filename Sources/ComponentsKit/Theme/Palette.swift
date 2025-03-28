import Foundation

extension Theme {
  /// Defines a set of colors that are used for styling components and interfaces.
  public struct Palette: Initializable, Updatable, Equatable {
    /// The color for the main background of the interface.
    public var background: UniversalColor = .themed(
      light: .hex("#FFFFFF"),
      dark: .hex("#000000")
    )
    /// The color for the secondary background of the interface.
    public var secondaryBackground: UniversalColor = .themed(
      light: .hex("#F5F5F5"),
      dark: .hex("#323335")
    )
    /// The color for text labels that contain primary content.
    public var foreground: UniversalColor = .themed(
      light: .hex("#0B0C0E"),
      dark: .hex("#FFFFFF")
    )
    /// The color for text labels that contain secondary content.
    public var secondaryForeground: UniversalColor = .themed(
      light: .hex("#424355"),
      dark: .hex("#D6D6D7")
    )
    /// The first content color.
    public var content1: UniversalColor = .themed(
      light: .hex("#EFEFF0"),
      dark: .hex("#27272a")
    )
    /// The second content color.
    public var content2: UniversalColor = .themed(
      light: .hex("#D4D4D8"),
      dark: .hex("#3F3F46")
    )
    /// The third content color.
    public var content3: UniversalColor = .themed(
      light: .hex("#B4BDC8"),
      dark: .hex("#52525b")
    )
    /// The forth content color.
    public var content4: UniversalColor = .themed(
      light: .hex("#8C9197"),
      dark: .hex("#86898B")
    )
    /// The color for thin borders or divider lines.
    public var divider: UniversalColor = .themed(
      light: .rgba(r: 11, g: 12, b: 14, a: 0.12),
      dark: .rgba(r: 255, g: 255, b: 255, a: 0.15)
    )
    /// The primary color.
    public var primary: ComponentColor = .init(
      main: .themed(
        light: .hex("#0B0C0E"),
        dark: .hex("#FFFFFF")
      ),
      contrast: .themed(
        light: .hex("#FFFFFF"),
        dark: .hex("#0B0C0E")
      ),
      background: .themed(
        light: .hex("#D9D9D9"),
        dark: .hex("#515253")
      )
    )
    /// The accent color.
    public var accent: ComponentColor = .init(
      main: .universal(.hex("#007AFF")),
      contrast: .universal(.hex("#FFFFFF")),
      background: .themed(
        light: .hex("#E1EEFE"),
        dark: .hex("#2B3E53")
      )
    )
    /// The success state color, used for indicating positive actions or statuses.
    public var success: ComponentColor = .init(
      main: .themed(
        light: .hex("#37D45C"),
        dark: .hex("#1EC645")
      ),
      contrast: .themed(
        light: .hex("#FFFFFF"),
        dark: .hex("#0B0C0E")
      ),
      background: .themed(
        light: .hex("#E1FBE7"),
        dark: .hex("#344B3C")
      )
    )
    /// The warning state color, used for indicating caution or non-critical alerts.
    public var warning: ComponentColor = .init(
      main: .themed(
        light: .hex("#F4B300"),
        dark: .hex("#F4B300")
      ),
      contrast: .universal(.hex("#0B0C0E")),
      background: .themed(
        light: .hex("#FFF6DD"),
        dark: .hex("#514A35")
      )
    )
    /// The danger state color, used for indicating errors, destructive actions, or critical alerts.
    public var danger: ComponentColor = .init(
      main: .themed(
        light: .hex("#F03E53"),
        dark: .hex("#D22338")
      ),
      contrast: .universal(.hex("#FFFFFF")),
      background: .themed(
        light: .hex("#FFE5E8"),
        dark: .hex("#4F353A")
      )
    )

    /// Initializes a new instance of `Palette` with default values.
    public init() {}
  }
}

// MARK: - ComponentColor + Palette Colors

extension ComponentColor {
  /// The primary color.
  public static var primary: Self {
    return Theme.current.colors.primary
  }
  /// The accent color.
  public static var accent: Self {
    return Theme.current.colors.accent
  }
  /// The success state color, used for indicating positive actions or statuses.
  public static var success: Self {
    return Theme.current.colors.success
  }
  /// The warning state color, used for indicating caution or non-critical alerts.
  public static var warning: Self {
    return Theme.current.colors.warning
  }
  /// The danger state color, used for indicating errors, destructive actions, or critical alerts.
  public static var danger: Self {
    return Theme.current.colors.danger
  }
}

// MARK: - UniversalColor + Neutral Colors

extension UniversalColor {
  public static var black: Self {
    return .universal(.hex("#000000"))
  }
  public static var white: Self {
    return .universal(.hex("#FFFFFF"))
  }
  public static var clear: Self {
    return .universal(.uiColor(.clear))
  }
}

// MARK: - UniversalColor + Palette Colors

extension UniversalColor {
  /// The color for the main background of the interface.
  public static var background: Self {
    return Theme.current.colors.background
  }
  /// The color for the secondary background of the interface.
  public static var secondaryBackground: Self {
    return Theme.current.colors.secondaryBackground
  }
  /// The color for text labels that contain primary content.
  public static var foreground: Self {
    return Theme.current.colors.foreground
  }
  /// The color for text labels that contain secondary content.
  public static var secondaryForeground: Self {
    return Theme.current.colors.secondaryForeground
  }
  /// The color for thin borders or divider lines.
  public static var divider: Self {
    return Theme.current.colors.divider
  }
  /// The first content color.
  public static var content1: Self {
    return Theme.current.colors.content1
  }
  /// The second content color.
  public static var content2: Self {
    return Theme.current.colors.content2
  }
  /// The third content color.
  public static var content3: Self {
    return Theme.current.colors.content3
  }
  /// The forth content color.
  public static var content4: Self {
    return Theme.current.colors.content4
  }
  /// The primary color.
  public static var primary: Self {
    return Theme.current.colors.primary.main
  }
  /// The accent color.
  public static var accent: Self {
    return Theme.current.colors.accent.main
  }
  /// The accent background color.
  public static var accentBackground: Self {
    return Theme.current.colors.accent.background
  }
  /// The success state color, used for indicating positive actions or statuses.
  public static var success: Self {
    return Theme.current.colors.success.main
  }
  /// The success background color.
  public static var successBackground: Self {
    return Theme.current.colors.success.background
  }
  /// The warning state color, used for indicating caution or non-critical alerts.
  public static var warning: Self {
    return Theme.current.colors.warning.main
  }
  /// The warning background color.
  public static var warningBackground: Self {
    return Theme.current.colors.warning.background
  }
  /// The danger state color, used for indicating errors, destructive actions, or critical alerts.
  public static var danger: Self {
    return Theme.current.colors.danger.main
  }
  /// The danger background color.
  public static var dangerBackground: Self {
    return Theme.current.colors.danger.background
  }
}
