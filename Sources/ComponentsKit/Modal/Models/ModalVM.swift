import Foundation
import SwiftUICore

public enum ModalOverlayStyle {
  case dimmed
  case blured
  case opaque
}

/// A model that defines generic appearance properties that can be in any modal component.
public protocol ModalVM: ComponentVM {
  var backgroundColor: UniversalColor { get set }
  var closesOnOverlayTap: Bool { get set }
  var contentPaddings: EdgeInsets { get set }
  // TODO: [1] Implement close button
  var hasCloseButton: Bool { get set }
  var overlayStyle: ModalOverlayStyle { get set }
}
