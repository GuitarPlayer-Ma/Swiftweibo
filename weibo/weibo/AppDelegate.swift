//
//  AppDelegate.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置外观
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = MainTabbarController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

/** 自定义打印输出*/
func JSJLog<T>(message: T, fileName: String = __FILE__, line: Int = __LINE__, method: String = __FUNCTION__) {
    #if DEBUG
    print("<\((fileName as NSString).lastPathComponent)>**\(line)**[\(method)]--\(message)")
    #endif
}
