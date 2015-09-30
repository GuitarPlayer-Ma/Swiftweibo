//
//  OAuthViewController.swift
//  weibo
//
//  Created by mada on 15/9/30.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit


class OAuthViewController: UIViewController {
    
    let WB_APP_Key: String = "4155480345"
    let WB_App_Secret:String = "d24f97bdb3bbb62a40c46e9cc6ba5ea1"
    let WB_Redirect_URI = "https://www.baidu.com/"

    override func loadView() {
        webView.delegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初始导航条
        navigationItem.title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Done, target: self, action: Selector("close"))
        // 加载登录界面
        let str = "https://api.weibo.com/oauth2/authorize?client_id=" + WB_APP_Key + "&redirect_uri=" + WB_Redirect_URI
        
        let url = NSURL(string: str)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    private lazy var webView = UIWebView()
}


extension OAuthViewController : UIWebViewDelegate {
    // 每次webView发送请求就会调用,如果返回true代表可以访问, 返回false代表不能访问
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 判断是否跳转到微博对应的页面
        let urlStr = request.URL!.absoluteString
        if !urlStr.hasPrefix(WB_Redirect_URI) {
            return true
        }
        // 是否是授权界面
        let codeStr = "code="
        if !urlStr.containsString("error") {
            JSJLog("已经授权")
            JSJLog(request.URL!)
            let code = request.URL?.query?.substringFromIndex(codeStr.endIndex)
            JSJLog(code)
        }else {
            JSJLog("取消授权")
            close()
        }
        return false
    }
}
