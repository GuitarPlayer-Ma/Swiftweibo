//
//  MainTabbarController.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class MainTabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewControllers()
    }
    
    private func addChildViewControllers() {
        tabBar.tintColor = UIColor.orangeColor()
//        let homeVc = HomeTableViewController()
//        homeVc.title = "首页"
//        homeVc.tabBarItem.image = UIImage(named: "tabbar_home")
//        let nav1 = UINavigationController(rootViewController: homeVc)
//        addChildViewController(nav1)
        
        /* 添加子控制器*/
        addChildViewController("HomeTableViewController", imageName: "tabbar_home", title: "首页")
        addChildViewController("DiscoverTableViewController", imageName: "tabbar_discover", title: "发现")
        addChildViewController("MessageTableViewController", imageName: "tabbar_message_center", title: "消息")
        addChildViewController("ProfileTableViewController", imageName: "tabbar_profile", title: "我")
        
    }
    
    private func addChildViewController(viewControllerName: String, imageName: String, title: String) {
        print(NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"])
        
        /* 根据控制器的名称实例化子控制器*/
        // 命名空间
        let namespace = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        let className = namespace + "." + viewControllerName
        let cls: AnyClass! = NSClassFromString(className)
        // 告诉编译器真实类型
        let vcClass = cls as! UIViewController.Type
        // 实例化控制器
        let vc = vcClass.init()
        
        /* 设置子控制器*/
        vc.title = title
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlight")
        // 包装导航控制器
        let naVc = UINavigationController(rootViewController: vc)
        addChildViewController(naVc)
    }
}
