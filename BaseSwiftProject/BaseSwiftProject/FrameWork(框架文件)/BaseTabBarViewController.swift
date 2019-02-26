//
//  BaseTabBarViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/16.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController ,UITabBarControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setupUI()
    }
    func setupUI(){
        self.tabBar.tintColor = "999999".zzy.hexToColor()
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.backgroundColor = UIColor.white
        self.addSubViewController(className: "KFMainViewController", titleName: "首页", imageN: "春节赚钱")
        self.addSubViewController(className: "KFReviewController", titleName: "审核", imageN: "春节游戏")
        self.addSubViewController(className: "KFInvitationController", titleName: "邀请", imageN: "春节邀请")
        self.addSubViewController(className: "KFDiscoverVC", titleName: "发现", imageN: "春节发现")
        self.addSubViewController(className: "KFPersonCenterVC", titleName: "我的", imageN: "春节个人中心")
    }
    func addSubViewController(className:String,titleName:String,imageN:String) {
        let vcName = "SmallSheep." + className
        let ViewControllerClass = NSClassFromString(vcName) as! UIViewController.Type
        let vc = ViewControllerClass.init()
        vc.title = titleName
        vc.tabBarItem.title = titleName
        let normalDic = [NSAttributedString.Key.font:kFont_system12,NSAttributedString.Key.foregroundColor:"999999".zzy.hexToColor()]
        vc.tabBarItem.setTitleTextAttributes(normalDic, for: UIControl.State.normal)
        let selectDic = [NSAttributedString.Key.font:kFont_system12,NSAttributedString.Key.foregroundColor:"333333".zzy.hexToColor()]
        vc.tabBarItem.setTitleTextAttributes(selectDic, for: UIControl.State.selected)
        vc.tabBarItem.selectedImage = imageName(name: imageN+"_选中")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.image = imageName(name: imageN)?.withRenderingMode(.alwaysOriginal)
        let nav = CustomNavigationViewController.init(rootViewController: vc)
        self.addChild(nav)
    }
    func hideTheTabbar() {
        self.tabBar.isHidden = true
    }
    func showTheTabbar() {
        self.tabBar.isHidden = false
    }
}
