//
//  GrowChartView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/11.
//

import UIKit

class GrowChartView: UIView {
    
    /* About Calculating Size */
    
    let fullHeight: CGFloat = 419
    let topPadding: CGFloat = 33
    
    let leftPadding: CGFloat = 47
    
    var fullWidthAddedByCalcalating: CGFloat = .zero
    
    /* About X Axis Position */
    
    var startXYAxisPosition: CGFloat = .zero
    
    var yAxisLineInterval: CGFloat = 50
    var yAxisLineHeight: CGFloat = 1
    
    
    /* Position */
    
    var yAxisPositions: [CGPoint] = []
    var xAxisPositions: [CGPoint] = []
    var itemPositions: [CGPoint] = []
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        /* Draw order
            1. 라인 포지션 계산
            2. 영역 포지션 계산
            3. 평균 포지션 계산
            4. 아이 값 위치 포지션 계산
         
            5. 영역 -> 평균 -> 라인 -> 아이 값 위치 순서로 그리기
         */
        
        self.makeYAxisPosition()
        
    }
    
    // MARK: Y Axis
    
    private func makeYAxisPosition() {
        self.yAxisPositions.removeAll()
        
        for i in 0...5 {
            let xStartPosition: CGFloat = leftPadding
            let yStartPosition: CGFloat = topPadding + (yAxisLineHeight * CGFloat(i)) + (yAxisLineInterval * CGFloat(i))
            
            let position = CGPoint.init(x: xStartPosition,
                                        y: yStartPosition)
            self.yAxisPositions.append(position)
        }
    }
    
    // MARK: Util
    
    
    
}
