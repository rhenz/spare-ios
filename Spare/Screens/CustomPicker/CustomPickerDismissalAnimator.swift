//
//  CustomPickerDismissalAnimator.swift
//  Spare
//
//  Created by Matt Quiros on 15/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CustomPickerDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Duration.Animation
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) as? __CPVCView
            else {
                return
        }
        
        UIView.animateWithDuration(
            self.transitionDuration(transitionContext),
            animations: {
                fromView.dimView.alpha = 0
                fromView.mainContainerBottom.constant = -(fromView.mainContainer.bounds.size.height)
                fromView.setNeedsLayout()
                fromView.layoutIfNeeded()
            },
            completion: { _ in
                let successful = transitionContext.transitionWasCancelled() == false
                transitionContext.completeTransition(successful)
        })
    }
    
}