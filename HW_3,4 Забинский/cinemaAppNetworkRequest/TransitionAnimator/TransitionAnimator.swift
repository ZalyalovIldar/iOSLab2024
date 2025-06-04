//
//  TransitionAnimator.swift
//  cinemaAppNetworkRequest
//
//  Created by Данил Забинский on 04.01.2025.
//

import UIKit

enum TransitionMode {
    case present
    case dismiss
}

class TransitionAnimator: NSObject {
    
    private let transitionMode: TransitionMode
    private let duration: CGFloat
    
    init(duration: CGFloat, transitionMode: TransitionMode) {
        self.duration = duration
        self.transitionMode = transitionMode
    }
}

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        switch self.transitionMode {
        case .present:
            guard let presentedView = transitionContext.view(forKey: .to) else {
                transitionContext.completeTransition(false)
                return
            }
            
            let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            let rotationTransform = CGAffineTransform(rotationAngle: .pi / 12)
            let mixedTransform = scaleTransform.concatenating(rotationTransform)
            presentedView.transform = mixedTransform
            presentedView.alpha = 0
            containerView.addSubview(presentedView)

            UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                presentedView.transform = .identity
                presentedView.alpha = 1
            }) { isFinished in
                transitionContext.completeTransition(isFinished)
            }

        case .dismiss:
            guard let dismissedView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(false)
                return
            }

            UIView.animate(withDuration: self.duration / 2, delay: 0, options: .curveEaseInOut, animations: {
                let scaleTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                let rotationTransform = CGAffineTransform(rotationAngle: .pi / -12)
                let mixedTransform = scaleTransform.concatenating(rotationTransform)
                
                dismissedView.transform = mixedTransform
                dismissedView.alpha = 0
            }) { isFinished in
                UIView.animate(withDuration: self.duration / 2, animations: {
                    dismissedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }, completion: { isFinished in
                    dismissedView.removeFromSuperview()
                    transitionContext.completeTransition(isFinished)
                })
            }
        }
    }
}
