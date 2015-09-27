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
    // MARK: - 懒加载
    lazy private var publishButton: UIButton = {
        // 创建按钮
        let btn = UIButton()
        // 设置图片
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_hightlight"), forState: UIControlState.Highlighted)
        // 设置背景
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        // 添加监听
        btn.addTarget(self, action: Selector("publishButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 添加中间的加号按钮
        tabBar.addSubview(publishButton)
        // 设置按钮的位置
        let buttonW = UIScreen.mainScreen().bounds.width / CGFloat(childViewControllers.count)
        let rect = CGRect(origin: CGPointZero, size: CGSize(width: buttonW, height: 49))
        publishButton.frame = CGRectOffset(rect, 2*buttonW, 0)
    }
    
    // MARK: - 内部方法
    func publishButtonClick() {
        JSJLog(__FUNCTION__)
    }
    
    private func addChildViewControllers() {
        tabBar.tintColor = UIColor.orangeColor()
//        let homeVc = HomeTableViewController()
//        homeVc.title = "首页"
//        homeVc.tabBarItem.image = UIImage(named: "tabbar_home")
//        let nav1 = UINavigationController(rootViewController: homeVc)
//        addChildViewController(nav1)
        
        do {
            // json数据路径
            let path = NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil)!
            // 根据路径创建NSData
            let data = NSData(contentsOfFile: path)!
            // 解析成数组
            let dictArray = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            // 遍历数组创建子控制器
            for dict in dictArray as! [[String : AnyObject]] {
                addChildViewController(dict["vcName"] as! String, imageName: dict["imageName"] as! String, title: dict["title"] as! String)
            }
        }catch {
            // 如果json数据没有就正常创建
            addChildViewController("HomeTableViewController", imageName: "tabbar_home", title: "首页")
            addChildViewController("MessageTableViewController", imageName: "tabbar_message_center", title: "消息")
            // 用来占位的子控制器
            addChildViewController("NullViewController", imageName: "", title: "")
            addChildViewController("DiscoverTableViewController", imageName: "tabbar_discover", title: "广场")
            addChildViewController("ProfileTableViewController", imageName: "tabbar_profile", title: "我")
        }
    }
    
    private func addChildViewController(viewControllerName: String, imageName: String, title: String) {
        JSJLog(NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"])
        
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
        if imageName != "" {
            vc.tabBarItem.image = UIImage(named: imageName)
            vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlight")
        }
        // 包装导航控制器
        let naVc = UINavigationController(rootViewController: vc)
        addChildViewController(naVc)
    }
}
