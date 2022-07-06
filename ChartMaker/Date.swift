//
//  Date.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/01.
//

import Foundation

extension Date {
    
    
    
    
    
}

struct Tools {
    
    static let customDate = CustomDate()
    
}

struct CustomDate {
    
    func convertStringToDate(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: time) else { return Date() }
        return date
    }
    
    // 데이트 포맷을 원하는 타입의 String 으로 변경
    func convertDateBasicFormatToStringWithFormat(date: Date,
                                                  format: String) -> String {
        let formatter = DateFormatter()
//        formatter.locale = Locale.init(identifier: "")
        formatter.dateFormat = "\(format)"
        let string = formatter.string(from: date)
        return string
    }
    
}
