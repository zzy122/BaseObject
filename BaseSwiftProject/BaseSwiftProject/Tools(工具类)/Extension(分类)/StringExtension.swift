//
//  StringExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2018/8/9.
//  Copyright © 2018年 zzy. All rights reserved.
//
import Foundation
import UIKit
public protocol GeneralExt {
    associatedtype Base
    /// 访问原来的value
    var base: Base { get }
}
/// 扩展点基础实现:
public final class ExtbaseImpl<T>: GeneralExt {

    public let base: T
    public init(_ base: T) {
        self.base = base
    }
}
/// 扩展点protocol：作为扩展和访问点
public protocol BaseExtPoint {
    associatedtype ZT

    /// 访问 扩展功能（这个可以修改为其他的名字，所有的功能在该属性下访问 zzy.*），比如修改 ch，那么就通过 zzy.*
    var zzy: ZT { get }
}


//给string添加扩展
extension String: BaseExtPoint {

    public var zzy: ExtbaseImpl<String> {
        return ExtbaseImpl.init(self)

    }
}


extension GeneralExt where Base == String
{
    /// 从String中截取出参数
    func getUrlParameters() -> [String: AnyObject]? {
        var params = [String: AnyObject]()
        // 截取参数
        let paramsString = self.zzy_subString(fromStr: "?")
        if paramsString.count == 0 {return nil}
        // 判断参数是单个参数还是多个参数
        if paramsString.contains("&") {
            // 多个参数，分割参数
            let urlComponents = paramsString.components(separatedBy: "&")
            // 遍历参数
            for keyValuePair in urlComponents {
                // 生成Key/Value
                let pairComponents = keyValuePair.components(separatedBy: "=")
                let key = pairComponents.first?.removingPercentEncoding
                let value = pairComponents.last?.removingPercentEncoding
                // 判断参数是否是数组
                if let key = key, let value = value {
                    // 已存在的值，生成数组
                    if let existValue = params[key] {
                        if var existValue = existValue as? [AnyObject] {
                            existValue.append(value as AnyObject)
                        } else {
                            params[key] = [existValue, value] as AnyObject
                        }
                    } else {
                        params[key] = value as AnyObject
                    }
                }
            }
        } else {
            // 单个参数
            let pairComponents = paramsString.components(separatedBy: "=")
            // 判断是否有值
            if pairComponents.count == 1 {
                return nil
            }
            let key = pairComponents.first?.removingPercentEncoding
            let value = pairComponents.last?.removingPercentEncoding
            if let key = key, let value = value {
                params[key] = value as AnyObject
            }
        }
        return params
    }
    
    func containts(str:String) ->Bool//标准判断
    {
        if base.range(of: str) != nil {
            return true
        }
        
        return false
    }
    
    func containsIgnoringCase(find: String) -> Bool{//忽略字母大小写
        return base.range(of: find, options: .caseInsensitive) != nil
    }
    //字符串操作
    //字符串操作
    func zzy_subString(fromStr:String) -> String {//从某个位置开始
        if base.count > 0 {
            let indexRange:NSRange = self.nsRange(from: base.range(of: fromStr)) ?? NSRange.init(location: 0, length: 0)
            let strIndex = base.index(base.endIndex, offsetBy: -(base.count - indexRange.location - indexRange.length))
            
            return String(base[strIndex...])
            
        }
        return ""
    }
    func zzy_subString(toStr:String) -> String {//截取到某个位置
        
        let indexRange:NSRange = self.nsRange(from: base.range(of: toStr)) ?? NSRange.init(location: 0, length: 0)
        if indexRange.location == 0 {
            return ""
        }
        
        let strIndex = base.index(base.startIndex, offsetBy: indexRange.location - 1)
        return String(base[...strIndex])
    }
    
    func zzy_subString(star:Int, length:Int) -> String {//从某个位置截取长度
        let starIndex = base.index(base.startIndex, offsetBy: star)
        let endIndex = base.index(starIndex, offsetBy: length)
        
        return String(base[starIndex..<endIndex])
        
        
    }
    func zzy_subString(fromIndex:Int) -> String {//从index开始截取
        if base.count > fromIndex {
            let index = base.index(base.endIndex, offsetBy: fromIndex - base.count)
            return String(base[index...])
        }
        return ""
    }
    func zzy_subString(toIndex:Int) -> String {//截取到index
        if base.count > toIndex {
            let index = base.index(base.startIndex, offsetBy: toIndex)
            return String(base[...index])
        }
        return ""
    }
    
    
    func nsRange(from range: Range<String.Index>?) -> NSRange? {//range->nsrange
        if let range1 = range {
            return NSRange.init(range1, in: base)
        }
        return nil
        
        
    }
    func range(from nsRange: NSRange) -> Range<String.Index>? {//nsrang->range
        guard
            let from16 = base.utf16.index(base.utf16.startIndex, offsetBy: nsRange.location, limitedBy: base.utf16.endIndex),
            let to16 = base.utf16.index(from16, offsetBy: nsRange.length, limitedBy: base.utf16.endIndex),
            let from = String.Index(from16, within: base),
            let to = String.Index(to16, within: base)
            else { return nil }
        return from ..< to
    }
    //计算文字高度
    func caculateHeight(font:UIFont,width:CGFloat,lineSpace : CGFloat) -> CGFloat {
        
        //        let size = CGSizeMake(width,CGFloat.max)
        if base.count == 0 {
            return 0.0
        }
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = lineSpace
        
        paragraphStyle.lineBreakMode = .byWordWrapping;
        
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        
        let rect = base.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
    }
    
    //简化版CGFloat(str)
    func StringToFloat()->(CGFloat){
        
        let string = base
        var cgFloat: CGFloat = 0
        
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    //简化版 Int(str)
    func StringToInt()->(Int){
        
        let string = base
        var cgInt: Int = 0
        
        if let doubleValue = Double(string)
        {
            cgInt = Int(doubleValue)
        }
        return cgInt
    }
    //简化版Double(str)
    func StringToDouble(str:String)->(Double){
        
        let string = base
        var cgInt: Double = 0.0
        
        if let doubleValue = Double(string)
        {
            cgInt = (doubleValue)
        }
        return cgInt
    }
    
    func caculateWidth(font:UIFont) -> CGFloat {//计算文字宽度
        
        let str = base as NSString
        let rect = str.boundingRect(with: CGSize.init(width: CGFloat(MAXFLOAT), height: 30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font], context: nil)
        
        return ceil(rect.width)
    }
    //md5加密
    func md5() ->String{
        let str =
            base.cString(using: String.Encoding.utf8)
        
        let strLen = CUnsignedInt(base.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    //转换成十六进制 alph透明度
    func hexToColor(alpha : CGFloat = 1.0) -> UIColor {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        let scanner = Scanner(string: base)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (base.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
            default:
                return UIColor()
            }
        } else {
            return UIColor()
        }
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    func isPurnInt() -> Bool {//判断是否是数字
        
        let scan: Scanner = Scanner(string: base)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    //时间格式转换
    //string ->时间戳
    func getTimeStamp(_ formateStr:String = "yyyy-MM-dd HH:mm:ss") ->Int{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: base)
        return (date ?? Date()).zzy.serializeToTimestamp() * 1000
    }
    
    //MARK:json->Dictionary
    func serializeToDic() ->NSDictionary{
        let jsonData:Data = base.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
}
extension GeneralExt where Base == String{/// swift Base64处理
    
    /**
               *编码
     */
    func base64Encoding()->String
    {
        let plainData = base.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
    /**
     *   解码
     */
    func base64Decoding()->String
    {
        let decodedData = NSData(base64Encoded: base, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
        return decodedString
    }

}

