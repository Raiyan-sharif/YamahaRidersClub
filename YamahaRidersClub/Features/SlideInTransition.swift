//
//  SlideInTransition.swift
//  YamahaRidersClub
//
//  Created by raiyan sharif on 15/3/21.
//

import UIKit

class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPressenting = false
    let dimmingView = UIView()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
        let fromViewController = transitionContext.viewController(forKey: .from) else {return}
        
        let  containerView = transitionContext.containerView
        let finalWidth = toViewController.view.bounds.width * 0.8
        let finalHeight = toViewController.view.bounds.height
        
        if isPressenting{
            //Adding dimming view
            dimmingView.backgroundColor = .black
            dimmingView.alpha = 0.0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = CGRect(x: -finalWidth, y: 0, width: finalWidth, height: finalHeight)
        }
        let transform = {
            self.dimmingView.alpha = 0.5
            toViewController.view.transform = CGAffineTransform(translationX: finalWidth, y: 0)
        }
        let idendity = {
            self.dimmingView.alpha = 0.0
            fromViewController.view.transform = .identity
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        
        
        UIView.animate(withDuration: duration, animations: {
            self.isPressenting ? transform() : idendity()
        }) { (_) in
            transitionContext.completeTransition(!isCancelled)
        }
        
        
    }
    
    
    

}
