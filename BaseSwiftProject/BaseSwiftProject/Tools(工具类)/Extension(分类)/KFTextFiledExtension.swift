//
//  KFTextFiledExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2018/9/18.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import UIKit

extension UITextField:UITextFieldDelegate {

//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        self.delegate = self
//    }
//    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.resignFirstResponder()
//        return true
//    }
}
var maxTextNumberDefault = 20

extension UITextField{
    /// 使用runtime给textField添加最大输入字数属性,默认15
    var maxTextNumber: Int {
        set {
            objc_setAssociatedObject(self, &maxTextNumberDefault, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let rs = objc_getAssociatedObject(self, &maxTextNumberDefault) as? Int {
                return rs
            }
            return 20
        }
    }
    /// 添加判断数量方法
    func addChangeTextTarget(){
        self.addTarget(self, action: #selector(changeText), for: .editingChanged)
    }
    @objc func changeText(){
        //判断并过滤空格
        self.text = self.text?.removeAllSapce
        //判断是否是表情，并过滤
        self.text = self.disable_emoji(text: self.text! as NSString)
        //判断是不是在拼音状态,拼音状态不截取文本
        if let positionRange = self.markedTextRange{
            guard self.position(from: positionRange.start, offset: 0) != nil else {
                checkTextFieldText()
                return
            }
        }else {
            checkTextFieldText()
        }
    }
    
    func checkTextFieldText(){
        //判断是否是带区号的手机号，去掉区号
        if self.text?.hasPrefix("+86") == true {
            self.text = (self.text?.zzy.zzy_subString(fromIndex: 3))
        }
        /// 判断已输入字数是否超过设置的最大数.如果是则截取
        guard (self.text?.length)! <= maxTextNumber  else {
            self.text = (self.text?.stringCut(end: maxTextNumber))!
            self.undoManager?.removeAllActions()//禁用摇一摇手机撤销键入功能
            return
        }
    }
    ///过滤表情
    func disable_emoji(text : NSString)->String{
        do {
            let regex = try NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: NSRegularExpression.Options.caseInsensitive)
            let modifiedString = regex.stringByReplacingMatches(in: text as String, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.length), withTemplate: "")
            
            return modifiedString
        } catch {
            print(error)
        }
        return ""
    }
}
//判断输入的是否是表情符号
extension String{
    /// 判断是不是九宫格
    ///
    /// - Returns: true false
    func isNineKeyBoard()->Bool{
        let other : NSString = "➋➌➍➎➏➐➑➒"
        let len = self.count
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        
        return true
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    var length: Int {
        ///更改成其他的影响含有emoji协议的签名
        return self.utf16.count
    }
    
    /// 截取第一个到第任意位置
    ///
    /// - Parameter end: 结束的位值
    /// - Returns: 截取后的字符串
    func stringCut(end: Int) -> String{
        if !(end <= count) { return self }
        let sInde = index(startIndex, offsetBy: end)
        return String(self[..<sInde])
    }
}
