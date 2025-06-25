import SwiftUI

/// A SwiftUI component that displays a field to input a text.
public struct SUInputField<FocusValue: Hashable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: InputFieldVM

  /// A Binding value to control the inputted text.
  @Binding public var text: String

  /// The shared focus state used to manage focus across multiple text inputs and input fields.
  ///
  /// When the `localFocus` value matches `globalFocus`, this input field becomes focused.
  /// This enables centralized focus management for multiple text inputs and input fields within a single view.
  public let globalFocus: FocusState<FocusValue>.Binding?

  /// The unique value for this field to match against the global focus state to determine whether this input field is focused.
  ///
  /// Determines the local focus value for this particular input field. It is compared with `globalFocus` to
  /// decide if this input field should be focused. If `globalFocus` matches the value of `localFocus`, the
  /// input field gains focus, allowing the user to interact with it.
  ///
  /// - Warning: The `localFocus` value must be unique to each text input and input field, to ensure that different
  /// text inputs and input fields within the same view can be independently focused based on the shared `globalFocus`.
  public let localFocus: FocusValue

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - globalFocus: The shared state controlling focus across multiple text inputs and input fields.
  ///   - localFocus: The unique value for this field to match against the global focus state to determine focus.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    globalFocus: FocusState<FocusValue>.Binding,
    localFocus: FocusValue,
    model: InputFieldVM = .init()
  ) {
    self._text = text
    self.globalFocus = globalFocus
    self.localFocus = localFocus
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    VStack(alignment: .leading, spacing: self.model.spacing) {
      if let title = self.model.attributedTitle,
         self.model.titlePosition == .outside {
        Text(title)
      }

      HStack(spacing: self.model.spacing) {
        if let title = self.model.attributedTitle,
           self.model.titlePosition == .inside {
          Text(title)
        }

        Group {
          if self.model.isSecureInput {
            SecureField(text: self.$text, label: {
              Text(self.model.placeholder ?? "")
                .foregroundStyle(self.model.placeholderColor.color)
            })
          } else {
            TextField(text: self.$text, label: {
              Text(self.model.placeholder ?? "")
                .foregroundStyle(self.model.placeholderColor.color)
            })
          }
        }
        .tint(self.model.tintColor.color)
        .font(self.model.preferredFont.font)
        .foregroundStyle(self.model.foregroundColor.color)
        .applyFocus(globalFocus: self.globalFocus, localFocus: self.localFocus)
        .disabled(!self.model.isEnabled)
        .keyboardType(self.model.keyboardType)
        .submitLabel(self.model.submitType.submitLabel)
        .autocorrectionDisabled(!self.model.isAutocorrectionEnabled)
        .textInputAutocapitalization(self.model.autocapitalization.textInputAutocapitalization)
      }
      .padding(.horizontal, self.model.horizontalPadding)
      .frame(height: self.model.height)
      .background(self.model.backgroundColor.color)
      .onTapGesture {
        self.globalFocus?.wrappedValue = self.localFocus
      }
      .clipShape(
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
      )
      .overlay(
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
        .strokeBorder(
          self.model.borderColor.color,
          lineWidth: self.model.borderWidth
        )
      )

      if let caption = self.model.caption, caption.isNotEmpty {
        Text(caption)
          .font(self.model.preferredCaptionFont.font)
          .foregroundStyle(self.model.captionColor.color)
      }
    }
  }
}

// MARK: Helpers

extension View {
  @ViewBuilder
  fileprivate func applyFocus<FocusValue: Hashable>(
    globalFocus: FocusState<FocusValue>.Binding?,
    localFocus: FocusValue
  ) -> some View {
    if let globalFocus {
      self.focused(globalFocus, equals: localFocus)
    } else {
      self
    }
  }
}

// MARK: - Boolean Focus Value

extension SUInputField where FocusValue == Bool {
  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - isFocused: A binding that controls whether this input field is focused or not.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding,
    model: InputFieldVM = .init()
  ) {
    self._text = text
    self.globalFocus = isFocused
    self.localFocus = true
    self.model = model
  }
}

// MARK: - No Focus Value

extension SUInputField where FocusValue == Bool {
  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    model: InputFieldVM = .init()
  ) {
    self._text = text
    self.globalFocus = nil
    self.localFocus = true
    self.model = model
  }
}
