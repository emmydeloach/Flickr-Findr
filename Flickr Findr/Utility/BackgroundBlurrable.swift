//
//  BackgroundBlurrable.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/7/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

protocol BackgroundBlurable {
    
    func applyBackgroundBlur()
}

extension BackgroundBlurable where Self: UIViewController {

    func applyBackgroundBlur() {
        
        guard !UIAccessibility.isReduceTransparencyEnabled else {
            view.backgroundColor = UIColor.systemBackground
            return
        }
        
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
}
