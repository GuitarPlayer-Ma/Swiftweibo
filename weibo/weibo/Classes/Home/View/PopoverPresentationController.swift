//
//  PopoverPresentationController.swift
//  weibo
//
//  Created by mada on 15/9/28.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    
    override func containerViewWillLayoutSubviews() {
        // 修改被弹出来的view的大小和位置
        presentedView()?.frame = CGRect(x: 100, y: 56, width: 200, height: 300)
        // 添加子控制器
        containerView?.insertSubview(maskView, atIndex: 0)
    }
    
    func maskViewClick() {
        // 退出
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 懒加载
    private lazy var maskView: UIView = {
        let mView = UIView()
        mView.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        mView.frame = UIScreen.mainScreen().bounds
        
        mView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("maskViewClick")))
        return mView
    }()
    
    
}
