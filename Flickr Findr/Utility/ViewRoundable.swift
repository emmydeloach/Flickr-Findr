//
//  ViewRoundable.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/7/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

protocol ViewRoundable { }

extension ViewRoundable where Self: UIView {
    
    func roundCorners(on subview: UIView? = nil, radius: CGFloat? = nil) {
        
        let view = subview ?? self
        
        view.clipsToBounds = true
        view.layer.cornerRadius = radius ?? min(view.frame.height / 2, view.frame.width / 2)
    }
}

class RoundedButton: UIButton, ViewRoundable {}

class RoundedLabel: UILabel, ViewRoundable {
    
    var inset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        let insetRect = bounds.inset(by: inset)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -inset.top,
                                          left: -inset.left,
                                          bottom: -inset.bottom,
                                          right: -inset.right)
        
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect.inset(by: inset))
    }
}
