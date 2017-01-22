//
//  PBChiledViewController.swift
//  PhotoBrower
//
//  Created by HLH on 2017/1/22.
//  Copyright © 2017年 胡良海. All rights reserved.
//

import UIKit
import SDWebImage.UIImageView_WebCache

class PBChiledViewController: UIViewController,UIScrollViewDelegate {
   fileprivate let scrollView = UIScrollView.init() // 通过scrollview实现图片的放大缩小功能
   fileprivate let pregressLabel = UILabel.init() // 进度
   fileprivate let shareBtn = UIButton.init() // 分享按钮
   fileprivate let saveBtn  = UIButton.init() // 保存按钮
   fileprivate let textLabel = UILabel.init() // 简介
   fileprivate var imageView :UIImageView = UIImageView.init() // 显示的图片
    
    init(data :Any) {
        super.init(nibName: nil, bundle: nil)
        self.initSubView()
        if let urlStr = data as? String {
            self.loadImageWithUrl(urlStr: urlStr)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:  初始化子视图
   fileprivate func initSubView() {
        self.view.backgroundColor = UIColor.black
        
        self.scrollView.backgroundColor = .black
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.frame = self.view.bounds
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 3
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
    
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(self.imageView)
    
        
    }
    
    fileprivate func loadImageWithUrl(urlStr :String) {
        self.imageView.sd_setImage(with: URL.init(string: urlStr)) { (image, _, _, _) in
            let imageSize = self.convertSizeToFit(size: (image?.size)!)
            self.scrollView.contentSize = imageSize
            DispatchQueue.main.async {
                var frame = CGRect.zero
                frame.size = imageSize
                self.imageView.frame = frame
                self.imageView.center = self.scrollView.center
            }
            
        }
        
    }
    
    fileprivate func convertSizeToFit(size :CGSize) ->CGSize {
        var size = size
        let screenWith = UIScreen.main.bounds.size.width
        let ratio = screenWith / size.width
        size.width *= ratio
        size.height *= ratio
        return size
    }
    
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let screenSize = scrollView.bounds.size
        let offsetX = (screenSize.width > contentSize.width) ? (screenSize.width - contentSize.width) / 2 : 0
        let offsetY = (screenSize.height > contentSize.height) ? (screenSize.height - contentSize.height) / 2 : 0
        self.imageView.center = CGPoint.init(x: contentSize.width / 2 + offsetX, y: contentSize.height / 2 + offsetY)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}
