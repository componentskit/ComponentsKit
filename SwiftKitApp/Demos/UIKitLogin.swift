import UIKit
import SwiftKit
import SwiftUI

final class UIKitLogin: UIViewController {
  enum Pages {
    case signIn
    case signUp
  }

  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.delaysContentTouches = false
    return scrollView
  }()
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.alignment = .center
    return stackView
  }()

  private let pageControl = UKSegmentedControl<Pages>(
    selectedId: .signIn,
    model: .init {
      $0.items = [
        .init(id: .signIn) {
          $0.title = "Sign In"
        },
        .init(id: .signUp) {
          $0.title = "Sign Up"
        }
      ]
    }
  )
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 30, weight: .bold)
    return label
  }()
  private let nameInput = UKInputField(
    model: .init {
      $0.title = "Name"
      $0.isRequired = true
    }
  )
  private let emailInput = UKInputField(
    model: .init {
      $0.title = "Email"
      $0.isRequired = true
    }
  )
  private let passwordInput = UKInputField(
    model: .init {
      $0.title = "Password"
      $0.isRequired = true
      $0.isSecureInput = true
    }
  )
  private let consentCheckbox = UKCheckbox(
    model: .init {
      $0.title = "By continuing, you accept our Terms of Service and Privacy Policy"
    }
  )
  private let continueButton = UKButton(
    model: .init {
      $0.title = "Continue"
      $0.isFullWidth = true
    }
  )
  private let loader = UKLoading()

  private var isLoading = false {
    didSet { self.update() }
  }

  private var isButtonEnabled: Bool {
    return self.emailInput.text.isNotEmpty
    && self.passwordInput.text.isNotEmpty
    && self.consentCheckbox.isSelected
    && (
      self.pageControl.selectedId == .signUp && self.nameInput.text.isNotEmpty
      || self.pageControl.selectedId == .signIn
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
    self.style()
    self.layout()
    self.update()
  }

  private func setup() {
    self.view.addSubview(self.scrollView)
    self.scrollView.addSubview(self.stackView)
    self.scrollView.addSubview(self.loader)

    self.stackView.addArrangedSubview(self.pageControl)
    self.stackView.addArrangedSubview(self.titleLabel)
    self.stackView.addArrangedSubview(self.nameInput)
    self.stackView.addArrangedSubview(self.emailInput)
    self.stackView.addArrangedSubview(self.passwordInput)
    self.stackView.addArrangedSubview(self.consentCheckbox)
    self.stackView.addArrangedSubview(self.continueButton)

    self.pageControl.onSelectionChange = { [weak self] selectedPage in
      guard let self else { return }

      if selectedPage == .signIn && self.nameInput.isSelected {
        self.emailInput.isSelected = true
      }

      self.update()
    }
    self.nameInput.onValueChange = { [weak self] _ in
      self?.update()
    }
    self.emailInput.onValueChange = { [weak self] _ in
      self?.update()
    }
    self.passwordInput.onValueChange = { [weak self] _ in
      self?.update()
    }
    self.consentCheckbox.onValueChange = { [weak self] _ in
      self?.update()
    }
    self.continueButton.action = {
      self.isLoading = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.isLoading = false
        UINotificationFeedbackGenerator().notificationOccurred(.success)
      }
    }

    self.scrollView.addGestureRecognizer(
      UITapGestureRecognizer(
        target: self,
        action: #selector(self.dismissKeyboard)
      )
    )
  }

  @objc private func dismissKeyboard() {
    self.nameInput.isSelected = false
    self.emailInput.isSelected = false
    self.passwordInput.isSelected = false
  }

  private func style() {
    self.stackView.setCustomSpacing(50, after: self.pageControl)
    self.stackView.setCustomSpacing(50, after: self.titleLabel)
    self.stackView.setCustomSpacing(50, after: self.consentCheckbox)
  }

  private func layout() {
    self.scrollView.pinToSafeEdges()

    self.stackView.top(20)
    self.stackView.leading(20, to: self.view)
    self.stackView.trailing(20, to: self.view)
    self.stackView.bottom(20)

    self.loader.below(of: self.stackView, padding: 50)
    self.loader.centerHorizontally()

    self.nameInput.widthAnchor.constraint(
      equalTo: self.stackView.widthAnchor
    ).isActive = true
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print(self.stackView.frame)
  }

  private func update() {
    switch self.pageControl.selectedId {
    case .signIn:
      self.nameInput.isHidden = true
      self.titleLabel.text = "Welcome back"
    case .signUp:
      self.nameInput.isHidden = false
      self.titleLabel.text = "Create an account"
    }

    self.pageControl.model.update {
      $0.isEnabled = !self.isLoading
    }
    self.nameInput.model.update {
      $0.isEnabled = !self.isLoading
    }
    self.emailInput.model.update {
      $0.isEnabled = !self.isLoading
    }
    self.passwordInput.model.update {
      $0.isEnabled = !self.isLoading
    }
    self.consentCheckbox.model.update {
      $0.isEnabled = !self.isLoading
    }
    self.continueButton.model.update { [weak self] in
      guard let self else { return }
      $0.isEnabled = self.isButtonEnabled
    }
    self.loader.isHidden = !self.isLoading
    self.continueButton.isHidden = self.isLoading
  }
}

#Preview {
  UIViewControllerRepresenting {
    UIKitLogin()
  }
}
