//
//  ZoomNavigationControllerDelegate.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/16/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomNavigationControllerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    public fileprivate(set) var interactivePopGestureRecognizer: UIGestureRecognizer?
    weak var navigationController: UINavigationController?
    
    public init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeFromLeft(_:)))
        left.delaysTouchesBegan = true
        left.delegate = self
        left.edges = .left
        navigationController.view.addGestureRecognizer(left)
        self.interactivePopGestureRecognizer = left
    }
    
    @objc private func handleSwipeFromLeft(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        let percent = gesture.translation(in: gestureView).x / gestureView.bounds.size.width
        
        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
            
        case .changed:
            self.interactionController?.update(percent)
        case .cancelled:
            self.interactionController?.cancel()
        case .ended, .failed:
            if percent > 0.3 || gesture.velocity(in: gestureView).x > 1000.0 {
                self.interactionController?.finish()
            } else {
                self.interactionController?.cancel()
            }
            self.interactionController = nil
        default:
            break
        }
    }
    
    //    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        return true
    //    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer is UIScreenEdgePanGestureRecognizer
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //        if let source = sourceForController(fromVC),
        //            let destination = destinationForController(toVC),
        //            source.transitionSourceImageView() != nil,
        //            destination.transitionDestinationImageViewFrame(forward: true) != nil,
        //            operation == .push {
        //            return true
        //        } else if let source = sourceForController(toVC),
        //            let destination = destinationForController(fromVC),
        //            destination.transitionDestinationImageView() != nil,
        //            source.transitionSourceImageViewFrame(forward: false) != nil,
        //            operation == .pop {
        //            return true
        //        }
        return true
    }
}


// MARK: - UINavigationControllerDelegate

extension ZoomNavigationControllerDelegate: UINavigationControllerDelegate {
    
    fileprivate func sourceForController(_ controller: UIViewController) -> ZoomTransitionSource? {
        if let sourceProvider = controller as? ZoomTransitionSourceProvider,
           let source = sourceProvider.zoomTransitionSource {
            return source
        }
        if let comform = controller as? ZoomTransitionSource {
            return comform
        }
        for itemController in controller.childViewControllers {
            if let c = sourceForController(itemController) {
                return c
            }
        }
        return nil
    }
    
    fileprivate func destinationForController(_ controller: UIViewController) -> ZoomTransitionDestination? {
        if let destinationProvider = controller as? ZoomTransitionDestinationProvider,
           let destination = destinationProvider.zoomTransitionDestination {
            return destination
        }
        if let comform = controller as? ZoomTransitionDestination {
            return comform
        }
        for itemController in controller.childViewControllers {
            if let c = destinationForController(itemController) {
                return c
            }
        }
        return nil
    }
    
    //    private func findController<T>(_ controller: UIViewController) -> T? where T: UIViewController {
    //        if let comform = controller as? T {
    //            return comform
    //        } else {
    //            for itemController in controller.childViewControllers {
    //                if let c = findController(itemController) as? T {
    //                    return c
    //                }
    //            }
    //            return nil
    //        }
    //    }
    
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let source = sourceForController(fromVC),
           let destination = destinationForController(toVC),
           source.transitionSourceImageView(toVC) != nil,
           destination.transitionDestinationImageViewFrame(forward: true) != nil,
           operation == .push {
            return ZoomTransitioning(source: source, destination: destination, forward: true)
        } else if let source = sourceForController(toVC),
                  let destination = destinationForController(fromVC),
                  destination.transitionDestinationImageView(toVC) != nil,
                  source.transitionSourceImageViewFrame(forward: false) != nil,
                  operation == .pop {
            return ZoomTransitioning(source: source, destination: destination, forward: false)
        }
        
        return nil
    }
}
