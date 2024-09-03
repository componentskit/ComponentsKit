import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  let loading = UKLoading(
    model: LoadingVM {
      $0.color = .danger
      $0.size = .medium
    }
  )
  let button = UKButton(
    model: ButtonVM {
      $0.title = "Toggle animation"
    }
  )

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.backgroundColor = Palette.Base.background.uiColor

    self.addSubview(self.loading)
    self.addSubview(self.button)

    self.button.action = { [weak self] in
      guard let self else { return }
      self.loading.model.update {
        $0.isAnimating.toggle()
//        $0.speed -= 0.2
      }
    }

    self.loading.size(60)
    self.loading.centerVertically()
    self.loading.centerHorizontally()

    self.button.centerHorizontally()
    self.button.below(of: self.loading, padding: 40)
  }
}

struct LoadingsView: View {
  @State var model = LoadingVM {
    $0.isAnimating = true
  }

  var body: some View {
    UIViewRepresenting {
      Container()
    }
//    VStack {
//      SULoading(model: model)
//      SUButton(
//        model: ButtonVM {
//          $0.title = "Toggle animation"
//        }
//      ) {
//        self.model.isAnimating.toggle()
//      }
//      .padding(.top, 20)
//      HStack {
//        SUButton(
//          model: ButtonVM {
//            $0.title = "Slow down"
//          }
//        ) {
//          self.model.speed -= 0.2
//        }
//        SUButton(
//          model: ButtonVM {
//            $0.title = "Speed Up"
//          }
//        ) {
//          self.model.speed += 0.2
//        }
//      }
//    }
  }
}

#Preview {
  LoadingsView()
}
