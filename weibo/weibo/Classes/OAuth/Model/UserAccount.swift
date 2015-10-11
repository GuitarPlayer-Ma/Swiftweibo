//
//  UserAccount.swift
//  weibo
//
//  Created by mada on 15/10/1.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
    var expires_date: NSDate?
    
    var access_token: String?
    var expires_in: NSNumber?  {
        didSet {
            // 根据过期秒数计算真正过期时间
            expires_date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
        }
    }
    var uid: String?
    
    // 用户头像
    var avatar_large: String?
    // 用户昵称
    var screen_name: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    static let keys = ["access_token", "expires_in", "uid", "avatar_large", "screen_name"]
    override var description: String {
        return "\(dictionaryWithValuesForKeys(UserAccount.keys))"
    }
    
    // MARK: 外部控制方法
    private static let path = "account.plist".cacheDir()
    static var account: UserAccount?
    
    // 加载用户信息
    func loadUserInfo (finished: (account: UserAccount?, error: NSError?) ->()) {
        // 自定义url
        let url = "2/users/show.json"
        // 定义参数
        let parameters = ["access_token" : access_token!, "uid": uid!]
        NetworkingTools.shareNetworkTools().GET(url, parameters: parameters, success: { (_, dict) -> Void in
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            
            // 保存授权模型
            finished(account: self, error: nil)
            
            }, failure: { (_, error) -> Void in
                finished(account: nil, error: error)
        })
    }
    
    /** 保存数据*/
    func saveAccount() {
        JSJLog(UserAccount.path)
        NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.path)
    }
    /** 读取数据*/
    class func loadAccount() -> UserAccount? {
        if account == nil {
            account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.path) as? UserAccount
        }
        
        if account != nil {
            // 查看是否过期(过期时间 < 当前时间 -- 升序)
            if account?.expires_date?.compare(NSDate()) == NSComparisonResult.OrderedAscending {
                account = nil
            }
        }
        return account
    }
    
    // MARK: - NSCoding
    // 写入文件(序列化)
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_date, forKey: "expires_date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    // 从文件中读取(反序列化)
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_date = aDecoder.decodeObjectForKey("expires_date") as? NSDate
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
}
