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
            $0?.delegate = self
        }
    }

    //
    
    private func fillUI() {
        if let selectedDate = selectedDate {
            // 기 선택한 날짜가 있을 때
            
            
            
            
        } else {
            // 기 선택한 날짜가 없을 때
            let selectedDate = Date()
            selectedDate.year()
            selectedDate.month()
            
            
            let days = selectedDate.numberOfDaysInMonth()
            
        }
    }
    
    private func fillWithSelectedDate() {
        
    }
    
    //
    
    //
    
    private func reloadDate() {
        dayPickerView.reloadAllComponents()
    }
    


}

extension PopUpDatePickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView {
        case yearPickerView:
            
        case monthPickerView:
            
        case dayPickerView:
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case yearPickerView:
            
        case monthPickerView:
            
        case dayPickerView:
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
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
    
}
