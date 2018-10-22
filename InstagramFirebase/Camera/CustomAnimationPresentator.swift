//
//  CustomAnimationPresentator.swift
//  InstagramFirebase
//
//  Created by Tien Tran on 10/22/18.
//  Copyright © 2018 Tien-Enterprise. All rights reserved.
//

import Foundation
import UIKit

class CustomAnimationPresentator: NSObject, UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.5
	}
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		// my custom transition animation code logic
		let containerView = transitionContext.containerView
		guard let toView = transitionContext.view(forKey: .to) else { return }
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
		containerView.addSubview(toView)
		toView.frame = startingFrame
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			//animations
			toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
			fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
		}) { (_) in
				transitionContext.completeTransition(true)
		}
	}
}
