//
//  HomeCollectionViewCell.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit
import Charts



class HomeCollectionViewCell: UICollectionViewCell, ChartViewDelegate  {
    //, ChartViewDelegate
    @IBOutlet weak var homeChartView: LineChartView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var items = [TransfersModel]()
    
    var incomeChartData = [ChartDataEntry]()
    var outcomeChartData = [ChartDataEntry]()
    let topColor =  UIColor(ciColor: .blue).cgColor
    let bottomColor = UIColor(ciColor: .white).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        homeChartView.notifyDataSetChanged()
        homeChartView.delegate = self
        //
        //                homeChartView.backgroundColor = .clear
        //                homeChartView.layer.cornerRadius = 25
        //                homeChartView.clipsToBounds = true
      
        homeChartView.rightAxis.enabled = false
        homeChartView.noDataText = "There's nothing to show on the chart ;("
        homeChartView.noDataTextColor = .systemBlue
        homeChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        // homeChartView.leftAxis.setLabelCount(5, force: false)
        homeChartView.leftAxis.labelTextColor = .white
        homeChartView.leftAxis.zeroLineColor = .white
        homeChartView.leftAxis.axisLineColor = .systemBlue
        homeChartView.leftAxis.labelPosition = .insideChart
        //homeChartView.xAxis.axisRange = 30
        homeChartView.xAxis.labelPosition = .bottom
        homeChartView.xAxis.labelCount = 3
        homeChartView.setVisibleXRangeMinimum(0.1)
        homeChartView.fitScreen()

        
        // homeChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        //  homeChartView.xAxis.setLabelCount(6, force: false)
        // homeChartView.xAxis.labelTextColor = .white
        homeChartView.xAxis.axisLineColor = .blue
        // homeChartView.xAxis.labelPosition = .bottom
        DispatchQueue.main.async {
            self.setData()
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
      
    }
    
    
    func loadDataFromUserDefault() -> [TransfersModel]? {
        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
                return transferData
            }
            
        }
        return nil
        
    }
    
    
    func setData() {
        guard let items = loadDataFromUserDefault() else {
            contentView.backgroundColor = .red
            homeChartView.backgroundColor = .red
            return
            
        }
        
        incomeChartData = items.filter({$0.isIncome}).compactMap({ChartDataEntry(x: Double($0.dateOfTransaction.get(.day)), y: Double($0.amountOfTransaction)!)}).sorted(by: {$0.x < $1.x})
        
        
        
//        for it in items {
//            incomeChartData.append(ChartDataEntry(x: Double(it.dateOfTransaction.get(.day)), y: (it.amountOfTransaction)))
//        }
        
        outcomeChartData = items.filter({!$0.isIncome}).compactMap({ChartDataEntry(x: Double($0.dateOfTransaction.get(.day)), y: Double($0.amountOfTransaction)!)}).sorted(by: {$0.x < $1.x})
        
        
//                incomeChartData = [
//                    ChartDataEntry(x: 5, y: 15),
//                    ChartDataEntry(x: 10, y: 10),
//                    ChartDataEntry(x: 20, y: 20),
//                    ChartDataEntry(x: 30, y: 30),
//                    ChartDataEntry(x: 30, y: 30),
//                    ChartDataEntry(x: 20, y: 20)
//                ]
//        //
//        //
//                outcomeChartData = [
//                    ChartDataEntry(x: 4, y: 2),
//                    ChartDataEntry(x: 14, y: 6),
//                    ChartDataEntry(x: 16, y: 8),
//                    ChartDataEntry(x: 20, y: 15),
//                    ChartDataEntry(x: 25, y: 3),
//                                ChartDataEntry(x: 30, y: 30),
//                                ChartDataEntry(x: 30, y: 30),
//                                ChartDataEntry(x: 20, y: 20)
//
//
//                ]
        

        let item1 = LineChartDataSet(entries: incomeChartData, label: "Income")
        let item2 = LineChartDataSet(entries: outcomeChartData, label: "Outcome")
        item1.mode = .cubicBezier
        item2.mode = .cubicBezier
        item1.lineWidth = 4
        item2.lineWidth = 4
        item1.drawCirclesEnabled = true
        item2.drawCirclesEnabled = true
        item1.drawCircleHoleEnabled = true
        item2.drawCircleHoleEnabled = true
        item1.circleColors = [UIColor.systemGreen]
        item2.circleColors = [UIColor.systemRed]
        item1.drawFilledEnabled = true
        item2.drawFilledEnabled = true
        item1.setColor(.systemGreen)
        item2.setColor(.systemRed)
        item1.drawFilledEnabled = true
        item2.drawFilledEnabled = true
        item1.drawVerticalHighlightIndicatorEnabled = false
        item2.drawVerticalHighlightIndicatorEnabled = false
        item1.drawHorizontalHighlightIndicatorEnabled = false
        item2.drawHorizontalHighlightIndicatorEnabled = false
        homeChartView.leftAxis.forceLabelsEnabled = true
        homeChartView.xAxis.drawGridLinesEnabled = false
        homeChartView.leftAxis.enabled = false
        homeChartView.drawBordersEnabled = false
        let gradientColors = [topColor, bottomColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient
        
        let xAxis = homeChartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.axisMinimum = 0
        xAxis.axisMaximum = 30
        xAxis.granularity = 0.000001
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = -0.5
        xAxis.spaceMin = 0
       // xAxis.valueFormatter = CustomChartFormatter()

        
        let yAxis = homeChartView.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        yAxis.labelTextColor = .black
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        yAxis.centerAxisLabelsEnabled = true
        yAxis.axisMinimum = 0

        yAxis.axisMaximum = (Double(items.sorted(by: {Int($0.amountOfTransaction)! > Int($1.amountOfTransaction)!}).first!.amountOfTransaction) ?? 20) + 5
        yAxis.granularity = 0.000001
        // homeChartView.highlightValue()
        homeChartView.scaleXEnabled = false
        homeChartView.scaleYEnabled = false
        item1.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        item2.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
        
        //        let dataset = items.map({ item in
        //            let result: LineChartDataSet!
        //            if item. {
        //                result = LineChartDataSet(entries: incomeChartData, label: "Income")
        //
        //
        //
        //            } else {
        //                result = LineChartDataSet(entries: incomeChartData, label: "Income")
        //
        //
        //
        //
        //            }
        //            return result
        //        })
        
        //        item1.setDrawValues(false)
        
        //                let chartData = LineChartData(dataSets: )
        
        homeChartView.data = LineChartData(dataSets: [item1, item2])
        
        homeChartView.notifyDataSetChanged()
        homeChartView.data?.notifyDataChanged()

    }
    
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    var europeanFormattedEn_US : String {
        Formatter.date.calendar = Calendar(identifier: .iso8601)
        Formatter.date.timeZone = .current
        Formatter.date.dateFormat = "dd/M/yyyy, H:mm"
        return Formatter.date.string(from: self)
    }
}

extension Formatter {
    static let date = DateFormatter()
}

