//
//  PopoverAnimationController.swift
//  weibo
//
//  Created by mada on 15/9/28.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

let JSJPopoverViewDidPrentedNotification = "PopoverViewDidPrentedNotification"
let JSJPopoverViewDidDismissedNotification = "PopoverViewDidDismissedNotification"

class PopoverAnimationController: UIPresentationController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    // popoverView是展现还是消失
    var isPrsent: Bool = true
    // 展示的尺寸和位置
    var presentFrame: CGRect = CGRectZero
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        JSJLog(presented)
        let pVc = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pVc.presentFrame = presentFrame
        return pVc
    }
    
    // 展示时调用(告诉系统谁执行展示)
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPrsent = true
        NSNotificationCenter.defaultCenter().postNotificationName(JSJPopoverViewDidPrentedNotification, object: self)
        return self
    }
    
    // 消失时调用(告诉系统谁执行消失)
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPrsent = false
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(JSJPopoverViewDidDismissedNotification, object: self)
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1
    }
    
    /**
    告诉系统如何执行转场动画
    一旦实现这个方法,所有操作都由我们自己来完成:如何出现,如何消失
    - parameter transitionContext: 上下文,保存了需要的数据
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /* 判断是出现还是消失*/
        if isPrsent {
            JSJLog("展示")
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            // 添加到容器视图
            transitionContext.containerView()?.addSubview(toView)
            toView.transform = CGAffineTransformMakeScale(1.0, 0)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                toView.transform = CGAffineTransformIdentity
                }) { (_) -> Void in
                    // 告诉系统转场完毕,一定要写
                    transitionContext.completeTransition(true)
            }
        }
        else {
            JSJLog("消失")
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                fromView.transform = CGAffineTransformMakeScale(1.0, 0.000001)
                }, completion: { (_) -> Void in
                    // 告诉系统转场完毕,一定要写
                    transitionContext.completeTransition(true)
            })
        }
        
    }
}
