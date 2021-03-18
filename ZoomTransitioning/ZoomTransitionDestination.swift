//
//  ZoomTransitionDestination.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionDestinationProvider {
    var zoomTransitionDestination: ZoomTransitionDestination? { get }
}

public protocol ZoomTransitionDestination {
    func transitionDestinationImageView(_ fromViewController: UIViewController) -> UIImageView?
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect?
    func transitionDestinationClippingMaskFrame(_ transitioning: ZoomTransitioning) -> CGRect?
    func transitionDestinationWillBegin(_ transitioning: ZoomTransitioning)
    func transitionDestinationDidEnd(_ transitioning: ZoomTransitioning, transitioningImageView imageView: UIImageView)
    func transitionDestinationDidCancel(_ transitioning: ZoomTransitioning)
}

extension ZoomTransitionDestination {
    func transitionDestinationClippingMaskFrame(_ transitioning: ZoomTransitioning) -> CGRect? { return nil }
    func transitionDestinationWillBegin(_ transitioning: ZoomTransitioning) {}
    func transitionDestinationDidEnd(_ transitioning: ZoomTransitioning, transitioningImageView imageView: UIImageView) {}
    func transitionDestinationDidCancel(_ transitioning: ZoomTransitioning) {}
}
