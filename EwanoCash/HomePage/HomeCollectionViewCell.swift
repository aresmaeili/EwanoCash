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
                //  print("*****************\(String(describing: transferData))")
                item = transferData
                //items.append(contentsOf: item)
            }
        }
    }
    
    
    
    //    let sampleData : [ChartDataEntry] = [
    //        ChartDataEntry(x: 1, y: Double(item[0].amountOfTransaction) ?? 0),
    //        ChartDataEntry(x: 1, y: 5),
    //        ChartDataEntry(x: 2, y: 2),
    //        ChartDataEntry(x: 3, y: 10),
    //        ChartDataEntry(x: 4, y: 5),
    //        ChartDataEntry(x: 5, y: 2),
    //        ChartDataEntry(x: 6, y: 10),
    //        ChartDataEntry(x: 7, y: 5),
    //        ChartDataEntry(x: 8, y: 2),
    //        ChartDataEntry(x: 9, y: 2),
    //        ChartDataEntry(x: 10, y: 9),
    //        ChartDataEntry(x: 11, y: 15),
    //        ChartDataEntry(x: 12, y: 21),
    //        ChartDataEntry(x: 13, y: 12),
    //        ChartDataEntry(x: 14, y: 10),
    //        ChartDataEntry(x: 15, y: 5),
    //        ChartDataEntry(x: 16, y: 2),
    //        ChartDataEntry(x: 17, y: 2),
    //        ChartDataEntry(x: 18, y: 9),
    //        ChartDataEntry(x: 19, y: 15),
    //        ChartDataEntry(x: 20, y: 25),
    //        ChartDataEntry(x: 21, y: 12),
    //        ChartDataEntry(x: 22, y: 2),
    //        ChartDataEntry(x: 23, y: 9),
    //        ChartDataEntry(x: 24, y: 10),
    //        ChartDataEntry(x: 25, y: 5),
    //        ChartDataEntry(x: 26, y: 2),
    //        ChartDataEntry(x: 27, y: 2),
    //        ChartDataEntry(x: 28, y: 9),
    //        ChartDataEntry(x: 29, y: 10),
    //        ChartDataEntry(x: 30, y: 5),
    //        ChartDataEntry(x: 31, y: 2),
    //    ]
    
    let topColor =  UIColor(ciColor: .blue).cgColor
    let bottomColor = UIColor(ciColor: .white).cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadDataFromUserDefault()
        
        
        let sampleData : [ChartDataEntry] = [
//            ChartDataEntry(x: 0, y: Double(item[0].amountOfTransaction) ?? 0),
//            ChartDataEntry(x: 1, y: Double(item[1].amountOfTransaction) ?? 0)
            
        ]
        
        
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
            let set1 = LineChartDataSet(entries: sampleData, label: "Spendings")
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
