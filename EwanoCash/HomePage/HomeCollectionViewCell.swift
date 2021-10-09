//
//  HomeCollectionViewCell.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit
import Charts



class HomeCollectionViewCell: UICollectionViewCell  {
    //, ChartViewDelegate
    @IBOutlet weak var homeChartView: LineChartView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var item = [TransfersModel]()
    
    
    func loadDataFromUserDefault() {
        
        if let data = UserDefaults.standard.value(forKey:"listOfTransactions") as? Data {
            if let transferData = try? PropertyListDecoder().decode(Array<TransfersModel>.self, from: data) {
                item = transferData
                
                let chartCostList = item.map { cost in
                    return Double(cost.amountOfTransaction)
                }
                let chartDateList = item.map { date in
                    return Double(date.dateOfTransaction)
                }
                
                let combinedIncomeChart = zip(chartDateList, chartCostList).map { ($0, $1) }
//                incomeChart = combinedIncomeChart
                
                print("HJHJHJHJHJ\(combinedIncomeChart)HJHJHJHJH")
                
               // var incomeChart = [ChartDataEntry(x: Double, y: Double)]

//                for i in 0..<chartDateList.count {
//                    incomeChart.append((chartDateList[i], chartCostList[i]))
//                }
//                print(incomeChart)
                

            }
            
            
            //        incomeChart[ChartDataEntry(x: chartDateList[0], y: chartCostList[0])]
            
        }
    }
    
    //    var chartDateList = [Double]()
    //    var chartCostList = [Double]()
    //    var dateList = [String]()
    //    var costList = [String]()
   // var incomeChart = [ChartDataEntry]()
    var incomeChart = [ChartDataEntry]()
    let topColor =  UIColor(ciColor: .blue).cgColor
    let bottomColor = UIColor(ciColor: .white).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadDataFromUserDefault()
        
        
        //        let incomeChart : [ChartDataEntry] = [
        //            ChartDataEntry(x: chartDateList[0], y: chartCostList[0])
        
        //  ]
        
        
        homeChartView.backgroundColor = .clear
        homeChartView.layer.cornerRadius = 25
        homeChartView.clipsToBounds = true
        homeChartView.rightAxis.enabled = false
        //IN Zireshe : homeChartView.xAxis.enabled = false
        
        //homeChartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        homeChartView.leftAxis.setLabelCount(5, force: false)
        homeChartView.leftAxis.labelTextColor = .white
        homeChartView.leftAxis.zeroLineColor = .white
        homeChartView.leftAxis.axisLineColor = .systemBlue
        homeChartView.leftAxis.labelPosition = .insideChart
        //homeChartView.leftAxis.maxWidth = 5
        homeChartView.xAxis.labelPosition = .bottom
        
        // homeChartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        //  homeChartView.xAxis.setLabelCount(6, force: false)
        // homeChartView.xAxis.labelTextColor = .white
        homeChartView.xAxis.axisLineColor = .blue
        // homeChartView.xAxis.labelPosition = .bottom
        func setData() {
            let set1 = LineChartDataSet(entries: incomeChart, label: "Spendings")
            let data = LineChartData(dataSet: set1)
            homeChartView.data = data
            //set1.mode = .cubicBezier
            set1.lineWidth = 4
            data.setDrawValues(false)
            set1.drawCirclesEnabled = true
            set1.drawCircleHoleEnabled = true
            homeChartView.xAxis.drawGridLinesEnabled = false
            homeChartView.leftAxis.enabled = false
            homeChartView.drawBordersEnabled = false
            set1.circleColors = [UIColor.systemBlue]
            let gradientColors = [topColor, bottomColor] as CFArray
            let colorLocations:[CGFloat] = [1.0, 0.0]
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
            set1.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
            set1.drawFilledEnabled = true
            set1.setColor(.systemBlue)
            set1.drawFilledEnabled = true
            set1.drawVerticalHighlightIndicatorEnabled = false
            set1.drawHorizontalHighlightIndicatorEnabled = false
        }
        setData()
    }
    
    //    func setData() {
    //        let set1 = LineChartDataSet(entries: sampleData, label: "Spendings")
    //        let data = LineChartData(dataSet: set1)
    //        homeChartView.data = data
    //        //set1.mode = .cubicBezier
    //        set1.lineWidth = 4
    //        data.setDrawValues(false)
    //        set1.drawCirclesEnabled = true
    //        set1.drawCircleHoleEnabled = true
    //        homeChartView.xAxis.drawGridLinesEnabled = false
    //        homeChartView.leftAxis.enabled = false
    //        homeChartView.drawBordersEnabled = false
    //        set1.circleColors = [UIColor.systemBlue]
    //        let gradientColors = [topColor, bottomColor] as CFArray
    //        let colorLocations:[CGFloat] = [1.0, 0.0]
    //        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
    //        set1.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)
    //        set1.drawFilledEnabled = true
    //        set1.setColor(.systemBlue)
    //        set1.drawFilledEnabled = true
    //        set1.drawVerticalHighlightIndicatorEnabled = false
    //        set1.drawHorizontalHighlightIndicatorEnabled = false
    //    }
}


