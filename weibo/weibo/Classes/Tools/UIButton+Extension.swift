//
//  UIButton+Extension.swift
//  weibo
//
//  Created by mada on 15/10/12.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, imageName: String) {
        self.init()
        self.setTitle(title, forState: UIControlState.Normal)
        self.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), forState: UIControlState.Normal)
        setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(15)
        titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        adjustsImageWhenHighlighted = false
    }
}
