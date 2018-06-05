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
        if forward {
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }

    private func animateTransitionForPush(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.from)

        let containerView = transitionContext.containerView
        guard let transitioningImageView = transitionSourceImageView() else { return }

        if let toViewController = transitionContext.viewController(forKey: .to) {
            destinationView.frame = transitionContext.finalFrame(for: toViewController)
        }
        
        sourceView?.alpha = 1.0
        destinationView.alpha = 0.0

        if let sourceView = sourceView, transitionContext.presentationStyle == .none {
            containerView.insertSubview(destinationView, belowSubview: sourceView)
            containerView.backgroundColor = sourceView.backgroundColor
        } else {
            containerView.addSubview(destinationView)
        }
        containerView.addSubview(transitioningImageView)
        
        source.transitionSourceWillBegin(self)
        destination.transitionDestinationWillBegin(self)

        UIView.animateCornerRadii(withDuration: self.transitionDuration(using: transitionContext),
                                  to: transitionDestinationImageView()?.layer.cornerRadius ?? 0,
                                  views: [transitioningImageView])
        
        UIView.animate(
            withDuration: transitionDuration,
            delay: 0.0,
            usingSpringWithDamping: animationSpringDamping,
            initialSpringVelocity: animationSpringInitialVelocity,
            options: .curveEaseOut,
            animations: {
                sourceView?.alpha = 0.0
                destinationView.alpha = 1.0
                transitioningImageView.frame = self.destination.transitionDestinationImageViewFrame(forward: self.forward) ?? .zero
            },
            completion: { _ in
                sourceView?.alpha = 1.0
                transitioningImageView.alpha = 0.0
                transitioningImageView.removeFromSuperview()

                self.source.transitionSourceDidEnd(self)
                self.destination.transitionDestinationDidEnd(self, transitioningImageView: transitioningImageView)

                let completed = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(completed)
        })
    }

    private func animateTransitionForPop(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }
        
        let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.to)

        let containerView = transitionContext.containerView
        guard let transitioningImageView = transitionDestinationImageView() else { return }

        destinationView.alpha = 1.0
        sourceView?.alpha = 0.0

        if let sourceView = sourceView, transitionContext.presentationStyle == .none {
            containerView.insertSubview(sourceView, belowSubview: destinationView)
            containerView.backgroundColor = destinationView.backgroundColor
        }
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin(self)
        destination.transitionDestinationWillBegin(self)

        if transitioningImageView.frame.maxY < 0.0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }
        
        UIView.animateCornerRadii(withDuration: self.transitionDuration(using: transitionContext),
                                  to: transitionSourceImageView()?.layer.cornerRadius ?? 0,
                                  views: [transitioningImageView])
        
        UIView.animate(
            withDuration: transitionDuration,
            delay: 0.0,
            usingSpringWithDamping: animationSpringDamping,
            initialSpringVelocity: animationSpringInitialVelocity,
            options: .curveEaseOut,
            animations: {
                destinationView.alpha = 0.0
                sourceView?.alpha = 1.0
                transitioningImageView.frame = self.source.transitionSourceImageViewFrame(forward: self.forward) ?? .zero
            },
            completion: { _ in
                destinationView.alpha = 1.0
                transitioningImageView.removeFromSuperview()

                self.source.transitionSourceDidEnd(self)
                self.destination.transitionDestinationDidEnd(self, transitioningImageView: transitioningImageView)

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func transitionSourceImageView() -> UIImageView? {
        if let imageView = source.transitionSourceImageView() {
            let frame = source.transitionSourceImageViewFrame(forward: forward) ?? .zero
            return UIImageView(baseImageView: imageView, frame: frame)
        }
        return nil
    }

    private func transitionDestinationImageView() -> UIImageView? {
        let sourceImageView = source.transitionSourceImageView()
        if let imageView = destination.transitionDestinationImageView() ?? sourceImageView {
            let frame = destination.transitionDestinationImageViewFrame(forward: forward) ?? .zero
            let retImageView = UIImageView(baseImageView: imageView, frame: frame)
            retImageView.contentMode = sourceImageView?.contentMode ?? retImageView.contentMode
            return retImageView
        }
        return nil
    }
    
}
