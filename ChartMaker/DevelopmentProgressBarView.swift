//
//  DevelopmentProgressBarView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/24.
//

import UIKit

class DevelopmentProgressBarView: UIView {
    
    let barColor: UIColor = UIColor.rgb(r: 246, g: 216, b: 255)
    let barBgColor: UIColor = .white
    let barBgBorderColor: UIColor = UIColor.rgb(r: 228, g: 228, b: 228)
    
    
    /* About Bar Drawing */
    
    let barHeight: CGFloat = 16
    let barRadius: CGFloat = 8
    
    let barTopPadding: CGFloat = 22
    let barLeftPadding: CGFloat = 76
    let barRightPadding: CGFloat = 84
    
    var barRect: CGRect = .zero
    
    /* Frame */
//    let fullWidth
    let fullHeight: CGFloat = 38
    
    /* About Keyword */
    
    let keywordLeftPadding: CGFloat = 20
    var keywordCenterY: CGFloat = .zero
    
    var progress: CGFloat = 0.5 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
//        guard isCategorySet else { return }
        
        /* Draw Order
            1. Border Line
            2. progressView
            3. averageLine
         
         */
        
        self.backgroundColor = UIColor.rgb(r: 250, g: 250, b: 250)
        
        self.makeBorderLine()
        self.makeProgress()
        self.makeAverageDotLine()
    }
    
    private func makeBorderLine() {
        // 깔끔하지 않은 Radius 부분을 Mask 로 해결 -> 전체가 mask 되는 문제 있어 제거
//        let bgMask = CAShapeLayer()
        
        let barRect = CGRect
            .init(x: .zero,
                  y: self.barTopPadding,
                  width: self.bounds.width,
                  height: self.fullHeight - barTopPadding)
//        bgMask.path = UIBezierPath.init(roundedRect: barRect,
//                                        cornerRadius: barHeight / 2).cgPath
//        layer.mask = bgMask
        
        let path = UIBezierPath.init(roundedRect: barRect,
                                     cornerRadius: barHeight / 2)
        UIColor.rgb(r: 228, g: 228, b: 228).set()
        path.stroke()
        
        self.barRect = barRect
        self.keywordCenterY = self.barTopPadding + (self.barHeight / 2)
    }
   
    
    private func makeProgress() {
        // 애니메이션이 필요하다면 CALayer 가 필요
//        let progressRect = CGRect.init(origin: .zero,
//                                       size: CGSize.init(width: rect.width * progress,
//                                                         height: rect.height))
//        let progressLayer = CALayer()
//        progressLayer.frame = progressRect
//        layer.addSublayer(progressLayer)
//        progressLayer.backgroundColor = self.barColor.cgColor
        
        if progress > 0 {
            let rect = CGRect.init(x: barRect.minX,
                                   y: barRect.minY,
                                   width: barRect.width * progress,
                                   height: barRect.height)
            let path = UIBezierPath.init(roundedRect: rect,
                                         cornerRadius: rect.height / 2)
            barColor.setFill()
            path.close()
            path.fill()
        } else {
//            let rect = CGRect.init(origin: .zero,
//                                   size: CGSize.init(width: rect.height,
//                                                     height: rect.height))
//
//            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.height / 2)
//            barColor.setFill()
//            path.close()
//            path.fill()
        }
    }
    
    private func makeAverageDotLine() {
        let centerX = self.barRect.width / 2
        
        let averageStartPoint = CGPoint.init(x: centerX - 0.5,
                                             y: self.barRect.minY - 1)
        let averageXEndPoint = CGPoint.init(x: centerX - 0.5,
                                            y: self.barRect.maxY)
        
        let path = UIBezierPath()
        let dashPattern: [CGFloat] = [1, 5.0]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineCapStyle = .round
        
        path.move(to: averageStartPoint)
        path.addLine(to: averageXEndPoint)
        UIColor.rgb(r: 205, g: 0, b: 255).set()
        path.close()
        path.stroke()
        
        // Making Text
        let averageTextSize = self.getLabelSize(text: "평균",
                                                font: Font.poppins(type: "Bold",
                                                                   size: 11.0))
        
        let startPoint = CGPoint
            .init(x: centerX - (averageTextSize.width / 2),
                  y: .zero)
        
        self.makeItem(startPoint: startPoint,
                      text: "평균")
    }
    
    /* 단위 표시 2 */
    func makeItem(startPoint: CGPoint, text: String) {
        let textColor = UIColor.rgb(r: 60, g: 60, b: 60)
        let textFont = Font.poppins(type: "Bold",
                                    size: 11.0)
        
        let from = text as NSString
        
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]

        from.draw(at: startPoint,
                  withAttributes: butes)
    }
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = font
        label.sizeToFit()
//        print("\(font.fontName) frame size : ", label.frame.size)
//        print("\(font.fontName) bounds size : ", label.bounds.size)

        return label.frame.size
    }
    
}
