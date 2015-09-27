//
//  VisitorView.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SnapKit

@objc
protocol VisitorViewDelegate: NSObjectProtocol {
    // 协议中定义的方法,默认情况下是必须实现的
    
    // 点击了注册按钮
    optional func visitorViewDidRegisterButtonClick(visitorView: VisitorView)
    // 点击了登录按钮
    optional func visitorViewDidLoginButtomClick(visitorView: VisitorView)
}

class VisitorView: UIView {

    // 代理
    weak var delegate: VisitorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 232.0/255.0, green: 233.0/255.0, blue: 232.0/255.0, alpha: 1.0)
        setupChildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 定义一个可供外界调用修改属性的方法
    func setupVisitorInfo(isHome: Bool, centerIconImage: String, noteText: String) {
        centerIcon.image = UIImage(named: centerIconImage)
        noteInfo.text = noteText
        icon.hidden = !isHome
        if isHome {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 20.0
        anim.repeatCount = MAXFLOAT
        // 注意:removedOnCompletion默认只要动画执行完毕就会移除动画
        anim.removedOnCompletion = false
        icon.layer.addAnimation(anim, forKey: nil)
    }
    
    private func setupChildView() {
        /* 添加子控件*/
        addSubview(icon)
        addSubview(maskBgView)
        addSubview(centerIcon)
        addSubview(noteInfo)
        addSubview(registerButton)
        addSubview(loginButton)
        
        /* 布局子控件*/
        // 转盘
        icon.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.centerY.equalTo(self.snp_centerY).offset(-50)
        }
        // 图标
        centerIcon.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.centerY.equalTo(self.snp_centerY).offset(-50)
        }
        // 提示文本
        noteInfo.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(icon.snp_bottom).offset(25)
            make.width.equalTo(224)
        }
        // 注册按钮
        registerButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(noteInfo.snp_bottom).offset(25)
            make.left.equalTo(noteInfo.snp_left)
            make.size.equalTo(CGSize(width: 100, height: 35))
        }
        // 登录按钮
        loginButton.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(noteInfo.snp_bottom).offset(25)
            make.right.equalTo(noteInfo.snp_right)
            make.size.equalTo(CGSize(width: 100, height: 35))
        }
        // 背景图片
        maskBgView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
    }
    
    
    // MARK: - 按钮点击监听
    
    // 注册
    func registerClick() {
        JSJLog(__FUNCTION__)
        delegate?.visitorViewDidRegisterButtonClick!(self)
    }
    
    // 登陆
    func loginClick() {
        JSJLog(__FUNCTION__)
        delegate?.visitorViewDidLoginButtomClick!(self)
    }
    
    // MARK: - 懒加载
    
    // 转盘
    private lazy var icon: UIImageView = {
        let ic = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return ic
    }()
    
    // 图标
    private lazy var centerIcon: UIImageView = {
        let centerIc = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        return centerIc
    }()
    
    // 提示文本
    private lazy var noteInfo: UILabel = {
        let note = UILabel()
        note.text = "发生的观点是法国的风格的非官方个地方噶发给我么欧美为人工MRPOMS高"
        note.numberOfLines = 0;
        note.textColor = UIColor.grayColor()
        return note
    }()
    
    // 注册按钮
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        // 注册按钮点击监听
        btn.addTarget(self, action: Selector("registerClick"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
        }()
    // 登录按钮
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        // 注册按钮点击监听
        btn.addTarget(self, action: Selector("loginClick"), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
        }()
    
    // 背景图片
    private lazy var maskBgView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        return iv
        }()
}
