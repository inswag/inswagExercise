//
//  DevelopmentProgressView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/11.
//

import UIKit

class DevelopmentProgressView: UIView {
    
    // MARK: abcd
    
    enum DevProgressCategory {
        case height
        case weight
        case head
    }
    
    /* Color */
    
    let barColor: UIColor = UIColor.rgb(r: 246, g: 216, b: 255)
    let barBgColor: UIColor = .white
    let barBgBorderColor: UIColor = UIColor.rgb(r: 228, g: 228, b: 228)
    
    
    /* About Bar Drawing */
    
    let barHeight: CGFloat = 16
    let barRadius: CGFloat = 8
    
    let barTopPadding: CGFloat = 22
    let barLeftPadding: CGFloat = 76
    let barRightPadding: CGFloat = 84
    
    /* Frame */
    let fullWidth = UIScreen.main.bounds.width
    let fullHeight: CGFloat = 38
    
    /* About Keyword */
    
    let keywordLeftPadding: CGFloat = 20
    var keywordCenterY: CGFloat = .zero
    
    //
    
    
    /* Categories */
    var category: DevProgressCategory = .height {
        didSet {
            isCategorySet = true
        }
    }
    
    var isCategorySet: Bool = false {
        didSet {
            if isCategorySet {
                self.setNeedsDisplay()
            }
        }
    }
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        guard isCategorySet else { return }
        
        /* Draw Order
            1. Border Line
            2. progressView
            3. averageLine
         
         */
        
        self.makeBorderLine(rect)
        
        self.makeProgress(rect)
        
        self.makeAverageDotLine(rect)
        
        self.makeKeyword()
        
        self.makePercent()
    }
    
    private func makeKeyword() {
        var size: CGSize = .zero
        
        switch self.category {
        case .height:
            size = self.getLabelSize(text: "키", font: Font.poppins(type: "Bold", size: 13.0))
            
            let startPosition = CGPoint.init(x: self.keywordLeftPadding,
                                             y: self.keywordCenterY - (size.height / 2))
            self.makeItem(startPoint: startPosition, text: "키")
        case .weight:
            size = self.getLabelSize(text: "몸무게", font: Font.poppins(type: "Bold", size: 13.0))
            
            let startPosition = CGPoint.init(x: self.keywordLeftPadding,
                                             y: self.keywordCenterY - (size.height / 2))
            self.makeItem(startPoint: startPosition, text: "몸무게")
        case .head:
            size = self.getLabelSize(text: "머리둘레", font: Font.poppins(type: "Bold", size: 13.0))
            
            let startPosition = CGPoint.init(x: self.keywordLeftPadding,
                                             y: self.keywordCenterY - (size.height / 2))
//            self.makeItem(startPoint: startPosition, text: "머리둘레")
            
            self.makeItem(from: "머리둘레", at: startPosition)
        }
    }
    
    private func makeItem(from: String, at: CGPoint) {
        let textColor = UIColor.rgb(r: 60, g: 60, b: 60)
        let textFont = Font.poppins(type: "Medium", size: 13.0)
        
        let text = from as NSString
        
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        text.draw(at: at,
                  withAttributes: butes)
    }
    
    private func makePercent() {
        
    }
    
    private func makeBorderLine(_ rect: CGRect) {
        // 깔끔하지 않은 Radius 부분을 Mask 로 해결
        let bgMask = CAShapeLayer()
        
        let barRect = CGRect
            .init(x: self.barLeftPadding,
                  y: self.barTopPadding,
                  width: self.fullWidth - self.barLeftPadding - self.barRightPadding,
                  height: self.barHeight)
        
        bgMask.path = UIBezierPath.init(roundedRect: barRect,
                                        cornerRadius: barHeight / 2).cgPath
        layer.mask = bgMask
        
        
        let path = UIBezierPath.init(roundedRect: barRect,
                                     cornerRadius: barHeight / 2)
        UIColor.rgb(r: 228, g: 228, b: 228).set()
        path.stroke()
        
        
        self.keywordCenterY = self.barTopPadding + (self.barHeight / 2)
    }
    
    var progress: CGFloat = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private func makeProgress(_ rect: CGRect) {
        // 애니메이션이 필요하다면 CALayer 가 필요
//        let progressRect = CGRect.init(origin: .zero,
//                                       size: CGSize.init(width: rect.width * progress,
//                                                         height: rect.height))
//        let progressLayer = CALayer()
//        progressLayer.frame = progressRect
//        layer.addSublayer(progressLayer)
//        progressLayer.backgroundColor = self.barColor.cgColor
        
        if progress > 0 {
            let rect = CGRect.init(origin: .zero,
                                   size: CGSize.init(width: rect.width * progress,
                                                     height: rect.height))
            
            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.height / 2)
            barColor.setFill()
            path.close()
            path.fill()
        } else {
            let rect = CGRect.init(origin: .zero,
                                   size: CGSize.init(width: rect.height,
                                                     height: rect.height))
            
            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.height / 2)
            barColor.setFill()
            path.close()
            path.fill()
        }
    }
    
    private func makeAverageDotLine(_ rect: CGRect) {
        let centerX = rect.width / 2
        
        let averageStartPoint = CGPoint.init(x: centerX - 0.5,
                                             y: rect.minY)
        let averageXEndPoint = CGPoint.init(x: centerX - 0.5,
                                            y: rect.maxY)
        
        
        let path = UIBezierPath()
        let dashPattern: [CGFloat] = [1, 5.0]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineCapStyle = .round
        
        path.move(to: averageStartPoint)
        path.addLine(to: averageXEndPoint)
        UIColor.rgb(r: 205, g: 0, b: 255).set()
        path.close()
        path.stroke()
    }
    
    /* 단위 표시 2 */
    func makeItem(startPoint: CGPoint, text: String) {
        let textColor = UIColor.rgb(r: 60, g: 60, b: 60)
        let textFont = Font.poppins(type: "Bold",
                                    size: 13.0)
        
        let from = text as NSString
        
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]

        from.draw(at: .zero,
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
