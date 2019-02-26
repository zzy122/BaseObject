//
//  CustomFunc.swift
//
//  Created by zzy on 2018/4/12.
//  Copyright © 2018年 zzy. All rights reserved.
//

import UIKit


//MARK: -Debug环境下打印信息
func DebugLog<T>(message:T){
    #if DEBUG
        print("\(message)")
    #endif
}

/// 打印内容，并包含类名和打印所在行数
///
/// - Parameters:
///   - message: 打印消息
///   - file: 打印所属类
///   - lineNumber: 打印语句所在行数
//MARK: -Debug环境下打印信息,Release环境下不打印
func DebugLogLine<T>(message : T, file : String = #file, lineNumber : Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
    #endif
}
//debug时打印,release时不打印
func KFLog<T>(messege : T,file : String = #file,line : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName).\(line):\(messege)")
    #endif
}

//MARK: -image
func imageName(name:String) -> UIImage? {
    return UIImage.init(named: name, in: Bundle.main, compatibleWith: nil)
}
//根据URL加载图片
func imageWithUrl(urlStr: String) -> UIImage?{
    let imageData = NSData.init(contentsOf: URL.init(string: urlStr)!)
    let image = UIImage.init(data: imageData! as Data)
    return image
}

//MARK: -保存数据到指定文件
func saveDataToFile(data:[String:Any], file:String)
{
    if !FileManager.default.fileExists(atPath: User_Path) {
        do
        {
            try FileManager.default.createDirectory(atPath: User_Path, withIntermediateDirectories: true, attributes: nil)
        }
        catch{}
    }
    NSDictionary(dictionary:data).write(toFile: file, atomically: true)
//    KFUserSaveAction.saveUserToMemory(user: data)//存储已经登陆过的用户
}

//MARK: -提示
func alertHud(title:String)
{
    KFToastLabel.toastBottomLabel(title, maxY: ScreenHeight * 0.83)
}

//MARK: -得到json字符串
func getJSONStringFromObject(dictionary:Any) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
    let JSONString: String = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)! as String
    let str1 = JSONString.replacingOccurrences(of: "\\", with: "")
    let str = str1.replacingOccurrences(of: "\n", with: "")
    return str
}


//MARK: -颜色配置
func k_CustomColor(red:Int, green:Int, blue:Int) -> UIColor{
    return UIColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
}












