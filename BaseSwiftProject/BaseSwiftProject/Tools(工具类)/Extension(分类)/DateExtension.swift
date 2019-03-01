//
//  DateExtension.swift
//  SmallSheep
//
//  Created by kfzs on 2019/1/22.
//  Copyright © 2019 KFZS. All rights reserved.
//

import UIKit
extension Date: BaseExtPoint {
    public var zzy: ExtbaseImpl<Date> {
        return ExtbaseImpl.init(self)
    }
}
public enum HSHDateWeek: Int {
    case saturday = 7
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
}
extension GeneralExt where Base == Date{
    public var week: HSHDateWeek {
        return HSHDateWeek(rawValue: components(dateSets: [.weekday]).weekday!)!
    }
    /// month
    public var month: Int {
        return components(dateSets: [.month]).month!
    }
    
    /// day
    public var day: Int {
        return components(dateSets: [.day]).day!
    }
    
    /// year
    public var year: Int {
        return components(dateSets: [.year]).year!
    }
    
    /// ear
    public var era: Int {
        return components(dateSets: [.era]).era!
    }
    
    /// hour
    public var hour: Int {
        return components(dateSets: [.hour]).hour!
    }
    
    /// minute
    public var minute: Int {
        return components(dateSets: [.minute]).minute!
    }
    
    /// second
    public var second: Int {
        return components(dateSets: [.second]).second!
    }
    
    /// 这个月的第几周
    public var weekdayOrdinal: Int {
        return components(dateSets: [.weekdayOrdinal]).weekdayOrdinal!
    }
    
    /// 季度
    public var quarter: Int {
        return components(dateSets: [.quarter]).quarter!
    }
    
    /// 这个月的第几个星期
    public var weekOfMonth: Int {
        return components(dateSets: [.weekOfMonth]).weekOfMonth!
    }
    
    /// 该年的第几个星期
    public var weekOfYear: Int {
        return components(dateSets: [.weekOfYear]).weekOfYear!
    }
    
    /// 判断该月是否为润月
    public var leapMonth: Bool {
        return components(dateSets: [.yearForWeekOfYear]).isLeapMonth!
    }
    
    /// get components from format component
    ///
    /// - Parameter dateSets: components
    /// - Returns: DateComponents
    public func components(_ calendar: Calendar = Calendar.current, dateSets: Set<Calendar.Component>) -> DateComponents {
        return calendar.dateComponents(dateSets, from: base)
    }
    
    /// date to string
    ///
    /// - Parameter format: format
    /// - Returns: time string
    public func serializeToString(using format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: base)
    }
    //获取时间戳
    public func serializeToTimestamp() ->Int{
        let timeInterval:TimeInterval = base.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    static func getDate(dateStr: String, format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    func getComponent(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: base)
    }
    
    func getString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        let dateString = dateFormatter.string(from: base)
        return dateString
    }
}

