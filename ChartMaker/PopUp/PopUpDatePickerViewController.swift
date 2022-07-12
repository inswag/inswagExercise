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
