//
//  OAuthViewController.swift
//  weibo
//
//  Created by mada on 15/9/30.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SVProgressHUD



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
    // 开始加载时调用
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("加载中..", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
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
            loadAccessToken(code!)
            close()
        }else {
            JSJLog("取消授权")
            close()
        }
        return false
    }
    
    func loadAccessToken(code: String) {
        let path = "oauth2/access_token"
        let parameters = ["client_id" : WB_APP_Key, "client_secret" : WB_App_Secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : WB_Redirect_URI]
        NetworkingTools.shareNetworkTools().POST(path, parameters: parameters, success: { (_, dict) -> Void in
            JSJLog(dict)
            // 将字典转换为模型
            let account = UserAccount(dict: dict as! [String : AnyObject])
            
            // 加载用户信息
            account.loadUserInfo { (account, error) -> () in
                if account != nil {
                    // 保存用户信息
                    JSJLog(account)
                    account?.saveAccount()
                    return
                }
                SVProgressHUD.showErrorWithStatus("获取授权信息失败")
            }
            
            }) { (_, error) -> Void in
                JSJLog(error)
                SVProgressHUD.showErrorWithStatus("获取授权信息失败", maskType: SVProgressHUDMaskType.Black)
        }
    }
}
