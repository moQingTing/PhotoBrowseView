//
//  PhotoBrowserController.swift
//  PhotoPreviewView
//
//  Created by mqt on 2018/5/19.
//  Copyright © 2018年 mqt.com. All rights reserved.
//

import UIKit

class PhotoBrowserController: UIViewController {
    
    /// 转场动画后，动画的图片消息，将用这个图片显示
    lazy var imageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    init(imageViewFrame:CGRect,image:UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.frame = imageViewFrame
        self.imageView.image = image
        self.setConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加手势
        self.imageView.isUserInteractionEnabled = true
        let signTap = UITapGestureRecognizer(target: self, action: #selector(self.clickImageView(sender:)))
        self.imageView.addGestureRecognizer(signTap)
    }
    
    /// 添加图片
    func setConstraint(){
        self.view.addSubview(self.imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     @objc func clickImageView(sender:UITapGestureRecognizer){
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoBrowserController:AnimatorDismissDelegate{
    /// 当前controller dismiss时执行
    func imageViewForDimissView() -> UIImageView {
        print("imageViewForDimissView")
//        self.imageView.isHidden = true
        return self.imageView
    }
    
    
}

