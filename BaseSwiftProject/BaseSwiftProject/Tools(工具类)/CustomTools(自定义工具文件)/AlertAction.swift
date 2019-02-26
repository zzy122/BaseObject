//
//  AlipayAction.swift
//  JellyGarden
//
//  Created by zzy on 2018/7/11.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
enum ShowType {
    case center;
    case bottom;
}
class AlertAction: NSObject {
    typealias clickClose = () -> Void
    private var clickBtn:clickClose?
    var isTouchClose:Bool = true//背景是否可点击
    {
        didSet{
            if !isTouchClose {self.backView.removeGestureRecognizer(self.tapGester)}
            else {self.backView.addGestureRecognizer(self.tapGester)}
        }
    }
    lazy var closeBtn:UIButton = {//关闭按钮
        let btn = UIButton()
        btn.setImage(imageName(name: "close"), for: UIControl.State.normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(clickCloseBtn), for: UIControl.Event.touchUpInside)
        self.bottomView?.addSubview(btn)
        btn.isHidden = true
        return btn
    }()
    lazy var tapGester:UITapGestureRecognizer = {
        let gester = UITapGestureRecognizer.init(target: self, action: #selector(clickBack))
        return gester
    }()
    lazy var backView:UIView = {
        let view1 = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view1.alpha = 0.3
        view1.backgroundColor = UIColor.black
        view1.isHidden = true
       
        view1.addGestureRecognizer(self.tapGester)
        self.bottomView?.addSubview(view1)
        return view1
    }()

    var showType:ShowType {
        didSet {
            if self.showView != nil
            {
                if showType == .center
                {
                    self.showView?.frame = CGRect.init(x: ((self.bottomView?.bounds.width)! - (self.showView?.frame.width ?? 0)) / 2.0, y: (ScreenHeight - (self.showView?.frame.height ?? 0)) / 2.0, width: self.showView?.frame.width ?? 0, height: self.showView?.frame.height ?? 0)
                }
                else
                {
                    self.showView?.frame = CGRect.init(x: 0, y: ScreenHeight, width: self.showView?.frame.width ?? 0.0, height: self.showView?.frame.height ?? 0.0)
                    self.backView.alpha = 0.0
                }
            }
        }
    }
    private var showTagView:UIView?
    weak var showView:UIView? {
        set {
            self.showTagView?.removeFromSuperview()
            self.showTagView = newValue
            self.bottomView?.addSubview(self.showTagView!)
        }
        get{
            return self.showTagView
        }
    
    }
    var bottomView:UIView? = UIApplication.shared.keyWindow
    
    init(showType:ShowType,view:UIView,windowView:UIView?,clickCloseBtn:@escaping clickClose) {
        self.showType = .center
        super.init()
        if windowView != nil {self.bottomView = windowView}
        
        self.backView.isHidden = true
        self.showView = view

        self.showType = showType
        self.clickBtn = clickCloseBtn
        
    }
   @objc private func clickBack()
   {
        self.hiddenTheView()
    }
    @objc private func clickCloseBtn()
    {
        self.clickBtn?()
    }
    private func showBackView()  {
        self.backView.alpha = 0.0
        self.backView.isHidden = false
        UIView.beginAnimations("fadeIn", context: nil)
        UIView.setAnimationDuration(0.35)
        self.backView.alpha = 0.3
        UIView.commitAnimations()
    }
    
    func showTheView() {
        self.showView?.isHidden = false
        self.backView.isHidden = false
        if self.showType == .center {
            self.showBackView()
            self.closeBtn.frame = CGRect(x: ((self.bottomView?.bounds.width)! - 46) / 2.0, y: (self.showView?.frame.maxY)! + 20 * SCALE, width: 46, height: 46)
            self.closeBtn.isHidden = false
            let animation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform")
            animation.duration = 0.30;
            animation.isRemovedOnCompletion = true;
            animation.fillMode = CAMediaTimingFillMode.forwards;
            let valus = NSMutableArray()
            valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
            valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
            valus.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
            animation.values = valus as? [Any]
            self.showView?.layer.add(animation, forKey: nil)
        }
        else
        {
            self.backView.alpha = 0.3
            UIView.animate(withDuration: 0.3, animations: {
                self.showView?.frame = CGRect.init(x: 0, y: ScreenHeight - (self.showView?.frame.height ?? 0), width: self.showView?.frame.width ?? 0, height: (self.showView?.frame.height ?? 0))
            }, completion: { (result) in
                
            })
        }
    }
    func hiddenTheView()
    {
        self.showView?.endEditing(true)
        self.closeBtn.isHidden = true
        if self.showType == .center
        {
            UIView.beginAnimations("fadeIn", context: nil)
            UIView.setAnimationDuration(0.35)
            self.backView.alpha = 0.0
            UIView.commitAnimations()
            showView?.isHidden = true
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: {
                self.showView?.frame = CGRect.init(x: 0, y: ScreenHeight, width: self.showView?.frame.width ?? 0.0, height: self.showView?.frame.height ?? 0.0)
                self.backView.alpha = 0.0
            }) { (complete) in
                if complete {
                    self.backView.isHidden = true
                }
            }
            
            
        }
    }
    

}
