import Foundation

/// Specifies the position of the image relative to the button's title.
extension ButtonVM {
  public enum ImageLocation {
    /// The image is displayed before the title.
    case leading
    /// The image is displayed after the title.
    case trailing
  }
}
