//
//  NewfeatureController.swift
//  weibo
//
//  Created by mada on 15/10/1.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit
import SnapKit

private let reuseIdentifier = "Cell"

class NewfeatureController: UICollectionViewController {
    
    private var layout = NewfeatureLayout()
    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerClass(NewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewfeatureCell
    
        // Configure the cell
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 传入的indexPath是上一页的索引
//        JSJLog(indexPath.item)
        
        // 这里才是真正的页码
        let path = collectionView.indexPathsForVisibleItems().last!
        JSJLog(path)
        // 判断是不是最后一页
        if path.item == 3 {
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewfeatureCell
            cell.showButtonAnimation()
        }
    }
}

class NewfeatureCell: UICollectionViewCell {
    
    var imageIndex: Int = 0 {
        didSet {
            iconImageView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            // 先隐藏所有按钮
            button.hidden = true
        }
    }
    
    func showButtonAnimation() {
        // 显示按钮
        button.hidden = false
//        button.alpha = 0.0
        button.transform = CGAffineTransformMakeScale(0.0, 0.0)
        button.userInteractionEnabled = false
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
//            self.button.alpha = 1.0
            self.button.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                self.button.userInteractionEnabled = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 初始化UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 懒加载子控件
    private func setupUI() {
        // 添加子控件
        contentView.addSubview(iconImageView)
        contentView.addSubview(button)
        
        // 布局子控件
        iconImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        button.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView.snp_bottom).offset(-160)
        }
        
    }
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: Selector("startButtonClick"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    func startButtonClick() {
        JSJLog("...")
    }
    
    private lazy var iconImageView: UIImageView = UIImageView()
}

class NewfeatureLayout: UICollectionViewFlowLayout {
    
    // 专门用来准备布局,会在调用返回cell之前调用
    override func prepareLayout() {
        // 设置布局
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置collectionView
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}