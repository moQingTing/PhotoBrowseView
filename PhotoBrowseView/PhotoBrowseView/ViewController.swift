//
//  ViewController.swift
//  PhotoBrowseView
//
//  Created by mqt on 2018/5/26.
//  Copyright © 2018年 mqt. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// 图片
    lazy var imageView:UIImageView = {
        let view = UIImageView(image: UIImage(named: "image"))
        view.frame = CGRect(x: self.view.center.x - 100, y: self.view.center.y - 150, width: 200, height: 300)
        return view
    }()

    /// 转场代理
    let photoBrowserAnimator = PhotoBrowserAnimator()
    
    /// 点击
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let point = touch.location(in: self.view)
        let layer = self.view.layer.hitTest(point)
        if layer === self.imageView.layer{
            self.handlePhotoShowPress()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /// 如果已上传图片就打开预览
    func handlePhotoShowPress() {
        
        let photoBrowserVc = PhotoBrowserController(imageViewFrame: self.getImageViewFrame(),image:self.imageView.image!)
        
        // 设置modal的样式,自定义
        photoBrowserVc.modalPresentationStyle = .custom
        
        // 转场代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        photoBrowserAnimator.presentedDelegate = self
        
        // 以自定义的modal弹出
        self.present(photoBrowserVc, animated: true, completion: nil)
        
    }
    
}

extension ViewController:AnimatorPresentedDelegate{
    func startRect() -> CGRect {
        //获取imageView的frame
        let startFrame = self.view.convert(self.imageView.frame, to: UIApplication.shared.keyWindow)
        
        return startFrame
    }
    
    func endRect() -> CGRect {
        return self.getImageViewFrame()
    }
    
    func getImageViewFrame()->CGRect{
        //获取该位置的image对象
        let image = self.imageView.image
        //计算结束的frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        
        var y:CGFloat = 0
        if h > UIScreen.main.bounds.height {
            y = 0
        }else{
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func getImageView() -> UIImageView {
        //创建UIImageView对象
        let imageView = UIImageView()
        
        //获取该位置的image对象
        let image = self.imageView.image
        
        //设置imageView的属性
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }
}

