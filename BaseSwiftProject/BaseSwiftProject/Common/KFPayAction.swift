//
//  KFPayAction.swift
//  SmallSheep
//
//  Created by kfzs on 2018/12/25.
//  Copyright © 2018 KFZS. All rights reserved.
//

import UIKit
enum PayType {
    case aliPay
    case weiChat
}
struct KFWeiChatPayModel: JSON {
    var partnerid:String?
    var prepayid:String?
    var package:String = "Sign=WxPay"
    var noncestr:String?
    var timestamp:UInt32 = 0
    var sign:String?
    var appid:String?
}
class KFPayAction: NSObject {//微信支付
    typealias backComplection = (Bool,[String:Any]?) -> Void
    var aliPayComplection:backComplection?
    var weiChatComplection:((Bool) -> Void)?
    var type:PayType = .aliPay
    static let share = KFPayAction()
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(aliPaySuccess), name: NSNotification.Name.init("Alipay"), object: nil)
    }
    @objc func aliPaySuccess(notify:Notification){
        if notify.userInfo?["resultStatus"] as? String == "9000"{
            self.aliPayComplection?(true,notify.userInfo as? [String : Any])
        }
        else{
            self.aliPayComplection?(false,notify.userInfo as? [String : Any])
        }
    }
    func pay(charge: String, complection: @escaping backComplection) {
        self.aliPayComplection = complection//Scheme:NemoPay
        
        AlipaySDK.defaultService().payOrder(charge, fromScheme: APPCustomDefine.AlipayScheme) { (result) in//此回调只会在web的时候调用
            if result?["resultStatus"] as? String == "9000" {
                /// 支付成功
                complection(true,result as? [String : Any])
            }
            else {
                complection(false,result as? [String : Any])
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
extension KFPayAction:WXApiDelegate{//支付宝支付
    
    func pay(payModel:KFWeiChatPayModel,completion: ((Bool) -> Void)?) {
//        WXApi.registerApp(APPCustomDefine.WechatPayKey)
        weiChatComplection = completion
        let req = PayReq()
        
        req.partnerId = payModel.partnerid ?? ""
        req.prepayId = payModel.prepayid
        req.package = payModel.package
        req.nonceStr = payModel.noncestr
        req.timeStamp = payModel.timestamp
        req.sign = payModel.sign
        
        WXApi.send(req)
    }
    
    func handleUrl(_ url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onResp(_ resp: BaseResp!) {
        if let resp = resp as? PayResp {
            if resp.errCode == WXSuccess.rawValue {
                /// 支付成功
                weiChatComplection?(true)
            }
            else {
                weiChatComplection?(false)
                /// 支付失败
            }
        }
    }
}
