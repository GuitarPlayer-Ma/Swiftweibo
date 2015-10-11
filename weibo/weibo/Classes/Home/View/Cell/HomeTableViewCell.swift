//
//  HomeTableViewCell.swift
//  weibo
//
//  Created by mada on 15/10/10.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    
    var status: Status? {
        didSet{
            // 设置顶部视图数据
            topView.status = status
            
            // 设置正文
            contentLabel.text = status?.text
            
            // 配置配图
            pictureView.status = status
            
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 设置子控件
        setupChildUI()
    }

    private func setupChildUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footBarView)
        
        /* 布局子控件 */
        
        // 布局头部控件
        topView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentView)
            make.top.equalTo(contentView)
            make.right.equalTo(contentView)
        }
        
        // 布局微博内容
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(topView)
            make.top.equalTo(topView.snp_bottom).offset(15)
            make.width.equalTo(UIScreen.mainScreen().bounds.width - 20)
        }
        
        // 布局配图
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
        }
        
        // 布局底部条
        footBarView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(pictureView.snp_bottom).offset(10)
            make.bottom.equalTo(contentView.snp_bottom).offset(-10)
            make.height.equalTo(44)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
    }
    
    
    // MARK: - 懒加载

    // 头部
    private lazy var topView: HomeStatusTopView = HomeStatusTopView()
    
    // 正文
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.text = "银河系漫游权威指南"
        label.numberOfLines = 0
        return label
    }()
    
    // 配图
    private lazy var pictureView: HomeStatusPictureView = HomeStatusPictureView()
    
    // 底部条
    private lazy var footBarView: HomeStatusFooterView = {
        let footBar = HomeStatusFooterView()
        footBar.backgroundColor = UIColor.lightGrayColor()
        return footBar
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


