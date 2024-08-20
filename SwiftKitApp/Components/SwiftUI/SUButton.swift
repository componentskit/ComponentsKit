//
//  SUButton.swift
//  SwiftKitApp
//
//  Created by Mikhail on 20.08.2024.
//

import SwiftUI
import UIKit

struct SUButton: UIViewRepresentable {
  func makeUIView(context: Context) -> UKButton {
//    return UKButton(frame: .zero)
    let button = UKButton()
    button.cornerRadius = .large
    button.animationScale = .large
    button.font = .boldSystemFont(ofSize: 16)
    button.setTitle("Tap me", for: .normal)
    button.backgroundColor = .blue
    return button
  }

  func updateUIView(_ uiView: UKButton, context: Context) {

  }
}
