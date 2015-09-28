//
//  HomeTableViewController.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
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
        titleButton.setTitle("啦啦啦啦  ", forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        titleButton.addTarget(self, action: Selector("titleButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
        
        // 初始化两边的按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, actionName: "leftButtonClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, actionName: "rightButtonClick")
    }
    
    // MARK: - 导航栏按钮点击
    func titleButtonClick() {
        JSJLog(__FUNCTION__)
        
        let storyboard = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        
        /* 设置这两个属性之后,modal出控制器后,原控制器的view不会被移除*/
        // 告诉系统谁负责转场
        vc.transitioningDelegate = popoverAnimator
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
    
    func changeTitleButton() {
        titleButton.selected = !titleButton.selected
    }
    
    // MARK: - 懒加载
    private lazy var popoverAnimator: PopoverAnimationController = {
        let animator = PopoverAnimationController()
        
        // 设置popoverview的大小和位置
        animator.presentFrame = CGRect(x: 85, y: 56, width: 200, height: 300)
        
        // 注册监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeTitleButton"), name: JSJPopoverViewDidPrentedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeTitleButton"), name: JSJPopoverViewDidDismissedNotification, object: nil)
        
        return animator
    }()
    
    private lazy var titleButton: TitleButton = TitleButton()
}
