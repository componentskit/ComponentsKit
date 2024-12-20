import ComponentsKit
import SwiftUI

// MARK: - AnimationScalePicker

struct AnimationScalePicker: View {
  @Binding var selection: AnimationScale

  var body: some View {
    Picker("Animation Scale", selection: self.$selection) {
      Text("None").tag(AnimationScale.none)
      Text("Small").tag(AnimationScale.small)
      Text("Medium").tag(AnimationScale.medium)
      Text("Large").tag(AnimationScale.large)
      Text("Custom: 0.9").tag(AnimationScale.custom(0.9))
    }
  }
}

// MARK: - AutocapitalizationPicker

struct AutocapitalizationPicker: View {
  @Binding var selection: TextAutocapitalization

  var body: some View {
    Picker("Autocapitalization", selection: $selection) {
      Text("Never").tag(TextAutocapitalization.never)
      Text("Characters").tag(TextAutocapitalization.characters)
      Text("Words").tag(TextAutocapitalization.words)
      Text("Sentences").tag(TextAutocapitalization.sentences)
    }
  }
}

// MARK: - ComponentColorPicker

struct ComponentColorPicker: View {
  @Binding var selection: ComponentColor

  var body: some View {
    Picker("Color", selection: self.$selection) {
      Text("Primary").tag(ComponentColor.primary)
      Text("Accent").tag(ComponentColor.accent)
      Text("Success").tag(ComponentColor.success)
      Text("Warning").tag(ComponentColor.warning)
      Text("Danger").tag(ComponentColor.danger)
      Text("Custom").tag(ComponentColor(
        main: .universal(.uiColor(.systemPurple)),
        contrast: .universal(.uiColor(.systemYellow))
      ))
    }
  }
}

// MARK: - ComponentOptionalColorPicker

struct ComponentOptionalColorPicker: View {
  @Binding var selection: ComponentColor?

  var body: some View {
    Picker("Color", selection: self.$selection) {
      Text("Default").tag(Optional<ComponentColor>.none)
      Text("Primary").tag(ComponentColor.primary)
      Text("Accent").tag(ComponentColor.accent)
      Text("Success").tag(ComponentColor.success)
      Text("Warning").tag(ComponentColor.warning)
      Text("Danger").tag(ComponentColor.danger)
      Text("Custom").tag(ComponentColor(
        main: .universal(.uiColor(.systemPurple)),
        contrast: .universal(.uiColor(.systemYellow))
      ))
    }
  }
}

// MARK: - CornerRadiusPicker

struct CornerRadiusPicker<Custom: View>: View {
  @Binding var selection: ComponentRadius
  @ViewBuilder var custom: () -> Custom

  var body: some View {
    Picker("Corner Radius", selection: self.$selection) {
      Text("None").tag(ComponentRadius.none)
      Text("Small").tag(ComponentRadius.small)
      Text("Medium").tag(ComponentRadius.medium)
      Text("Large").tag(ComponentRadius.large)
      Text("Full").tag(ComponentRadius.full)
      self.custom()
    }
  }
}

// MARK: - FontPickers

struct BodyFontPicker: View {
  let title: String
  @Binding var selection: UniversalFont?
  
  init(title: String = "Font", selection: Binding<UniversalFont?>) {
    self.title = title
    self._selection = selection
  }

  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Default").tag(Optional<UniversalFont>.none)
      Text("Small").tag(UniversalFont.smBody)
      Text("Medium").tag(UniversalFont.mdBody)
      Text("Large").tag(UniversalFont.lgBody)
      Text("Custom: system bold of size 18").tag(UniversalFont.system(size: 18, weight: .bold))
    }
  }
}

struct ButtonFontPicker: View {
  let title: String
  @Binding var selection: UniversalFont?
  
  init(title: String = "Font", selection: Binding<UniversalFont?>) {
    self.title = title
    self._selection = selection
  }
  
  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Default").tag(Optional<UniversalFont>.none)
      Text("Small").tag(UniversalFont.smButton)
      Text("Medium").tag(UniversalFont.mdButton)
      Text("Large").tag(UniversalFont.lgButton)
      Text("Custom: system bold of size 18").tag(UniversalFont.system(size: 18, weight: .bold))
    }
  }
}

struct HeadlineFontPicker: View {
  let title: String
  @Binding var selection: UniversalFont?
  
  init(title: String = "Font", selection: Binding<UniversalFont?>) {
    self.title = title
    self._selection = selection
  }

  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Default").tag(Optional<UniversalFont>.none)
      Text("Small").tag(UniversalFont.smHeadline)
      Text("Medium").tag(UniversalFont.mdHeadline)
      Text("Large").tag(UniversalFont.lgHeadline)
      Text("Custom: system bold of size 18").tag(UniversalFont.system(size: 18, weight: .bold))
    }
  }
}

struct CaptionFontPicker: View {
  let title: String
  @Binding var selection: UniversalFont?
  
  init(title: String = "Font", selection: Binding<UniversalFont?>) {
    self.title = title
    self._selection = selection
  }
  
  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Default").tag(Optional<UniversalFont>.none)
      Text("Small").tag(UniversalFont.smCaption)
      Text("Medium").tag(UniversalFont.mdCaption)
      Text("Large").tag(UniversalFont.lgCaption)
      Text("Custom: system bold of size 12").tag(UniversalFont.system(size: 12, weight: .bold))
    }
  }
}

// MARK: - KeyboardTypePicker

struct KeyboardTypePicker: View {
  @Binding var selection: UIKeyboardType

  var body: some View {
    Picker("Keyboard Type", selection: $selection) {
      Text("Default").tag(UIKeyboardType.default)
      Text("asciiCapable").tag(UIKeyboardType.asciiCapable)
      Text("numbersAndPunctuation").tag(UIKeyboardType.numbersAndPunctuation)
      Text("URL").tag(UIKeyboardType.URL)
      Text("numberPad").tag(UIKeyboardType.numberPad)
      Text("phonePad").tag(UIKeyboardType.phonePad)
      Text("namePhonePad").tag(UIKeyboardType.namePhonePad)
      Text("emailAddress").tag(UIKeyboardType.emailAddress)
      Text("decimalPad").tag(UIKeyboardType.decimalPad)
      Text("twitter").tag(UIKeyboardType.twitter)
      Text("webSearch").tag(UIKeyboardType.webSearch)
      Text("asciiCapableNumberPad").tag(UIKeyboardType.asciiCapableNumberPad)
    }
  }
}

// MARK: - SizePicker

struct SizePicker: View {
  @Binding var selection: ComponentSize

  var body: some View {
    Picker("Size", selection: self.$selection) {
      Text("Small").tag(ComponentSize.small)
      Text("Medium").tag(ComponentSize.medium)
      Text("Large").tag(ComponentSize.large)
    }
  }
}

// MARK: - SubmitTypePicker

struct SubmitTypePicker: View {
  @Binding var selection: SubmitType

  var body: some View {
    Picker("Submit Type", selection: $selection) {
      Text("done").tag(SubmitType.done)
      Text("go").tag(SubmitType.go)
      Text("join").tag(SubmitType.join)
      Text("route").tag(SubmitType.route)
      Text("return").tag(SubmitType.return)
      Text("next").tag(SubmitType.next)
      Text("continue").tag(SubmitType.continue)
    }
  }
}

// MARK: - UniversalColorPicker

struct UniversalColorPicker: View {
  let title: String
  @Binding var selection: UniversalColor

  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Primary").tag(UniversalColor.primary)
      Text("Accent").tag(UniversalColor.accent)
      Text("Success").tag(UniversalColor.success)
      Text("Warning").tag(UniversalColor.warning)
      Text("Danger").tag(UniversalColor.danger)
      Text("Custom").tag(UniversalColor.universal(.uiColor(.systemPurple)))
    }
  }
}
