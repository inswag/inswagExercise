//
//  GrowChartView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/11.
//

import UIKit

class GrowChartModel {
 
    var startPositionFromYAxisStart: CGPoint = .zero
    var endPositionFromYAxisStart: CGPoint = .zero
    
    var date: Date
    var value: Double
    
    init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
    
}

class GrowChart {
    
    var startDrawingYAxisPosition: CGFloat = .zero
    var endDrawingYAxisPosition: CGFloat = .zero
    
}

class GrowChartView: UIView {
    
    // MARK: Properties
    
    var datas: [GrowChartModel] = [
        GrowChartModel.init(date: Date().dateByAddingDays(0), value: 20.4),
        GrowChartModel.init(date: Date().dateByAddingDays(1), value: 40.4),
        GrowChartModel.init(date: Date().dateByAddingDays(2), value: 60.4),
        GrowChartModel.init(date: Date().dateByAddingDays(3), value: 80.4),
        GrowChartModel.init(date: Date().dateByAddingDays(4), value: 90.4)
    ]
    
    // MARK: Charts
    
    var chartYAxisUnit: [CGFloat] = [
        0, 20, 40, 60, 80, 100
    ]
    
    var chartYAxisPositions: [GrowChart] = []
    
    /* About Calculating Size For Chart */
    
    var fullWidth: CGFloat = .zero
    var fullHeight: CGFloat = .zero
    
    let chartOutsideTopPadding: CGFloat = 33
    let chartOutsideBottomPadding: CGFloat = 47
    let chartOutsideLeftPadding: CGFloat = 47
    let chartOutsideRightPadding: CGFloat = 20
    let chartItemWidth: CGFloat = 52
    
    
    /* About X Axis Position */
    
    var startXYAxisPosition: CGFloat = .zero
    
    var yAxisLineInterval: CGFloat = 50
    var yAxisLineHeight: CGFloat = 1
    
    
    /* Position */
    
    var yAxisStartPositions: [CGPoint] = [] // Ascending from 0
    
    var xAxisPositions: [CGPoint] = [] // Ascending from 0
    var itemPositions: [CGPoint] = []
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        /* Calculating Order
            1. Full Height
            2. Full Width
         */
        
        // 1.
        self.fullHeight = self.bounds.height
        // 2.
        self.fullWidth = self.getFullWidth()
        
        /* Draw order
            1. 라인 포지션 계산
            2. 영역 포지션 계산
            3. 평균 포지션 계산
            4. 아이 값 위치 포지션 계산
         
            5. 영역 -> 평균 -> 라인 -> 아이 값 위치 순서로 그리기
         */
        
        self.makeYAxisPosition()
        self.makeXAxisPosition()
        
        
    }
    
    // MARK: Draw
    
    private func drawYAxis() {
        let path = UIBezierPath()
        let dashPattern: [CGFloat] = [1, 5.0]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineCapStyle = .round
        
        path.move(to: maximumStartPoint)
        path.addLine(to: maximumXEndPoint)
        maximumDotColor.set()
        path.close()
        path.stroke()
        
        
    }
    
    // MARK: Y Axis
    
    // 차트에서 Y축 선을 그릴 좌표의 시작점을 구합니다.
    private func makeYAxisPosition() {
        self.yAxisStartPositions.removeAll()
        
        for (idx, _) in self.chartYAxisUnit.enumerated() {
            // X 좌표 시작점
            let xStartPosition: CGFloat = chartOutsideLeftPadding
            let yStartPosition: CGFloat = chartOutsideTopPadding + (yAxisLineHeight * CGFloat(idx)) + (yAxisLineInterval * CGFloat(idx))
            

            let position = CGPoint.init(x: xStartPosition,
                                        y: yStartPosition)
            self.yAxisStartPositions.append(position)
        }
        
        // Make Ascending Positions
        self.yAxisStartPositions.sort { $0.y > $1.y }
    }
    
    // MARK: X Axis
    
    private func makeXAxisPosition() {
        self.xAxisPositions.removeAll()
        
        guard let yStartPosition = yAxisPositions.first else { return }
        
        for i in 0..<self.datas.count {
            let yStartPosition = yStartPosition
            let xPositionStart = chartItemWidth * CGFloat(i)
            let xPositionEnd = xPositionStart + chartItemWidth
            
            let startPositionFromYAxisStart = CGPoint.init(x: yStartPosition.x + xPositionStart,
                                                           y: yStartPosition.y)
            let endPositionFromYAxisStart = CGPoint.init(x: yStartPosition.x + xPositionEnd,
                                                         y: yStartPosition.y)
            
            // 좌표 세팅
            self.datas[i].startPositionFromYAxisStart = startPositionFromYAxisStart
            self.datas[i].endPositionFromYAxisStart = endPositionFromYAxisStart
        }
    }
    
    
    // MARK: Util
    
    
    
}

// MARK: Calculating

extension GrowChartView {
    
    func getFullWidth() -> CGFloat {
        let itemCount = self.datas.count
        return chartOutsideLeftPadding + chartOutsideRightPadding + (chartItemWidth * CGFloat(itemCount))
    }
    
}
