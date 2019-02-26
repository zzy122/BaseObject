//
//  KFToastLabel.swift
//  SmallSheep
//
//  Created by KF001 on 2018/9/18.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

class KFToastLabel: NSObject {
    /// 自定义底部弹出提示窗
    class func toastBottomLabel(_ title: String, maxY: CGFloat = ScreenHeight/2.0,delayAfter:CGFloat = 2.0) {
        //先去除页面上的其他toast
        for view in UIApplication.shared.keyWindow?.subviews ?? [] {
            if view.isKind(of: UILabel.self){
                view.removeFromSuperview()
            }
        }
        // 初始化一个标签视图
        let alertL = UILabel()
        alertL.text = title
        alertL.textColor = UIColor.white
        alertL.font = kFont_system16
        let width = title.zzy.caculateWidth(font: UIFont.systemFont(ofSize: 16))
        let height = title.zzy.caculateHeight(font: UIFont.systemFont(ofSize: 16), width: ScreenWidth-60, lineSpace: 4)
        alertL.frame = CGRect(x: 0, y: 0, width: width+40, height: 38)
        let labelWidth = alertL.bounds.size.width
        if labelWidth >= ScreenWidth-60{
            alertL.bounds.size.width = ScreenWidth-40;
            alertL.bounds.size.height = height
            alertL.numberOfLines = 0;
        }else{
            alertL.bounds.size.height = 38
            alertL.bounds.size.width = alertL.bounds.size.width + 10;
        }
        if (alertL.bounds.size.height <= AAdaption(num: 64)) {
            alertL.bounds.size.height =  AAdaption(num: 64)
        }
        alertL.center = CGPoint(x: ScreenWidth/2, y: maxY - 22)
        alertL.backgroundColor = "8E8E8E".zzy.hexToColor()
        alertL.alpha = 0.0
        alertL.textAlignment = .center
        alertL.layer.cornerRadius = 19
        alertL.layer.masksToBounds = true
        // 将视图添加到window上
        UIApplication.shared.keyWindow?.addSubview(alertL)
        // 动画
        UIView.animate(withDuration: 1.0, animations: {
            alertL.alpha = 1.0
        }, completion: { (_) in
            UIView.animate(withDuration: TimeInterval(delayAfter), animations: {
                alertL.alpha = 0.0
            }, completion: { (_) in
                alertL.removeFromSuperview()
            })
        })
    }
}
