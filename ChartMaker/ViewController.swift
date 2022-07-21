//
//  ViewController.swift
//  ChartMaker
//
//  Created by 박인수 on 2022/06/20.
//

import UIKit
import CoreMotion
import HealthKit

class StepModel: NSObject {
    var step: Int = 0
    var date: Date = Date()
    override init() {
        super.init()
    }
    convenience init(step: Double, date: Date) {
        self.init()
        self.step = Int(step)
        self.date = date
    }
}

class ViewController: UIViewController {

    //
    
    @IBOutlet weak var polygonview: NinePolygonChartView!
    @IBOutlet weak var chartView: TodayChartView!
    @IBOutlet weak var dateLabel: UILabel!
    
    //
    
    let pedometer = CMPedometer()
    let healthStore = HKHealthStore()
    let typeToRead = HKObjectType.quantityType(forIdentifier: .stepCount)
    
    var stepDataList: [String] = []
    var stepList: [StepModel] = []
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        polygonview.setBase(in: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2))
//        self.chartView.makeTapGesture()
        
//        print("Auth : ", healthStore.authorizationStatus(for: typeToRead!).rawValue)
        
        
    }

    var count: Int = 0
    
    @IBAction func getLeftAction(_ sender: UIButton) {
        
//        self.getTodayStepData {
//
//        }
//        self.prepareTimeData(insertTime: "2022-06-28 10:34:24") {
//
//        }
        
        let view = GrowthViewController.init()
        view.modalPresentationStyle = .fullScreen
        self.present(view,
                     animated: true,
                     completion: nil)
        
    }
    
    func prepareTimeData(insertTime: String,
                         completion: @escaping ()->()) {
        if insertTime == "" {
            self.getTodayStepData {
                completion()
            }
            
            return
        } else {
            let evaluatingDates = self.getUpdateNeedDates(lastInsertTime: insertTime)
            self.getTimeModel(evaluatingDates: evaluatingDates,
                              lastInsertTime: insertTime)
//            self.getTodayTimeDataByHealthKit()
            self.getTodayTimeDataCollectionQuery()
        }
    }
    
    
    /* 최근 업데이트된 시간이 없으면 당일을 기준으로 업데이트 해줌 */
    private func getTodayStepData(completion: @escaping ()->()) {
        self.stepData.removeAll()
        
        let toDate = Date()
        let fromDate = Calendar.current.startOfDay(for: toDate)
        
        let from = "2022-07-01 15:44:36"
        let to = "2022-07-01 17:52:08"
//
//        let sibal = Tools.customDate.convertStringToDate(time: to)
//
//        let no = Date.init(timeIntervalSinceReferenceDate: 678343002.1)
//        let krNo = Tools.customDate.convertDateBasicFormatToStringWithFormat(date: no, format: "yyyyMM월 dd일 HH:mm:ss")
        
        self.pedometer.queryPedometerData(from: Tools.customDate.convertStringToDate(time: from),
                                          to: Tools.customDate.convertStringToDate(time: to)) { data, error in
            DispatchQueue.main.async {
                if error == nil {
                    if let step = data?.numberOfSteps.intValue {
                        let model = PedometerAddingStepModel.init(insertDate: toDate, step: step)
                        self.stepData = [model]
                        completion()
                    }
                }
            }
        }
    }
    
    /* 마지막 업데이트 시간의 날짜부터 오늘까지 평가에 필요한 날짜 모음을 리턴합니다. */
    private func getUpdateNeedDates(lastInsertTime: String) -> [Date] {
        var evaluatedDates: [Date] = []
        
        let insertTime = Tools.customDate.convertStringToDate(time: lastInsertTime)
        
        for i in 0..<1000 {
            let evaluatingDay = insertTime.dateByAddingDays(i)
            
            let evaluatingDate = Tools.customDate
                .convertDateBasicFormatToStringWithFormat(date: evaluatingDay,
                                                          format: "yyyyMMdd")
            let today = Tools.customDate
                .convertDateBasicFormatToStringWithFormat(date: Date(),
                                                          format: "yyyyMMdd")
            
            if Int(evaluatingDate)! < Int(today)! {
                evaluatedDates.append(evaluatingDay)
                continue
            } else if Int(evaluatingDate)! == Int(today)! {
                evaluatedDates.append(evaluatingDay)
                break
            }
        }
        
        evaluatedDates.forEach {
            print("EvaluatingDates Day name : ", Tools.customDate.convertDateBasicFormatToStringWithFormat(date: $0, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))
        }
        
        return evaluatedDates
    }
    
    
    
    @IBAction func getDayData(_ sender: UIButton) {
        let calendar = Calendar.current
        
        let interval = DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: 2, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        var components = DateComponents.init(calendar: calendar, timeZone: calendar.timeZone, era: nil, year: nil, month: nil, day: nil, hour: 0, minute: 0, second: 0, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        guard let anchorDate = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward) else {
            return
        }
        
        
        let quantityType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        
        let query = HKStatisticsCollectionQuery.init(quantityType: quantityType,
                                                     quantitySamplePredicate: nil,
                                                     options: .cumulativeSum,
                                                     anchorDate: anchorDate,
                                                     intervalComponents: interval)
        query.initialResultsHandler = { query, results, error in
            print("==========================")
            print("Query : ", query)
            print("Results : ", results)
            print("Error : ", error ?? 0)
            print("==========================")
        }
        
        healthStore.execute(query)
    }
    
    private func dateFromString(_ text: String) -> Date {
        let dateAndTime = text.components(separatedBy: " ")
        let date = dateAndTime.first!
        let time = dateAndTime.last!
        
        var str: String  = ""
        
        if Int(time)! > 9 {
            str = date + " " + "\(time):00:00"
        } else {
            str = date + " " + "0\(time):00:00"
        }
        
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: str)!
    }
    
    private func dateFromStringForEnd(_ text: String) -> Date {
        let dateAndTime = text.components(separatedBy: " ")
        let date = dateAndTime.first!
        let time = dateAndTime.last!
        
        var str: String  = ""
        
        if Int(time)! > 9 {
            str = date + " " + "\(time):59:59"
        } else {
            str = date + " " + "0\(time):59:59"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: str)!
    }
    
    private func dateToFromDateZero(_ date: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let str = dateFormatter.string(from: date)
        let strDate = str.components(separatedBy: " ").first! + " 00:00:00"
        
        return dateFormatter.date(from: strDate)!
    }
    
    
    private func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    var stepData: [PedometerAddingStepModel] = [] {
        didSet {
            print("stepData changed")
            print("stepData count ", self.stepData.count)
        }
    }
    
    
    var models: [PedometerAddingTimeModel] = []
    
    @IBAction func getMonthlyData(_ sender: UIButton) {
        let view = PopUpDatePickerViewController.init()
        view.modalPresentationStyle = .overCurrentContext
        self.present(view, animated: true)
        
//        self.prepareTimeDatas(insertTime: "2022-06-28 10:34:24") {
//
//        }
    }
    
    func prepareTimeDatas(insertTime: String,
                         completion: @escaping ()->()) {
        if insertTime == "" {
            self.getTodayStepData {
                completion()
            }
            
            return
        } else {
            let evaluatingDates = self.getUpdateNeedDates(lastInsertTime: insertTime)
            self.getTimeModel(evaluatingDates: evaluatingDates,
                              lastInsertTime: insertTime)
            self.getTodayTimeDataByHealthKit()
//            self.getTodayTimeDataCollectionQuery()
        }
    }

    private func getOneDayTimeData(lastInsertTime: String) {
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        if lastInsertTime == "" {
            self.getTodayStepData()
            return
        } else {
            // 업데이트 대상 날짜 획득
            let evaluatingDates = self.getUpdateNeedDates(lastInsertTime: lastInsertTime)
            // 업데이트 대상 날짜의 from 타임 to 타임 모델 획득
            self.getTimeModel(evaluatingDates: evaluatingDates,
                              lastInsertTime: lastInsertTime)
//            self.getTodayTimeData()
        }
        
    }
    
    private func getTodayTimeDataCollectionQuery() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.minute = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        print("Anchor Date : ", Tools.customDate.convertDateBasicFormatToStringWithFormat(date: anchorDate!, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))
        
        

        // Set the results handler
        print("-------------------------------------------------------------")
        
        self.models.forEach {
            
            let model = $0
            
            let stepsCumulativeQuery = HKStatisticsCollectionQuery(
                quantityType: sampleType,
                quantitySamplePredicate: nil,
                options: .cumulativeSum,
                anchorDate: anchorDate!,
                intervalComponents: dateComponents)
            
            stepsCumulativeQuery.initialResultsHandler = { query, results, error in
                
                let endDate = model.endDate
                let startDate = model.fromDate
            
                
                if let myResults = results{
                    
                    myResults.enumerateStatistics(from: startDate,
                                                  to: endDate as Date) { [self] statistics, stop in
                        if let quantity = statistics.sumQuantity() {
                            let date = statistics.startDate
                            let steps = quantity.doubleValue(for: HKUnit.count())
                            
                            print("START DATE :: \(Tools.customDate.convertDateBasicFormatToStringWithFormat(date: statistics.startDate, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))")
                            print("END DATE :: \(Tools.customDate.convertDateBasicFormatToStringWithFormat(date: statistics.endDate, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))")
                            print("STEP COUNT :: \(steps)")
                            print("-------------------------------------------------------------")
                        }
                    }
                } else {
                    print("STEP COUNT DATA NIL")
                }
            }
            
            HKHealthStore().execute(stepsCumulativeQuery)
        }
        
        
        
        
    }
    
    private func getTodayTimeDataByHealthKit() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        self.stepData.removeAll()
        
        var executeCount = 0
        
        for (idx, item) in models.enumerated() {
            let startOfDay = item.fromDate
            let now = item.endDate
            
            let predicate = HKQuery
                .predicateForSamples(withStart: startOfDay,
                                     end: now,
                                     options: .strictStartDate)
            
            let query = HKStatisticsQuery.init(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum) { _, result, _ in
                    guard let result = result, let sum = result.sumQuantity() else {
                        return
                    }
                    
                    let step = Int(sum.doubleValue(for: HKUnit.count()))
                    let model = PedometerAddingStepModel.init(insertDate: now,
                                                              step: step)
                    self.stepData.append(model)
                    
                    print("=====================================================")
                    print("Query Start Date : ", self.convertDateBasicFormatToStringWithFormat(date: startOfDay, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))
                    print("Query Insert Date : ", self.convertDateBasicFormatToStringWithFormat(date: now, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))
                    print("Order \(idx) Step : ", step)
                    print("=====================================================")
                    
                    
                    executeCount += 1
                    
                    if (executeCount == self.models.count) {
                        print("=====================================================")
                        print("Health Kit Step Result")
                        print("Health Kit sTep Data coutn : ", self.stepData.count)
                        print("=====================================================")
                        
                        
                        
                        
                    }
            }
            
            healthStore.execute(query)
        }
        
        print("Async Test Finish")
    }
    
    
    
    private func getTimeModel(evaluatingDates: [Date],
                              lastInsertTime: String) {
        print("==================================================")
        print("INSERT FROM TO TIME AREA START")
        print("==================================================")
        
        self.models.removeAll()
        
        let insertTime = self.convertStringToDate(time: lastInsertTime)
        
        guard evaluatingDates.count != 1 else {
            // 평가해야할 날짜가 오늘 일 때
            let model = PedometerAddingTimeModel.init(fromD: insertTime,
                                                      endD: Date())
            models = [model]
            
            let fromD = self.convertDateBasicFormatToStringWithFormat(date: model.fromDate, format: "yyyy년 MM월 dd일 HH시 mm분 ss초")
            let endD = self.convertDateBasicFormatToStringWithFormat(date: model.endDate, format: "yyyy년 MM월 dd일 HH시 mm분 ss초")
            
            print("=============================================================")
            print("평가대상일 시작시간 : ", fromD)
            print("평가대상일 종료시간 : ", endD)
            print("=============================================================")
            
            return
        }
        
        
        for evaluatingDate in evaluatingDates {
            // 마지막 업데이트 날짜
            let insertDate = self.convertDateBasicFormatToStringWithFormat(date: insertTime,
                                                                           format: "yyyy-MM-dd")
            // 평가 대상 날짜
            let eDate = self.convertDateBasicFormatToStringWithFormat(date: evaluatingDate, format: "yyyy-MM-dd")
            // 오늘 날짜
            let tDate = self.convertDateBasicFormatToStringWithFormat(date: Date(), format: "yyyy-MM-dd")
            
            // 날짜 평가
            if insertDate == eDate {
                // 첫 날의 경우 시작 시간은 최근 업데이트 날짜로, 끝나는 시간은 그 날의 자정 직전으로 한다.
                let fromD = insertTime
                let endD = self.convertStringToDate(time: eDate + " 23:59:59")
                let model = PedometerAddingTimeModel.init(fromD: fromD, endD: endD)
                models.append(model)
                continue
            }
            
            // 오늘 평가
            if eDate == tDate {
                // 오늘의 경우 시작 시간은 자정, 끝나는 시간은 현재로 한다
                let fromD = Calendar.current.startOfDay(for: evaluatingDate)
                let endD = Date()
                let model = PedometerAddingTimeModel.init(fromD: fromD, endD: endD)
                models.append(model)
                continue
            }
            
            // 그 외의 경우
            let fromD = Calendar.current.startOfDay(for: evaluatingDate)
            let endD = self.convertStringToDate(time: eDate + " 23:59:59")
            let model = PedometerAddingTimeModel.init(fromD: fromD, endD: endD)
            models.append(model)
        }
        
        models.forEach {
            let fromD = self.convertDateBasicFormatToStringWithFormat(date: $0.fromDate, format: "yyyy년 MM월 dd일 HH시 mm분 ss초")
            let endD = self.convertDateBasicFormatToStringWithFormat(date: $0.endDate, format: "yyyy년 MM월 dd일 HH시 mm분 ss초")
            
            print("=============================================================")
            print("평가대상일 시작시간 : ", fromD)
            print("평가대상일 종료시간 : ", endD)
            print("=============================================================")
        }
    }
    
    private func getTodayStepData() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery
            .predicateForSamples(withStart: startOfDay,
                                 end: now,
                                 options: .strictStartDate)
        
        let query = HKStatisticsQuery.init(
            quantityType: type,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum) { _, result, _ in
                guard let result = result, let sum = result.sumQuantity() else {
                    return
                }
                
                let step = Int(sum.doubleValue(for: HKUnit.count()))
                let model = PedometerAddingStepModel.init(insertDate: now, step: step)
                self.stepData = [model]
                
                print("=====================================================")
                print("Query Start Date : ", self.convertDateBasicFormatToStringWithFormat(date: startOfDay, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))
                print("Query Insert Date : ", self.convertDateBasicFormatToStringWithFormat(date: now, format: "yyyy년 MM월 dd일 HH시 mm분 ss초"))
                print("Step : ", step)
                print("=====================================================")
        }
        
        healthStore.execute(query)
    }
    
    
//    private func getDayStart(lastInsertTime: String) {
//        var startDate: Date?
//
//        if lastInsertTime == "" {
//            startDate = Calendar.current.startOfDay(for: )
//        } else {
//
//        }
//    }
//
//    private func getDayEnd() -> Date {
//
//
//    }
    
    
    private func getOneDayIntervalStepData() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        let anchorDate = calendar.date(from: anchorComponents)
        
        let stepsCumulativeQuery = HKStatisticsCollectionQuery(
            quantityType: sampleType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate!,
            intervalComponents: dateComponents
        )
        
        // Set the results handler
        stepsCumulativeQuery.initialResultsHandler = { query, results, error in
            
            if error != nil {
                print("Error Msg : ", error!)
            }
            
            let endDate = Date()
            let startDate = calendar.date(byAdding: .day,
                                          value: -30,
                                          to: endDate,
                                          wrappingComponents: false)
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { [self] statistics, stop in
                    if let quantity = statistics.sumQuantity(){
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        print("START DATE :: \(statistics.startDate)")
                        print("STEP COUNT :: \(steps)")
                        print("-------------------------------------------------------------")
                    } else {
                        // 읽기 권한을 허용하지 않았을 때는 모든 카운트가 0으로 내려온다.
                        // 따라서 모든 카운트가 0일 경우에 권한이 없음을 확인할 수 있음.
                        
                        print("START DATE :: \(statistics.startDate)")
                        print("STEP COUNT :: 0")
                        print("-------------------------------------------------------------")
                    }
                }
            } else {
                print("STEP COUNT DATA NIL")
            }
        }
        HKHealthStore().execute(stepsCumulativeQuery)
    }
    
    private func getTwoHourIntervalStepData() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 2

        var anchorComponents = calendar.dateComponents([.hour, .day, .month, .year], from: Date())
        anchorComponents.hour = 0
        
        let anchorDate = calendar.date(from: anchorComponents)
        
//        let predicate = HKQuery
//            .predicateForSamples(withStart: startDate,
//                                 end: endDate,
//                                 options: HKQueryOptions.strictStartDate)
        
        let stepsCumulativeQuery = HKStatisticsCollectionQuery(
            quantityType: sampleType,
            quantitySamplePredicate: nil,
            options: .cumulativeSum,
            anchorDate: anchorDate!,                // 오늘 00:00:00
            intervalComponents: dateComponents      // 간격
        )
        
        // Set the results handler
        stepsCumulativeQuery.initialResultsHandler = { query, results, error in
            let endDateZero = self.dateToFromDateZero(Date())
            
            let startDate = calendar.date(byAdding: .day,
                                          value: -30,
                                          to: endDateZero,
                                          wrappingComponents: false)
            
            
            if let myResults = results{
                myResults.enumerateStatistics(from: startDate!,
                                              to: endDateZero as Date) { [self] statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {
                        
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        print("START DATE :: \(self.stringFromDate(statistics.startDate))")
                        print("END DATE :: \(self.stringFromDate(statistics.endDate))")
                        print("STEP COUNT :: \(Int(steps))")
                        print("-------------------------------------------------------------")
                    } else {
                        
                        print("START DATE :: \(self.stringFromDate(statistics.startDate))")
                        print("END DATE :: \(self.stringFromDate(statistics.endDate))")
                        print("STEP COUNT :: 0")
                        print("-------------------------------------------------------------")
                    }
                }
            } else {
                print("STEP COUNT DATA NIL")
            }
            
            // enumerate 가 동기적으로 작동하면서
            // Finish 전에 ㅏㅇ상 끝났음
            
            print("Finish")
        }
        
        HKHealthStore().execute(stepsCumulativeQuery)
    }
    
    private func temp2() {
//        let date = "2022-06-26"
//
//        //        for i in [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22] {
//        let startDate = dateFromString("\(date) \(0)")
//        let endDate = dateFromStringForEnd("\(date) \(23)")
//
//        let strSD = stringFromDate(startDate)
//        let strED = stringFromDate(endDate)
//
//        guard let sampleSteps = HKQuantityType.quantityType(forIdentifier: .stepCount) else { fatalError() }
//
//        let predicate = HKQuery
//            .predicateForSamples(withStart: startDate,
//                                 end: endDate,
//                                 options: HKQueryOptions.strictStartDate)
//
//        let query = HKStatisticsQuery.init(quantityType: sampleSteps,
//                                           quantitySamplePredicate: predicate,
//                                           options: .separateBySource) { _, result, _ in
//            guard let result = result, let sum = result.sumQuantity() else {
//                print("Step Zero")
//                return
//            }
//            print("result check \(result)")
//            print("value : ", sum.doubleValue(for: HKUnit.count()))
//        }
//
//        healthStore.execute(query)
    }
    
    private func temp() {
        let calender = Calendar.current
        var interval = DateComponents()
        interval.hour = 2
        
        var anchorComponents = calender.dateComponents([.day, .month, .year], from: NSDate() as Date)
        anchorComponents.hour = 0
        anchorComponents.minute = 0
        anchorComponents.second = 0
        let anchorDate = calender.date(from: anchorComponents)
        
        print("anchorDate : ", anchorDate)
        
        let stepQuery = HKStatisticsCollectionQuery(
            quantityType: HKObjectType.quantityType(forIdentifier: .stepCount)!,
            quantitySamplePredicate: nil,
            options: .mostRecent,
            anchorDate: anchorDate!,
            intervalComponents: interval as DateComponents)
        
        stepQuery.initialResultsHandler = { query, results, error in
            let endDate = NSDate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let eDate = formatter.string(from: endDate as Date) + " 00:00:00"
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let realEndDate = formatter.date(from: eDate)!
            
            
            
            // 오늘로부터 30일간의 걸음수 데이터를 가져오도록 진행
            let startDate = calender.date(byAdding: .hour,
                                          value: -24,
                                          to: realEndDate as Date,
                                          wrappingComponents: false)
            
            if let myResults = results {
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        
                        let date = statistics.startDate
                        let steps = quantity.doubleValue(for: HKUnit.count())
                        
                        let dateFormatter = DateFormatter.init()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let strDate = dateFormatter.string(from: date)
                        
                        self.stepDataList.append("\(strDate): \(Int(steps))")
                        let model = StepModel(step: steps, date: date)
                        self.stepList.append(model)
                        
                        self.count += 1
                        print("=================")
                        print("\(self.count) stepDataList : ", self.stepDataList)
                        
                        
//                        DispatchQueue.main.async {
//                            for (idx, item) in self.stepDataList.enumerated() {
//                                print("\(idx) : ", item)
//                            }
//                        }
                    }
                }
            }
        }
        healthStore.execute(stepQuery)
    }
    
    
    @IBAction func reDrawButton(_ sender: UIButton) {
        guard healthStore.authorizationStatus(for: typeToRead!) == .notDetermined else {
            print("health Auth Denied")
            return
        }
                                
        // 앱을 갑작스레 종료해도 notDetermined 상태가 유지 됌
        // 권한 승인이 완료되었다는 것은 허용되었다는 것이 아님. 허용 했을지 안했을지 여부 알 수 없음
        
        self.healthStore.requestAuthorization(toShare: nil, read: Set([typeToRead!]), completion: { isSuccess, error in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                if isSuccess {
                    print("권한 승인 완료")
                } else {
                    print("권한 승인 실패")
                }
            }
        })
        
        
        
        
        
        
//        self.index += 1
//
//        let idx = self.index
//        var key: String = ""
//
//        switch idx {
//        case 0:
//            key = "2022-06-18"
//        case 1:
//            key = "2022-06-19"
//        case 2:
//            key = "2022-06-20"
//        case 3:
//            key = "2022-06-21"
//        case 4:
//            key = "2022-06-22"
//        case 5:
//            key = "2022-06-23"
//        default:
//            key = "2022-06-24"
//        }
//
//        if self.index == 6 {
//            self.index = 0
//        }
//
//
//        let selectedModel = self.model[key]!
//
//        self.chartView.todayChart = selectedModel
//        self.dateLabel.text = key
    }
    
    var model: [String: [TodayChartDetail]] = [
        "2022-06-18": [
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
        ],
        "2022-06-19": [
            TodayChartDetail.init(time: 0, steps: 2845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 2, steps: 17845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 4, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 6, steps: 153, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 8845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 10, steps: 19845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 12, steps: 24845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 14, steps: 45, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 16, steps: 845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 18, steps: 8845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 20, steps: 10245, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 22, steps: 9023, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 24, steps: 0, isFirst: false, isSecond: false)
        ],
        "2022-06-20": [
            TodayChartDetail.init(time: 0, steps: 1845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 2, steps: 845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 4, steps: 27845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 6, steps: 3845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 8845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 8845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 10, steps: 19845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 12, steps: 24845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 14, steps: 45, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 16, steps: 1845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 20, steps: 245, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 22, steps: 90, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 24, steps: 10, isFirst: false, isSecond: false)
        ],
        "2022-06-21": [
            TodayChartDetail.init(time: 0, steps: 7845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 2, steps: 45, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 4, steps: 845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 6, steps: 1045, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 18845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 10, steps: 845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 12, steps: 245, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 14, steps: 184, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 16, steps: 45, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 18, steps: 6845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 20, steps: 10245, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 22, steps: 190, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 24, steps: 90, isFirst: false, isSecond: false)
        ],
        "2022-06-22": [
            TodayChartDetail.init(time: 0, steps: 75, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 2, steps: 45, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 4, steps: 275, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 6, steps: 84, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 10, steps: 984, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 12, steps: 5845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 14, steps: 18845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 16, steps: 1845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 18, steps: 24845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 20, steps: 15, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 22, steps: 920, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 24, steps: 80, isFirst: false, isSecond: false)
        ],
        "2022-06-23": [
            TodayChartDetail.init(time: 0, steps: 92, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 2, steps: 15, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 4, steps: 275, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 6, steps: 384, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 10, steps: 11845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 12, steps: 22845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 14, steps: 18450, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 16, steps: 8455, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 18, steps: 2845, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 20, steps: 3245, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 22, steps: 900, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 24, steps: 870, isFirst: false, isSecond: false)
        ],
        "2022-06-24": [
            TodayChartDetail.init(time: 0, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 2, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 4, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 6, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 8, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 10, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 12, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 14, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 16, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 18, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 20, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 22, steps: 0, isFirst: false, isSecond: false),
            TodayChartDetail.init(time: 24, steps: 0, isFirst: false, isSecond: false)
        ]
    ]
    
    
    
}

class PedometerAddingTimeModel {
    
    var fromDate: Date
    var endDate: Date
    
    init(fromD: Date, endD: Date) {
        self.fromDate = fromD
        self.endDate = endD
    }
    
}

class PedometerAddingStepModel {
    
    var insertDate: Date
    var step: Int
    
    init(insertDate: Date,
         step: Int) {
        self.insertDate = insertDate
        self.step = step
    }
    
    
}

extension UIViewController {
    
    // 데이트 포맷을 다른 형식으로 변경
    func convertDateBasicFormatToOtherDateFormat(date: Date,
                                                 format: String) -> Date {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let string = formatter.string(from: date)
        let date = string.components(separatedBy: " ").first!
        
        formatter.dateFormat = "\(format)"
        
        guard let result = formatter.date(from: date) else { return Date() }
        return result
    }
    
    // 데이트 포맷을 원하는 타입의 String 으로 변경
    func convertDateBasicFormatToStringWithFormat(date: Date,
                                                  format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "ko_KR")
        formatter.dateFormat = "\(format)"
        let string = formatter.string(from: date)
        return string
    }
    
    func convertStringToDate(time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: time) else { return Date() }
        return date
    }
    
}

extension Date {
    
    func dateByAddingDays(_ days : Int ) -> Date {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.day = days
        return (calendar as NSCalendar).date(byAdding: dateComponent, to: self, options: NSCalendar.Options.matchNextTime)!
    }
    
}
