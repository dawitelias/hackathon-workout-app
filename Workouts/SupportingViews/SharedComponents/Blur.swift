//
//  Blur.swift
//  HopHound
//
//  Created by Jeff Jackson on 4/16/20.
//  Copyright © 2020 Jeff Jackson. All rights reserved.
//
import SwiftUI

struct Blur: UIViewRepresentable {

    var style: UIBlurEffect.Style = .systemChromeMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: style))
        return UIVisualEffectView(effect: vibrancyEffect)
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }

}

struct Blur_Previews: PreviewProvider {
    static var previews: some View {
        Blur(style: .systemMaterialDark)
    }
}
