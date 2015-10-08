//
//  AppDelegate.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

let JSJSwitchRootViewController = "JSJSwitchRootViewController"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // 返回默认控制器
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        // 注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("switchRootViewController:"), name: JSJSwitchRootViewController, object: nil)
        return true
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func switchRootViewController(notify: NSNotification) {
        if notify.object != nil {
            window?.rootViewController = WelcomeController()
        }
            
        window?.rootViewController = MainTabbarController()
    }
    
    /**
    判断是不是新版本
    */
    private func isNewUpdate() -> Bool {
        // 获取当前版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]! as! String
        // 从沙盒中取出上次版本号(??作用：如果为nil则取??后面的值)
        let lastVersion = NSUserDefaults.standardUserDefaults().valueForKey("version") ?? ""
        // 比较两个版本
        if currentVersion.compare(lastVersion as! String) == NSComparisonResult.OrderedDescending {
            NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: "version")
            return true
        }
        return false
    }
    
    private func defaultViewController() -> UIViewController {
        // 判断是否登录
        if UserAccount.loadAccount() != nil {
            return isNewUpdate() ? NewfeatureController() : WelcomeController()
        }
        // 保存当前版本
        isNewUpdate()
        return MainTabbarController()
    }
}

/** 自定义打印输出*/
func JSJLog<T>(message: T, fileName: String = __FILE__, line: Int = __LINE__, method: String = __FUNCTION__) {
    #if DEBUG
    print("<\((fileName as NSString).lastPathComponent)>**\(line)**[\(method)]--\(message)")
    #endif
}
