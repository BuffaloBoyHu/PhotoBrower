//
//  PBPageViewController.swift
//  PhotoBrower
//
//  Created by HLH on 2017/1/22.
//  Copyright © 2017年 胡良海. All rights reserved.
//

import UIKit

fileprivate let animationDuration = 0.2

enum PBStyle : NSInteger {
    case defaultStyle // 默认都显示
    case NoTextStyle // 没有简介
    case OnlyPhotoStyle // 只显示图片
}

class PBPageViewController: UIPageViewController,UIPageViewControllerDataSource {
    
    var sourceData : NSArray? = nil
    var currentIndex : NSInteger = 0
    var isStatusBarHidden :Bool = true
    fileprivate var childArray : NSMutableArray? = []
    
    init(sourceData :NSArray?,currentPhotoUrl:String) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey : 20])
        self.sourceData = sourceData
        self.currentIndex = (self.sourceData?.index(of: currentPhotoUrl))!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.shared.setStatusBarHidden(true, with: .none)
//        UINavigationBar.appearance().isHidden = true
        self.dataSource = self
        self.view.backgroundColor = .black
        self.isStatusBarHidden = true
        self.addChildViewControllers()
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureAction))
        self.view.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: private function
    fileprivate func hide() {
        UIView.animate(withDuration: animationDuration) {
            self.view.alpha = 0
        }
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    fileprivate func addChildViewControllers() {
       self.sourceData?.enumerateObjects({[unowned self] (object, index, _) in
            let childController = PBChiledViewController.init(data: object)
            self.childArray?.add(childController)
       })
        
        let currentController = self.childArray?.object(at: self.currentIndex)
        self.setViewControllers([currentController as! PBChiledViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc fileprivate func tapGestureAction() {
        self.hide()
    }
    
    
    
    //MARK: public function
    public func showInViewController(viewController :UIViewController, style:PBStyle) {
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
