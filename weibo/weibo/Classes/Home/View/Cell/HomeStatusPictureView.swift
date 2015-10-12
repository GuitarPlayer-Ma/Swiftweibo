//
//  HomeStatusPictureView.swift
//  weibo
//
//  Created by mada on 15/10/12.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SDWebImage

let JSJPictureCollectionViewCellID = "JSJPictureCollectionViewCell"

class HomeStatusPictureView: UICollectionView, UICollectionViewDataSource {

    var status: Status? {
        didSet {
            reloadData()
            snp_updateConstraints { (make) -> Void in
                make.size.equalTo(calculateItemSize())
            }
        }
    }
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        backgroundColor = UIColor.darkGrayColor()
        dataSource = self
        registerClass(PictureCollectionViewCell.self, forCellWithReuseIdentifier: JSJPictureCollectionViewCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(JSJPictureCollectionViewCellID, forIndexPath: indexPath) as! PictureCollectionViewCell
        
        cell.imageURL = status?.pictureURLs?[indexPath.item]
        
        return cell
    }
    
    /**
    配置图片尺寸
    */
    private func calculateItemSize() -> CGSize {
        
        /* 判断是否有配图*/
        if status?.pictureURLs == nil {
            return CGSizeZero
        }
        
        let count = status?.pictureURLs?.count ?? 0
        
        // 没有配图
        if count == 0 {
            return CGSizeZero
        }
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        
        // 有一张配图
        if count == 1 {
            let key = status!.pictureURLs?.first!.absoluteString
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            // 设置layout的属性
            layout.itemSize = image.size
            return image.size
        }
        
        // 4张配图
        let imageWidth = 90
        let imageHeight = imageWidth
        let imageMargin = 10
        layout.itemSize = CGSize(width: imageWidth, height: imageHeight)
        
        if count == 4 {
            // 宽度
            let width = imageWidth * 2 + imageMargin
            let height = width
            return CGSize(width: width, height: height)
        }
        // 多张配图
        let col = 3
        let row = (count - 1) / 3 + 1
        // 宽度
        let width = imageWidth * col + (col - 1) * imageMargin
        let height = imageHeight * row + (row - 1) * imageMargin
        return CGSize(width: width, height: height)
    }

}

class PictureCollectionViewCell: UICollectionViewCell {
    
    var imageURL: NSURL? {
        didSet {
            imageView.sd_setImageWithURL(imageURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
        }()
}
