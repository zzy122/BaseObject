//
//  APPCustomFunc.swift
//  Swift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

//tabbarVC
var RootViewController:UIViewController? {
    get{
        return UIApplication.shared.keyWindow?.rootViewController
    }
}
//最上层表面的VC
func TopViewContoller() -> BaseViewController? {
    let appdele = UIApplication.shared.delegate as! AppDelegate
    let vc = appdele.window?.rootViewController
    if let tabVC = RootViewController {
        if let nav = RootViewController?.presentedViewController {//判断是不是有present的
            if nav.isKind(of: CustomNavigationViewController.self){
                return (nav as! CustomNavigationViewController).topViewController as? BaseViewController
            }
            else {return nav as? BaseViewController}
        }
        else if let barVC = tabVC as? BaseTabBarViewController{
            if let nav:CustomNavigationViewController = barVC.selectedViewController as? CustomNavigationViewController
            {
                return nav.topViewController as? BaseViewController
            }
            else if let vc1 = barVC.selectedViewController as? BaseViewController
            {
                return vc1
            }
            else
            {
                return barVC.selectedViewController as?BaseViewController
            }
        }
        else {
            return tabVC as? BaseViewController
        }
    }
    guard let rootVC = vc else {
        return nil
    }
    if let rootNav = rootVC as? UINavigationController
    {
        return rootNav.topViewController as? BaseViewController
    }
    else if rootVC.isKind(of: BaseViewController.self)
    {
        return rootVC as? BaseViewController
    }
    return nil
}
//根导航vc
func RootNav() -> CustomNavigationViewController? {
    
    return TopViewContoller()?.navigationController as? CustomNavigationViewController
}





