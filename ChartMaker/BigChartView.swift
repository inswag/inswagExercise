//
//  BigChartView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/06.
//

import UIKit

class AxisPosition {
    
    var startPoint: CGPoint = .zero
    var endPoint: CGPoint = .zero
    
    init(start: CGPoint, end: CGPoint) {
        self.startPoint = start
        self.endPoint = end
    }
    
}

class XAxisLinePosition: AxisPosition {
    
    var number: Int = 0
    var isBold: Bool = false
    let boldNumberColor = UIColor.rgb(r: 132, g: 142, b: 150)
    let normalNumberColor = UIColor.rgb(r: 207, g: 212, b: 218)
    
}

class YAxisLinePosition: AxisPosition {
    
}

/* 영역을 그리기 위한 클래스*/
class XAxisLinePositionByNumber: XAxisLinePosition {
    
    init(start: CGPoint, end: CGPoint, number: Int) {
        super.init(start: start, end: end)
        self.number = number
    }
    
}

class DevelopmentRange {
    
    var number: Int
    var color: UIColor
    
    init(number: Int, color: UIColor) {
        self.number = number
        self.color = color
    }
    
}

class DevelopmentLineGraph {
    
    var position: CGPoint = .zero
    
    var number: Int
    var color: UIColor
    
    init(number: Int, color: UIColor, position: CGPoint) {
        self.number = number
        self.color = color
        self.position = position
    }
    
}


class BigChartView: UIView {
    
    /* UI Components */
    let label: UILabel = {
        let lb = UILabel()
        lb.font = Font.poppins(type: "Bold", size: 13.0)
        lb.textColor = UIColor.rgb(r: 60, g: 60, b: 60)
        lb.numberOfLines = 0
        return lb
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage.init(named: "info")
        return iv
    }()
    
    
    let boldNumber: Int = 12
    let normalNumber: Int = 4
    let numberSpacing: Int = 0
    
    /* Common Layout */
    let fullHeight: CGFloat = 602
    let topPadding: CGFloat = 67
    let lineWidth: CGFloat = 1
    let lineHeight: CGFloat = 1
    let lineInterval: CGFloat = 24
    
    let itemWidth: CGFloat = 49
    
    /* About Axis */
    let yAxisLeftPadding: CGFloat = 36
    
    let rightPadding: CGFloat = 24
    let fullWidth: CGFloat = 492
    
    /* Position */
    var xAxisStartPositions: [CGPoint] = []
    
    /* Color Area */


//    let weakAreaColor = UIColor.rgb(r: 255, g: 183, b: 192)
//    let boundaryAreaColor = UIColor.rgb(r: 255, g: 228, b: 109)
//    let normalAreaColor = UIColor.rgb(r: 200, g: 222, b: 255)
    
    /* 영역을 그리기 위한 좌표 값 */

    var xAxisTopStartPosition: CGPoint = CGPoint.zero
    var xAxisTopEndPotion: CGPoint = CGPoint.zero
    
    /* Number Area */
    let numberRange: [Int] = [
        0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72
    ]
    
    /* Item Area */
    let items = [
        BabyDevelopmentItem.init(name: "전체\n발달", description: "전체발달", number: 68),
        BabyDevelopmentItem.init(name: "표현\n언어", description: "표현언어", number: 56),
        BabyDevelopmentItem.init(name: "언어\n이해", description: "언어이해", number: 62),
        BabyDevelopmentItem.init(name: "글자", description: "글자", number: 54),
        BabyDevelopmentItem.init(name: "숫자", description: "숫자", number: 10),
        BabyDevelopmentItem.init(name: "대근육", description: "대근육", number: 26),
        BabyDevelopmentItem.init(name: "소근육", description: "소근육", number: 34),
        BabyDevelopmentItem.init(name: "자조", description: "자조", number: 44),
        BabyDevelopmentItem.init(name: "사회성", description: "사회성", number: 49)
    ]

    let rangeItems = [
        DevelopmentRange
            .init(number: 12,
                  color: UIColor.rgb(r: 255, g: 183, b: 192)),
        DevelopmentRange
            .init(number: 24,
                  color: UIColor.rgb(r: 255, g: 228, b: 109)),
        DevelopmentRange
            .init(number: 50,
                  color: UIColor.rgb(r: 200, g: 222, b: 255)),
    ]
    
    /* About X Axis */
    
    // Position O Drawing O
    var xAxisLines: [XAxisLinePosition] = []
    // Position O But Drawing X
    var xAxisFullLinesByNumber: [XAxisLinePositionByNumber] = []
    // X Axis
    var xAxisBottomPosition: CGPoint = CGPoint.zero
    
    /* About Y Axis */
    
    // Position O Drawing O
    var yAxisLines: [YAxisLinePosition] = []
    // X Axis
    var yAxisBottomPosition: CGPoint = CGPoint.zero
    
    /* About Graph */
    var graphs: [DevelopmentLineGraph] = []
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .white
        
        /*
          먼저 포지션 획득한 후 그려야 한다.
         */
        
        self.makeXAxisLineModel()
        self.makeXAxisLineByNumberModel()
        self.makeYAxisLineModel()
        /* makeItem()' must be executed after makeYAxisLine() */
        self.makeItem()
        self.makeGraph()
        
        /*
          그리는 순서
         1. 범위 영역
         2. X축 Y축 및 하단 색인
         3. 꺾은 선
         4. 지점 원형 포인트
         
         */
        // 1
        self.drawRange()
        // 2
        self.drawXAxisLine()
        self.drawYAxisLine()
        // 3
        self.drawGraph()
        /* Test Area */
//        self.drawXAxisFullLine()
    }
    
    // MARK: Area
    
    public func makeGraph() {
        self.graphs.removeAll()
        
        for (idx, item) in self.yAxisLines.enumerated() {
            if idx == items.count {
                break
            }
            
            // 항목
            let selectedItem = items[idx]
            
            
            let halfXPosition = item.endPoint.x + (itemWidth / 2)
            
            for xAxisFullLinesByNumber in xAxisFullLinesByNumber {
                if selectedItem.number == xAxisFullLinesByNumber.number {
                    let yPosition = xAxisFullLinesByNumber.startPoint.y
                    
                    let model = DevelopmentLineGraph
                        .init(number: selectedItem.number,
                              color: UIColor.rgb(r: 205, g: 0, b: 255),
                              position: CGPoint.init(x: halfXPosition,
                                                     y: yPosition))
                    self.graphs.append(model)
                    break
                }
            }
        }
    }
    
    private func drawGraph() {
        print("Graph Count : ", self.graphs.count)
        
        let linePath = UIBezierPath()
        
        for (idx, item) in graphs.enumerated() {
            if idx == 0 {
                linePath.move(to: item.position)
            } else {
                linePath.addLine(to: item.position)
            }
            
            
        }
        
        linePath.lineWidth = 3
        UIColor.rgb(r: 205, g: 0, b: 255).set()
        linePath.stroke()
        
        for graph in graphs {
            
            let graphX = graph.position.x - 9
            let graphY = graph.position.y - 9
            let circlePosition = CGPoint.init(x: graphX, y: graphY)
            
            let glayer = CAGradientLayer()
            glayer.frame = CGRect.init(origin: circlePosition,
                                       size: CGSize.init(width: 18, height: 18))
            glayer.cornerRadius = 9
            glayer.type = .radial
            glayer.locations = [0, 0.5, 1]
            glayer.colors = [UIColor.rgb(r: 205, g: 0, b: 255).cgColor,
                             UIColor.rgb(r: 205, g: 0, b: 255, a: 0.8).cgColor,
                             UIColor.rgb(r: 205, g: 0, b: 255, a: 0.0).cgColor]
            glayer.startPoint = CGPoint.init(x: 0.5, y: 0.5)
            glayer.endPoint = CGPoint.init(x: 1, y: 1)
            layer.addSublayer(glayer)
        }
    }
    
    // MARK: About X Axis
    
    public func makeXAxisLineModel() {
        self.xAxisLines.removeAll()
        
        for (idx, item) in numberRange.reversed().enumerated() {
            if item % boldNumber == 0 {
                // 굵은 선 처리
                self.makeXAxisLinePosition(isBold: true, idx: idx, number: item)
            } else if item % normalNumber == 0 {
                // 일반 선 처리
                self.makeXAxisLinePosition(isBold: false, idx: idx, number: item)
            } else {
                continue
            }
        }
    }
    
    private func makeXAxisLinePosition(isBold: Bool, idx: Int, number: Int) {
        let xStartPosition: CGFloat = 0
        let xEndPosition: CGFloat = fullWidth
    
        let yPosition: CGFloat = topPadding + (lineHeight * CGFloat(idx)) + (lineInterval * CGFloat(idx))
        
        let start = CGPoint.init(x: xStartPosition, y: yPosition)
        let end = CGPoint.init(x: xEndPosition, y: yPosition)
        
        let model = XAxisLinePosition.init(start: start,
                                           end: end)
        model.isBold = isBold
        self.xAxisLines.append(model)
        
        if idx == (numberRange.count - 1) {
            self.xAxisBottomPosition = CGPoint.init(x: xStartPosition + yAxisLeftPadding,
                                                    y: yPosition)
        }
    }
    
    private func makeXAxisLineByNumberModel() {
        self.xAxisFullLinesByNumber.removeAll()
        
        for (idx, item) in numberRange.enumerated() {
            if idx != numberRange.count - 1 {
                // 0 밑으로 내려가는 것 방지
                for i in 0...3 {
                    self.makeXAxisLineByNumberPosition(idx: idx,
                                                       subIdx: i,
                                                       number: item)
                }
            }
        }
    }
    
    private func makeXAxisLineByNumberPosition(idx: Int, subIdx: Int, number: Int) {
        let xStartPosition: CGFloat = 0
        let xEndPosition: CGFloat = fullWidth

        let extraY: CGFloat = (lineInterval / CGFloat(4)) * CGFloat(subIdx)
        let yPosition: CGFloat = xAxisBottomPosition.y - ((lineHeight * CGFloat(idx)) + (lineInterval * CGFloat(idx)) + extraY)
        
        let start = CGPoint.init(x: xStartPosition, y: yPosition)
        let end = CGPoint.init(x: xEndPosition, y: yPosition)
        

        let model = XAxisLinePositionByNumber.init(start: start,
                                                   end: end,
                                                   number: number + subIdx)
        self.xAxisFullLinesByNumber.append(model)
    }
    
    // MARK: About Y Axis
    
    public func makeYAxisLineModel() {
        self.yAxisLines.removeAll()
        
        for (idx, item) in numberRange.reversed().enumerated() {
            self.makeYAxisLinePosition(idx: idx, item: item)
        }
    }
    
    private func makeYAxisLinePosition(idx: Int, item: Int) {
        // X Axis is Dynamic, Y Axis is Static
        let xStartPosition: CGFloat = yAxisLeftPadding + lineWidth + (itemWidth * CGFloat(idx)) + (lineWidth * CGFloat(idx))
        let yStartPosition: CGFloat = topPadding + lineHeight
        
        let yEndPosition: CGFloat = xAxisBottomPosition.y
        
        let start = CGPoint.init(x: xStartPosition, y: yStartPosition)
        let end = CGPoint.init(x: xStartPosition, y: yEndPosition)
        
        let model = YAxisLinePosition.init(start: start, end: end)
        self.yAxisLines.append(model)
    }
    
    // MARK: Index Item
    
    public func makeItem() {
        for (idx, item) in self.yAxisLines.enumerated() {
            if idx == items.count {
                break
            }
            
            let halfXPosition = item.endPoint.x + (itemWidth / 2)
            
            let selectedItem = items[idx]
            let contentSize = selectedItem.makeItemSize()
            let halfSize = contentSize.width / 2
            
            let padding: CGFloat = 12
            
            let resultXPoint = halfXPosition - halfSize
            let resultYPoint = item.endPoint.y + padding
            
            let resultPoint = CGPoint.init(x: resultXPoint, y: resultYPoint)
            
            /* Components */
            let rect = CGRect.init(origin: resultPoint, size: contentSize)
            let view = UIView.init(frame: rect)
            self.addSubview(view)
            
            let lb = UILabel()
            lb.font = Font.poppins(type: "Bold", size: 13.0)
            lb.textColor = UIColor.rgb(r: 60, g: 60, b: 60)
            lb.numberOfLines = 0
            lb.textAlignment = .center
            lb.text = selectedItem.name
            
            let iv = UIImageView()
            iv.image = UIImage.init(named: "info")
            
            view.addSubview(lb)
            view.addSubview(iv)
            
            lb.anchor(top: view.topAnchor, left: view.leftAnchor,
                      bottom: nil, right: view.rightAnchor,
                      paddingTop: 0, paddingLeft: 0,
                      paddingBottom: 0, paddingRight: 0,
                      width: 0, height: 0)
            iv.anchor(top: lb.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
            iv.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    // MARK: Drawing
    
    private func drawRange() {
        for range in rangeItems.reversed() {
            for data in xAxisFullLinesByNumber {
                if range.number == data.number {
                    // Make Rectangle
                    let leftBottomPoint = xAxisBottomPosition
                    let leftTopPoint = CGPoint.init(x: data.startPoint.x + yAxisLeftPadding, y: data.startPoint.y)
                    let rightBottomPoint = CGPoint.init(x: fullWidth,
                                                        y: xAxisBottomPosition.y)
                    let rightTopPoint = data.endPoint
                    
                    let path = UIBezierPath()
                    path.move(to: leftBottomPoint)
                    path.addLine(to: leftTopPoint)
                    path.addLine(to: rightTopPoint)
                    path.addLine(to: rightBottomPoint)
                    range.color.setFill()
                    path.fill()
                    path.close()
                }
            }
        }
    }
    
    private func drawXAxisLine() {
        for xAxisLine in xAxisLines {
            
            let path = UIBezierPath()
            path.lineWidth = 1
            path.move(to: xAxisLine.startPoint)
            path.addLine(to: xAxisLine.endPoint)
            
            if xAxisLine.isBold {
                xAxisLine.boldNumberColor.set()
            } else {
                xAxisLine.normalNumberColor.set()
            }
            
            path.close()
            path.stroke()
        }
    }
    
    /* For Line Test */
    private func drawXAxisFullLine() {
        for xAxisFullLine in xAxisFullLinesByNumber {
            let path = UIBezierPath()
            path.lineWidth = 1
            path.move(to: xAxisFullLine.startPoint)
            path.addLine(to: xAxisFullLine.endPoint)
            
            xAxisFullLine.normalNumberColor.set()
            
            path.close()
            path.stroke()
        }
    }
    
    private func drawYAxisLine() {
        for yAxisLine in yAxisLines {
            let path = UIBezierPath()
            path.lineWidth = 1
            path.move(to: yAxisLine.startPoint)
            path.addLine(to: yAxisLine.endPoint)
            UIColor.rgb(r: 207, g: 212, b: 218).set()
            path.close()
            path.stroke()
        }
    }
    
    // MARK: Util
    
    public func getLabelSize(text: String, font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = font
        label.sizeToFit()
        return label.frame.size
    }
    
}

class BabyDevelopmentItem {
    
    var name: String
    var description: String
    var number: Int = 0
    
    init(name: String, description: String, number: Int) {
        self.name = name
        self.description = description
        self.number = number
    }
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    public func makeItemSize() -> CGSize {
        let labelSize = getLabelSize(text: name,
                                     font: Font.poppins(type: "Bold", size: 15.0))
        let padding: CGFloat = 4
        let imageHeight: CGFloat = 20
        let size = CGSize.init(width: labelSize.width,
                               height: labelSize.height + imageHeight + padding)
        return size
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
