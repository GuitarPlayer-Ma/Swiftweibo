//
//  HomeTableViewController.swift
//  weibo
//
//  Created by mada on 15/9/27.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SDWebImage

private let JSJHomeTableViewCellIdentify = "JSJHomeTableViewCellIdentify"

class HomeTableViewController: BaseTableViewController {
    
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 存储所有微博数据
    private var statues: [Status]? {
        didSet {
            // 刷新微博列表
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setupVisitorInfo(true, centerIconImage: "visitordiscover_feed_image_house", noteText: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 注册cell 
        tableView.registerClass(HomeNormalCell.self, forCellReuseIdentifier: JSJCellReusableIdentifier.normalCell.rawValue)
        tableView.registerClass(HomeForwardCell.self, forCellReuseIdentifier: JSJCellReusableIdentifier.forwardCell.rawValue)
        
        // 初始化导航条
        setupNav()
        
        // 加载微博数据
        loadData()
        
//        tableView.estimatedRowHeight = 300
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    private func loadData() {
        let parameter = ["access_token": UserAccount.loadAccount()!.access_token!];
        NetworkingTools.shareNetworkTools().GET("2/statuses/home_timeline.json", parameters: parameter, success: { (_, JSON) -> Void in
            
            if let dictArray = JSON["statuses"] {
                // 有值
                var models = [Status]()
                for dict in dictArray as! [[String: AnyObject]] {
                    models.append(Status(dict: dict))
                }
                // 设置微博数据
//                self.statues = models
                
                // 缓存所有微博配图(优化)
                self.cacheImage(models)
            }
            
            }) { (_, error) -> Void in
                JSJLog(error)
        }
    }
    
    
    // MARK: - 缓存所有配图
    
    private func cacheImage(models: [Status]) {
        // 判断模型数组是否为空
        // 如果count是nil则等于0
        let count = models.count ?? 0
        guard count != 0 else { // 确保不为0
            return
        }
        
        // 创建一个组(用来确保所有图片的缓存完成,再进行其他操作)
        let group = dispatch_group_create()
        
        // 遍历模型数组
        for status in models {
            // 判断是否有配图
            if status.pictureURLs == nil || status.pictureURLs?.count == 0 {
                continue
            }
            
            for url in status.pictureURLs! {
                // 将当前下载图片的操作添加到组
                dispatch_group_enter(group)
                // 下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: [], progress: nil) { (_, _, _, _, _) -> Void in
                    JSJLog("图片已下载")
                    // 离开组
                    dispatch_group_leave(group)
                }
            }
            
        }
        // 监听到所有图片都下载完成(所有元素都退出了组)
        dispatch_group_notify(group, dispatch_get_main_queue(), { () -> Void in
            JSJLog("***所有图片下载完成***")
            self.statues = models
        })
    }

    
    // MARK: - 设置导航栏
    
    private func setupNav() {
        // 初始化标题按钮
        titleButton.setTitle("啦啦啦啦  ", forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        titleButton.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        titleButton.addTarget(self, action: Selector("titleButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.titleView = titleButton
        
        // 初始化两边的按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, actionName: "leftButtonClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, actionName: "rightButtonClick")
    }
    
    func titleButtonClick() {
        JSJLog(__FUNCTION__)
        
        let storyboard = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        
        /* 设置这两个属性之后,modal出控制器后,原控制器的view不会被移除*/
        // 告诉系统谁负责转场
        vc.transitioningDelegate = popoverAnimator
        // 转场样式
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func changeTitleButton() {
        titleButton.selected = !titleButton.selected
    }
    
    func leftButtonClick() {
        JSJLog(__FUNCTION__)
    }
    
    func rightButtonClick() {
        JSJLog(__FUNCTION__)
        let storyboard = UIStoryboard.init(name: "QRCodeViewController", bundle: nil)
        let vc = storyboard.instantiateInitialViewController()!
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - 数据源方法
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statues?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statues![indexPath.row]
        
        let identity = JSJCellReusableIdentifier.reusableIdentifier(status)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identity) as! HomeTableViewCell
        
        cell.status = status
        
        return cell
    }
    
    
    // MARK: - 代理方法
    // 缓存cell高的字典
    private var rowHeightCache = [Int: CGFloat]()
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let status = statues![indexPath.row]
        let identity = JSJCellReusableIdentifier.reusableIdentifier(status)
        // 取出cell
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! HomeTableViewCell
        // 从缓存池中取
        let cell = tableView.dequeueReusableCellWithIdentifier(identity) as! HomeTableViewCell
        
        // 判断缓存中是否有高度
        if let height = rowHeightCache[status.id] {
            return height
        }
        
        let height = cell.rowHeight(status)
        
        // 缓存高度
        rowHeightCache[status.id] = height
        
        return height
    }
    
    // 收到内存警告,手动释放
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        rowHeightCache.removeAll()
    }
    
    // MARK: - 懒加载
    
    private lazy var popoverAnimator: PopoverAnimationController = {
        let animator = PopoverAnimationController()
        
        // 设置popoverview的大小和位置
        animator.presentFrame = CGRect(x: 85, y: 56, width: 200, height: 300)
        
        // 注册监听通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeTitleButton"), name: JSJPopoverViewDidPrentedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeTitleButton"), name: JSJPopoverViewDidDismissedNotification, object: nil)
        
        return animator
    }()
    
    private lazy var titleButton: TitleButton = TitleButton()
}
