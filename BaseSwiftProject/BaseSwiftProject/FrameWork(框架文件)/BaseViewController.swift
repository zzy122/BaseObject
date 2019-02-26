//
//  BaseViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var isShowBannerInage: Bool = false//导航栏图标
    lazy var leftBtn:ImageRightBtn = {
        let btn = ImageRightBtn()
        btn.setImage(imageName(name: "navigationButtonReturn"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(clickLeftBtn), for: UIControl.Event.touchUpInside)
        let barbutton = UIBarButtonItem.init(customView: btn)
        self.navigationItem.leftBarButtonItem = barbutton
        
        return btn
    }()
    lazy var rightBtn:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickRightBtn), for: UIControl.Event.touchUpInside)
        btn.setTitleColor(k_CustomColor(red: 240, green: 240, blue: 240), for: UIControl.State.normal)
        let barbutton = UIBarButtonItem.init(customView: btn)
        self.navigationItem.rightBarButtonItem = barbutton
        return btn
    }()
    private func showBarImage(){
        if self.isShowBannerInage {
            navigationController?.navigationBar.setBackgroundImage(imageName(name: "首页状态栏"), for: UIBarMetrics.default)
        }
        else{
            navigationController?.navigationBar.setBackgroundImage(imageName(name: ""), for: UIBarMetrics.default)
        }
//         navigationController?.navigationBar.alpha = 0.6
    }
    //可以选择性设置navigationbar的title的图片
    var logoTittleBgView:UIImageView = UIImageView()//titleImage
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.autoresizesSubviews = true
        self.view.backgroundColor = k_CustomColor(red: 240, green: 240, blue: 240)
        self.logoTittleBgView = UIImageView.init(image: imageName(name: ""))
        self.logoTittleBgView.frame = CGRect.init(x: (ScreenWidth - 200) / 2.0, y: 8, width: 200, height: 30)
        self.logoTittleBgView.tag = 600
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBarImage()
       //设置导航栏透明
//        self.navigationController?.navigationBar.setBackgroundImage(imageWithColor(color: k_CustomColor(red: 253, green: 253, blue: 253)), for: UIBarMetrics.default)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        if (self.navigationController?.viewControllers.count ?? 0) > 1{
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }else{
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }
        //隐藏下划线
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.isTranslucent = true//导航栏覆盖view
        //设置title样式
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font:kFont_system20]
        
        
        
        self.leftBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        self.rightBtn.isHidden = true
        if self.navigationController?.viewControllers.count == 1
        {
            self.leftBtn.isHidden = true
        }
        self.rightBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        if let view = self.navigationController?.navigationBar.viewWithTag(666)
        {
            view.isHidden = true
        }
        else
        {
            self.navigationController?.navigationBar.addSubview(self.logoTittleBgView)
        }
        
        //不让导航栏遮挡view
        if navigationController?.navigationBar.isHidden == true || tabBarController?.tabBar.isHidden == false
        {
            edgesForExtendedLayout = UIRectEdge.bottom
        }
        
        if navigationController?.navigationBar.isHidden == false || tabBarController?.tabBar.isHidden == true
        {
            edgesForExtendedLayout = UIRectEdge.top
        }
        if navigationController?.navigationBar.isHidden == false || tabBarController?.tabBar.isHidden == false
        {
            edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        }
        else
        {
            edgesForExtendedLayout = UIRectEdge.all
        }

    }
    @objc public func clickLeftBtn()
    {
        self.view.endEditing(true)
        self.navigationController?.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    @objc public func clickRightBtn()
    {
        
    }
    

}

