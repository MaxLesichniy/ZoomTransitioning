//
//  UIImageView+extension.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/16/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

extension UIImageView {

    convenience init(baseImageView: UIImageView, frame: CGRect) {
        self.init(frame: CGRect.zero)

        image = baseImageView.image
        contentMode = baseImageView.contentMode
        layer.cornerRadius = baseImageView.layer.cornerRadius
        clipsToBounds = true
        
        self.frame = frame
    }
}

extension UIView {
    
    class func animateCornerRadii(withDuration duration: TimeInterval, to value: CGFloat, views: [UIView], completion: ((Bool) -> Void)? = nil) {
        assert(views.count > 0, "Must call `animateCornerRadii:duration:value:views:completion:` with at least 1 view.")
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion?(true)
        }
        
        for view in views {
            view.layer.masksToBounds = true
            
            let animation = CABasicAnimation(keyPath: #keyPath(CALayer.cornerRadius))
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animation.fromValue = view.layer.cornerRadius
            animation.toValue = value
            animation.duration = duration
            
            view.layer.add(animation, forKey: "CornerRadiusAnim")
            view.layer.cornerRadius = value
        }
        
        CATransaction.commit()
    }
    
}
