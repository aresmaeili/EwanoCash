//
//  TotalSumViewController.swift
//  EwanoCash
//
//  Created by Reza Kashkoul on 7/11/1400 AP.
//

import UIKit

class TotalSummaryViewController: UIViewController {
    
    @IBOutlet var summaryChartView: UIView!
    @IBOutlet weak var totalSpendingAmountLabel: UILabel!
    
    @IBOutlet weak var totalIncomeAmountLabel: UILabel!
    
    @IBOutlet weak var totalSummaryTableView: UITableView!
    
    
    
    let items = ["bill" , "buying show" , "coffee" , "taxi" , "bill" , "buying show" , "coffee" , "taxi" , "bill" , "buying show" , "coffee" , "taxi"]
    override func viewDidLoad() {
        super.viewDidLoad()
        totalSummaryTableView.delegate = self
        totalSummaryTableView.dataSource = self
        
        
        
        navigationItem.title = "Total Summary"
        summaryChartView.layer.cornerRadius = 25
        summaryChartView.clipsToBounds = true
        totalSummaryTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        
    }
    
    
}

extension TotalSummaryViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.itemTitle.text = items[indexPath.row]
        //        cell?.itemImage.image =
        cell.itemPrice.text = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
}
