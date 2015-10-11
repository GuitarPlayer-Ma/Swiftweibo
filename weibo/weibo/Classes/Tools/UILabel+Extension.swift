//
//  UILabel+Extension.swift
//  weibo
//
//  Created by mada on 15/10/10.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(color: UIColor, size: CGFloat) {
        self.init()
        textColor = color
        font = UIFont.systemFontOfSize(size)
    }
}
