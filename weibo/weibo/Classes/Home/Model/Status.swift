//
//  Status.swift
//  weibo
//
//  Created by mada on 15/10/9.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class Status: NSObject {
    
    // 微博创建时间
    var created_at: String? {
        didSet {
            let date = NSDate.dateWithStr(created_at!)
            created_at = date?.dateDescription
        }
    }
    
    // 微博id
    var id: Int = 0
    
    // 微博来源
    var source: String? {
        didSet {
            if let str = source {
                if str == "" {
                    return
                }
                // 拿到起始位置
                let startIndex = (str as NSString).rangeOfString(">").location + 1
                // 获取截取的长度
                let strLength = (str as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
                // 截取字符串
                source = "来自 " + (str as NSString).substringWithRange(NSMakeRange(startIndex, strLength))
            }
        }
    }
    
    // 微博内容
    var text: String?
    
    // 配图数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 进行安全检查
            let count = pic_urls?.count ?? 0
            if count == 0 {
                return
            }
            // 生成URL数组
            thumbnail_pics = [NSURL]()
            for dict in pic_urls! {
                let str = dict["thumbnail_pic"] as! String
                let url = NSURL(string: str)!
                thumbnail_pics?.append(url)
            }
        }
    }
    
    // 配图的URL数组
    var thumbnail_pics: [NSURL]?
    
    var pictureURLs: [NSURL]? {
        
        return retweeted_status != nil ? retweeted_status?.thumbnail_pics : thumbnail_pics
    }
    
    // 用户模型
    var user: User?
    
    // 转发微博
    var retweeted_status: Status?
    
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // setValuesForKeysWithDictionary方法内部会调用setValue方法
    override func setValue(value: AnyObject?, forKey key: String) {
        // 判断是不是user
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        
        // 如果是retweet_status,自己处理
        if key == "retweeted_status" {
            retweeted_status = Status(dict: value as! [String: AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    // 必须重写这个方法,告诉系统不转化的key要怎么做
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
    
    // 属性字典
    static let properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    // 打印对象
    override var description: String{
        return "\(self.dictionaryWithValuesForKeys(User.properties))"
    }
}
