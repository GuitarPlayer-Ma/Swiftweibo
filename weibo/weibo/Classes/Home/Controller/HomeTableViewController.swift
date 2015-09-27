//
//  HomeTableViewController.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

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
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_friendattention"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("leftButtonClick"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, actionName: "leftButtonClick")
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationbar_pop"), style: UIBarButtonItemStyle.Done, target: self, action: Selector("rightButtonClick"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, actionName: "rightButtonClick")
    }
    
    func titleButtonClick(button: UIButton) {
        JSJLog(__FUNCTION__)
        button.selected = !button.selected
    }
    
    func leftButtonClick() {
        JSJLog(__FUNCTION__)
    }

    func rightButtonClick() {
        JSJLog(__FUNCTION__)
    }
}
