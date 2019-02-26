//
//  UITextFieldExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2019/1/22.
//  Copyright © 2019 KFZS. All rights reserved.
//

import UIKit
enum TextFiledType {
    case isOnlyInputNumber//只允许输入数字
    case isPhoneInput//手机号校验
    case isAllowSpeaceInput//空格输入
    
}
fileprivate struct TextKey {
    static var textChangeValue =  UnsafeRawPointer.init(bitPattern: "EditingTextChangeValue".hashValue)
    static var textChangeValueTag = UnsafeRawPointer.init(bitPattern: "EditingChangeValueTag".hashValue)
    static var editingDidBeginKey = UnsafeRawPointer.init(bitPattern: "EditingDidBeginKey".hashValue)
    static var editingDidEndKey = UnsafeRawPointer.init(bitPattern: "EditingDidEndKey".hashValue)
    static var editingDidEndOnExitKey = UnsafeRawPointer.init(bitPattern: "EditingDidEndOnExitKey".hashValue)
    static var maxNumEditingKey = UnsafeRawPointer.init(bitPattern: "maxNumEditingKey".hashValue)//输入最大位数限制
    static var isAllowSpeaceInput = UnsafeRawPointer.init(bitPattern: "isAllowSpeaceInput".hashValue)//是否允许输入空格标识
    static var isPhoneInput = UnsafeRawPointer.init(bitPattern: "isPhoneInput".hashValue)//是否允许输入空格标识
    static var onlyInputNumber = UnsafeRawPointer.init(bitPattern: "isPhoneInput".hashValue)//是否是纯数字
    static var textTarget = UnsafeRawPointer.init(bitPattern: "textTarget".hashValue)
}
extension UITextField{
    var changeValued:((String) -> Void)?{
        set{
            objc_setAssociatedObject(self, TextKey.textChangeValue!, newValue,  objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, TextKey.textChangeValue!) as? ((String) -> Void)
        }
    }
    var maxNum:Int{//最大输入数量
        set{
            objc_setAssociatedObject(self, TextKey.maxNumEditingKey!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return (objc_getAssociatedObject(self, TextKey.maxNumEditingKey!) as? Int) ?? 1000
        }
    }
    var isPhoneInput:Bool{//是否校验手机号输入
        set{
            if newValue == true{
                self.maxNum = 11
                self.isAllowSpeaceInput = false
                self.keyboardType = UIKeyboardType.numberPad
                self.borderStyle = UITextField.BorderStyle.none
            }
            else{self.maxNum = 10000}
            objc_setAssociatedObject(self, TextKey.isPhoneInput!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return (objc_getAssociatedObject(self, TextKey.isPhoneInput!) as? Bool) ?? false
        }
    }
    var isAllowSpeaceInput:Bool{//是否允许输入空格
        set{
            objc_setAssociatedObject(self, TextKey.isAllowSpeaceInput!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get{
            return (objc_getAssociatedObject(self, TextKey.isAllowSpeaceInput!) as? Bool) ?? true
        }
    }
    func editingChange(_ change:@escaping (String) ->Void){
        let target = ControlEventObject(nil)
        target.text = self
        self.changeValued = change
        objc_setAssociatedObject(self, TextKey.textChangeValueTag!, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func editingDidBegin(_ change:@escaping (UITextField) ->Void){
        let target = ControlEventObject(change)
        self.addTarget(target, action: #selector(ControlEventObject.selectorAction(_:)), for: UIControl.Event.editingDidBegin)
        objc_setAssociatedObject(self, TextKey.editingDidBeginKey!, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func editingDidEnd(_ change:@escaping (UITextField) ->Void){
        let target = ControlEventObject(change)
        self.addTarget(target, action: #selector(ControlEventObject.selectorAction(_:)), for: UIControl.Event.editingDidEnd)
        objc_setAssociatedObject(self, TextKey.editingDidEndKey!, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    func editingDidEndOnExit(_ change:@escaping (UITextField) ->Void){
        let target = ControlEventObject(change)
        self.addTarget(target, action: #selector(ControlEventObject.selectorAction(_:)), for: UIControl.Event.editingDidEndOnExit)
        objc_setAssociatedObject(self, TextKey.editingDidEndOnExitKey!, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
fileprivate class ControlEventObject<T:UITextField>:NSObject,UITextFieldDelegate{
    weak var text:UITextField?{
        didSet{
            text?.delegate = self
        }
    }
    private let action:((T) -> Void)?
    init(_ action:((T) -> Void)?) {
        self.action = action
    }
    @objc func selectorAction(_ sender:UITextField){
        self.action?(sender as! T)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var resultReturn = true
        let str:String = textField.text?.replacingCharacters(in: (textField.text?.zzy.range(from: range))!, with: string) ?? ""
        if str.count > textField.maxNum{
            textField.undoManager?.removeAllActions()
            return false
        }
        if textField.isPhoneInput == true{//手机号
            if range.length > 0 && string.count == 0{//删除
                DebugLog(message: "删除")
            }
            if range.length == 0 && string.count > 0{
                resultReturn = string.zzy.isPurnInt()
            }
            if range.length == 0 && (string.contains("+ 86")){
                textField.text = textField.text?.appending(string.zzy.zzy_subString(fromStr: "+ 86").replacingOccurrences(of: " ", with: ""))
                text?.changeValued?(textField.text!)
                textField.undoManager?.removeAllActions()//解决撤销崩溃
                return false
            }
        }
        if text?.isAllowSpeaceInput == false{
            if range.length == 0 && string.count > 0{
                if  string.contains(" "){
                    textField.text = textField.text?.appending(string.replacingOccurrences(of: " ", with: ""))
                     text?.changeValued?(textField.text!)
                    textField.undoManager?.removeAllActions()
                    return false
                }
            }
        }
        if resultReturn == true {
             text?.changeValued?(str)
        }
       return resultReturn
    }
}

