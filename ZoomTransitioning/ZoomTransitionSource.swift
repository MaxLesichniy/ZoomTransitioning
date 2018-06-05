//
//  ZoomTransitionSource.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/12/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public protocol ZoomTransitionSource {
    func transitionSourceImageView() -> UIImageView?
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect?
    func transitionSourceWillBegin(_ transitioning: ZoomTransitioning)
    func transitionSourceDidEnd(_ transitioning: ZoomTransitioning)
    func transitionSourceDidCancel(_ transitioning: ZoomTransitioning)
}

public extension ZoomTransitionSource {
    func transitionSourceWillBegin(_ transitioning: ZoomTransitioning) {}
    func transitionSourceDidEnd(_ transitioning: ZoomTransitioning) {}
    func transitionSourceDidCancel(_ transitioning: ZoomTransitioning) {}
}

//public protocol ZoomTransitionChildSourceDelegate: ZoomTransitionSource {
//    func transitionSourceDelegate() -> ZoomTransitionSource?
//}
//
//public extension ZoomTransitionChildSourceDelegate {
//    func transitionSourceImageView() -> UIImageView? {
//        return transitionSourceDelegate()?.transitionSourceImageView()
//    }
//
//    func transitionSourceImageViewFrame(forward: Bool) -> CGRect? {
//        return transitionSourceDelegate()?.transitionSourceImageViewFrame(forward: forward)
//    }
//
//    func transitionSourceWillBegin(_ transitioning: ZoomTransitioning) {
//        transitionSourceDelegate()?.transitionSourceWillBegin(transitioning)
//    }
//
//    func transitionSourceDidEnd(_ transitioning: ZoomTransitioning) {
//        transitionSourceDelegate()?.transitionSourceDidEnd(transitioning)
//    }
//
//    func transitionSourceDidCancel(_ transitioning: ZoomTransitioning) {
//        transitionSourceDelegate()?.transitionSourceDidCancel(transitioning)
//    }
//}


