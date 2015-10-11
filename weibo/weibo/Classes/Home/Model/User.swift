//
//  User.swift
//  weibo
//
//  Created by mada on 15/10/9.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class User: NSObject {
    // 用户id
    var id: Int = 0
    
    // 名称
    var name: String?
    
    // 头像地址
    var profile_image_url: String? {
        didSet {
            if let urlStr = profile_image_url {
                profile_URL = NSURL(string: urlStr)
            }
        }
    }
    
    // 头像的url
    var profile_URL: NSURL? 
    
    // 是否认证
    var verified: Bool = false
    
    // 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = -1 {
        didSet {
            switch verified_type {
            case 0: // 个人认证
                verified_image = UIImage(named: "avatar_vip")
            case 2:
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 3:
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 5:
                verified_image = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verified_image = UIImage(named: "avatar_grassroot")
            default:
                verified_image = UIImage(named: "")
            }
        }
    }
    
    var verified_image: UIImage?
    
    // 会员等级
    var mbrank: Int = -1 {
        didSet {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
    }
    // 会员等级图标
    var vipImage: UIImage?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    // 属性字典
    static let properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    // 打印对象
    override var description: String{
        return "\(self.dictionaryWithValuesForKeys(User.properties))"
    }
    
}
