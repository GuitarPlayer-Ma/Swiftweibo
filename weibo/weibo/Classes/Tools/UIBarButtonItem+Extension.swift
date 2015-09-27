//
//  UIBarButtonItem+Extension.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // 创建一个item
    class func createBarButtonItem(imageName: String, target: AnyObject?, actionName: String) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        
        btn.addTarget(target, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        return UIBarButtonItem(customView: btn)
    }
    
    // 便利方法
    // 被convenience修饰的构造方法我们称之为 便利构造方法
    // 便利构造方法和普通构造方法的区别 普通是一等类型, 便利构造方法是二等类型
    // 便利构造方法中必须调用self.init, 也就是说便利构造方法中必须调用指定构造方法
    convenience init(imageName: String, target: AnyObject?,actionName: String) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.sizeToFit()
        
        btn.addTarget(target, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        self.init(customView: btn)
    }
}
