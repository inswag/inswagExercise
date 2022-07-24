//
//  PopUpDatePickerViewController.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/12.
//

import UIKit

class PopUpDatePickerViewController: UIViewController {

    //
    
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var dayPickerView: UIPickerView!
    
    //
    
    var selectedDate: Date?
    
    var currentYear: Int = 2010
    var currentMonth: Int = 1
    var currentDay: Int = 1
    
    var numberOfDayInMonth: Int = 0
    
    let yearArr: [Int] = [
        2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022
    ]
    
    let monthArr: [Int] = [
        1,2,3,4,5,6,7,8,9,10,11,12
    ]
    
    var dayArr: [Int] = [
    
    ]
    
    //
    
    convenience init(selectedDate: Date) {
        self.init()
        self.selectedDate = selectedDate
    }
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        [yearPickerView,
         monthPickerView,
         dayPickerView].forEach {
            $0?.dataSource = self
            $0?.delegate = self
        }
        
        fillUI()
    }

    override func viewDidLayoutSubviews() {
        [yearPickerView,
         monthPickerView,
         dayPickerView].forEach {
            $0?.subviews[1].backgroundColor = .clear
        }
    }
    
    //
    
    private func fillUI() {
        if let selectedDate = selectedDate {
            // 기 선택한 날짜가 있을 때
            self.currentYear = selectedDate.year()
            self.currentMonth = selectedDate.month()
            self.currentDay = selectedDate.day()
            
            self.numberOfDayInMonth = selectedDate.numberOfDaysInMonth()
        } else {
            // 기 선택한 날짜가 없을 때
            let selectedDate = Date()
            self.currentYear = selectedDate.year()
            self.currentMonth = selectedDate.month()
            self.currentDay = selectedDate.day()
            
            self.numberOfDayInMonth = selectedDate.numberOfDaysInMonth()
        }
        
        self.insertDayArr(length: self.numberOfDayInMonth)
        self.reloadDay()
        
        // 날짜 세팅 후 맞춤 처리
        
        for (idx, item) in yearArr.enumerated() {
            if currentYear == item {
                self.yearPickerView.selectRow(idx,
                                              inComponent: 0,
                                              animated: true)
                break
            }
        }
        
        for (idx, item) in monthArr.enumerated() {
            if currentMonth == item {
                self.monthPickerView.selectRow(idx,
                                              inComponent: 0,
                                              animated: true)
                break
            }
        }
        
        for (idx, item) in dayArr.enumerated() {
            if currentDay == item {
                self.dayPickerView.selectRow(idx,
                                             inComponent: 0,
                                             animated: true)
                break
            }
        }
    }
    
    private func fillWithSelectedDate() {
        
    }
    
    //
    
    //
    
    private func reloadDay() {
        dayPickerView.reloadAllComponents()
        
    }
    

    private func insertDayArr(length: Int) {
        self.dayArr.removeAll()
        
        for i in 0..<length {
            self.dayArr.append(i+1)
        }
        
        print("Day count : ", self.dayArr.count)
    }

    @IBAction func finishSelectAction(_ sender: UIButton) {
        
        let yearSelectedRow = self.yearPickerView.selectedRow(inComponent: 0)
        let monthSelectedRow = self.monthPickerView.selectedRow(inComponent: 0)
        let daySelectedRow = self.dayPickerView.selectedRow(inComponent: 0)
        
        let currentYear = self.yearArr[yearSelectedRow]
        let currentMonth = self.monthArr[monthSelectedRow]
        let currentDay = self.dayArr[daySelectedRow]
        
        
        print("Current Value is \(currentYear)년 \(currentMonth)월 \(currentDay)일")
        
        
        
    }
    
}

extension PopUpDatePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case yearPickerView:
            return yearArr.count
        case monthPickerView:
            return monthArr.count
        case dayPickerView:
            return dayArr.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView,
                    widthForComponent component: Int) -> CGFloat {
        return 60
    }

    func pickerView(_ pickerView: UIPickerView,
                    rowHeightForComponent component: Int) -> CGFloat {
        return 59
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        let view = GrowthDateView.init()
        
        switch pickerView {
        case yearPickerView:
            view.fillUI(value: self.yearArr[row], category: .year)
            return view
        case monthPickerView:
            view.fillUI(value: self.monthArr[row], category: .month)
            return view
        case dayPickerView:
            view.fillUI(value: self.dayArr[row], category: .day)
            return view
        default:
            let view = UIView.init()
            return view
        }
    }

    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch pickerView {
        case yearPickerView:
            // Data Set
            self.currentYear = self.yearArr[row]
            
            // Picker Set
            var day = ""
            
            if currentMonth < 10 {
                day = "\(currentYear)-0\(currentMonth)-01 00:00:00"
            } else {
                day = "\(currentYear)-\(currentMonth)-01 00:00:00"
            }

            
            print("Day : ", day)
            
            let selectDateLength = Tools.customDate.convertStringToDate(time: day).numberOfDaysInMonth()
            self.insertDayArr(length: selectDateLength)
            self.reloadDay()
        case monthPickerView:
            // Data Set
            self.currentMonth = self.monthArr[row]
            
            // Picker Set
            var day = ""
            
            if currentMonth < 10 {
                day = "\(currentYear)-0\(currentMonth)-01 00:00:00"
            } else {
                day = "\(currentYear)-\(currentMonth)-01 00:00:00"
            }

            print("Day : ", day)
            
            let selectDateLength = Tools.customDate.convertStringToDate(time: day).numberOfDaysInMonth()
            self.insertDayArr(length: selectDateLength)
            self.reloadDay()
        case dayPickerView:
            // Data Set
            self.currentDay = self.dayArr[row]
            
        default:
            return
        }
    }

}

// MARK: Do NOT COPY

extension Date {
    
    func numberOfDaysInMonth() -> Int {
        let calendar = Calendar.current
        let days = (calendar as NSCalendar).range(of: NSCalendar.Unit.day,
                                                  in: NSCalendar.Unit.month,
                                                  for: self)
        return days.length
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.month, from: self)
        return dateComponent.month!
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.year, from: self)
        return dateComponent.year!
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = (calendar as NSCalendar).components(.day, from: self)
        return dateComponent.day!
    }
    
    
}
