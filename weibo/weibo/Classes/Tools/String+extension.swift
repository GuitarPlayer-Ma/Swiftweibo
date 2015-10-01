//
//  String+extension.swift
//  weibo
//
//  Created by mada on 15/10/1.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

extension String
{
    func cacheDir() -> String
    {
        let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!) as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func docDir() -> String
    {
        let path = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!) as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func tmpDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.stringByAppendingPathComponent((self as NSString).lastPathComponent)
    }
}