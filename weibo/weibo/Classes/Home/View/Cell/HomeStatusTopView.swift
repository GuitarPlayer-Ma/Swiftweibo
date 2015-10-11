//
//  HomeStatusTopView.swift
//  weibo
//
//  Created by mada on 15/10/12.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeStatusTopView: UIView {

    var status: Status? {
        didSet {
            // 头像
            iconView.sd_setImageWithURL(status?.user?.profile_URL)
            // 设置昵称
            nameLabel.text = status?.user?.name
            // 认证图标
            verifiedView.image = status?.user?.verified_image
            // 会员图标
            if let image = status?.user?.vipImage {
                vipView.image = image
                nameLabel.textColor = UIColor.orangeColor()
            }
            else {
                vipView.image = nil
                nameLabel.textColor = UIColor.blackColor()
            }
            // 微博来源
            sourceLabel.text = status?.source
            // 设置时间
            timeLabel.text = status?.created_at;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupUI() {
        
        addSubview(iconView)
        iconView.addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 布局头像
        iconView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        // 布局认证
        verifiedView.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(iconView).offset(8)
            make.bottom.equalTo(iconView).offset(8)
        }
        // 布局昵称
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(iconView).offset(5)
            make.left.equalTo(iconView.snp_right).offset(10)
        }
        // 布局会员图标
        vipView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp_right).offset(10)
            make.size.equalTo(CGSize(width: 17, height: 17))
        }
        // 布局发布时间
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel.snp_left)
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
        }
        // 布局微博来源
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(timeLabel.snp_right).offset(5)
            make.top.equalTo(timeLabel)
        }
    }
    
    // MARK: - 懒加载
    
    // 头像
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
    // 认证图片
    private lazy var verifiedView: UIImageView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    // 昵称
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "加斯加的猿"
        return nameLabel
        }()
    // 会员图标
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership_expired"))
    // 时间
    private lazy var timeLabel: UILabel = {
        let label = UILabel(color: UIColor.orangeColor(), size: 13)
        label.text = "刚刚"
        return label
        }()
    // 来源
    private lazy var sourceLabel: UILabel = {
        let label = UILabel(color: UIColor.lightGrayColor(), size: 13)
        label.text = "来自:宇宙计算机"
        return label
        }()
}
