//
//  HomeStatusFooterView.swift
//  weibo
//
//  Created by mada on 15/10/12.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeStatusFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 添加子控件
        addSubview(retweetView)
        addSubview(commentView)
        addSubview(unlikeView)
        addSubview(lineView1)
        addSubview(lineView2)
        
        // 布局子控件
        retweetView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self)
        }
        commentView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(retweetView.snp_right)
            make.top.equalTo(self)
            make.height.equalTo(retweetView)
            make.width.equalTo(retweetView)
        }
        unlikeView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(commentView.snp_right)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(retweetView)
            make.width.equalTo(retweetView)
        }
        lineView1.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44 * 0.6)
            make.width.equalTo(0.5)
            make.centerX.equalTo(retweetView.snp_right)
            make.centerY.equalTo(self)
        }
        lineView2.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(44 * 0.6)
            make.width.equalTo(0.5)
            make.centerX.equalTo(commentView.snp_right)
            make.centerY.equalTo(self)
        }
    }
    
    
    // MARK: - 懒加载
    
    // 转发
    private lazy var retweetView: UIButton = {
        let btn = UIButton(title: "转发", imageName: "timeline_icon_retweet")
        return btn
        }()
    
    // 评论
    private lazy var commentView: UIButton = {
        let btn = UIButton(title: "评论", imageName: "timeline_icon_comment")
        return btn
        }()
    
    // 赞
    private lazy var unlikeView: UIButton = {
        let btn = UIButton(title: "赞", imageName: "timeline_icon_unlike")
        return btn
        }()
    
    // 分割线
    private lazy var lineView1: UIView = self.createLineView()
    private lazy var lineView2: UIView = self.createLineView()
    private func createLineView() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor.darkGrayColor()
        return line
    }


}
