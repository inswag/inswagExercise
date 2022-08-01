//
//  ObesityChartView.swift
//  ChartMaker
//
//  Created by Insu Park on 2022/07/20.
//

import UIKit

class ObesityChartModel {

    var startPositionFromYAxisStart: CGPoint = .zero
    var middlePositionFromYAxisStart: CGPoint = .zero
    var endPositionFromYAxisStart: CGPoint = .zero

    // 차트 상에서 아이템이 가지는 좌표
    var itemPosition: CGPoint = .zero

    var date: Date
    var value: Double

    var isSelected: Bool = false
    var idx: Int = 0

    init(idx: Int, date: Date, value: Double) {
        self.idx = idx
        self.date = date
        self.value = value
    }

}

class ObesityChartView: UIView {

    // MARK: Properties

    var isViewSizeDecided: Bool = false

    // MARK: Charts

    var chartYAxisUnit: [CGFloat] = [
        0, 20, 40, 60, 80, 100
    ]

    var chartYAxisPositions: [GrowChart] = []

    var averageValue: CGFloat = 55.0

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

    var yAxisLineInterval: CGFloat = .zero


    var yAxisLineHeight: CGFloat = 1


    /* Position */

    // first -> 0 / last -> Max Unit
    var yAxisStartPositions: [CGPoint] = [] // Ascending from 0

    var xAxisPositions: [CGPoint] = [] // Ascending from 0
    var itemPositions: [CGPoint] = []

    /* Data */
    var datas: [GrowChartModel] = [
        GrowChartModel.init(idx: 0,date: Date().dateByAddingDays(0), value: 20.4),
        GrowChartModel.init(idx: 1,date: Date().dateByAddingDays(1), value: 40.4),
        GrowChartModel.init(idx: 2,date: Date().dateByAddingDays(2), value: 60.4),
        GrowChartModel.init(idx: 3,date: Date().dateByAddingDays(3), value: 80.4),
        GrowChartModel.init(idx: 4,date: Date().dateByAddingDays(4), value: 90.4),
        GrowChartModel.init(idx: 5,date: Date().dateByAddingDays(5), value: 40.4),
        GrowChartModel.init(idx: 6,date: Date().dateByAddingDays(6), value: 50.4),
        GrowChartModel.init(idx: 7,date: Date().dateByAddingDays(7), value: 60.4),
        GrowChartModel.init(idx: 8,date: Date().dateByAddingDays(8), value: 70.4),
    ]
    
    /* Init */

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
    }

    override func draw(_ rect: CGRect) {
//        guard isViewSizeDecided else { return }

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

        self.makeYAxisPosition()    // 차트의 Y축 좌표
        self.makeXAxisPosition()    // 차트 아이템의 X축 좌표
        self.makeXYAxisPosition()   // 아이템의 차트상 좌표


        self.drawYAxis()    // Y축 선 생성
        self.drawItem()     // X축 아이템 생성

        // 평균 라인 생성
        self.drawAverageValue() // 평균 선 생성

        self.drawValue()        // 차트 상 값 생성
        self.drawValueCircle()  // 차트 값 원형 표시 생성
        self.drawValueTitle()

        self.makeTouchArea()
    }

    // MARK: Touch Area

    private func makeTouchArea() {
        guard datas.count > 0 else { return }

        self.subviews.forEach {
            $0.removeFromSuperview()
        }

        // 차트 최하단 좌표 (Y축 시작점 기준)
//        let startX = self.yAxisStartPositions.first!.x
        let startY = self.yAxisStartPositions.first!.y

        // 차트 최상단 좌표 (Y축 시작점 기준)
//        let endX = self.yAxisStartPositions.last!.x
        let endY = self.yAxisStartPositions.last!.y

        for (_, data) in datas.enumerated() {
            // 총 4개의 좌표가 필요 -> 좌우 측 상하단
            let viewX = data.startPositionFromYAxisStart.x
            let viewY = endY

            let height = abs(endY - startY) + CGFloat(23)


            let view = ChartAreaView.init(frame: CGRect.init(x: viewX, y: viewY, width: chartItemWidth, height: height))
            view.makeTapGesture()
            view.isUserInteractionEnabled = true
            view.insertModel(data: data)
            view.backgroundColor = .clear

            view.selectAction = { [weak self] model in
                guard let self = self else { return }
                for data in self.datas {
                    if data.idx == model.idx {
                        if data.isSelected {
                            // 이미 선택된 경우 다시 그리지 않고 리턴
                            return
                        } else {
                            data.isSelected = true
                        }
                    } else {
                        data.isSelected = false
                    }
                }

                self.setNeedsDisplay()
            }

            self.addSubview(view)
        }
    }

    // MARK: Draw

    private func drawAverageValue() {
        let xStartPosition = self.yAxisStartPositions.first!.x
        let yPosision = self.getDynamicValueYAxisPositionInXAxisZero(value: self.averageValue)

        let path = UIBezierPath()
        let dashPattern: [CGFloat] = [1, 5.0]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineCapStyle = .square

        path.move(to: CGPoint.init(x: xStartPosition, y: yPosision))
        path.addLine(to: CGPoint.init(x: fullWidth - chartOutsideRightPadding, y: yPosision))
        UIColor.rgb(r: 79, g: 211, b: 205).set()
        path.close()
        path.stroke()
    }

    private func drawValueCircle() {
        for data in datas {
            let ovalStartX = data.itemPosition.x - 5
            let ovalStartY = data.itemPosition.y - 5

            let ovalPosition = CGPoint.init(x: ovalStartX, y: ovalStartY)
            self.drawingCircle(borderColor:  UIColor.rgb(r: 218, g: 122, b: 255),
                               circleInnerColor:  UIColor.white,
                               lineWidth: 4,
                               width: 10,
                               height: 10,
                               position: ovalPosition)
        }
    }

    private func drawValueTitle() {
        for data in datas {
//            var size: CGSize = .zero
//            var position: CGPoint = .zero

            if data.isSelected {
                let size = self.getLabelSize(text: "\(data.value)", font: Font.poppins(type: "Bold", size: 13.0))

                let startX = data.itemPosition.x - (size.width / 2)
                let startY = data.itemPosition.y - size.height - 9 // padding

                let startPosition = CGPoint.init(x: startX, y: startY)

                self.makeItem(itemColor: UIColor.rgb(r: 60, g: 60, b: 60),
                              itemFont: Font.poppins(type: "Bold", size: 13.0),
                              from: "\(data.value)",
                              at: startPosition)
            } else {
                let size = self.getLabelSize(text: "\(data.value)",
                                             font: Font.poppins(type: "Medium", size: 13.0)) // NotoSans

                let startX = data.itemPosition.x - (size.width / 2)
                let startY = data.itemPosition.y - size.height - 9 // padding

                let startPosition = CGPoint.init(x: startX, y: startY)

                self.makeItem(itemColor: UIColor.rgb(r: 134, g: 142, b: 150),
                              itemFont: Font.poppins(type: "Medium", size: 13.0),
                              from: "\(data.value)",
                              at: startPosition)
            }
        }
    }


    private func drawValue() {
        let path = UIBezierPath()

        for (idx, item) in self.datas.enumerated() {
            if idx == 0 {
                path.move(to: item.itemPosition)
            } else {
                path.addLine(to: item.itemPosition)
            }
        }

        path.lineWidth = 3
        UIColor.rgb(r: 205, g: 0, b: 255).set()
        path.stroke()
    }

    private func drawItem() {
        for (_, item) in self.datas.enumerated() {
            let startX = item.startPositionFromYAxisStart.x
            let endX = item.endPositionFromYAxisStart.x

            let middleX = (startX + endX) / 2

            let text = Tools.customDate.convertDateBasicFormatToStringWithFormat(date: item.date,
                                                                                 format: "MM.dd")

            if item.isSelected {
                let size = self.getLabelSize(text: text,
                                             font: Font.poppins(type: "Bold", size: 13.0))
                let textMiddle = (size.width / 2)

                let resultStartX = middleX - textMiddle
                let resultY = item.startPositionFromYAxisStart.y + 4

                self.makeItem(itemColor: UIColor.rgb(r: 60, g: 60, b: 60),
                              itemFont: Font.poppins(type: "Medium", size: 13.0),
                              from: text,
                              at: CGPoint.init(x: resultStartX, y: resultY))
            } else {
                let size = self.getLabelSize(text: text,
                                             font: Font.poppins(type: "Medium", size: 13.0))
                let textMiddle = (size.width / 2)

                let resultStartX = middleX - textMiddle
                let resultY = item.startPositionFromYAxisStart.y + 4

                self.makeItem(itemColor: UIColor.rgb(r: 134, g: 142, b: 150),
                              itemFont: Font.poppins(type: "Medium", size: 13.0),
                              from: text,
                              at: CGPoint.init(x: resultStartX, y: resultY))
            }
        }
    }

    private func drawYAxis() {
        for (_, position) in yAxisStartPositions.enumerated() {

            let endLineXPosition = fullWidth - chartOutsideRightPadding

            let path = UIBezierPath()
//            let dashPattern: [CGFloat] = [1, 5.0]
    //        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
    //        path.lineCapStyle = .round

            path.move(to: position)
            path.addLine(to: CGPoint.init(x: endLineXPosition, y: position.y))
            UIColor.rgb(r: 207, g: 212, b: 218).set()
            path.close()
            path.stroke()
        }
    }

    // MARK: Item's X Y Axis

    private func makeXYAxisPosition() {
        guard self.yAxisStartPositions.count > 1 else { return }

        for item in self.datas {
            let maxY = self.yAxisStartPositions.last!.y
            let minY = self.yAxisStartPositions.first!.y

            let currentValue = item.value

            let absoluteFullArea = abs(maxY - minY)
            let currentValueY = minY - ((absoluteFullArea * currentValue) / CGFloat(100))
            let currentValueX = item.middlePositionFromYAxisStart.x

            item.itemPosition = CGPoint.init(x: currentValueX, y: currentValueY)
        }
    }

    private func getDynamicValueYAxisPositionInXAxisZero(value: CGFloat) -> CGFloat {
        let maxY = self.yAxisStartPositions.last!.y
        let minY = self.yAxisStartPositions.first!.y

        let currentValue = value

        let absoluteFullArea = abs(maxY - minY)
        let currentValueY = minY - ((absoluteFullArea * currentValue) / CGFloat(100))
        return currentValueY
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
            let xStartPosition: CGFloat = chartOutsideLeftPadding
            let yStartPosition: CGFloat = chartOutsideTopPadding + (yAxisLineHeight * CGFloat(idx)) + (yAxisLineInterval * CGFloat(idx))


            let position = CGPoint.init(x: xStartPosition,
                                        y: yStartPosition)
            self.yAxisStartPositions.append(position)


        }

        // Make Ascending Positions
        self.yAxisStartPositions.sort { $0.y > $1.y }
    }

//    private func

    // Y축 선 간격을 구합니다.
    private func makeDynamicYAxisInterval(idx: Int) {
        let totalLineHeight = CGFloat(idx) * yAxisLineHeight
        let totalDynamicInterval = fullHeight - chartOutsideTopPadding - chartOutsideBottomPadding - totalLineHeight
        self.yAxisLineInterval = totalDynamicInterval / CGFloat(self.chartYAxisUnit.count - 1)

        print("complete")
    }

    // MARK: X Axis

    private func makeXAxisPosition() {
        self.xAxisPositions.removeAll()

        guard let yStartPosition = yAxisStartPositions.first else { return }

        for i in 0..<self.datas.count {
            let yStartPosition = yStartPosition
            let xPositionStart = chartItemWidth * CGFloat(i)
            let xPositionEnd = xPositionStart + chartItemWidth

            let startPositionFromYAxisStart = CGPoint.init(x: yStartPosition.x + xPositionStart,
                                                           y: yStartPosition.y)
            let endPositionFromYAxisStart = CGPoint.init(x: yStartPosition.x + xPositionEnd,
                                                         y: yStartPosition.y)


            let middleX = (startPositionFromYAxisStart.x + endPositionFromYAxisStart.x) / 2
            let middlePositionFromYAxisStart = CGPoint.init(x: middleX, y: yStartPosition.y)

            // 좌표 세팅
            self.datas[i].startPositionFromYAxisStart = startPositionFromYAxisStart
            self.datas[i].endPositionFromYAxisStart = endPositionFromYAxisStart
            self.datas[i].middlePositionFromYAxisStart = middlePositionFromYAxisStart
        }
    }

    // MARK: Util

    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = font
        label.sizeToFit()
        return label.frame.size
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

    // MARK: Drawing Util

    private func drawingCircle(borderColor: UIColor,
                               circleInnerColor: UIColor,
                               lineWidth: CGFloat,
                               width: CGFloat,
                               height: CGFloat,
                               position: CGPoint) {
        let path = UIBezierPath.init(ovalIn: CGRect.init(origin: position,
                                                         size: CGSize.init(width: width, height: height)))
        path.lineWidth = lineWidth
        borderColor.set()
        circleInnerColor.setFill()
        path.stroke()
        path.fill()
        path.close()
    }


}

// MARK: Calculating

extension ObesityChartView {

    func getFullWidth() -> CGFloat {
        let itemCount = self.datas.count
        let result = chartOutsideLeftPadding + chartOutsideRightPadding + (chartItemWidth * CGFloat(itemCount))
        self.isViewSizeDecided = true

        if result < UIScreen.main.bounds.width {
            return UIScreen.main.bounds.width
        } else {
            return result
        }
    }

}

class ObesityAreaView: UIView {

    var model: ObesityChartModel?
    var selectAction: ((ObesityChartModel)->())?

    /* Init */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }

    func makeTapGesture() {
        let tapG = UITapGestureRecognizer
            .init(target: self, action: #selector(tapGesture))
        self.addGestureRecognizer(tapG)
    }

    func insertModel(data: ObesityChartModel) {
        self.model = data
    }

    @objc func tapGesture() {
        guard let model = model else {
            print("Invalid Model")
            return
        }

        guard let selectAction = selectAction else {
            return
        }

        selectAction(model)
    }


}
