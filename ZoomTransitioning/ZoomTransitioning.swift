//
//  ZoomTransitioning.swift
//  ZoomTransitioning
//
//  Created by WorldDownTown on 07/08/2016.
//  Copyright © 2016 WorldDownTown. All rights reserved.
//

import UIKit

public final class ZoomTransitioning: NSObject {
    
    fileprivate let source: ZoomTransitionSource
    fileprivate let destination: ZoomTransitionDestination
    public let forward: Bool
    
    public var transitionDuration: TimeInterval = 0.5
    public var animationSpringDamping: CGFloat = 0.75
    public var animationSpringInitialVelocity: CGFloat = 0.0
    public var fadingTransitionImageViewDuration: TimeInterval = 0.2
    
    public weak var transitionContext: UIViewControllerContextTransitioning?
    
    required public init(source: ZoomTransitionSource, destination: ZoomTransitionDestination, forward: Bool) {
        self.source = source
        self.destination = destination
        self.forward = forward
        
        super.init()
    }
}

// MARK: -  UIViewControllerAnimatedTransitioning

extension ZoomTransitioning: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        if forward {
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }
    
    public func animationEnded(_ transitionCompleted: Bool) {
        if !transitionCompleted {
            source.transitionSourceDidCancel(self)
            destination.transitionDestinationDidCancel(self)
        }
    }
    
    // MARK: - Frames
    
    private func transitionSourceImageViewFrame(_ containerView: UIView) -> CGRect {
        source.transitionSourceImageViewFrame(forward: forward).map {
            containerView.convert($0, from: nil)
        } ?? .zero
    }
    
    private func transitionSourceClippingMaskFrame(_ containerView: UIView) -> CGRect {
        source.transitionSourceClippingMaskFrame(self).map {
            containerView.convert($0, from: nil)
        } ?? containerView.bounds
    }
    
    private func transitionDestinationImageViewFrame(_ containerView: UIView) -> CGRect {
        destination.transitionDestinationImageViewFrame(forward: forward).map {
            containerView.convert($0, from: nil)
        } ?? .zero
    }
    
    private func transitionDestinationClippingMaskFrame(_ containerView: UIView) -> CGRect {
        destination.transitionDestinationClippingMaskFrame(self).map {
            containerView.convert($0, from: nil)
        } ?? containerView.bounds
    }
    
    // MARK: -
    
    private func animateTransitionForPush(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            //            if transitionContext.isInteractive {
            //                transitionContext.finishInteractiveTransition()
            //            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        let fromView = transitionContext.view(forKey: .from)
        
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromViewController = transitionContext.viewController(forKey: .from)
        
        guard let transitioningImageView = transitionSourceImageView(toViewController: toViewController!,
                                                                     frame: transitionSourceImageViewFrame(containerView)) else { return }
        
        toViewController.map {
            toView.frame = transitionContext.finalFrame(for: $0)
            toView.layoutIfNeeded()
        }
        
        fromView?.alpha = 1.0
        toView.alpha = 0.0
        
        let transitionView = UIView(frame: containerView.bounds)
        
        let maskView = UIView()
        maskView.backgroundColor = .black
        transitionView.mask = maskView
        
        transitionView.mask?.frame = transitionSourceClippingMaskFrame(containerView)
        
        if let sourceView = fromView, transitionContext.presentationStyle == .none {
            containerView.insertSubview(toView, belowSubview: sourceView)
            containerView.backgroundColor = sourceView.backgroundColor
        } else {
            containerView.addSubview(toView)
        }
        
        transitionView.addSubview(transitioningImageView)
        containerView.addSubview(transitionView)
        
        source.transitionSourceWillBegin(self)
        destination.transitionDestinationWillBegin(self)
        
        //        UIView.animateCornerRadii(withDuration: self.transitionDuration(using: transitionContext),
        //                                  to: transitionDestinationImageView()?.layer.cornerRadius ?? 0,
        //                                  views: [transitioningImageView])
        
        UIView.animate(
            withDuration: transitionDuration,
            delay: 0.0,
            usingSpringWithDamping: animationSpringDamping,
            initialSpringVelocity: animationSpringInitialVelocity,
            options: .curveEaseOut,
            animations: {
                fromView?.alpha = 0.0
                toView.alpha = 1.0
                
                let destinationImageViewFrame = self.transitionDestinationImageViewFrame(containerView)
                
                // update parameters
                if let imageView = self.transitionDestinationImageView(fromViewController: fromViewController!,
                                                                       toViewController: toViewController!,
                                                                       createCopy: false,
                                                                       frame: destinationImageViewFrame) {
                    self.copyParameters(from: imageView, to: transitioningImageView)
                }
                
                transitioningImageView.frame = destinationImageViewFrame
                transitionView.mask?.frame = self.transitionDestinationClippingMaskFrame(containerView)
            }, completion: { _ in
                fromView?.alpha = 1.0
                
                UIView.animate(withDuration: self.fadingTransitionImageViewDuration, animations: {
                    transitioningImageView.alpha = 0.0
                }, completion: { _ in
                    transitionView.removeFromSuperview()
                })
                
                self.source.transitionSourceDidEnd(self)
                self.destination.transitionDestinationDidEnd(self, transitioningImageView: transitioningImageView)
                
                let completed = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(completed)
            })
    }
    
    private func animateTransitionForPop(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }
        
        let toView = transitionContext.view(forKey: .to)
        
        let toViewController = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
                
        guard let transitioningImageView = transitionDestinationImageView(fromViewController: transitionContext.viewController(forKey: .from)!,
                                                                          toViewController: toViewController!,
                                                                          frame: transitionDestinationImageViewFrame(containerView)) else { return }
        toViewController.map {
            toView?.frame = transitionContext.finalFrame(for: $0)
            toView?.layoutIfNeeded()
        }
        
        fromView.alpha = 1.0
        toView?.alpha = 0.0
        
        let transitionView = UIView(frame: containerView.bounds)
        
        let maskView = UIView()
        maskView.backgroundColor = .black
        transitionView.mask = maskView
        
        transitionView.mask?.frame = transitionDestinationClippingMaskFrame(containerView)
        
        if let sourceView = toView, transitionContext.presentationStyle == .none {
            containerView.insertSubview(sourceView, belowSubview: fromView)
            containerView.backgroundColor = fromView.backgroundColor
        }
        
        transitionView.addSubview(transitioningImageView)
        containerView.addSubview(transitionView)
        
        containerView.layoutIfNeeded()
        
        source.transitionSourceWillBegin(self)
        destination.transitionDestinationWillBegin(self)
        
        if transitioningImageView.frame.maxY < 0.0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }
        
        //        UIView.animateCornerRadii(withDuration: self.transitionDuration(using: transitionContext),
        //                                  to: transitionSourceImageView()?.layer.cornerRadius ?? 0,
        //                                  views: [transitioningImageView])
        
        UIView.animate(
            withDuration: transitionDuration,
            delay: 0.0,
            usingSpringWithDamping: animationSpringDamping,
            initialSpringVelocity: animationSpringInitialVelocity,
            options: .curveEaseOut,
            animations: {
                fromView.alpha = 0.0
                toView?.alpha = 1.0
                
                let sourceImageViewFrame = self.transitionSourceImageViewFrame(containerView)
                
                // update parameters
                if let imageView = self.transitionSourceImageView(toViewController: toViewController!,
                                                                  createCopy: false,
                                                                  frame: sourceImageViewFrame) {
                    self.copyParameters(from: imageView, to: transitioningImageView)
                }
                transitioningImageView.frame = sourceImageViewFrame
                transitionView.mask?.frame = self.transitionSourceClippingMaskFrame(containerView)
            }, completion: { _ in
                fromView.alpha = 1.0
                
                UIView.animate(withDuration: self.fadingTransitionImageViewDuration, animations: {
                    transitioningImageView.alpha = 0.0
                }, completion: { _ in
                    transitionView.removeFromSuperview()
                })
                
                self.source.transitionSourceDidEnd(self)
                self.destination.transitionDestinationDidEnd(self, transitioningImageView: transitioningImageView)
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
    }
    
    //    public func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    //
    //    }
    
    private func transitionSourceImageView(toViewController: UIViewController, createCopy: Bool = true, frame: CGRect) -> UIImageView? {
        if let imageView = source.transitionSourceImageView(toViewController) {
            if createCopy {
                return copyImageView(from: imageView, frame: frame)
            } else {
                return imageView
            }
        }
        return nil
    }
    
    private func transitionDestinationImageView(fromViewController: UIViewController, toViewController: UIViewController,
                                                createCopy: Bool = true, frame: CGRect) -> UIImageView? {
        let sourceImageView = source.transitionSourceImageView(toViewController)
        if let imageView = destination.transitionDestinationImageView(fromViewController) ?? sourceImageView {
            if createCopy {
                return copyImageView(from: imageView, frame: frame)
            } else {
                return imageView
            }
        }
        return nil
    }
    
    private func copyImageView(from baseImageView: UIImageView, frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.image = baseImageView.image
        imageView.clipsToBounds = true
        copyParameters(from: baseImageView, to: imageView)
        return imageView
    }
    
    private func copyParameters(from baseImageView: UIImageView, to imageView: UIImageView) {
        imageView.contentMode = baseImageView.contentMode
        imageView.backgroundColor = baseImageView.backgroundColor
        imageView.layer.cornerRadius = baseImageView.layer.cornerRadius
    }
    
}
