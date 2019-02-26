//
//  CustomNavigationViewController.swift
//  LeShanBankSwift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        interactivePopGestureRecognizer?.delegate = self
        
    }
    func setupNavigationBar() {
        let bar = UINavigationBar.appearance()
        //设置navbaritem字体颜色
        bar.tintColor = UIColor.black
        //设置navBar的颜色
        bar.barTintColor = UIColor.white
        //设置navbar标题的颜色和字体大小
        bar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.orange
            ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 25)//设置字体
        ]
        
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            //隐藏tabbar
            viewController.hidesBottomBarWhenPushed = true;
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "navigationButtonReturn"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(backClick))
            
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backClick() {
        popViewController(animated: true)
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if children.count == 1 {
            
            return false
        }else{
            
            return true
        }
    }
    

    

}
