//
//  HomeCollectionViewCell.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit
import AAInfographics

class HomeCollectionViewCell: UICollectionViewCell  {

    @IBOutlet var chartParentView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var item = [TransfersModel]()
    var chartModel = AAChartModel()
    let chart = AAChartView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartParentView.addSubview(chart)
        chart.frame = chartParentView.frame
    }
    
    func fill(with data: AAChartModel) {
        self.chartModel = data
        DispatchQueue.main.async { [self] in
            chart.aa_drawChartWithChartModel(data)
        }
    }
}
