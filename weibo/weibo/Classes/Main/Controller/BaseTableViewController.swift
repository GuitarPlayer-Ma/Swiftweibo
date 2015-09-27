//
//  BaseTableViewController.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController, VisitorViewDelegate {
    // 标记当前的登录状态
    var isLogin: Bool = true
    // 定义属性保存访客视图(可以供子控制器修改)
    var visitorView: VisitorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
        
    }
    
    private func setupVisitorView() {
        visitorView = VisitorView(frame: UIScreen.mainScreen().bounds)
        visitorView?.delegate = self
        view = visitorView
        
        // 设置导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }

    // MARK: - VisitorViewDelegate
    
    func visitorViewDidRegisterButtonClick(visitorView: VisitorView) {
        JSJLog(__FUNCTION__)
    }
    
    func visitorViewDidLoginButtomClick(visitorView: VisitorView) {
        JSJLog(__FUNCTION__)
    }
}
