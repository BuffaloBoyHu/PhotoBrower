//
//  ViewController.swift
//  PhotoBrower
//
//  Created by HLH on 2017/1/22.
//  Copyright © 2017年 胡良海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton.init(type: .roundedRect)
        btn.backgroundColor = .brown
        btn.frame = CGRect.init(origin: CGPoint.init(x: 100, y: 100), size: CGSize.init(width: 100, height: 100))
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func btnAction() {
        let array = ["http://odvxpvqb8.qnssl.com/%E7%86%8A%E7%8C%AB%E9%95%87/%E6%89%AF%E7%9D%80%E6%B7%A1/_image/%E6%8A%B5%E5%88%B6.jpg","http://odvxpvqb8.qnssl.com/%E7%86%8A%E7%8C%AB%E9%95%87/%E6%89%AF%E7%9D%80%E6%B7%A1/_image/%E7%8B%BC%E6%9D%A5%E4%BA%86.jpg","http://odvxpvqb8.qnssl.com/%E7%86%8A%E7%8C%AB%E9%95%87/%E6%89%AF%E7%9D%80%E6%B7%A1/_image/%E5%AF%BC%E6%B8%B8.jpg"]
        let pageController = PBPageViewController.init(sourceData: array as NSArray?, currentPhotoUrl: "http://odvxpvqb8.qnssl.com/%E7%86%8A%E7%8C%AB%E9%95%87/%E6%89%AF%E7%9D%80%E6%B7%A1/_image/%E5%AF%BC%E6%B8%B8.jpg", showStyle: PBStyle.defaultStyle)
        pageController.showInViewController(viewController: self)
    }

}

