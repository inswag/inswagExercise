//
//  GrowthDateView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/12.
//

import UIKit

class GrowthDateView: UIView {
    
    //
    
    enum GrowthDateCategory {
        case year
        case month
        case day
    }
    
    //
    
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed("GrowthDateView",
                                            owner: self,
                                            options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //
    
    func fillUI(value: Int, category: GrowthDateCategory) {
        switch category {
        case .year:
            self.dateLabel.text = "\(value)" + "년"
        case .month:
            self.dateLabel.text = "\(value)" + "월"
        case .day:
            self.dateLabel.text = "\(value)" + "일"
        }
    }
    
}
