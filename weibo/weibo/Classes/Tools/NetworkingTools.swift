//
//  NetworkingTools.swift
//  weibo
//
//  Created by mada on 15/9/30.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkingTools: AFHTTPSessionManager {
    
    private static let tools: NetworkingTools = {
        let url = NSURL(string: "https://api.weibo.com/")!
        let manager = NetworkingTools(baseURL: url)
        // 设置可以接收的数据类型
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain")  as Set<NSObject>
        return manager
    }()
    
    class func shareNetworkTools() -> NetworkingTools {
        return tools
    }
}
