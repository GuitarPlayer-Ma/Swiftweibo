//
//  HomeForwardCell.swift
//  weibo
//
//  Created by mada on 15/10/12.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeForwardCell: HomeTableViewCell {
    
    override var status: Status? {
        didSet {
            let name = status?.retweeted_status?.user?.name
            let text = status?.retweeted_status?.text
            if name != nil && text != nil {
                retweetContentLabel.text = "@\(name!): " + text!
            }
        }
    }

    override func setupChildUI() {
        super.setupChildUI()
        
        // 添加自己的子控件
        contentView.insertSubview(coverView, belowSubview: pictureView)
        coverView.addSubview(retweetContentLabel)
        
        // 布局子控件
        // 整体内容
        coverView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(pictureView.snp_bottom).offset(10)
        }
        // 文字内容
        retweetContentLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(coverView.snp_top).offset(10)
            make.left.equalTo(contentLabel)
            make.right.equalTo(contentLabel)
        }
        // 配图布局
        pictureView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(retweetContentLabel.snp_bottom).offset(10)
            make.left.equalTo(retweetContentLabel)
        }
    }
    
    
    // MARK: - 懒加载
    
    // 转发背景
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    
    // 转发内容
    private lazy var retweetContentLabel: UILabel = {
        let content = UILabel()
        content.text = "somethingsomethingsomethingsomethingsomethingsomethingsomethingsomething"
        content.numberOfLines = 0
        return content
    }()
}
