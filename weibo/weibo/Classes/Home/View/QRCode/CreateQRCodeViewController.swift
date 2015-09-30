//
//  CreateQRCodeViewController.swift
//  weibo
//
//  Created by mada on 15/9/30.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

class CreateQRCodeViewController: UIViewController {

    @IBOutlet weak var customImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        /* 生成二维码 */
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        // 2.还原滤镜默认设置
        filter.setDefaults()
        // 3.设置数据
        filter.setValue("加斯加的猿".dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        // 4.从滤镜中取出二维码
        let ciImage = filter.outputImage!
        let QRImage = createNonInterpolatedUIImageFormCIImage(ciImage, size: 500)
        let iconImage = UIImage(named: "nange.jpg")!
        // 5.合成二维码图片
        let newImage = createImage(QRImage, iconImage: iconImage)
        // 6.设置图片到界面上
        customImageView.image = newImage
    }
    
    private func createImage(backgroundImage: UIImage, iconImage: UIImage) -> UIImage {
        // 开启图形上下文
        UIGraphicsBeginImageContext(backgroundImage.size)
        // 绘制图片
        backgroundImage.drawInRect(CGRect(origin: CGPointZero, size: backgroundImage.size))
        // 绘制图标
        let width: CGFloat = 100.0
        let height: CGFloat = 100.0
        let x = (backgroundImage.size.width - width) * 0.5
        let y = (backgroundImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        // 取出图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    /**
    根据CIImage生成指定大小的高清UIImage
    
    :param: image 指定CIImage
    :param: size    指定大小
    :returns: 生成好的图片
    */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap;
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
}
