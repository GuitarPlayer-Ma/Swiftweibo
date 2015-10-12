//
//  HomeNormalCell.swift
//  weibo
//
//  Created by mada on 15/10/12.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class HomeNormalCell: HomeTableViewCell {

    override func setupChildUI() {
        super.setupChildUI()
        
        // 布局配图
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentLabel)
            make.top.equalTo(contentLabel.snp_bottom).offset(10)
        }
    }

}
