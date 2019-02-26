//
//  AppLunchSetting.swift
//  BaseSwiftProject
//
//  Created by kfzs on 2019/1/31.
//  Copyright © 2019 zzy. All rights reserved.
//

import UIKit

class AppLunchSetting: NSObject {
    
    class func  uMengSetting(){
        UMConfigure.initWithAppkey(APPCustomDefine.UmAppkey, channel: "App Store ")
        WXApi.registerApp(APPCustomDefine.WechatAppkey)
        UMSocialManager.default().setPlaform(.wechatSession, appKey: APPCustomDefine.WechatAppkey, appSecret: APPCustomDefine.WechatAppScreate, redirectURL: "")
        UMSocialManager.default().setPlaform(.QQ, appKey: APPCustomDefine.QQAppkey, appSecret: nil, redirectURL: "http://www.qq.com/music.html")
        UMCommonLogManager.setUp()
        UMConfigure.setLogEnabled(true)
    }
    
}
