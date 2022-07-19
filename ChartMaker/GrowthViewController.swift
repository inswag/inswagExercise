//
//  GrowthViewController.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/19.
//

import UIKit

class GrowthViewController: UIViewController {

    //
    @IBOutlet weak var growChart: GrowChartView!
    @IBOutlet weak var growChartWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIView.animate(withDuration: 0.2) {
            self.growChartWidth.constant = self.growChart.getFullWidth()
            self.growChart.setNeedsDisplay()
        }
    }

    //
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
