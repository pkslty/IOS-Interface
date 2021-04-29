//
//  Animations.swift
//  VKApp
//
//  Created by Denis Kuzmin on 27.04.2021.
//

import UIKit

class PushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to),
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        containerView.addSubview(destinationView)

        let rotations = 3.0
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
        //destinationView.backgroundColor = .systemBackground
        containerView.backgroundColor = .systemBackground
        transitionContext.completeTransition(true)
        }
        let animation1 = CABasicAnimation(keyPath: "transform.scale")
        animation1.fromValue = 0.1
        animation1.toValue = 1
            animation1.duration = timeInterval
            animation1.repeatCount = 1
            destinationView.layer.add(animation1, forKey: nil)
            let animation2 = CABasicAnimation(keyPath: "transform.rotation")
            animation2.fromValue = 0
            
            animation2.toValue = 2 * Double.pi
            animation2.duration = timeInterval / rotations
        animation2.repeatCount = Float(rotations)
        destinationView.layer.add(animation2, forKey: nil)
        CATransaction.commit()      
    }
}

class PopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.5
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from),
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to),
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        destinationView.alpha = 0
        destinationView.backgroundColor = .black
        containerView.backgroundColor = .black
        containerView.insertSubview(destinationView, belowSubview: sourceView)
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            destinationView.alpha = 1
            destinationView.backgroundColor = .systemBackground
            containerView.backgroundColor = .systemBackground
            transitionContext.completeTransition(true)
        }
        let animation1 = CABasicAnimation(keyPath: "transform.scale.y")
        animation1.fromValue = 1
        animation1.toValue = 0.005
        animation1.duration = timeInterval * 0.4
        animation1.repeatCount = 1
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        animation1.beginTime = CACurrentMediaTime()
        sourceView.layer.add(animation1, forKey: nil)
        let animation2 = CABasicAnimation(keyPath: "transform.scale.x")
        animation2.fromValue = 1
        animation2.toValue = 0.01
        animation2.duration = timeInterval * 0.5
        animation2.repeatCount = 1
        animation2.beginTime = CACurrentMediaTime() + timeInterval * 0.5
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = .forwards
        sourceView.layer.add(animation2, forKey: nil)
        CATransaction.commit()
    }
}

class PercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isStarted: Bool = false
    var shouldFinish: Bool = false
}


class FriendPhotosPopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
 
    let timeInterval: TimeInterval = 0.0
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }


    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let source = transitionContext.viewController(forKey: .from) as? PhotoPresenterViewController,
              let sourceView = source.view,
              let destination = transitionContext.viewController(forKey: .to) as? FriendPhotosViewController,
              let destinationView = destination.view
        else { return }

        let containerView = transitionContext.containerView
        containerView.frame = sourceView.frame
        destinationView.frame = sourceView.frame
        let index = IndexPath(row: source.currentImage, section: 0)
        //print(index)
        //destination.collectionView.scrollToItem(at: index, at: UICollectionView.ScrollPosition.centeredVertically, animated: false)
        destination.currentImage = source.currentImage
        print("currentImage in animateTransition: \(destination.currentImage)")
        destinationView.alpha = 0
        containerView.backgroundColor = .systemBackground
        containerView.insertSubview(destinationView, belowSubview: sourceView)
        //print(sourceView.subviews)
        
        UIView.animate(withDuration: timeInterval) {
            destinationView.alpha = 1
        } completion: { complete in
            transitionContext.completeTransition(complete && !transitionContext.transitionWasCancelled)
            //print(source)
            //print(destination)
        }
        
        
    }
}
