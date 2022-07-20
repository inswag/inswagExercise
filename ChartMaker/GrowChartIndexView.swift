//
//  GrowChartIndexView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/11.
//

import UIKit

class GrowChartIndexView: UIView {
    
    /* About Axis */
    let yAxisLeftPadding: CGFloat = 36

    
    /* Position */
    var xAxisStartPositions: [CGPoint] = []
    
    var yAxisLineStartPositions: [YAxisLineStartPositions] = []
    var yAxisLineInterval: CGFloat = .zero
    var yAxisLineHeight: CGFloat = 1


    /* Number Area */
    var chartYAxisUnit: [CGFloat] = [
        0, 20, 40, 60, 80, 100
    ]
    
    /* Item Area */
    var yAxisStartPositions: [CGPoint] = [] // Ascending from 0
    
    /* About Calculating Size For Chart */
    let fullWidth: CGFloat = 47
    var fullHeight: CGFloat = .zero
    
    let chartOutsideTopPadding: CGFloat = 33
    let chartOutsideBottomPadding: CGFloat = 47
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .white
        
        self.fullHeight = self.bounds.height

        self.makeYAxisPosition()    // 차트의 Y축 좌표
        self.drawYAxisUnit()    // Y축 단위 생성
    }
    
    private func drawYAxisUnit() {
        for (idx, position) in yAxisStartPositions.enumerated() {
            let leftIdxPadding: CGFloat = 16
            
            
            let size = self.getLabelSize(text: "\(Int(chartYAxisUnit[idx]))",
                                         font: Font.poppins(type: "Medium", size: 13.0))
            
            let startX = position.x + leftIdxPadding
            let startY = position.y - (size.height / 2)
            
            self.makeItem(itemColor: UIColor.rgb(r: 90, g: 91, b: 107),
                          itemFont: Font.poppins(type: "Medium", size: 13.0),
                          from: "\(Int(chartYAxisUnit[idx]))",
                          at: CGPoint.init(x: startX, y: startY))
        }
    }
    
    private func makeItem(itemColor: UIColor,
                          itemFont: UIFont,
                          from: String,
                          at: CGPoint) {
        let textColor = itemColor
        let textFont = itemFont
        
        let text = from as NSString
        
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        text.draw(at: at,
                  withAttributes: butes)
    }
    
    // MARK: Y Axis
    
    // 차트에서 Y축 선을 그릴 좌표의 시작점을 구합니다.
    private func makeYAxisPosition() {
        self.yAxisStartPositions.removeAll()
        
        // Dynamic Item Height
        self.makeDynamicYAxisInterval(idx: self.chartYAxisUnit.count - 1)
        
        // 스크롤뷰가 필요한지 여부 필요
        
        for (idx, _) in self.chartYAxisUnit.enumerated() {
            // X 좌표 시작점
            let xStartPosition: CGFloat = .zero
            let yStartPosition: CGFloat = chartOutsideTopPadding + (yAxisLineHeight * CGFloat(idx)) + (yAxisLineInterval * CGFloat(idx))
            

            let position = CGPoint.init(x: xStartPosition,
                                        y: yStartPosition)
            self.yAxisStartPositions.append(position)
        }
        
        // Make Ascending Positions
        self.yAxisStartPositions.sort { $0.y > $1.y }
    }
    
    // Y축 선 간격을 구합니다.
    private func makeDynamicYAxisInterval(idx: Int) {
        let totalLineHeight = CGFloat(idx) * yAxisLineHeight
        let totalDynamicInterval = fullHeight - chartOutsideTopPadding - chartOutsideBottomPadding - totalLineHeight
        self.yAxisLineInterval = totalDynamicInterval / CGFloat(self.chartYAxisUnit.count - 1)
    }
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = font
        label.sizeToFit()
        return label.frame.size
    }
    
}


