//
//  ZoomTransitionDestination.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionDestination {

    func transitionDestinationImageView() -> UIImageView?
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect?
    func transitionDestinationWillBegin(_ transitioning: ZoomTransitioning)
    func transitionDestinationDidEnd(_ transitioning: ZoomTransitioning, transitioningImageView imageView: UIImageView)
    func transitionDestinationDidCancel(_ transitioning: ZoomTransitioning)
}

extension ZoomTransitionDestination {
    func transitionDestinationWillBegin(_ transitioning: ZoomTransitioning) {}
    func transitionDestinationDidEnd(_ transitioning: ZoomTransitioning, transitioningImageView imageView: UIImageView) {}
    func transitionDestinationDidCancel(_ transitioning: ZoomTransitioning) {}
}
