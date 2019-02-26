//
//  UMengAcion.swift
//  JellyGarden
//
//  Created by zzy on 2018/6/4.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit

class UMengAcion: NSObject {
    //分享图片
    class func uMengImageShare(platformType:UMSocialPlatformType,image:UIImage,complection:(UMSocialRequestCompletionHandler?) = nil){
        let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
        let imageObject:UMShareImageObject = UMShareImageObject()
        imageObject.title = "小绵羊"
        imageObject.shareImage = image
        messageObject.shareObject = imageObject
        
        UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: RootViewController, completion: complection)
        
    }
    //分享到指定软件
    class func uMengshare(platformType:UMSocialPlatformType,title:String?,descr:String?,shareUrl:String?,callback:((Bool) -> Void)? = nil){
//        WXApi.registerApp(APPCustomDefine.WechatAppkey)
        let shareObject:UMShareWebpageObject = UMShareWebpageObject.shareObject(withTitle: title ?? "分享title", descr: descr ?? "", thumImage: imageName(name: ""))
        shareObject.webpageUrl = shareUrl ?? "www.baidu.com"
        
        let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
        messageObject.shareObject = shareObject;
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: RootViewController, completion: { (shareResponse, error) in
            if let error1 = error {
                alertHud(title: "分享失败")
                print("Share Fail with error ：%@", error1.localizedDescription)
            }else{
                if callback != nil{
                    callback!(true)
                }
            }
        })
    }
    //调用分享面板分享图片
    class func uMenShareImage(image:UIImage?,complection:(UMSocialRequestCompletionHandler?) = nil){
        guard let imageTag = image else {return}
        UMSocialShareUIConfig.shareInstance()?.shareTitleViewConfig.shareTitleViewTitleString = "请选择分享平台"
        UMSocialUIManager.setPreDefinePlatforms([NSNumber.init(value: Int8(UMSocialPlatformType.QQ.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.qzone.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.wechatSession.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.wechatTimeLine.rawValue))])
        UMSocialUIManager.showShareMenuViewInWindow {(platformType, shreMenuView) in
            self.uMengImageShare(platformType: platformType, image: imageTag, complection: complection)
        }
    }
    //调用分享面板分享链接
    class func uMengShare(title:String?,descr:String?,shareUrl:String?,back:((Bool) -> Void)? = nil) {
        UMSocialShareUIConfig.shareInstance()?.shareTitleViewConfig.shareTitleViewTitleString = "请选择分享平台"
        UMSocialUIManager.setPreDefinePlatforms([NSNumber.init(value: Int8(UMSocialPlatformType.QQ.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.qzone.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.wechatSession.rawValue)),NSNumber.init(value: Int8(UMSocialPlatformType.wechatTimeLine.rawValue))])
        UMSocialUIManager.showShareMenuViewInWindow {(platformType, shreMenuView) in
            self.uMengshare(platformType: platformType, title: title, descr: descr, shareUrl: shareUrl, callback: { (result) in
                if back != nil{
                    back!(result)
                }
            })
        }
    }
    class func getUserInfoForPlatform(platformType:UMSocialPlatformType){
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: RootViewController, completion: { (result:Any?, error:Error?) in
            if let userinfo  = result as? UMSocialUserInfoResponse {
                let message = " name: \(userinfo.name ?? "")\n icon: \(userinfo.iconurl ?? "")\n gender: \(userinfo.gender ?? "")\n"
                print(message)
                AlertViewCoustom().showalertView(style: UIAlertController.Style.alert, title: alertTitle, message: message, cancelBtnTitle: alertConfirm, touchIndex: { (index) in
                    
                }, otherButtonTitles: nil);
                
            }
        })
    }
    //三方登录
//    class func uMengLogin(type:UMSocialPlatformType, loginSuccess:@escaping (KFUserModel?,KFErrorModel?,UMSocialUserInfoResponse) -> Void) {
//        UMSocialDataManager.default().clearAllAuthorUserInfo()
//        WXApi.registerApp(WechatAppkey)
//        UMSocialManager.default().getUserInfo(with: type, currentViewController: TopViewContoller()) { (result, error) in
//            guard let userResult = result as? UMSocialUserInfoResponse else {
//                DebugLog(message: error)
//                return
//            }
//            DispatchQueue.main.async {
//                let params:[String:Any] = ["code":userResult.accessToken,"scope":"","username":userResult.openid]
//            }
//        }
//    }
}
//分享

