//
//  KFPayResultTool.swift
//  SmallSheep
//
//  Created by KF001 on 2018/10/30.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

class KFPayResultTool: NSObject {

    
    class func dealPayResult(resultCode:String,controller:UIViewController){
        switch resultCode {
        //        9000  订单支付成功
        //        8000  正在处理中
        //        4000  订单支付失败
        //        6001  用户中途取消
        //        6002  网络连接出错
        case "6001":
            alertHud(title: "用户中途取消")
        case "6002":
            alertHud(title: "网络连接出错")
        case "4000":
            alertHud(title: "订单支付失败")
        case "8000":
            alertHud(title: "正在处理中")
        case "9000":
            alertHud(title: "订单支付成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.0) {
                controller.navigationController?.popViewController(animated: true)
            }
        default:
            break
        }
    }
}
