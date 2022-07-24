//
//  BabyGrowthRecordHistory.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/24.
//

import Foundation
import UIKit

class BabyGrowthRecordHistory {
    
    // 키, 몸무게, 머리둘레값
    var height: String
    var weight: String
    var head: String
    
    var isNotChanged: Bool = false
    var isIncrement: Bool = false
    var isDecrement: Bool = false
    
    let notChangedColor = UIColor.rgb(r: 90, g: 91, b: 107)
    let incrementColor = UIColor.rgb(r: 79, g: 211, b: 205)
    let decrementColor = UIColor.rgb(r: 255, g: 117, b: 83)
    
    // 날짜 및 태어난 날로부터의 표시
    var registeredDate = Date()
    var daysFromBabyBirthDate: Int = 0
    
    // Position Index
    var lineIdx: Int = 0
    var rowIdx: Int = 0
    
    init(height: String,
         weight: String,
         head: String) {
        self.height = height
        self.weight = weight
        self.head = head
    }
    
}

class ABCD {
    
    var records: [BabyGrowthRecordHistory] = [
        
    
    ]
    
    
}
