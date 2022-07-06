//
//  BigChartIndexView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/06.
//

import UIKit

class YAxisLineStartPositions {
    var position: CGPoint
    var isBold: Bool
    
    init(position: CGPoint, isBold: Bool) {
        self.position = position
        self.isBold = isBold
    }
}

class BigChartIndexView: UIView {
    

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
    let fullWidth: CGFloat = 37
    
    /* Position */
    var xAxisStartPositions: [CGPoint] = []
    
    var yAxisLineStartPositions: [YAxisLineStartPositions] = []
    
    /* Color Area */
    let boldNumberColor = UIColor.rgb(r: 132, g: 142, b: 150)
    let normalNumberColor = UIColor.rgb(r: 207, g: 212, b: 218)

    let weakAreaColor = UIColor.rgb(r: 255, g: 183, b: 192)
    let boundaryAreaColor = UIColor.rgb(r: 255, g: 228, b: 109)
    let normalAreaColor = UIColor.rgb(r: 200, g: 222, b: 255)
    
    /* Number Area */
    let numberRange: [Int] = [
        0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 64, 68, 72
    ]
    
    /* Item Area */
    let items = [
        BabyDevelopmentItem.init(name: "전체\n발달", description: "전체발달"),
        BabyDevelopmentItem.init(name: "표현\n언어", description: "표현언어"),
        BabyDevelopmentItem.init(name: "언어\n이해", description: "언어이해"),
        BabyDevelopmentItem.init(name: "글자", description: "글자"),
        BabyDevelopmentItem.init(name: "숫자", description: "숫자"),
        BabyDevelopmentItem.init(name: "대근육", description: "대근육"),
        BabyDevelopmentItem.init(name: "소근육", description: "소근육"),
        BabyDevelopmentItem.init(name: "자조", description: "자조"),
        BabyDevelopmentItem.init(name: "사회성", description: "사회성")
    ]
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .white
        self.makeXAxisLine()
//        self.makeYAxisLine()
        /* makeItem()' must be executed after makeYAxisLine() */
        self.makeIndex()
    }
    
    // MARK: Index
    
    public func makeIndex() {
        let leftPadding: CGFloat = 10
        let viewLeftPadding: CGFloat = 6
        let viewRightPadding: CGFloat = 4
        let viewWidth: CGFloat = 27
        
        guard yAxisLineStartPositions.count == numberRange.count else {
            return
        }
        
        for (idx, item) in self.yAxisLineStartPositions.reversed().enumerated() {
            let selectedItem = numberRange[idx]
            
            if item.isBold {
                // 볼드체 사이즈
                
            } else {
                // 일반 사이즈
                
            }
            
        
            let getItemSize = self.getLabelSize(
                text: "\(selectedItem)",
                font: Font.poppins(type: "Bold", size: 13.0))
            
            let indexX = item.position.x + leftPadding
            let indexY = item.position.y - (getItemSize.height / 2)
            let indexPosition = CGPoint.init(x: indexX, y: indexY)
            let indexSize = CGSize.init(width: viewWidth,
                                        height: getItemSize.height)
            
            let frame = CGRect.init(origin: indexPosition,
                                    size: indexSize)
            
            
            let view = UIView.init(frame: frame)
            view.backgroundColor = .white
            self.addSubview(view)
            
            let lb = UILabel()
            lb.font = Font.poppins(type: "Bold", size: 13.0)
            lb.textColor = UIColor.rgb(r: 60, g: 60, b: 60)
            lb.numberOfLines = 0
            lb.textAlignment = .left
            lb.text = "\(selectedItem)"
            
            view.addSubview(lb)
            lb.anchor(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: viewLeftPadding, paddingBottom: 0, paddingRight: viewRightPadding, width: 0, height: 0)
            lb.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            
            
        }
    }
    
    // MARK: ITEM
    
    public func makeItem() {
        for (idx, item) in self.xAxisStartPositions.enumerated() {
            if idx == items.count {
                break
            }
            
            
            let selectedItem = items[idx]
            
            let halfXPosition = item.x + (itemWidth / 2)
            let contentSize = selectedItem.makeItemSize()
            let halfSize = contentSize.width / 2
            
            let padding: CGFloat = 12
            
            let resultXPoint = halfXPosition - halfSize
            let resultYPoint = item.y + padding
            
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
    
    
    
    // MARK: X Axis
    
    public func makeXAxisLine() {
        self.yAxisLineStartPositions.removeAll()
        
        for (idx, item) in numberRange.reversed().enumerated() {
            if item % boldNumber == 0 {
                // 굵은 선 처리
                self.makeXAxisBoldLine(idx: idx,
                                       number: item)
            } else if item % normalNumber == 0 {
                // 일반 선 처리
                self.makeXAxisNormalLine(idx: idx,
                                         number: item)
            } else {
                continue
            }
        }
    }
    
    private func makeXAxisBoldLine(idx: Int, number: Int) {
        let xStartPosition: CGFloat = 0
        let xEndPosition: CGFloat = fullWidth
    
        let yPosition: CGFloat = topPadding + (lineHeight * CGFloat(idx)) + (lineInterval * CGFloat(idx))
        
        let position = CGPoint.init(x: xStartPosition, y: yPosition)
        let model = YAxisLineStartPositions.init(position: position, isBold: true)
        self.yAxisLineStartPositions.append(model)
        
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint.init(x: xStartPosition, y: yPosition))
        path.addLine(to: CGPoint.init(x: xEndPosition, y: yPosition))
        boldNumberColor.set()
        path.close()
        path.stroke()
    }
    
    private func makeXAxisNormalLine(idx: Int, number: Int) {
        let xStartPosition: CGFloat = 0
        let xEndPosition: CGFloat = fullWidth

        let yPosition: CGFloat = topPadding + (lineHeight * CGFloat(idx)) + (lineInterval * CGFloat(idx))
        
        let position = CGPoint.init(x: xStartPosition, y: yPosition)
        let model = YAxisLineStartPositions.init(position: position, isBold: false)
        self.yAxisLineStartPositions.append(model)
        
        
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint.init(x: xStartPosition, y: yPosition))
        path.addLine(to: CGPoint.init(x: xEndPosition, y: yPosition))
        normalNumberColor.set()
        path.close()
        path.stroke()
    }
    
    // MARK: Y Axis
    
    public func makeYAxisLine() {
        self.xAxisStartPositions.removeAll()
        
        for (idx, item) in numberRange.reversed().enumerated() {
            self.makeYAxisNormalLine(idx: idx, item: item)
        }
    }
    
    private func makeYAxisNormalLine(idx: Int, item: Int) {
        // X좌표는 동적으로, y시작점과 끝점은 정적
        let xStartPosition: CGFloat = yAxisLeftPadding + lineWidth + (itemWidth * CGFloat(idx)) + (lineWidth * CGFloat(idx))
        let yStartPosition: CGFloat = topPadding + lineHeight
        let yEndPosition: CGFloat = 518
        
        // X축의 시작 좌표를 저장
        let xAxisStartPosition = CGPoint.init(x: xStartPosition,
                                              y: yEndPosition)
        self.xAxisStartPositions.append(xAxisStartPosition)
        
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint.init(x: xStartPosition, y: yStartPosition))
        path.addLine(to: CGPoint.init(x: xStartPosition, y: yEndPosition))
        normalNumberColor.set()
        path.close()
        path.stroke()
    }
    
    public func getLabelSize(text: String, font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = font
        label.sizeToFit()
        return label.frame.size
    }
    
}

