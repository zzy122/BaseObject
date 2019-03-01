//
//  ResponseRuter.swift
//  SmallSheep
//
//  Created by kfzs on 2019/1/22.
//  Copyright © 2019 KFZS. All rights reserved.
//

import UIKit
protocol ResponderRouter {
    func interceptRoute(name:String,objc:UIResponder?,info:Any?)
}
extension UIResponder: BaseExtPoint {
    
    public var zzy: ExtbaseImpl<UIResponder> {
        return ExtbaseImpl.init(self)
    }
}
extension GeneralExt where Base == UIResponder//路由类
{
    func router(name:String, object:UIResponder?,info:Any?) {
        if let intercept = base.next as? ResponderRouter {
            intercept.interceptRoute(name: name, objc: nil, info: info)
            return
        }
        base.next?.zzy.router(name: name, object: object, info: info)
    }
}
