//
//  StringExtensionZhengZe.swift
//  SmallSheep
//
//  Created by KF001 on 2018/11/2.
//  Copyright © 2018年 KFZS. All rights reserved.
//

import Foundation

extension String {
    //是否是合格的电话号码
    func isvalitemobile() -> Bool {
        let mobileRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let mobileTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: self)
    }
    //邮箱
    func isvaliteemail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    //身份证号
    func isvaliteidnum() -> Bool {
        let idRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let idTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", idRegex)
        return idTest.evaluate(with: self)
    }
    //检测银行卡
    func isBankCard() -> Bool {
        let pattern = "^([0-9]{16}|[0-9]{19}|[0-9]{17}|[0-9]{18}|[0-9]{20}|[0-9]{21})$"
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) {
            return true
            }
        return false
        }
    
    //检测姓名
    func isUserName() -> Bool {
        
        let pattern = "(^[\u{4e00}-\u{9fa5}]{2,12}$)|(^[A-Za-z0-9_-]{4,12}$)"
        
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.dotMatchesLineSeparators)
        
        if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) {
            return true
            }
        return false
        }
    
    
}
