//
//  HomeTableViewController.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    // popoverView是展现还是消失
    var isPrsent: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setupVisitorInfo(true, centerIconImage: "visitordiscover_feed_image_house", noteText: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 初始化导航条
        setupNav()
    }
    
    private func setupNav() {
        // 初始化标题按钮
        let btn = TitleButton()
        btn.setTitle("啦啦啦啦  ", forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        btn.addTarget(self, action: Selector("titleButtonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = btn
        
        // 初始化两边的按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, actionName: "leftButtonClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, actionName: "rightButtonClick")
    }
    
    func titleButtonClick(button: UIButton) {
        JSJLog(__FUNCTION__)
        button.selected = !button.selected
        
        let storyboard = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        
        /* 设置这两个属性之后,modal出控制器后,原控制器的view不会被移除*/
        // 告诉系统谁负责转场
        vc.transitioningDelegate = self
        // 转场样式
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func leftButtonClick() {
        JSJLog(__FUNCTION__)
    }

    func rightButtonClick() {
        JSJLog(__FUNCTION__)
    }
    
    // MARK: - 懒加载
    private lazy var popoverAnimator: PopoverAnimationController = {
        let animator = PopoverAnimationController()
        return animator
        }()
}

extension HomeTableViewController : UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        JSJLog(presented)
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    // 展示时调用(告诉系统谁执行展示)
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPrsent = true
        return self
    }
    
    // 消失时调用(告诉系统谁执行消失)
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPrsent = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 11
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
