//
//  HomeRefreshController.swift
//  weibo
//
//  Created by mada on 15/10/13.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class RefreshControllerTipView: UIView {
    
    @IBOutlet weak var arrowView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var loadProgressView: UIImageView!
    
    typealias sendCallback = () -> Void
    
    var back: sendCallback?
    
    /**
    结束刷新(供外界调用)
    */
    func removeRefresh() {
        let sv = superview as! UIScrollView
        sv.contentInset.top = 64
        frontView.hidden = false
        // 添加监听
        addNeedObserver()
    }
    
    class func refreshTipView(callback: sendCallback?) -> RefreshControllerTipView {
        let refreshTipView = NSBundle.mainBundle().loadNibNamed("RefreshControllerTipView", owner: nil, options: nil).last as! RefreshControllerTipView
        
        refreshTipView.excuteCallBack(callback)
        
        return refreshTipView
    }
    
    private func excuteCallBack(callback: sendCallback?) {
        back = callback
    }
    
    // 添加到父控件后调用
    override func didMoveToSuperview() {
        
        // 修改frame
        resetFrame()
        
        // 添加监听
        addNeedObserver()
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "contentOffset" {
            changeStatus()
        }
        else {
            handleEndScroll()
        }
        
    }
    
    private func changeStatus() {
        // 父控件的contentOffset
        let sv = superview as! UIScrollView
        let refreshY = sv.contentOffset.y
        
        // 计算可以刷新的Y值
        let canRefreshY: CGFloat = -140
        if refreshY < canRefreshY {
            // 更改图片的方向
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            })
            // 更新文字显示
            tipLabel.text = "释放更新"
            
        }
        else {
            // 图片的方向(清空形变)
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.arrowView.transform = CGAffineTransformIdentity
            })
            // 更新文字显示
            tipLabel.text = "下拉刷新"
            
        }
    }
    
    private func handleEndScroll() {
        let sv = superview as! UIScrollView
        if sv.panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            // 可以刷新
            if sv.contentOffset.y < -140 {
                // 隐藏前面的view
                frontView.hidden = true
                sv.contentInset.top = bounds.height + 64
                // 开始动画
                startLoadAnimation()
                // 移除监听
                removeAllObeserver()
                // 执行闭包
                if (back != nil) {
                    
                    back!()
                }
            }
        }
    }
    
    private func startLoadAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 2.0
        anim.repeatCount = MAXFLOAT
        // 动画完成时不要移除动画
        anim.removedOnCompletion = false
        loadProgressView.layer.addAnimation(anim, forKey: nil)
    }
    
    deinit {
        let sv = self.superview as! UIScrollView
        sv.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    private func resetFrame() {
        frame.size.width = (self.superview?.frame.size.width)!
        
        frame.origin.y = -frame.size.height - 20
    }
    
    // 添加监听
    private func addNeedObserver() {
        let sv = superview as! UIScrollView
        // 监听contentOffset
        sv.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
        // 监听panGestureRecognizer的状态
        sv.addObserver(self, forKeyPath: "panGestureRecognizer.state", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    // 移除所有监听
    private func removeAllObeserver() {
        let sv = superview as! UIScrollView
        sv.removeObserver(self, forKeyPath: "contentOffset")
        sv.removeObserver(self, forKeyPath: "panGestureRecognizer.state")
    }
}
