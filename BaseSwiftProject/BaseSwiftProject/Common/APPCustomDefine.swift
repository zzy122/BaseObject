//
//  APPCustomDefine.swift
//  BaseSwiftProject
//
//  Created by kfzs on 2019/1/31.
//  Copyright © 2019 zzy. All rights reserved.
//

import UIKit

class APPCustomDefine: NSObject {
    static let WechatPayKey = "wx427e8e74e8dd27a6"
    //支付宝的scheme
    static let AlipayScheme = "smallSheepAlipay"
    static let WechatAppkey = "wx2be7f59bb7bb963f"
    static let WechatAppScreate = "6cf7ca0f6c6ac97c6961d901fee8adb9"
    static let UmAppkey = "5ad69d6e8f4a9d610f000013"
    static let QQAppkey = "101461115"
    static let UploadURL = "http://static.kuaifazs.com/sdkkitfile.php"
    static var UserPath:String = {
        let path:String = "\(documentPath)/User"
        if (!FileManager.default.fileExists(atPath: path))
        {
            do {
                
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
            catch(let error)
            {
                
            }
        }
        return path
    }()
    static let SERVER_HOST:String = "http://test.sheep.kfzs.com/v1/"
}
