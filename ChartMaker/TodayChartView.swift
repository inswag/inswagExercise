//
//  TodayChartView.swift
//  ChartMaker
//
//  Created by 박인수 on 2022/06/21.
//

import UIKit
import Foundation

class TodayChartDetail {
    
    var time: Int = 0
    var steps: Int = 0
    var isFirst: Bool = false
    var isSecond: Bool = false
    
    init() {
        
    }
    
    init(time: Int, steps: Int, isFirst: Bool, isSecond: Bool) {
        self.time = time
        self.steps = steps
        self.isFirst = isFirst
        self.isSecond = isSecond
    }
    
}

class TodayChartView: UIView {
    
    var todayChart: [TodayChartDetail] = [
        TodayChartDetail.init(time: 0, steps: 7845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 2, steps: 17845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 4, steps: 27845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 6, steps: 3845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 8, steps: 8845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 10, steps: 9845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 12, steps: 2845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 14, steps: 1845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 16, steps: 845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 18, steps: 4845, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 20, steps: 1245, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 22, steps: 90, isFirst: false, isSecond: false),
        TodayChartDetail.init(time: 24, steps: 0, isFirst: false, isSecond: false)
    ] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /* Properties */
    var isStartRedrawing: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // 최초 화면이 보였을 때만 애니메이션 보장
    var isFirstAnimatingFinished: Bool = false
    
    
    /* Chart Properties */
    let horizontalAxisLineWidth: CGFloat = 1 // X축 선 두께
    let yAxisTopPadding: CGFloat = 25        // y축 상단 여백
    let yAxisLeftPadding: CGFloat = 34       // y축 좌측 여백
    let xAxisBottomPadding: CGFloat = 25     // X축 하단 여백
    
    /* Chart Unit */
    let unit: String = "h"
    
    /* About Dot line */
    let averageDotColor = UIColor.rgb(r: 222, g: 226, b: 230)
    let maximumDotColor = UIColor.rgb(r: 222, g: 226, b: 230)
    
    /* Data */
    
    /* Animation */
    var barDuration: CGFloat = 0.5
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func insertData() {
        
    }
        
    /* Test */
    func makeTapGesture() {
        self.isUserInteractionEnabled = true
        let tapG = UITapGestureRecognizer.init(target: self,
                                               action: #selector(tapAction))
        self.addGestureRecognizer(tapG)
    }
    
    @objc func tapAction() {
        self.isStartRedrawing.toggle()
    }
    /* Test */
    
    /* Draw */
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers?.removeAll()
        
        /* Basic Configure
           - X Axis Unit
           - X Axis line
           - Y Axis Zero unit
           - XY Axis Unit
         */
        
        self.makeHorizontalAxis()   // X축 라인
        self.makeVerticalAxisZero() // Y축 최소값
        self.makeUnit()             // 단위 표기
        
        /* Maximum & Average Line + Bar Design */
        guard isStartRedrawing else { return }
        self.makeBar()
    }
    
    // MARK: About Content
    
    private func makeBar() {
        let rightPadding: CGFloat = 11              // 우측 여백
        let yAxisLeftExtraPadding: CGFloat = 9      // 좌측 추가 여백
        
        // 차트가 차지하는 총 너비
        let fullWidth = self.bounds.width - (yAxisLeftPadding + yAxisLeftExtraPadding) - rightPadding
        
        // 바 간격(8) & 바 간격이 차지하는 총 간격(모델 개수 - 1 = 12)
        let barSpacing: CGFloat = 8
        let fullSpacing = barSpacing * 12
        
        // 바가 시작되는 좌측 하단 시작 기준 점 설정
        let startX = yAxisLeftPadding + yAxisLeftExtraPadding
        let startY = self.bounds.height - xAxisBottomPadding
        
        // x축 선 높이 바로 위에 올 수 있게 1 & 전체 너비에서 전체 간격을 제외하고 모델의 갯수에 맞춰 나눠주면서 동적 너비 획득
        let xAxisLineWidth: CGFloat = 1
        let barWidth: CGFloat = (fullWidth - fullSpacing) / CGFloat(self.todayChart.count)
        
        let values = self.setDynamicFirstSecondAndGetMaxAvrgValue()
        
        if values.0 != 0 {
            // 최대값이 0인 경우에는 평균 및 최대 값을 그려줄 필요가 없다.
            if values.0 != 1 {
                self.makeMaximumDotLine()
                self.makeAverageDotLine()
                
                self.makeMaximumNum(from: "\(values.0)")
                self.makeAverageNum(from: "\(values.1)")
            } else {
                self.makeMaximumDotLine()
                self.makeMaximumNum(from: "\(values.0)")
            }
        }
        
        for (idx, item) in self.todayChart.enumerated() {
            let barHeight: CGFloat = self.getBarHeight(maxValue: values.0,
                                                       currentValue: item.steps)
            
            // steps -> 0 일때 처리가 필요하다.
            
            
            // 바의 X축 시작점을 구한다.
            let xAxisInterval = (barWidth + barSpacing) * CGFloat(idx)
            // X축 시작점을 통해 X축 Bar를 배치
            self.makeBar(startPosition: CGPoint.init(x: startX + xAxisInterval,
                                                     y: startY - xAxisLineWidth),
                         barWidth: barWidth,
                         barHeight: barHeight,
                         model: item)
        }
    }
    
    private func configureXAxisUnit() {
        let rightPadding: CGFloat = 11              // 우측 여백
        let yAxisLeftExtraPadding: CGFloat = 9      // 좌측 추가 여백
        
        // 차트가 차지하는 총 너비
        let fullWidth = self.bounds.width - (yAxisLeftPadding + yAxisLeftExtraPadding) - rightPadding
        
        // 바 간격(8) & 바 간격이 차지하는 총 간격(모델 개수 - 1 = 12)
        let barSpacing: CGFloat = 8
        let fullSpacing = barSpacing * 12
        
        // 바가 시작되는 좌측 하단 시작 기준 점 설정
        let startX = yAxisLeftPadding + yAxisLeftExtraPadding
        let startY = self.bounds.height - xAxisBottomPadding
        
        // x축 선 높이 바로 위에 올 수 있게 1 & 전체 너비에서 전체 간격을 제외하고 모델의 갯수에 맞춰 나눠주면서 동적 너비 획득
        let xAxisLineWidth: CGFloat = 1
        let barWidth: CGFloat = (fullWidth - fullSpacing) / CGFloat(self.todayChart.count)
        
        for (idx, item) in self.todayChart.enumerated() {
            // 바의 X축 시작점을 구한다.
            let xAxisInterval = (barWidth + barSpacing) * CGFloat(idx)
            // X축 시작점을 통해 X축 단위를 배치
            self.makeHorizontalAxisUnit(
                startPosition: CGPoint.init(x: startX + xAxisInterval,
                                            y: startY - xAxisLineWidth),
                barWidth: barWidth,
                unit: item.time)
        }
    }
    
    private func getBarHeight(maxValue: Int,
                              currentValue: Int) -> CGFloat {
        let xAxisLineWidth: CGFloat = 1
        let absoluteHeight: CGFloat = self.bounds.height - yAxisTopPadding - xAxisBottomPadding - xAxisLineWidth
        
        if currentValue == 0 {
            let emptyHeight: CGFloat = 5
            return emptyHeight
        } else {
            return ((absoluteHeight * CGFloat(currentValue)) / CGFloat(maxValue)) + 5
        }
    }
    
    private func makeBar(startPosition: CGPoint,
                         barWidth: CGFloat,
                         barHeight: CGFloat,
                         model: TodayChartDetail)  {
        
//        let bezier = UIBezierPath.init(
//            roundedRect: CGRect.init(origin: CGPoint.init(x: startPosition.x, y: startPosition.y - barHeight),
//                                     size: CGSize.init(width: barWidth, height: barHeight)),
//            byRoundingCorners: [.topLeft, .topRight],
//            cornerRadii: CGSize.init(width: 3, height: 3))

        let startLocations = [0, 0]
        let endLocations = [1, 1]

        let layer = CAGradientLayer()
        layer.frame = CGRect.init(origin: CGPoint.init(x: startPosition.x, y: startPosition.y - barHeight),
                                  size: CGSize.init(width: barWidth, height: barHeight))
        layer.locations = startLocations as [NSNumber]
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.cornerRadius = 3

        if model.isFirst {
            layer.colors = [UIColor.rgb(r: 199, g: 52, b: 255).cgColor,
                            UIColor.clear.cgColor]
            self.makeBarIndexCount(startPosition: startPosition,
                                   barWidth: barWidth,
                                   barHeight: barHeight,
                                   count: "\(model.steps)")
        }
        
        if model.isSecond {
            layer.colors = [UIColor.rgb(r: 237, g: 203, b: 245).cgColor,
                            UIColor.clear.cgColor]
        }
        
        if !model.isFirst && !model.isSecond {
            layer.colors = [UIColor.rgb(r: 231, g: 234, b: 236).cgColor,
                            UIColor.clear.cgColor]
        }
        
        self.layer.addSublayer(layer)
        
        /* Animation */
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = startLocations
        anim.toValue = endLocations
        anim.duration = barDuration
        
        layer.add(anim, forKey: "loc")
        layer.locations = endLocations as [NSNumber]
    }
    
    private func makeBarIndexCount(startPosition: CGPoint,
                                   barWidth: CGFloat,
                                   barHeight: CGFloat,
                                   count: String) {
        
        let textFont = Font.poppins(type: "SemiBoldItalic", size: 15.0)
        let textColor = UIColor.rgb(r: 199, g: 52, b: 255)
        
        let c = count as NSString
        
        let butes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont
        ]
        
        let size = self.getLabelSize(text: count, font: textFont)
        let padding: CGFloat = 2
        
        let at = CGPoint.init(x: startPosition.x + (barWidth / 2) - (size.width / 2),
                              y: startPosition.y - barHeight - padding - size.height)
        
        c.draw(at: at, withAttributes: butes)
    }
    
    
    private func setDynamicFirstSecondAndGetMaxAvrgValue() -> (Int, Int) {
        var total: Int = 0
        
        var first: Int = 0
        var secondCandidate: [Int] = []
        
        // Round 1. 전체 구하기 + 첫 번째 찾기 + 두번째 후보군 찾기
        for chart in self.todayChart {
            // 전체는 무조건
            total += chart.steps
            
            // 첫번째 찾기 + 순위가 밀릴 수 있으니 일단 두 번째 후보군에도 포함
            if chart.steps > first {
                first = chart.steps
                secondCandidate.append(chart.steps)
            } else {
                secondCandidate.append(chart.steps)
            }
        }
        
        // Round 2.첫 번째, 두 번째 확정하기
        // 오름차순으로 정렬
        var secondCandidates = secondCandidate.sorted(by: <)
        // 마지막은 1등이니 제거
        secondCandidates.removeLast()
        // 1등을 제거한 마지막이 2등이니 획득
        let candidate = secondCandidates.last ?? 0
        
        // 후보군 중 가장 높지만 첫번째와 겹치지 않게 주의
        for chart in self.todayChart {
            if chart.steps == first {
                if first != 0 {
                    chart.isFirst = true
                    continue
                }
            } else if chart.steps == candidate {
                if candidate != 0 {
                    chart.isSecond = true
                }
            }
        }
        
        return (first, (first / 2))
    }
    
    // MARK: About Horizontal Axis
    
    private func makeHorizontalAxis() {
        let xAxisStartPoint = CGPoint
            .init(x: yAxisLeftPadding,
                  y: self.bounds.height - xAxisBottomPadding)
        let xAxisEndYPoint = CGPoint
            .init(x: self.bounds.width,
                  y: self.bounds.height - xAxisBottomPadding)
        
        let path = UIBezierPath()
        path.move(to: xAxisStartPoint)
        path.addLine(to: xAxisEndYPoint)
        path.lineWidth = horizontalAxisLineWidth
        UIColor.rgb(r: 173, g: 181, b: 189).set()
        path.close()
        path.stroke()
        
        // X Axis Unit
        self.configureXAxisUnit()
    }
    
    private func makeAverageDotLine() {
        let averageStartPoint = CGPoint.init(x: yAxisLeftPadding,
                                             y: self.bounds.height / 2)
        let averageXEndPoint = CGPoint.init(x: self.bounds.width,
                                            y: self.bounds.height / 2)
        
        let path = UIBezierPath()
        let dashPattern: [CGFloat] = [1, 5.0]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineCapStyle = .round
        
        path.move(to: averageStartPoint)
        path.addLine(to: averageXEndPoint)
        averageDotColor.set()
        path.close()
        path.stroke()
    }
    
    private func makeMaximumDotLine() {
        let yAxisExtraPadding: CGFloat = 4
        let maximumStartPoint = CGPoint.init(x: yAxisLeftPadding,
                                             y: yAxisTopPadding + yAxisExtraPadding)
        let maximumXEndPoint = CGPoint.init(x: self.bounds.width,
                                            y: yAxisTopPadding + yAxisExtraPadding)
        
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
    
    private func makeAverageNum(from: String) {
        let textColor = UIColor.rgb(r: 155, g: 155, b: 155)
        let textFont = Font.poppins(type: "Regular", size: 12.0)
        
        let text = from as NSString
        
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        text.draw(at: CGPoint.init(x: 0, y: (self.bounds.height / 2) - 5),
                  withAttributes: butes)
    }
    
    private func makeMaximumNum(from: String) {
        let textColor = UIColor.rgb(r: 155, g: 155, b: 155)
        let textFont = Font.poppins(type: "Regular", size: 12.0)
        
        let text = from as NSString
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        text.draw(at: CGPoint.init(x: 0, y: yAxisTopPadding - 5),
                  withAttributes: butes)
    }
    
    /* 차트 단위 값 */
    private func makeHorizontalAxisUnit(startPosition: CGPoint,
                                        barWidth: CGFloat,
                                        unit: Int) {
        let bottomPadding: CGFloat = 9
        let startX = startPosition.x + (barWidth / 2)
        let startY = startPosition.y + bottomPadding
        
        let unit = "\(unit)" as NSString
        
        let textColor = UIColor.rgb(r: 155, g: 155, b: 155)
        let textFont = Font.poppins(type: "Regular", size: 12.0)
        
        let butes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont
        ]
        
        let size = self.getLabelSize(text: "\(unit)",
                                     font: textFont)
        
        let at = CGPoint.init(x: startX - (size.height / 2),
                              y: startY)
        
        unit.draw(at: at,
                  withAttributes: butes)
    }
    
    
    // MARK: About Vertical Axis
    
    /* 최소값 */
    private func makeVerticalAxisZero() {
        let textColor = UIColor.rgb(r: 155, g: 155, b: 155)
        let textFont = Font.poppins(type: "Regular", size: 12.0)
        
        let text = "0" as NSString
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        let adjustPadding: CGFloat = 5
        let xPoint: CGFloat = yAxisLeftPadding - 15
        let yPoint: CGFloat = bounds.height - xAxisBottomPadding - adjustPadding
        
        text.draw(at: CGPoint.init(x: xPoint,
                                   y: yPoint),
                  withAttributes: butes)
    }
    
    /* 단위값 */
    private func makeUnit() {
        let textColor = UIColor.rgb(r: 155, g: 155, b: 155)
        let textFont = Font.poppins(type: "Regular", size: 12.0)
        
        let text = self.unit as NSString
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        
        let xPoint: CGFloat = yAxisLeftPadding - 15
        let yPoint: CGFloat = bounds.height - 15
        
        text.draw(at: CGPoint.init(x: xPoint,
                                   y: yPoint),
                  withAttributes: butes)
    }
    
    // MARK: Helpful Methods
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = font
        label.sizeToFit()
//        print("\(font.fontName) frame size : ", label.frame.size)
//        print("\(font.fontName) bounds size : ", label.bounds.size)
        
        return label.frame.size
    }
    
    
    
}
