//
//  IntExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2019/1/25.
//  Copyright © 2019 KFZS. All rights reserved.
//

import UIKit

extension Int{//时间戳转换为时间
    func serializeTimeStampToString(formatStr:String = "yyyy-MM-dd HH:mm") ->String{
        let timeInterval:TimeInterval = TimeInterval.init(self)
        let date = Date.init(timeIntervalSince1970:timeInterval)
        //格式话输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatStr
        return dformatter.string(from: date)
    }
}
