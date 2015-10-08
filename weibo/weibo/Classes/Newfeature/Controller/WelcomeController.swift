//
//  WelcomeController.swift
//  weibo
//
//  Created by mada on 15/10/8.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class WelcomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置头像
        let url = NSURL(string: UserAccount.loadAccount()!.avatar_large!)
        iconView.sd_setImageWithURL(url)
        
        // 设置子控件
        setupUI()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 添加头像的动画
        iconView.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-UIScreen.mainScreen().bounds.height + 160)
        }
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView.animateWithDuration(1.2, animations: { () -> Void in
                    self.contentLabel.alpha = 1.0
                    }, completion: { (_) -> Void in
                        // 发送通知
                        NSNotificationCenter.defaultCenter().postNotificationName(JSJSwitchRootViewController, object: nil)
                })
        }
    }
    
    private func setupUI() {
        /* 添加子控件*/
        view.addSubview(backgroundImageView)
        view.addSubview(iconView)
        view.addSubview(contentLabel)
        
        /* 添加约束*/
        // 背景
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        // 头像
        iconView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp_bottom).offset(-160)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        // 欢迎
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconView.snp_centerX)
            make.top.equalTo(iconView.snp_bottom).offset(10)
        }
    }
    
    // MARK: - 懒加载
    
    // 背景图片
    private lazy var backgroundImageView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "ad_background"))
        return imageView
    }()
    
    // 头像
    private lazy var iconView: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "avatar_default_big"))
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // 欢迎
    private lazy var contentLabel: UILabel = {
        var label = UILabel()
        label.text = "欢迎你个蛋蛋！"
        label.alpha = 0.0
        label.font = UIFont.systemFontOfSize(20)
        label.sizeToFit()
        return label
    }()
}
