//
//  PBPageViewController.swift
//  PhotoBrower
//
//  Created by HLH on 2017/1/22.
//  Copyright © 2017年 胡良海. All rights reserved.
//

import UIKit

let animationDuration = 0.3

@objc enum PBStyle : NSInteger {
    case defaultStyle // 默认都显示
    case NoAbstractStyle // 没有简介
    case OnlyPhotoStyle // 只显示图片
}

@objc(PBPageViewController)

class PBPageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    fileprivate var sourceData : NSArray? = nil
    fileprivate var currentIndex : NSInteger = 0
    fileprivate var showStyle : PBStyle? = .OnlyPhotoStyle
    fileprivate var childArray : NSMutableArray? = [] // 子视图数组
    fileprivate var isNeedUpadteAbstract :Bool = true // 是否更新简介位置
    fileprivate var hideStatusBar : Bool = false
    var sharePhotoAction :((Void) ->Void)? // 图片分享
    var shareBtn = UIButton.init(type: UIButtonType.roundedRect) // 分享
    var saveBtn = UIButton.init(type: UIButtonType.roundedRect) // 保存
    var progressLabel = UILabel.init() // 进度
    var abstractView = UITextView.init() // 简介
    var reLayoutSubView :(() -> Void)? //重新布局保存和分享按钮等位置
    override var prefersStatusBarHidden: Bool{return self.hideStatusBar}
    
    init(sourceData :NSArray?,currentPhotoUrl:String,showStyle :PBStyle) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 20])
        self.sourceData = sourceData
        self.currentIndex = (self.sourceData?.index(of: currentPhotoUrl))!
        self.showStyle = showStyle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.view.backgroundColor = .black
        self.addChildViewControllers()
        self.initSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.showStyle != .OnlyPhotoStyle {
            let viewSize = self.view.bounds.size
            var frame = self.progressLabel.frame
            frame.origin.x = (viewSize.width - frame.width) / 2
            frame.origin.y = 100
            self.progressLabel.frame = frame
            
            frame = self.shareBtn.frame
            frame.origin.x = 20
            frame.origin.y = viewSize.height - 20 - 20
            frame.size = CGSize.init(width: 50, height: 30)
            self.shareBtn.frame = frame
            
            frame = self.saveBtn.frame
            frame.origin.x = viewSize.width - 20 - 50
            frame.origin.y = viewSize.height - 20 - 20
            frame.size = CGSize.init(width: 50, height: 30)
            self.saveBtn.frame = frame
            
            frame = self.abstractView.frame
            frame.origin.x = 10
            if !self.isNeedUpadteAbstract {
               frame.origin.y = self.saveBtn.frame.origin.y - 10 - 50   
            }
            frame.size = CGSize.init(width: viewSize.width - 20, height: viewSize.height - frame.origin.y)
            self.abstractView.frame = frame
        }
        self.reLayoutSubView?()
    }
    
    //MARK: private function
    fileprivate func initSubviews() {
        self.progressLabel.backgroundColor = .clear
        self.progressLabel.textColor = .white
        self.progressLabel.text = "\(self.currentIndex + 1)/\((self.childArray?.count)!)"
        self.progressLabel.sizeToFit()
        
        self.shareBtn.backgroundColor = UIColor.lightGray
        self.shareBtn.alpha = 0.8
        self.shareBtn.setTitle("分享", for: .normal)
        self.shareBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        self.shareBtn.setTitleColor(.green, for: .normal)
        
        self.saveBtn.backgroundColor = UIColor.lightGray
        self.saveBtn.alpha = 0.8
        self.saveBtn.setTitle("保存", for: .normal)
        self.saveBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        self.saveBtn.setTitleColor(.green, for: .normal)
        
        self.abstractView.backgroundColor = .clear
        self.abstractView.textColor = .white
        self.abstractView.text = "test texttest\n texttest texttest\n texttest texttest\n texttest texttest\n texttest texttest\n texttest texttest texttest texttest\n texttest texttest texttest\n texttest texttest]\n texttest texttest texttest texttest\n texttest texttest text"
        self.abstractView.textAlignment = .left
        self.abstractView.isEditable = false
        self.abstractView.isSelectable = false
        
        switch self.showStyle! {
        case .defaultStyle:
            self.view.addSubview(self.abstractView)
            fallthrough
        case .NoAbstractStyle:
            self.view.addSubview(self.progressLabel)
            self.view.addSubview(self.shareBtn)
            self.view.addSubview(self.saveBtn)
        default:
            break
        }
    }
    
    fileprivate func hide() {
        UIView.animate(withDuration: animationDuration) {
            self.view.alpha = 0
        }
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        self.hideStatusBar = false
        
    }
    
    /// 隐藏进度条和保存和分享等控件
    ///
    /// - Parameter isHidden:
    fileprivate func hideOtherComponent(isHidden :Bool) {
        self.progressLabel.isHidden = isHidden
        self.shareBtn.isHidden = isHidden
        self.saveBtn.isHidden = isHidden
        self.abstractView.isHidden = isHidden
    }
    
    fileprivate func addChildViewControllers() {
       self.sourceData?.enumerateObjects({[unowned self] (object, index, _) in
            let childController = PBChiledViewController.init(data: object)
        childController.hideOtherComponent = {[unowned self] (isHidden) in
            self.hideOtherComponent(isHidden: isHidden)
        }
        childController.updateAbstractViewFrame = {[unowned self] (imageFrame) in
            self.isNeedUpadteAbstract = true
            var frame = self.abstractView.frame
            frame.origin.y = imageFrame.origin.y + imageFrame.size.height + 5
            self.abstractView.frame = frame
        }
        childController.dismissBlock = {[unowned self] in
            self.hide()
        }
            childController.tag = index + 1
            childController.progressBlock = {[unowned self] (index) in
            self.progressLabel.text = "\(index)/\((self.childArray?.count)!)"
        }
            self.childArray?.add(childController)
       })
        
        let currentController = self.childArray?.object(at: self.currentIndex)
        self.setViewControllers([currentController as! PBChiledViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc fileprivate func btnAction(sender :UIButton) {
        let titleStr = sender.title(for: .normal)
        if titleStr == "保存" {
            if let childController  = self.childArray?[self.currentIndex] as? PBChiledViewController {
                UIImageWriteToSavedPhotosAlbum(childController.imageView.image!, self, #selector(didFinishSavingPhoto(image:error:info:)), nil)
            }
        }
        
    }
    
    //MARK: private function
    @objc fileprivate func didFinishSavingPhoto(image:UIImage,error:NSError?,info : Any) {
        if error  == nil {
            let alertView : UIAlertController = UIAlertController.init(title: "保存成功", message: nil, preferredStyle: .alert)
            alertView.addAction(.init(title: "确定", style: .destructive, handler: nil))
            self.present(alertView, animated: true, completion: nil)
            
        }else {
            let alertView : UIAlertController = UIAlertController.init(title: "保存失败", message: nil, preferredStyle: .alert)
            alertView.addAction(.init(title: "确定", style: .destructive, handler: nil))
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    //MARK: public function
    public func showInViewController(viewController :UIViewController) {
        self.hideStatusBar = true
        viewController.addChildViewController(self)
        viewController.view.addSubview(self.view)
        UIView.animate(withDuration: animationDuration) {
            self.view.alpha = 1
        }
        
    }
    
    //MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.childArray?.index(of: viewController)
        let count = (self.childArray?.count)! - 1
        if index! >= count || index! == NSNotFound {
            return nil
        }
        index = index! + 1
        return self.childArray?.object(at: index!) as! PBChiledViewController?
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.childArray?.index(of: viewController)
        if index! <= 0 || index! == NSNotFound {
            return nil
        }
        index = index! - 1
        return self.childArray?.object(at: index!) as! PBChiledViewController?
    }
    
    
}
