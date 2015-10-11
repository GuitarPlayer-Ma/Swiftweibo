//
//  NSDate+Extension.swift
//  weibo
//
//  Created by mada on 15/10/10.
//  Copyright © 2015年 MD. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func dateWithStr(dateString: String) -> NSDate? {
        // 创建格式化工具
        let formatter = NSDateFormatter()
        // 设置时间格式
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        // 设置时区
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 将字符串转化为NSDate
        return formatter.dateFromString(dateString)
    }
    
    // 在分类中添加计算型的属性
    var dateDescription : String {
        // 创建日历类
        let calendar = NSCalendar.currentCalendar()
        
        // 处理时间
        if calendar.isDateInToday(self) { // 今天
            // 获取两个时间的差值
            let res = Int(NSDate().timeIntervalSinceDate(self))
            
            if res < 60 {
                return "刚刚"
            }
            else if res < 60 * 60 {
                return "\(res / 60)分钟前"
            }
            else {
                return "\(res / (60 * 60))小时前"
            }
        }
        
        var formatterStr = "HH:mm"
        if calendar.isDateInYesterday(self) { // 昨天
            formatterStr = "昨天:" + formatterStr
        }
        else {
            
            // 一年以内
            // 比较年份的差值
            let compareYearRes = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: [])
            if compareYearRes.year == 0 {
                // 今年
                formatterStr = "MM-dd " + formatterStr
            }
            else {
                formatterStr = "yyyy-MM-dd " + formatterStr
            }
        }
        
        let formatter = NSDateFormatter()
        // 设置时间格式
        formatter.dateFormat = formatterStr
        // 设置时区
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.stringFromDate(self)
    }
}
