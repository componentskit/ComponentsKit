import SwiftUI

/// A SwiftUI component that displays a multi-line text input form.
public struct SUTextInput<FocusValue: Hashable>: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: TextInputVM

  /// A Binding value to control the inputted text.
  @Binding public var text: String

  /// The shared focus state used to manage focus across multiple text inputs and input fields.
  ///
  /// When the `localFocus` value matches `globalFocus`, this text input becomes focused.
  /// This enables centralized focus management for multiple text inputs and input fields within a single view.
  public let globalFocus: FocusState<FocusValue>.Binding?

  /// The unique value for this field to match against the global focus state to determine whether this text input is focused.
  ///
  /// Determines the local focus value for this particular text input. It is compared with `globalFocus` to
  /// decide if this text input should be focused. If `globalFocus` matches the value of `localFocus`, the
  /// text input gains focus, allowing the user to interact with it.
  ///
  /// - Warning: The `localFocus` value must be unique to each text input and input field, to ensure that different
  /// text inputs and input fields within the same view can be independently focused based on the shared `globalFocus`.
  public let localFocus: FocusValue

  @State private var textEditorPreferredHeight: CGFloat = 0

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - globalFocus: The shared state controlling focus across multiple text inputs and input fields.
  ///   - localFocus: The unique value for this text input to match against the global focus state to determine focus.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    globalFocus: FocusState<FocusValue>.Binding,
    localFocus: FocusValue,
    model: TextInputVM = .init()
  ) {
    self._text = text
    self.globalFocus = globalFocus
    self.localFocus = localFocus
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    ZStack(alignment: .topLeading) {
      TextEditor(text: self.$text)
        .contentMargins(self.model.contentPadding)
        .transparentScrollBackground()
        .frame(
          minHeight: self.model.minTextInputHeight,
          idealHeight: max(
            self.model.minTextInputHeight,
            min(
              self.model.maxTextInputHeight,
              self.textEditorPreferredHeight
            )
          ),
          maxHeight: max(
            self.model.minTextInputHeight,
            min(
              self.model.maxTextInputHeight,
              self.textEditorPreferredHeight
            )
          )
        )
        .lineSpacing(0)
        .font(self.model.preferredFont.font)
        .foregroundStyle(self.model.foregroundColor.color)
        .tint(self.model.tintColor.color)
        .applyFocus(globalFocus: self.globalFocus, localFocus: self.localFocus)
        .disabled(!self.model.isEnabled)
        .keyboardType(self.model.keyboardType)
        .submitLabel(self.model.submitType.submitLabel)
        .autocorrectionDisabled(!self.model.isAutocorrectionEnabled)
        .textInputAutocapitalization(self.model.autocapitalization.textInputAutocapitalization)

      if let placeholder = self.model.placeholder,
         self.text.isEmpty {
        Text(placeholder)
          .font(self.model.preferredFont.font)
          .foregroundStyle(
            self.model.placeholderColor.color
          )
          .padding(self.model.contentPadding)
      }
    }
    .background(
      GeometryReader { geometry in
        self.model.backgroundColor.color
          .onAppear {
            self.textEditorPreferredHeight = TextInputHeightCalculator.preferredHeight(
              for: self.text,
              model: self.model,
              width: geometry.size.width
            )
          }
          .onChange(of: self.text) { newText in
            self.textEditorPreferredHeight = TextInputHeightCalculator.preferredHeight(
              for: newText,
              model: self.model,
              width: geometry.size.width
            )
          }
          .onChange(of: self.model) { [oldValue = self.model] newModel in
            if newModel.shouldUpdateLayout(oldValue) {
              self.textEditorPreferredHeight = TextInputHeightCalculator.preferredHeight(
                for: self.text,
                model: newModel,
                width: geometry.size.width
              )
            }
          }
          .onChange(of: geometry.size.width) { newValue in
            self.textEditorPreferredHeight = TextInputHeightCalculator.preferredHeight(
              for: self.text,
              model: self.model,
              width: newValue
            )
          }
      }
    )
    .clipShape(
      RoundedRectangle(
        cornerRadius: self.model.adaptedCornerRadius()
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
  }
}

// MARK: - Helpers

extension View {
  fileprivate func transparentScrollBackground() -> some View {
    if #available(iOS 16.0, *) {
      return self.scrollContentBackground(.hidden)
    } else {
      return self.onAppear {
        UITextView.appearance().backgroundColor = .clear
      }
    }
  }

  fileprivate func contentMargins(_ value: CGFloat) -> some View {
    // By default, `TextEditor` has a horizontal content margin. We cannot know the exact value
    // since the implementation details are hidden, but approximately it is equal to 5.
    let defaultHorizontalContentMargin: CGFloat = 5
    return self.onAppear {
      UITextView.appearance().textContainerInset = .init(
        top: value,
        left: value - defaultHorizontalContentMargin,
        bottom: value,
        right: value - defaultHorizontalContentMargin
      )
      UITextView.appearance().textContainer.lineFragmentPadding = 0
    }
  }

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

extension SUTextInput where FocusValue == Bool {
  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - isFocused: A binding that controls whether this text input is focused or not.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding,
    model: TextInputVM = .init()
  ) {
    self._text = text
    self.globalFocus = isFocused
    self.localFocus = true
    self.model = model
  }
}

// MARK: - No Focus Value

extension SUTextInput where FocusValue == Bool {
  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    model: TextInputVM = .init()
  ) {
    self._text = text
    self.globalFocus = nil
    self.localFocus = true
    self.model = model
  }
}
