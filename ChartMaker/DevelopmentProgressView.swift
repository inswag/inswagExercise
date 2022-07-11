//
//  DevelopmentProgressView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/11.
//

import UIKit

class DevelopmentProgressView: UIView {
    
    /* Color */
    
    let barColor: UIColor = UIColor.rgb(r: 246, g: 216, b: 255)
    
    let barBgColor: UIColor = .white
    let barBgBorderColor: UIColor = UIColor.rgb(r: 228, g: 228, b: 228)
    
    let barHeight: CGFloat = 16
    let barRadius: CGFloat = 8
    
    //
    
    
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
    }
    
    override func draw(_ rect: CGRect) {
        /* Draw Order
            1. Border Line
            2. progressView
            3. averageLine
         
         */
        
        self.makeBorderLine(rect)
        
        
        self.makeProgress(rect)
        
        self.makeAverageDotLine(rect)
    }
    
    private func makeBorderLine(_ rect: CGRect) {
        // 깔끔하지 않은 Radius 부분을 Mask 로 해결
        let bgMask = CAShapeLayer()
        bgMask.path = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.height / 2).cgPath
        layer.mask = bgMask
        
        
        let path = UIBezierPath.init(roundedRect: rect, cornerRadius: rect.height / 2)
        UIColor.rgb(r: 228, g: 228, b: 228).set()
        path.stroke()
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
    
    
    
}
