//
//  NinePolygonChartView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/04.
//

import UIKit

enum NineBabyDevelopment: Int {
    case total = 0
    case expressionLanguage
    case underStandingLanguage
    case word
    case number
    case bigMuscle
    case smallMuscle
    case selfIndependance
    case society
}

enum BabyDevelopmentRangeAge: Int {
    case twoFour = 24
    case twoSix = 26
    case threeTwo = 35
}

class NinePolygonChartView: UIView {

    /* UI */
    
    // 9각형 모서리부터 측면 끝까지 사이의 간격
    let sidePadding: CGFloat = 58
    // 각 9각형 사이의 Y값의 기본 인터벌 값
    let interval: CGFloat = 22
    // (360 / 9각형) = 40도 의 값
    var pointAngle: Int = 40
    
    // 중심에서 각 끝으로 보내는 일직선이 한번만 그려지도록 조정
    var isFirstDrawing: Bool = true
    
    /* Polegon Postion */
    
    // 그래프의 가장 큰 9각형의 위치 값을 저장
    var polygonPositions: [CGPoint] = []
    // 그래프의 단위가 입력될 위치 저장
    var polygonUnitPositions: [CGPoint] = []
    // 입력되어야 할 유저의 평가 값의 위치를 저장
    var valuePositions: [CGPoint] = []
    // 직선이 그려져야 할 좌표값 저장
    var linearPositions: [CGPoint] = []
    
    //  발달 범위의 위치 값
    var firstDevelopmentRangePositions: [CGPoint] = []
    var secondDevelopmentRangePositions: [CGPoint] = []
    var thirdDevelopmentRangePositions: [CGPoint] = []
    
    /* Content */
    
    // 각 항목 별 최대값
    let maxValue: Int = 72
    // 각 9각형 사이의 인터벌의 기준이 되는 값
    let intervalValue: Int = 12
    
    
    /* Baby */
    
    // 아이의 성장 값
    var babyDevelopmentRange: BabyDevelopmentRange = BabyDevelopmentRange.init(data: [:]) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var babyDevelopmentRangeAge: [BabyDevelopmentRangeAge] = [
        .twoFour,
        .twoSix,
        .threeTwo
    ]
    var babyDevelopmentRangeAgeFirstPositions: [CGPoint] = []
    var babyDevelopmentRangeAgeSecondPositions: [CGPoint] = []
    var babyDevelopmentRangeAgeThirdPositions: [CGPoint] = []
    
    /* Init */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers?.removeAll()
        setBase()
    }
    
    func setBase() {
        let centerPoint = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let calRadius: CGFloat = (self.bounds.height / 2) - sidePadding
    
        let path = UIBezierPath()
        path.lineWidth = 1
        
        for i in (0...5) {
            if i == 4 {
                break
            }
            
            let distance = interval * CGFloat(i)
            
            for j in 0...9 {
                let angle = j * pointAngle
                let displacedAngle = angle - 90
                
                let x = centerPoint.x + cos(deg2rad(Double(displacedAngle))) * (calRadius - distance)
                let y = centerPoint.y + sin(deg2rad(Double(displacedAngle))) * (calRadius - distance)
                
                if j == 0 {
                    path.move(to: CGPoint.init(x: x, y: y))
                    
                    //
                    self.polygonUnitPositions.append(CGPoint.init(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint.init(x: x, y: y))
                }
                
                // 최초로 그려지는 가장 큰 9각형의 좌표를 저장할 수 있도록 저장
                if i == 0 {
                    self.polygonPositions.append(CGPoint.init(x: x, y: y))
                }
                
                // 처음 그린 이후 한번 더 그려지는 것을 방지
                if i == 0 {
                    // 중심에서 각 모서리로 이어지는 선
                    self.linearPositions.append(CGPoint.init(x: x, y: y))
                }
                
                if i == 0 {
                    // 값의 위치
                    let maxValue = self.maxValue
                    let maxAbValue = calRadius
                    
                    var currentValue: Int = 0
                    
                    var newCalRadius: CGFloat = 0
                    
                    switch j {
                    case 0:
                        currentValue = self.babyDevelopmentRange.total
                    case 1:
                        currentValue = self.babyDevelopmentRange.expressionLanguage
                    case 2:
                        currentValue = self.babyDevelopmentRange.underStandingLanguage
                    case 3:
                        currentValue = self.babyDevelopmentRange.word
                    case 4:
                        currentValue = self.babyDevelopmentRange.number
                    case 5:
                        currentValue = self.babyDevelopmentRange.bigMuscle
                    case 6:
                        currentValue = self.babyDevelopmentRange.smallMuscle
                    case 7:
                        currentValue = self.babyDevelopmentRange.selfIndependance
                    case 8:
                        currentValue = self.babyDevelopmentRange.society
                    default:
                        currentValue = self.babyDevelopmentRange.total
                    }
                    
                    newCalRadius = (maxAbValue * CGFloat(currentValue)) / CGFloat(maxValue)
                    
                    let valueX = centerPoint.x + cos(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    let valueY = centerPoint.y + sin(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    print("Value X : ", valueX)
                    print("Value Y : ", valueY)
                    
                    let valuePosition = CGPoint.init(x: valueX, y: valueY)
                    self.valuePositions.append(valuePosition)
                }
                
                // 첫번째 발달 범위 획득
                if i == 0 {
                    // 값의 위치
                    let maxValue = self.maxValue
                    let maxAbValue = calRadius
                    
                    var currentValue: Int = BabyDevelopmentRangeAge.threeTwo.rawValue
                    var newCalRadius: CGFloat = 0
                    
                    newCalRadius = (maxAbValue * CGFloat(currentValue)) / CGFloat(maxValue)
                    
                    let valueX = centerPoint.x + cos(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    let valueY = centerPoint.y + sin(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    print("Value X : ", valueX)
                    print("Value Y : ", valueY)
                    
                    let valuePosition = CGPoint.init(x: valueX, y: valueY)
                    self.babyDevelopmentRangeAgeFirstPositions.append(valuePosition)
                }
                
                // 두번째 발달 범위 획득
                if i == 0 {
                    // 값의 위치
                    let maxValue = self.maxValue
                    let maxAbValue = calRadius
                    
                    let currentValue: Int = BabyDevelopmentRangeAge.twoSix.rawValue
                    var newCalRadius: CGFloat = 0
                    
                    newCalRadius = (maxAbValue * CGFloat(currentValue)) / CGFloat(maxValue)
                    
                    let valueX = centerPoint.x + cos(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    let valueY = centerPoint.y + sin(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    print("Value X : ", valueX)
                    print("Value Y : ", valueY)
                    
                    let valuePosition = CGPoint.init(x: valueX, y: valueY)
                    self.babyDevelopmentRangeAgeSecondPositions.append(valuePosition)
                }
                
                // 세번째 발달 범위 획득
                if i == 0 {
                    // 값의 위치
                    let maxValue = self.maxValue
                    let maxAbValue = calRadius
                    
                    let currentValue: Int = BabyDevelopmentRangeAge.twoFour.rawValue
                    var newCalRadius: CGFloat = 0
                    
                    newCalRadius = (maxAbValue * CGFloat(currentValue)) / CGFloat(maxValue)
                    
                    let valueX = centerPoint.x + cos(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    let valueY = centerPoint.y + sin(deg2rad(Double(displacedAngle))) * (newCalRadius)
                    print("Value X : ", valueX)
                    print("Value Y : ", valueY)
                    
                    let valuePosition = CGPoint.init(x: valueX, y: valueY)
                    self.babyDevelopmentRangeAgeThirdPositions.append(valuePosition)
                }
            }
            
            UIColor.rgb(r: 207, g: 212, b: 218).set()
            path.close()
            path.stroke()
        }
            
        // 아이의 발달 범위 기준을 그래프로 표현합니다.
        self.getBabyDevelopmentRangeAge()
        self.getBabyDevelopmentRangeAgeSecond()
        self.getBabyDevelopmentRangeAgeThird()
        // 직선 표시
        self.getLinearPath()
        // 아이의 발달 상태를 그래프로 표현합니다.
        self.getBabyDevelopment()
        // 단위 표시는 가장 마지막에 그려지도록 합니다.
        self.getUnit()
        // 텍스트 표시
        self.makeText()
    }
    
    /* 아이의 발달 범위 기준 */
    func getBabyDevelopmentRangeAge() {
        var bezierPath = UIBezierPath.init()
        
        for (idx, position) in self.babyDevelopmentRangeAgeFirstPositions.enumerated() {
            if idx == 0 {
                bezierPath.move(to: position)
            } else {
                bezierPath.addLine(to: position)
            }
        }
        
        bezierPath.close()
        bezierPath.lineWidth = 1
        UIColor.rgb(r: 223, g: 244, b: 255).set()
        bezierPath.fill()
    }
    
    func getBabyDevelopmentRangeAgeSecond() {
        var bezierPath = UIBezierPath.init()
        
        for (idx, position) in self.babyDevelopmentRangeAgeSecondPositions.enumerated() {
            if idx == 0 {
                bezierPath.move(to: position)
            } else {
                bezierPath.addLine(to: position)
            }
        }
        
        bezierPath.close()
        bezierPath.lineWidth = 1
        UIColor.rgb(r: 255, g: 250, b: 223).set()
        bezierPath.fill()
    }
    
    func getBabyDevelopmentRangeAgeThird() {
        var bezierPath = UIBezierPath.init()
        
        for (idx, position) in self.babyDevelopmentRangeAgeThirdPositions.enumerated() {
            if idx == 0 {
                bezierPath.move(to: position)
            } else {
                bezierPath.addLine(to: position)
            }
        }
        
        bezierPath.close()
        bezierPath.lineWidth = 1
        UIColor.rgb(r: 255, g: 226, b: 223).set()
        bezierPath.fill()
    }
    
    /* 아이의 발달 상태 표시 */
    func getBabyDevelopment() {
        // 아이의 발달 값에 따라서 선을 그립니다.
        var bezierPath = UIBezierPath.init()
        
        for (idx, position) in valuePositions.enumerated() {
            if idx == 0 {
                bezierPath.move(to: position)
            } else {
                bezierPath.addLine(to: position)
            }
        }
        
//        bezierPath.close()
//        bezierPath.lineWidth = 1
//        UIColor.rgb(r: 205, g: 0, b: 255).set()
//        bezierPath.stroke()
        
        let view = UIView.init(frame: self.frame)
        view.backgroundColor = .clear
        self.addSubview(view)
        
        view.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        maskLayer.lineWidth = 3
        maskLayer.strokeColor = UIColor.rgb(r: 205, g: 0, b: 255).cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(maskLayer)
        
        view.isHidden = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear) {
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        } completion: { _ in
            view.isHidden = false
            UIView.animate(withDuration: 5.0, delay: 0.0, options: .curveEaseOut) {
                view.transform = CGAffineTransform.identity
            } completion: { _ in
                
            }

        }

        
//        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
//        scaleAnimation.fromValue = 0.9
//        scaleAnimation.toValue = 1
//
//        let opacityAnimation = CAKeyframeAnimation.init(keyPath: "opacity")
//        opacityAnimation.values = [0.0, 0.7, 1]
//        opacityAnimation.keyTimes = [0, 0.3, 1]
//
//        let animationGroup = CAAnimationGroup()
//        animationGroup.duration = 1.5
//        animationGroup.animations = [scaleAnimation, opacityAnimation]
//
//
//        maskLayer.add(animationGroup, forKey: "animation")
    }
    
    /* 단위 표시 1*/
    func getUnit() {
        for (idx, position) in polygonUnitPositions.enumerated() {
            self.makeUnit(destinationPoint: position,
                          value: String(maxValue - (intervalValue * idx)))
        }
    }
    
    /* 단위 표시 2 */
    func makeUnit(destinationPoint: CGPoint, value: String) {
        let textColor = UIColor.rgb(r: 123, g: 123, b: 123)
        let textFont = Font.poppins(type: "Regular", size: 11.0)
        
        let text = value as NSString
        let butes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: textFont,
        ]
        
        // 폰트 사이즈 계산
        let size = self.getLabelSize(text: value, font: textFont)
        let labelWidth = size.width / 2
        let labelHeight = size.height / 2
        
        let position = CGPoint.init(x: destinationPoint.x - labelWidth,
                                    y: destinationPoint.y - labelHeight)

        text.draw(at: position,
                  withAttributes: butes)
        
    }
    
    /* 9각형의 모서리로 향하는 직선 */
    func getLinearPath() {
        for linearPosition in linearPositions {
            let centerPoint = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height / 2)
            
            let linearPath = UIBezierPath.init()
            linearPath.lineWidth = 1
            linearPath.move(to: centerPoint)
            linearPath.addLine(to: linearPosition)
            UIColor.rgb(r: 173, g: 181, b: 189).set()
            linearPath.close()
            linearPath.stroke()
        }
    }
    
    /* 가장 큰 9각형의 모서리에 붙어야 하는 텍스트 */
    
    func makeText() {
        for (idx, position) in polygonPositions.enumerated() {
            switch idx {
            case NineBabyDevelopment.total.rawValue:
                self.handleFirstText(position: position)
            case NineBabyDevelopment.expressionLanguage.rawValue:
                self.handleSecondText(position: position)
            case NineBabyDevelopment.underStandingLanguage.rawValue:
                self.handleThirdText(position: position)
            case NineBabyDevelopment.word.rawValue:
                self.handleFourthText(position: position)
            case NineBabyDevelopment.number.rawValue:
                self.handleFivethText(position: position)
            case NineBabyDevelopment.bigMuscle.rawValue:
                self.handleSixthText(position: position)
            case NineBabyDevelopment.smallMuscle.rawValue:
                self.handleSeventhText(position: position)
            case NineBabyDevelopment.selfIndependance.rawValue:
                self.handleEighthText(position: position)
            case NineBabyDevelopment.society.rawValue:
                self.handleNinethText(position: position)
            default:
                print("Error")
            }
        }
    }
    
    func handleFirstText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "전체 발달", font: Font.poppins(type: "Bold", size: 15.0))
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 15
        
        let startX: CGFloat = position.x - (contentSize.width / 2)
        let startY: CGFloat = position.y - polygonInterval - contentSize.height
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "전체 발달")
        self.addSubview(view)
    }

    func handleSecondText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "표현\n언어", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 24
        
        let startX: CGFloat = position.x + polygonInterval
        let startY: CGFloat = position.y - (contentSize.height / 2)
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "표현\n언어")
        self.addSubview(view)
    }
    
    func handleThirdText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "언어\n이해", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 9
        
        let startX: CGFloat = position.x + polygonInterval
        let startY: CGFloat = position.y - (contentSize.height / 2) + 10
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "언어\n이해")
        self.addSubview(view)
    }
    
    func handleFourthText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "글자", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 10
        
        let startX: CGFloat = position.x + polygonInterval
        let startY: CGFloat = position.y + 5
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "글자")
        self.addSubview(view)
    }
    
    func handleFivethText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "숫자", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 11
        
        let startX: CGFloat = position.x - 10
        let startY: CGFloat = position.y + polygonInterval
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "숫자")
        self.addSubview(view)
    }
    
    func handleSixthText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "대근육\n발달", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 11
        
        let startX: CGFloat = position.x - 32
        let startY: CGFloat = position.y + polygonInterval
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "대근육\n발달")
        self.addSubview(view)
    }
    
    func handleSeventhText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "소근육\n발달", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 21
        
        let startX: CGFloat = position.x - 15 - contentSize.width
        let startY: CGFloat = position.y
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "소근육\n발달")
        self.addSubview(view)
    }
    
    func handleEighthText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "자조\n행동", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 21
        
        let startX: CGFloat = position.x - 9 - contentSize.width
        let startY: CGFloat = position.y - (contentSize.height / 2) + 10
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "자조\n행동")
        self.addSubview(view)
    }
    
    func handleNinethText(position: CGPoint) {
        let labelSize = self.getLabelSize(text: "사회성", font: Font.poppins(type: "Bold", size: 15.0))
        
        let interval: CGFloat = 4
        let imageSize: CGFloat = 16
        
        let resultWidth = labelSize.width
        let resultHeight = labelSize.height + interval + imageSize
        
        let contentSize = CGSize.init(width: resultWidth, height: resultHeight)
        
        let polygonInterval: CGFloat = 21
        
        let startX: CGFloat = position.x - contentSize.width - 10
        let startY: CGFloat = position.y - (contentSize.height / 2)
        
        let frame = CGRect.init(origin: CGPoint.init(x: startX, y: startY), size: contentSize)
        let view = BabyDevelopmentView.init(frame: frame)
        view.fillUI(text: "사회성")
        self.addSubview(view)
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
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

class BabyDevelopmentView: UIView {
    
    var label: UILabel = {
        let label = UILabel()
        label.font = Font.poppins(type: "Bold", size: 15.0)
        label.textColor = UIColor.rgb(r: 90, g: 91, b: 107)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var imageView: UIImageView = {
        let iV = UIImageView()
        iV.backgroundColor = .clear
        iV.image = UIImage.init(named: "info")
        iV.layer.cornerRadius = 8
        return iV
    }()
    
    var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        return btn
    }()
    
    /* Init */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    func fillUI(text: String) {
        label.text = text
        
        self.addSubview(label)
        self.addSubview(imageView)
        self.addSubview(button)

        label.anchor(top: self.topAnchor, left: self.leftAnchor, 
                     bottom: nil, right: self.rightAnchor,
                     paddingTop: 0, paddingLeft: 0,
                     paddingBottom: 0, paddingRight: 0,
                     width: 0, height: 0)
        imageView.anchor(top: label.bottomAnchor, left: nil,
                         bottom: self.bottomAnchor, right: nil,
                         paddingTop: 4, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0,
                         width: 16, height: 16)
        imageView.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
        
        button.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        button.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
    }
    
    @objc func selectAction() {
        print("Select")
    }
    
    
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor?,
                left: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingLeft: CGFloat,
                paddingBottom: CGFloat,
                paddingRight: CGFloat,
                width: CGFloat,
                height: CGFloat) {
        
        // .translatesAutoresizingMaskIntoConstraints :
        // A Boolean value that determines whether the view’s autoresizing mask is translated into Auto Layout constraints.
        // autoresizing mask : An integer bit mask that determines how the receiver resizes itself when its superview’s bounds change.
        // 쉽게, AutoLayout 을 동적으로 주고 싶을 때 'false'
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top,
                                      constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left,
                                       constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom,
                                         constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right,
                                        constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}


struct BabyDevelopmentRange {
    
    let total: Int
    let expressionLanguage: Int
    let underStandingLanguage: Int
    let word: Int
    let number: Int
    let bigMuscle: Int
    let smallMuscle: Int
    let selfIndependance: Int
    let society: Int
    
    init(data: [String: Any]) {
//        if let total = data["total"] as? Int {
//            self.total = total
//        }
//
//        if let expressionLanguage = data["expressionLanguage"] as? Int {
//            self.expressionLanguage = expressionLanguage
//        }
//
//        if let underStandingLanguage = data["underStandingLanguage"] as? Int {
//            self.underStandingLanguage = underStandingLanguage
//        }
//
//        if let word = data["word"] as? Int {
//            self.word = word
//        }
//
//        if let number = data["number"] as? Int {
//            self.number = number
//        }
//
//        if let bigMuscle = data["bigMuscle"] as? Int {
//            self.bigMuscle = bigMuscle
//        }
//
//        if let smallMuscle = data["smallMuscle"] as? Int {
//            self.smallMuscle = smallMuscle
//        }
//
//        if let selfIndependance = data["selfIndependance"] as? Int {
//            self.selfIndependance = selfIndependance
//        }
//
//        if let society = data["society"] as? Int {
//            self.society = society
//        }
        
        self.total = 60
        self.expressionLanguage = 54
        self.underStandingLanguage = 38
        self.word = 12
        self.number = 36
        self.bigMuscle = 48
        self.smallMuscle = 10
        self.selfIndependance = 37
        self.society = 42
    }
    
    
}
