//
//  QRCodeViewController.swift
//  weibo
//
//  Created by mada on 15/9/28.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var customTabBar: UITabBar!
    
    @IBOutlet weak var scanlineTopCons: NSLayoutConstraint!
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var scanlineView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startAnimation()
        // 超出边框的裁剪掉
        containerView.clipsToBounds = true
        setupQRScan()
    }
    
    // MARK: - 开启二维码扫描
    private func setupQRScan() {
        // 1.判断是否可以输入设备
        if !session.canAddInput(inputDevice) {
            return
        }
        // 2.判断是否可以输出设备
        if !session.canAddOutput(output) {
            return
        }
        // 3.添加输入输出设备到会话中
        session.addInput(inputDevice)
        session.addOutput(output)
        // 4.设置输出解析数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        // 5.添加输出代理,监听解析得到结果
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        // 7.利用会话开始扫描
        session.startRunning()
    }
    
    // MARK: - 二维码扫描动画
    private func startAnimation() {
        scanlineTopCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(1.5) { () -> Void in
            // 执行无数次
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanlineTopCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 二维码扫描界面相关点击事件的监听
    @IBAction func closeQRView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // tabBar的代理方法
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        containerHeightCons.constant = (item.tag == 1) ? 125 : 200
        
        // 停止动画
        scanlineView.layer.removeAllAnimations()
        // 再开始动画
        startAnimation()
    }
    
    // MARK: - 懒加载
    private lazy var inputDevice: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch {
            return nil
        }
    }()

    private lazy var output: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        return output
    }()

    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = "AVCaptureSessionPreset1920x1080"
        return session
    }()
    // 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preLayer = AVCaptureVideoPreviewLayer(session: self.session)
        preLayer.frame = UIScreen.mainScreen().bounds
        return preLayer
    }()
    // 创建一个二维码描边图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
}


extension QRCodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        JSJLog(metadataObjects.last?.intValue)
        
        for obj in metadataObjects {
            // 将扫描到的二维码坐标转换为我们能够识别的坐标
            let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(obj as! AVMetadataObject)
            // 根据转换好的坐标给二维码描边
            drawConner(codeObject as! AVMetadataMachineReadableCodeObject)
        }
        
    }
    
    private func drawConner(codeObject: AVMetadataMachineReadableCodeObject) {
        
        // 移除以前的描边
        clearCorner()
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = UIColor.blueColor().CGColor
        layer.lineWidth = 2.0
        /* 绘图路径*/
        let path = UIBezierPath()
        var point = CGPointZero
        var index = 0
        let dictArray = codeObject.corners
        // 取出第0个,将字典中的x,y转换成CGPoint
        CGPointMakeWithDictionaryRepresentation((dictArray[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        while index < dictArray.count {
            CGPointMakeWithDictionaryRepresentation((dictArray[index++] as! CFDictionaryRef), &point)
            path.addLineToPoint(point)
        }
        // 关闭路径
        path.closePath()
        
        layer.path = path.CGPath
        drawLayer.addSublayer(layer)
    }
    
    private func clearCorner() {
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0 {
            return
        }
        
        for subLayer in drawLayer.sublayers! {
            subLayer.removeFromSuperlayer()
        }
    }
}
