//
//  PhotoBrowserAnimator.swift
//  PhotoPreviewView
//
//  Created by mqt on 2018/5/19.
//  Copyright © 2018年 mqt.com. All rights reserved.
//

import UIKit

//MARK:面向协议开发
protocol AnimatorPresentedDelegate:NSObjectProtocol {
    func startRect()->CGRect
    
    func endRect()->CGRect
    
    func getImageView()->UIImageView
}

protocol AnimatorDismissDelegate:NSObjectProtocol {
    func imageViewForDimissView() ->UIImageView
}

class PhotoBrowserAnimator: NSObject {
    //属性
    var isPresented:Bool = false
    var presentedDelegate:AnimatorPresentedDelegate?
    var dismissDelegate:AnimatorDismissDelegate?
}

extension PhotoBrowserAnimator:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresented = false
        return self
    }
}


extension PhotoBrowserAnimator:UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.isPresented ? animationForPresentedView(transitionContext: transitionContext) :animationForDismissView(transitionContext: transitionContext)
    }
    
    
    
    func animationForPresentedView(transitionContext:UIViewControllerContextTransitioning){
        
        //0.nil值校验
        guard let presentedDelegate = presentedDelegate else{
            return
        }
        
        
        //获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        //将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //获取执行动画的imageView
        let startRect = presentedDelegate.startRect()
        let imageView = presentedDelegate.getImageView()
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        //执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            ()->Void in
            imageView.frame = presentedDelegate.endRect()
            
        }){(_)-> Void in
            transitionContext.containerView.backgroundColor = UIColor.black
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.completeTransition(true)
            
        }
    }
    
    
    func animationForDismissView(transitionContext:UIViewControllerContextTransitioning){
        
        //校验nil值
        guard let dismissDelegate = dismissDelegate,let presentedDelegate = presentedDelegate else{
            return
        }
        
        //获取消失的View
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        //获取执行动画的ImageView
        let imageView = dismissDelegate.imageViewForDimissView()
        transitionContext.containerView.addSubview(imageView)
        transitionContext.containerView.backgroundColor = UIColor.clear
        
        let endRect = presentedDelegate.startRect()
        
        dismissView?.alpha = endRect == CGRect.zero ? 1.0 : 0.0
        
        //执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            ()->Void in
            imageView.frame = endRect
        }){(_)->Void in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
            
            
        }
        
    }
    
}

