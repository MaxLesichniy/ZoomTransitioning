//
//  ZoomTransitionSource.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionSourceProvider {
    var zoomTransitionSource: ZoomTransitionSource? { get }
}

public protocol ZoomTransitionSource {
    func transitionSourceImageView(_ toViewController: UIViewController) -> UIImageView?
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect?
    func transitionSourceClippingMaskFrame(_ transitioning: ZoomTransitioning) -> CGRect?
    func transitionSourceWillBegin(_ transitioning: ZoomTransitioning)
    func transitionSourceDidEnd(_ transitioning: ZoomTransitioning)
    func transitionSourceDidCancel(_ transitioning: ZoomTransitioning)
}

public extension ZoomTransitionSource {
    func transitionSourceClippingMaskFrame(_ transitioning: ZoomTransitioning) -> CGRect? { return nil }
    func transitionSourceWillBegin(_ transitioning: ZoomTransitioning) {}
    func transitionSourceDidEnd(_ transitioning: ZoomTransitioning) {}
    func transitionSourceDidCancel(_ transitioning: ZoomTransitioning) {}
}

