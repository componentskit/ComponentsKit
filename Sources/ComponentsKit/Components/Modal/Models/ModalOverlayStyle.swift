/// Defines the style of the overlay displayed behind a modal.
public enum ModalOverlayStyle: Sendable {
  /// A dimmed overlay that darkens the background behind the modal.
  case dimmed
  /// A blurred overlay that applies a blur effect to the background behind the modal.
  case blurred
  /// A transparent overlay that leaves the background fully visible behind the modal.
  case transparent
}
