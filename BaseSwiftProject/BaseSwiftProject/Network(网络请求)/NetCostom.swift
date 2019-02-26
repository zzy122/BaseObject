//
//  NetCostom.swift
//
//  Created by zzy on 2018/4/10.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit
import Alamofire
import AdSupport
var Defult_jsonError = "error"

//var Defult_exceptionMessage = "message"
//var Defult_errorReson = "errorReson"
//
//var Defult_Invalid_user = "role.invalid_user"
 let adid:String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
final class NetCostom: NSObject {
    
    typealias BackRequestSuccess = (Any) -> Void
    typealias BackRequestError = (KFErrorModel?) -> Void
    typealias BackRequestIsFinish = (Bool) -> Void
    var manager:NetworkReachabilityManager?
   
    //单列;
    static let shared = NetCostom()
    private override init() {
        
    }
    var headers: HTTPHeaders {
        get {
            return [
                "Content-Type":"application/json",
                "Accept": "application/json",
                //此处设置token
                "platform":"ios",
                "X-Device-Id": adid,
            ]
        }
    }
    
}
extension NetCostom {
    func uploadFiles(images:[UIImage]?,complection:@escaping ([String]?,Bool) -> Void){//多图上传
        guard let tagImages = images,tagImages.count > 0 else {complection(nil,false) ;return}
        var backUrl:[String] = []
        for i  in 0 ..< tagImages.count{
            let image = tagImages[i]
            let imageData =   image.jpegData(compressionQuality: 0.5)
            self.uploadFile(imageData: imageData!, uploadProgress: { (progress) in
            }) { (urlStr, success) in
                if success {
                    guard let str = urlStr else{alertHud(title: "上传失败"); return}
                    backUrl.append(str)
                }
                if i == tagImages.count - 1{
                    if backUrl.count > 0{complection(backUrl,true)}
                    else{complection(nil,false)}
                }
            }
        }
        
    }
    //文件上传
    func uploadFile(imageData:Data,uploadProgress:@escaping (CGFloat) -> Void,complection:@escaping (String?,Bool) -> Void)
    {
//        KFHUDAction.showProgress(bg: nil, textStr: "请稍后...", detailStr: nil, afterDeLay: nil)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //采用post表单上传
                // 参数解释：
                //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的，要上传其他格式可以自行百度查一下
                multipartFormData.append(imageData, withName: "uploadfile", fileName: "image.jpg", mimeType: "image/jpeg")
                //如果需要上传多个文件,就多添加几个
                //multipartFormData.append(imageData, withName: "file", fileName: "123456.jpg", mimeType: "image/jpeg")
                //......
                
        },to: APPCustomDefine.UploadURL,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                //连接服务器成功后，对json的处理
                upload.responseJSON { response in
                    //解包
                    guard let result = response.result.value else {complection(nil,false);return}
                    DebugLog(message: ("json:\(result)"))
                    //上传成功
                    guard let resultData = response.data else {complection(nil,false); return}
                    let dic:[String:Any]? = try! JSONSerialization.jsonObject(with: resultData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any]
                    complection(((dic?["data"] as! [String:Any])["url"] as! String),true)
                }
                //获取上传进度
                upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    uploadProgress(CGFloat(progress.fractionCompleted))
                }
            case .failure(let encodingError):
                //打印连接失败原因
                print(encodingError)
                complection(nil,false)
            }
        })
    }
    
    
    
    func downLoad(urlStr:String,toFile:String,progressPercent:@escaping (CGFloat) -> Void, finished:@escaping BackRequestIsFinish) -> () {//文件下载
        
        let destination:DownloadRequest.DownloadFileDestination = {_,_ in
            //下载文件路径URL
            let documentPath:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let filePath = documentPath.appendingPathComponent(String.init(format: "%@/%@", APPCustomDefine.UserPath,toFile))
            return (filePath, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(urlStr, to: destination).downloadProgress(queue: DispatchQueue.main) { (progress) in
            progressPercent(CGFloat(progress.completedUnitCount / progress.totalUnitCount))
            DispatchQueue.main.async {
            }
            }.responseData { (response) in
                if response.result.value != nil
                 {
                    DispatchQueue.main.async {
                        finished(true)
                    }
                    //下载完成
                }
                else if response.result.error != nil
                {
                    DispatchQueue.main.async {
                        finished(false)
                    }
                }
        }
    }
    private func requestNormal(method:HTTPMethod, wengen:String ,params:[String:Any]?, success: @escaping BackRequestSuccess,allData:(([String:Any]) -> Void)? = nil, failture: @escaping BackRequestError) -> ()
    {
        let urlStr:String = self.getUrl(wengen: wengen)
        var coding:ParameterEncoding = URLEncoding.httpBody
        coding = URLEncoding.queryString
  
        Alamofire.request(urlStr, method: method, parameters: params, encoding: coding, headers: headers).responseData { (resultData) in
            KFHUDAction.hiddenHud()
            guard resultData.response?.statusCode != 401 else
            {
                alertHud(title: "您的账号已失效，请重新登录")
                self.gotoLoginVC()
                return
            }
            if  resultData.response?.statusCode == 200 {
                let resultDic:[String:Any]? = KFNetPasswordTools.share().conversion(toJson: resultData.data) as? [String : Any]
                DebugLog(message: "<-<-<- requestUrl:\(urlStr) === \nresult:\(String(describing: resultDic))");
                DispatchQueue.main.async {
                    guard let dic = resultDic else
                    {
                        let dic:[String:Any] = ["code":400]
                        self.showErrorMessg(errorDic: dic, backError: failture)
                        return;
                    }
                    self.dealWithRequestResult(resultDic: dic, success: success, allData: allData, error: failture)
                }
            }
            else{
                let dic:[String:Any] = ["code":400,"msg":"网络连接不可用,请检查网络"]
                self.showErrorMessg(errorDic: dic, backError: failture)
            }
        }
    }
    func gotoLoginVC(){
        if (RootViewController?.presentedViewController != nil) || (RootViewController?.presentingViewController != nil) {return}
    }
    func request(method:HTTPMethod, wengen:String ,params:[String:Any]?, success: @escaping BackRequestSuccess, allData:(([String:Any]) -> Void)? = nil, failture: @escaping BackRequestError) {//

        let urlStr:String = self.getUrl(wengen: wengen)
        DebugLog(message: "URLPath:\(urlStr)\n post:->->->\n\(String(describing: params))")
        KFHUDAction.showProgress(bg: nil, textStr: "请稍后...", detailStr: nil, afterDeLay: nil)
        if method == .get {
            self.requestNormal(method: method, wengen: wengen, params: params, success: success,allData:allData, failture: failture)
        }
            
        else if method == .post || method == .put
        {
            var coding:ParameterEncoding = URLEncoding.httpBody
            if params != nil
            {
                let paramStr = KFNetPasswordTools.share().conversion(to: params!)
                guard let str = paramStr else{
                    alertHud(title: "加密失败")
                    return
                }
                coding = JSONStringEncoding.init(paramStr: str)
            }
            else
            {
               self.requestNormal(method: method, wengen: wengen, params: params, success: success,allData:allData, failture: failture)
                return
            }
            
            Alamofire.request(urlStr, method: method, parameters: nil, encoding: coding, headers: headers).responseData {(resultData) in
                KFHUDAction.hiddenHud()
                guard resultData.response?.statusCode != 401 else
                {
                    alertHud(title: "您的账号已失效，请重新登录")
                    self.gotoLoginVC()
                    return
                }
                if  resultData.response?.statusCode == 200 {
                    let resultDic:[String:Any]? = KFNetPasswordTools.share().conversion(toJson: resultData.data) as? [String : Any]
                    DebugLog(message: "<-<-<- requestUrl:\(urlStr) === \nresult:\(String(describing: resultDic))");
                    DispatchQueue.main.async {
                        guard let dic = resultDic else
                        {
                            let dic:[String:Any] = ["code":400]
                            self.showErrorMessg(errorDic: dic, backError: failture)
                            return;
                        }
                        self.dealWithRequestResult(resultDic: dic, success: success, allData: allData, error: failture)
                    }
                }
                else{
                    let dic:[String:Any] = ["code":400,"msg":"网络连接不可用,请检查网络"]
                    self.showErrorMessg(errorDic: dic, backError: failture)
                }
            }
        }
    }
}
extension NetCostom {
    func getUrl(wengen:String) -> (String) {//拼接url
        var str:String = APPCustomDefine.SERVER_HOST
        str.append(wengen);
//        return str.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "`#%^{}\"[]|\\<>")) ?? ""
        return str
    }
    func dealWithRequestResult(resultDic:[String:Any],success:@escaping BackRequestSuccess,allData:(([String:Any]) -> Void)? = nil,error:@escaping BackRequestError) -> Void {//处理服务器返回信息  code200成功其他错误
        
        guard resultDic["data"] != nil else {
            if let code = resultDic["code"] as? Int ,code == 200
            {
                success(resultDic["data"] ?? "")
                allData?(resultDic)
            }
            else
            {
                if (resultDic["msg"] as? String) != nil
                {
                    self.showErrorMessg(errorDic: resultDic, backError: error)
                }
            }
            return
        }
        if let successDIc = resultDic["data"]
        {
            success(successDIc)
            allData?(resultDic)
        }
    }
    func showErrorMessg(errorDic:[String:Any]?, backError:@escaping BackRequestError) {
        let model = BaseModel<KFErrorModel,KFErrorModel>.init(resultData: errorDic ?? [:])
        backError(model.resultData)
    }
    func checkNetEnable() {
        self.manager = NetworkReachabilityManager.init(host: "https://www.baidu.com")
        manager?.listener = { status in
            switch status {
            case .notReachable:
                 DebugLog(message: "网络状态:无网络")
                break
            case .unknown:
                 DebugLog(message: "网络状态:unknown")
                break
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
             DebugLog(message: "网络状态:蜂窝")
            break
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):

             DebugLog(message: "网络状态:Wifi")
            break
            }
        }
            self.manager?.startListening()
    }
    
}
//自定义编码格式
struct JSONStringEncoding: ParameterEncoding {
    private let paramStr: String

    init(paramStr: String) {
        self.paramStr = paramStr
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        let data = paramStr.data(using: String.Encoding.utf8)
        urlRequest!.httpBody = data

        return urlRequest!
    }
}



